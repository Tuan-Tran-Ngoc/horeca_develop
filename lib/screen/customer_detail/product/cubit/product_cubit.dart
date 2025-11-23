import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horeca/service/stock_service.dart';
import 'package:horeca/service/sync_service.dart';
import 'package:horeca/utils/call_api_utils.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/model/product_stock.dart';
import 'package:horeca_service/model/request/customer_visit_checkin.dart';
import 'package:horeca_service/model/request/revisit_request.dart';
import 'package:horeca_service/model/response/customer_visit_response.dart';
import 'package:horeca_service/network/apis.dart';
import 'package:horeca_service/sqflite_database/dto/address_visit_dto.dart';
import 'package:horeca_service/sqflite_database/dto/customer_stock_price_dto.dart';
import 'package:horeca_service/sqflite_database/dto/product_dto.dart';
import 'package:horeca_service/sqflite_database/model/m_sync_offline.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final BuildContext context;

  ProductCubit(this.context) : super(ProductInitial());
  StockBalanceProvider stockBalanceProvider = StockBalanceProvider();
  CustomerStockProvider customerStockProvider = CustomerStockProvider();
  CustomerPriceProvider customerPriceProvider = CustomerPriceProvider();
  CustomerVisitProvider customerVisitProvider = CustomerVisitProvider();
  CustomerAddressProvider customerAddressProvider = CustomerAddressProvider();
  EmployeeProvider employeeProvider = EmployeeProvider();
  SyncOfflineProvider syncOfflineProvider = SyncOfflineProvider();
  RouteAssignmentProvider routeAssignmentProvider = RouteAssignmentProvider();
  SyncService syncService = SyncService();
  StockService stockService = StockService();
  late Database database;
  DatabaseProvider db = DatabaseProvider();
  late SharedPreferences prefs;
  String message = "";

  Future<void> init(
      int customerId, int customerVisitId, int customerAddressIdChoose) async {
    bool isStartVisit = false;
    String selectedAddval = '';
    List<ProductDto> listCustomerStock = [];
    prefs = await SharedPreferences.getInstance();
    int? shiftReportId = prefs.getInt('shiftReportId');
    int? baPositionId = prefs.getInt('baPositionId');

    //get address
    List<AddressVisitDto> lstAddress =
        await customerAddressProvider.getAddressByCustomerId(customerId);

    AddressVisitDto addressEmpty =
        AddressVisitDto(customerAddressId: 0, address: '');

    lstAddress.insert(0, addressEmpty);

    // get stock salesman
    final listStockBalance = await stockBalanceProvider
        .getListStockBalancePrice(baPositionId ?? 0, customerId);
    int indexDTC = 0;
    List<List<String>> rowDataDTC = listStockBalance.map((data) {
      indexDTC++;
      List<String> result = [];
      result.add(indexDTC.toString());
      result.add(data.productName.toString());
      result.add(data.type.toString());
      result.add(data.uom.toString());
      result
          .add(NumberFormat.currency(locale: 'vi').format(data.priceCost ?? 0));
      result
          .add(NumberFormat.decimalPattern().format(data.allocationStock ?? 0));
      result.add(NumberFormat.decimalPattern()
          .format((data.orderUsedStock ?? 0) + (data.promotionUsedStock ?? 0)));
      result.add(NumberFormat.decimalPattern().format(
          (data.allocationStock ?? 0) -
              ((data.orderUsedStock ?? 0) + (data.promotionUsedStock ?? 0))));
      return result;
    }).toList();

    // final listCustomerStock =
    //     await customerStockProvider.getListCustomerStock();

    List<CustomerVisit> lstCustomerVisit = await customerVisitProvider
        .getCustomerVisiting(shiftReportId!, customerId, customerVisitId);

    if (lstCustomerVisit.isNotEmpty) {
      //isStartVisit = true;
      int? customerAddressId = lstCustomerVisit[0].customerAddressId;
      AddressVisitDto addressSelected = lstAddress.firstWhere(
          (address) => address.customerAddressId == customerAddressId);
      selectedAddval = addressSelected.address!;
      customerAddressIdChoose = addressSelected.customerAddressId ?? 0;

      print('listCustomerStock $listCustomerStock');
    } else if (customerAddressIdChoose != 0) {
      AddressVisitDto addressSelected = lstAddress.firstWhere(
          (address) => address.customerAddressId == customerAddressIdChoose);
      selectedAddval = addressSelected.address!;
    }

    // get stock customer
    listCustomerStock = await customerStockProvider.getAllCustomerStock(
        customerId, customerAddressIdChoose);

    emit(ProductInitialSuccess(selectedAddval, lstAddress, listCustomerStock,
        listStockBalance, rowDataDTC, isStartVisit, customerVisitId));
  }

  void clickTab(isDTC) {
    emit(LoadingItem());
    emit(ClickTabSuccess(isDTC));
  }

  void modifyProductSuccess() {
    emit(ModifyProductSucess());
  }

  Future<void> startVisit(
      int routeId, int customerId, int? customerAddressId) async {
    try {
      emit(ClickStartVisit());
      AppLocalizations multiLang = AppLocalizations.of(context)!;

      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      await database.transaction((txn) async {
        DateTime now = DateTime.now();
        String dateStr = DateFormat(Constant.dateFormatterYYYYMMDD).format(now);
        String dateTimeStr = DateFormat(Constant.dateTimeFormatter).format(now);
        int? customerVisitId;

        // get global var
        prefs = await SharedPreferences.getInstance();
        int? shiftReportId = prefs.getInt('shiftReportId');
        int? baPositionId = prefs.getInt('baPositionId');
        String? shiftCode = prefs.getString('shiftCode');

        // check sync data
        if (await syncService.checkSyncCurrent(
            baPositionId ?? 0, SyncType.checkinVisit, null, txn)) {
          throw multiLang.msgCheckSync;
        }

        // get info employee
        List<Employee> lstEmployInfo =
            await employeeProvider.getEmployByPosId(baPositionId!, txn);

        Employee employInfo;

        if (lstEmployInfo.isEmpty) {
          // throw Exception(
          // 'Thông tin nhân viên không tìm thấy. Vui lòng đăng nhập lại.');
          // emit(StartVisitFail(
          //     'Thông tin nhân viên không tìm thấy. Vui lòng đăng nhập lại.'));
          message = [
            multiLang.notFound(
                [multiLang.information, multiLang.employee].join(" ")),
            multiLang.loginAgain
          ].join(".\n");
          throw message;
        }

        if (customerAddressId == null || customerAddressId == 0) {
          // throw Exception('Vui lòng chọn địa chỉ viếng thăm');
          message = multiLang.enter(multiLang.customerVisitAddress);
          throw message;
        }

        employInfo = lstEmployInfo[0];

        CustomerVisit visitDto = CustomerVisit(
            shiftReportId: shiftReportId,
            customerId: customerId,
            customerAddressId: customerAddressId,
            baPositionId: baPositionId,
            employeeId: employInfo.employeeId,
            employeeName: employInfo.employeeName,
            visitStatus: Constant.visiting,
            visitDate: dateTimeStr,
            startTime: dateTimeStr,
            shiftCode: shiftCode,
            createdBy: baPositionId,
            createdDate: dateTimeStr,
            updatedBy: baPositionId,
            updatedDate: dateTimeStr,
            visitTimes: 1,
            version: 1);

        CustomerVisit visit = await customerVisitProvider.insert(visitDto, txn);
        customerVisitId = visit.customerVisitId;

        // get stock lastest
        int customerVisitIdLastest =
            await customerVisitProvider.selectVisitLastest(
                customerId, customerAddressId, customerVisitId ?? 0, txn);

        CustomerStockPriceDto customerStockPriceDto =
            await stockService.copyStockIntoNewVisit(customerVisitIdLastest,
                visit.customerVisitId, dateTimeStr, txn);

        // sync data
        var connect = await Connectivity().checkConnectivity();
        if (connect == ConnectivityResult.none) {
          SyncOffline syncOffline = SyncOffline(
              positionId: baPositionId,
              type: SyncType.checkinVisit.toString(),
              status: Constant.STS_ACT,
              relatedId: customerVisitId,
              createdDate: dateTimeStr);
          await syncOfflineProvider.insert(syncOffline, txn);
        } else if (connect == ConnectivityResult.wifi ||
            connect == ConnectivityResult.mobile) {
          ShiftReportProvider shiftReportProvider = ShiftReportProvider();
          ShiftReport? shiftReportExisted =
              await shiftReportProvider.getReport(shiftReportId, txn);
          if (shiftReportExisted?.shiftReportIdSync == null) {
            // throw Exception(
            // 'Ca làm việc chưa đồng bộ, vui lòng đồng bộ ca làm việc trước');
            message = multiLang.syncNotYetAndDo(multiLang.shift);
            throw message;
          }
          CustomerVisitCheckinRequest request = CustomerVisitCheckinRequest(
            customerId,
            customerAddressId,
            baPositionId,
            dateTimeStr,
            dateTimeStr,
            shiftReportExisted!.shiftReportIdSync!,
            shiftCode!,
          );

          Map<String, dynamic> jsonMapping = request.toJson();
          String json = jsonEncode(jsonMapping);

          CallApiUtils<CustomerVisitResponse> sendRequest = CallApiUtils();
          APIResponseEntity<CustomerVisitResponse> response =
              await sendRequest.callApiPostMethod(
                  APIs.checkin, json, CustomerVisitResponse.fromJson);
          visit.customerVisitIdSync = response.data?.customerVisitId;
          await customerVisitProvider.updateSyncId(visit, txn);

          await syncService.syncStock(
              customerStockPriceDto.lstCustomerPrice,
              customerStockPriceDto.lstCustomerStock,
              visit.customerVisitIdSync,
              txn,
              multiLang);
        }

        emit(StartVisitSuccess(true, customerVisitId, customerAddressId));
      });
    } catch (error) {
      // if (error.toString() ==
      //     MessageUtils.getMessages(code: Constant.SESSION_LOGIN_EXPIRED)) {
      //   await CommonUtils.logout();
      //   GoRouter.of(context).go('/');
      // }
      emit(StartVisitFail(error.toString()));
    }
  }

  Future<void> revisit(int customerId, int customerVisitId) async {
    try {
      emit(ClickRevisitSuccess());
      AppLocalizations multiLang = AppLocalizations.of(context)!;
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      await database.transaction((txn) async {
        DateTime now = DateTime.now();
        String dateStr = DateFormat(Constant.dateFormatterYYYYMMDD).format(now);
        String dateTimeStr = DateFormat(Constant.dateTimeFormatter).format(now);

        // get global var
        prefs = await SharedPreferences.getInstance();
        int? shiftReportId = prefs.getInt('shiftReportId');
        int? baPositionId = prefs.getInt('baPositionId');
        String? shiftCode = prefs.getString('shiftCode');

        // check sync data
        if (await syncService.checkSyncCurrent(
            baPositionId ?? 0, SyncType.revisit, customerVisitId, txn)) {
          throw multiLang.msgCheckSync;
        }
        // get info employee
        List<Employee> lstEmployInfo =
            await employeeProvider.getEmployByPosId(baPositionId!, txn);

        Employee employInfo;

        if (lstEmployInfo.isEmpty) {
          // throw Exception(
          // 'Thông tin nhân viên không tìm thấy. Vui lòng đăng nhập lại.');
          message = [
            multiLang.notFound(
                [multiLang.information, multiLang.employee].join(" ")),
            multiLang.loginAgain
          ].join(".\n");
          throw message;
        }

        employInfo = lstEmployInfo[0];

        CustomerVisit? customerVisit =
            await customerVisitProvider.select(customerVisitId, txn);

        if (customerVisit == null) {
          // throw Exception('Lỗi trong quá trình lấy thông tin viếng thăm.');
          message = multiLang
              .errorOccur([multiLang.information, multiLang.visit].join(" "));
          throw message;
        }
        int maxVisitTimes = await customerVisitProvider
            .selectMaxVisitTimesByParent(customerVisit.customerVisitId!, txn);
        CustomerVisit visitDto = CustomerVisit.copyWith(customerVisit);
        visitDto.customerVisitId = null;
        visitDto.customerVisitIdSync = null;
        visitDto.visitDate = dateTimeStr;
        visitDto.startTime = dateTimeStr;
        visitDto.endTime = null;
        visitDto.visitStatus = Constant.visiting;
        visitDto.createdBy = baPositionId;
        visitDto.createdDate = dateTimeStr;
        visitDto.updatedBy = baPositionId;
        visitDto.updatedDate = dateTimeStr;
        visitDto.version = 1;
        visitDto.parentCustomerVisitId = customerVisit.customerVisitId;
        visitDto.visitTimes = maxVisitTimes + 1;
        visitDto.isStockCheckCompleted = null;
        visitDto.isSurveyCompleted = null;

        // int isVisit = await customerVisitProvider.revisit(visitDto, txn);
        CustomerVisit revisit =
            await customerVisitProvider.insert(visitDto, txn);

        // print('isVisit ${revisit.customerVisitId}');
        if (revisit.customerVisitId == null) {
          // throw Exception('Viếng thăm lại xảy ra lỗi.');
          message = multiLang.errorOccur(multiLang.revisit);
          throw message;
        }

        // // get customer stock available
        // List<CustomerStock> lstCustomerStockAvailable =
        //     await customerStockProvider.getAllCustomerStockByVisit(
        //         customerVisitId, txn);

        // List<CustomerStock> lstCustomerStock = [];
        // for (var customerStock in lstCustomerStockAvailable) {
        //   lstCustomerStock.add(CustomerStock.copyWith(
        //       customerStock, revisit.customerVisitId ?? 0));
        // }

        // // reset lastest customerStock
        // lstCustomerStock = lstCustomerStock.map((e) {
        //   e.lastUpdate = dateTimeStr;
        //   return e;
        // }).toList();

        // // get customer price available
        // List<CustomerPrice> lstCustomerPriceAvailable =
        //     await customerPriceProvider.getAllCustomerPriceByVisit(
        //         customerVisitId, txn);

        // List<CustomerPrice> lstCustomerPrice = [];

        // for (var customerPrice in lstCustomerPriceAvailable) {
        //   lstCustomerPrice.add(CustomerPrice.copyWith(
        //       customerPrice, revisit.customerVisitId ?? 0));
        // }

        // // reset lastest customerPrice
        // lstCustomerPrice = lstCustomerPrice.map((e) {
        //   e.lastUpdate = dateTimeStr;
        //   return e;
        // }).toList();

        // // insert local s_customer_price
        // for (CustomerPrice customerPrice in lstCustomerPrice) {
        //   await customerPriceProvider.insert(customerPrice, txn);
        // }

        // // insert local s_customer_stock
        // for (CustomerStock customerStock in lstCustomerStock) {
        //   await customerStockProvider.insert(customerStock, txn);
        // }
        CustomerStockPriceDto customerStockPriceDto =
            await stockService.copyStockIntoNewVisit(
                customerVisitId, revisit.customerVisitId, dateTimeStr, txn);

        // sync data
        var connect = await Connectivity().checkConnectivity();
        if (connect == ConnectivityResult.none) {
          SyncOffline syncOffline = SyncOffline(
              positionId: baPositionId,
              type: SyncType.revisit.toString(),
              status: Constant.STS_ACT,
              relatedId: revisit.customerVisitId,
              createdDate: dateTimeStr);
          await syncOfflineProvider.insert(syncOffline, txn);
        } else if (connect == ConnectivityResult.wifi ||
            connect == ConnectivityResult.mobile) {
          ShiftReportProvider shiftReportProvider = ShiftReportProvider();
          ShiftReport? shiftReportExisted =
              await shiftReportProvider.getReport(shiftReportId, txn);
          if (shiftReportExisted?.shiftReportIdSync == null) {
            // throw Exception(
            // 'Ca làm việc chưa đồng bộ, vui lòng đồng bộ ca làm việc trước');
            message = multiLang.syncNotYetAndDo(multiLang.shift);
            throw message;
          }

          RevisitRequest request = RevisitRequest(
              customerVisitId: customerVisit.customerVisitIdSync,
              baPositionId: baPositionId,
              reVisit: {
                "startTime": dateTimeStr,
                "visitDate": "${customerVisit.visitDate} 00:00:00.000"
              });

          Map<String, dynamic> requestBody = request.toJson();
          String requestBodyJson = jsonEncode(requestBody);

          CallApiUtils<CustomerVisitResponse> sendRequest = CallApiUtils();
          APIResponseEntity<CustomerVisitResponse> response =
              await sendRequest.callApiPostMethod(APIs.revisit, requestBodyJson,
                  CustomerVisitResponse.fromJson);
          CustomerVisitResponse revisitResponse = response.data!.reVisit!;

          revisit.customerVisitIdSync = revisitResponse.customerVisitId;

          await customerVisitProvider.updateSyncId(revisit, txn);

          //await customerVisitProvider.updateSyncId(visit, txn);

          // sync stock
          await syncService.syncStock(
              customerStockPriceDto.lstCustomerPrice,
              customerStockPriceDto.lstCustomerStock,
              revisit.customerVisitIdSync,
              txn,
              multiLang);
        }
        message = [multiLang.revisit, multiLang.success].join(" ");
        emit(RevisitSuccess(revisit.customerVisitId ?? 0,
            revisit.customerAddressId ?? 0, message));
      });
    } catch (error) {
      emit(RevisitFail(error.toString()));
    }
  }

  Future<void> saveCustomerStock(
      List<ProductDto> lstProduct, int customerId, int? customerVisitId) async {
    try {
      emit(ClickConfirmStockCustomer());
      AppLocalizations multiLang = AppLocalizations.of(context)!;
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      await database.transaction((txn) async {
        saveCustomerStockImpl(
            lstProduct, customerId, customerVisitId, txn, multiLang);
        message = [multiLang.update, multiLang.customerStock, multiLang.success]
            .join(" ");
        emit(SaveCustomerPriceSuccess(message));
      });
    } catch (error) {
      emit(SaveCustomerPriceFail(error.toString()));
    }
  }

  Future<void> saveCustomerStockImpl(
      List<ProductDto> lstProduct,
      int customerId,
      int? customerVisitId,
      Transaction txn,
      AppLocalizations multiLang) async {
    DateTime now = DateTime.now();
    String dateTimeStr = DateFormat(Constant.dateTimeFormatter).format(now);

    CustomerVisit? customerVisit =
        await customerVisitProvider.select(customerVisitId ?? 0, txn);

    if (customerVisit == null) {
      // throw Exception('Thông tin viếng thăm không tìm thấy');
      message = multiLang
          .notFound([multiLang.information, multiLang.visit].join(" "));
      throw message;
    }

    // get global var
    prefs = await SharedPreferences.getInstance();
    int? baPositionId = prefs.getInt('baPositionId');

    if (baPositionId == null) {
      // throw Exception('Thông tin đăng nhập không được tìm thấy');
      message = multiLang.notFound(multiLang.userInfo);
      throw message;
    }

    if (await syncService.checkSyncCurrent(
        baPositionId ?? 0, SyncType.customerStock, customerVisitId, txn)) {
      // throw Exception('Vui lòng đồng bộ trước');
      message = multiLang.syncNotYetAndDo(multiLang.data);
      throw message;
    }

    List<CustomerStock> lstCustomerStock = [];
    List<CustomerPrice> lstCustomerPrice = [];

    for (ProductDto product in lstProduct) {
      CustomerStock customerStock = CustomerStock(
          customerStockId: product.customerStockId,
          customerId: customerId,
          baPositionId: baPositionId,
          customerVisitId: customerVisitId,
          lastUpdate: dateTimeStr,
          productId: product.productId,
          availableStock: product.quantity,
          createdBy: baPositionId,
          createdDate: dateTimeStr,
          updatedBy: baPositionId,
          updatedDate: dateTimeStr);

      lstCustomerStock.add(customerStock);

      CustomerPrice customerPrice = CustomerPrice(
          customerPriceId: product.customerPriceId,
          customerId: customerId,
          baPositionId: baPositionId,
          customerVisitId: customerVisitId,
          lastUpdate: dateTimeStr,
          productId: product.productId,
          price: product.priceCustomer,
          createdBy: baPositionId,
          createdDate: dateTimeStr,
          updatedBy: baPositionId,
          updatedDate: dateTimeStr);

      lstCustomerPrice.add(customerPrice);
    }
    CustomerPrice? savedCustomerPrice;
    CustomerStock? savedCustomerStock;
    // delete all s_customer_price
    await customerPriceProvider.deleteByCustomerVisitId(
        customerVisitId ?? 0, txn);

    // delete all s_customer_stock
    await customerStockProvider.deleteByCustomerVisitId(
        customerVisitId ?? 0, txn);

    // insert local s_customer_price
    for (CustomerPrice customerPrice in lstCustomerPrice) {
      savedCustomerPrice =
          await customerPriceProvider.insert(customerPrice, txn);
    }

    // insert local s_customer_stock
    for (CustomerStock customerStock in lstCustomerStock) {
      savedCustomerStock =
          await customerStockProvider.insert(customerStock, txn);
    }

    // update is_stock_check_complete
    if (!(customerVisit.isStockCheckCompleted ?? false)) {
      customerVisit.isStockCheckCompleted = true;
      int isUpdate = await customerVisitProvider.updateStockCheckStatus(
          customerVisit, txn);

      if (isUpdate < 1) {
        // throw Exception('Cập nhật trạng thái xác nhận tồn kho thất bại');
        message = [
          multiLang.update,
          multiLang.status,
          multiLang.customerStock,
          multiLang.failed
        ].join(" ");
        throw message;
      }
    }

    // sync data
    var connect = await Connectivity().checkConnectivity();
    if (connect == ConnectivityResult.none) {
      if (!(await syncOfflineProvider.existedCustomerStock(
          savedCustomerStock?.customerVisitId,
          txn,
          SyncType.customerStock.toString(),
          Constant.STS_ACT))) {
        SyncOffline syncOffline = SyncOffline(
            positionId: baPositionId,
            type: SyncType.customerStock.toString(),
            status: Constant.STS_ACT,
            relatedId: savedCustomerStock?.customerVisitId,
            createdDate: dateTimeStr);
        await syncOfflineProvider.insert(syncOffline, txn);
      }
    } else if (connect == ConnectivityResult.wifi ||
        connect == ConnectivityResult.mobile) {
      await syncService.syncStock(lstCustomerPrice, lstCustomerStock,
          customerVisit.customerVisitIdSync, txn, multiLang);
      // if (response.error != null) {
      //   throw Exception(response.error?.code);
      // }
    }
  }

  Future<void> changeAddress(int customerId, AddressVisitDto? address) async {
    emit(EventChangeAddress());
    CustomerVisit result = CustomerVisit();
    List<ProductDto> listCustomerStock = [];
    if (address != null) {
      prefs = await SharedPreferences.getInstance();
      int? shiftReportId = prefs.getInt('shiftReportId');
      List<CustomerVisit> lstCustomerVisit =
          await customerVisitProvider.selectByAddress(
              shiftReportId, customerId, address.customerAddressId);
      if (lstCustomerVisit.isNotEmpty) {
        result = lstCustomerVisit[0];
      }
      listCustomerStock = await customerStockProvider.getAllCustomerStock(
          customerId, address.customerAddressId ?? 0);
    }
    emit(ChangeAddressSuccess(
        result, listCustomerStock, address?.customerAddressId ?? 0));
  }
}

DateTime getSpecificDayOfWeek(DateTime currentDate, int dayOfWeek) {
  DateTime firstDayOfWeek =
      currentDate.subtract(Duration(days: currentDate.weekday));
  int daysToAdd = (dayOfWeek - firstDayOfWeek.weekday - 1) % 7;
  if (daysToAdd <= 0) {
    daysToAdd += 7;
  }

  return firstDayOfWeek.add(Duration(days: daysToAdd));
}
