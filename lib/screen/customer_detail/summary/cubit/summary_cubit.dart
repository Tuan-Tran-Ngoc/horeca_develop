import 'dart:convert';
import 'dart:core';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horeca/screen/customer_detail/summary/cubit/summary_state.dart';
import 'package:horeca/service/sync_service.dart';
import 'package:horeca/utils/call_api_utils.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/model/request/customer_visit_checkout.dart';
import 'package:horeca_service/model/response/api_response_header.dart';
import 'package:horeca_service/network/apis.dart';
import 'package:horeca_service/sqflite_database/dto/order_check_out_dto.dart';
import 'package:horeca_service/sqflite_database/dto/product_checkout_dto.dart';
import 'package:horeca_service/sqflite_database/model/m_sync_offline.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SummaryCubit extends Cubit<SummaryState> {
  final BuildContext context;
  SummaryCubit(this.context) : super(SummaryInitial());
  CustomerVisitProvider customerVisitProvider = CustomerVisitProvider();
  OrderProvider orderProvider = OrderProvider();
  OrderDetailProvider orderDetailProvider = OrderDetailProvider();
  CustomerLiabilitiesProvider customerLiabilitiesProvider =
      CustomerLiabilitiesProvider();
  CustomerProvider customerProvider = CustomerProvider();
  SurveyProvider surveyProvider = SurveyProvider();
  SyncService syncService = SyncService();
  late Database database;
  DatabaseProvider db = DatabaseProvider();
  late SharedPreferences prefs;
  String message = "";
  Future<void> init(
      int customerVisitId, int customerId, int customerAddressId) async {
    // Use customerVisitId from session if parameter is 0 or null
    if (customerVisitId == 0) {
      prefs = await SharedPreferences.getInstance();
      customerVisitId = prefs.getInt(Session.customerVisitId.toString()) ?? 0;
    }
    await loadingInit(customerVisitId, customerId, customerAddressId);
  }

  Future<void> loadingInit(
      int customerVisitId, int customerId, int customerAddressId) async {
    CustomerVisit? customerVisit =
        await customerVisitProvider.select(customerVisitId, null);
    List<OrderCheckOutDTO> lstOrder = [];
    List<ProductCheckoutDto> lstProductInfo = [];
    Customer? customer = await customerProvider.getCutomerVisit(customerId);
    CustomerLiabilities? customerLiabilities;
    if (customer != null) {
      String customerCode = customer.customerCode!;
      List<CustomerLiabilities> lstCustomerLiabilities =
          await customerLiabilitiesProvider.select(customerCode, null);
      double sumGrandOrder =
          await orderProvider.sumGrandOrder(customerId, null);

      if (lstCustomerLiabilities.isNotEmpty) {
        customerLiabilities = lstCustomerLiabilities[0];
        customerLiabilities.remainDebtLimit =
            (customerLiabilities.remainDebtLimit ?? 0) + sumGrandOrder.toInt();
      } else {
        customerLiabilities = CustomerLiabilities();
      }
    }
    if (customerVisit != null) {
      lstOrder = await orderProvider.selectByCustomerVisitIdCheckOut(
          customerVisit.shiftReportId ?? 0,
          customerVisit.customerId ?? 0,
          customerVisit.customerAddressId);
      lstProductInfo = await orderDetailProvider.selectReportCheckoutProduct(
          customerVisit.shiftReportId ?? 0,
          customerVisit.customerId ?? 0,
          customerVisit.customerAddressId);
    } else if (customerAddressId != 0) {
      prefs = await SharedPreferences.getInstance();
      // get info shift from global var
      int? shiftReportId = prefs.getInt(Session.shiftReportId.toString());
      lstOrder = await orderProvider.selectByCustomerVisitIdCheckOut(
          shiftReportId ?? 0, customerId, customerAddressId);
      lstProductInfo = await orderDetailProvider.selectReportCheckoutProduct(
          shiftReportId ?? 0, customerId, customerAddressId);
    } else {
      prefs = await SharedPreferences.getInstance();
      // get info shift from global var
      int? shiftReportId = prefs.getInt(Session.shiftReportId.toString());
      lstOrder = await orderProvider.selectByCustomerVisitIdCheckOut(
          shiftReportId ?? 0, customerId, null);
      lstProductInfo = await orderDetailProvider.selectReportCheckoutProduct(
          shiftReportId ?? 0, customerId, null);
    }
    emit(LoadingInit(
        customerVisit, lstProductInfo, lstOrder, customerLiabilities));
  }

  Future<void> checkout(CustomerVisit? customertVisit) async {
    try {
      emit(ReloadControl());
      AppLocalizations multiLang = AppLocalizations.of(context)!;
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      await database.transaction((txn) async {
        print('checkout customer visit id ${customertVisit?.customerVisitId}');
        // await customerVisitProvider.clearTable();
        // emit(CheckoutSuccess());

        DateTime now = DateTime.now();
        String endTime = DateFormat(Constant.dateTimeFormatter).format(now);
        prefs = await SharedPreferences.getInstance();
        int? baPositionId = prefs.getInt(Session.baPositionId.toString());

        // check sync data
        if (await syncService.checkSyncCurrent(baPositionId ?? 0,
            SyncType.checkoutVisit, customertVisit?.customerVisitId, txn)) {
          throw multiLang.msgCheckSync;
        }

        var connect = await Connectivity().checkConnectivity();

        if (customertVisit == null) {
          // throw Exception('Thông tin viếng thăm không tìm thấy');
          message = multiLang
              .notFound([multiLang.information, multiLang.visit].join(" "));
          throw message;
        }

        // List<Survey> lstSurvey = await surveyProvider.selectSurveyByCustomer(
        //     customertVisit.customerId ?? 0,
        //     customertVisit.customerVisitId ?? 0,
        //     txn);
        // if (lstSurvey.isNotEmpty &&
        //     !(customertVisit.isStockCheckCompleted ?? false)) {
        //   throw multiLang.confirmInvetory;
        // } else if (lstSurvey.isNotEmpty &&
        //     !(customertVisit.isSurveyCompleted ?? false)) {
        //   // throw Exception('Vui lòng thực hiện khảo sát');
        //   message = [multiLang.please, multiLang.doSurvey].join(" ");
        //   throw message;
        // }

        CustomerVisit record = customertVisit;
        record.endTime = endTime;
        record.visitStatus = Constant.visited;
        int isUpdate = await customerVisitProvider.update(record, txn);

        if (isUpdate != 1) {
          // throw Exception('Kết thúc viếng thăm không thành công');
          message = [multiLang.endVisit, multiLang.unsucess].join(" ");
          throw message;
        }

        if (connect == ConnectivityResult.none) {
          SyncOfflineProvider syncOfflineProvider = SyncOfflineProvider();

          SyncOffline syncOffline = SyncOffline(
              positionId: baPositionId!,
              type: SyncType.checkoutVisit.toString(),
              status: Constant.STS_ACT,
              relatedId: customertVisit.customerVisitId,
              createdDate: endTime);

          await syncOfflineProvider.insert(syncOffline, txn);
        } else if (connect == ConnectivityResult.wifi ||
            connect == ConnectivityResult.mobile) {
          CustomerVisitCheckoutRequest request = CustomerVisitCheckoutRequest(
              customertVisit.customerVisitIdSync ?? 0,
              customertVisit.signature ?? '',
              endTime);

          CallApiUtils<dynamic> sendRequest = CallApiUtils();
          String requestBodyJson = jsonEncode(request.toJson());
          APIResponseHeader response =
              await sendRequest.sendRequestAPI(APIs.checkout, requestBodyJson);

          if (response.error != null) {
            throw Exception(response.error?.code);
          }
        }

        // Clear customerVisitId from session after successful checkout
        await prefs.remove(Session.customerVisitId.toString());

        message = [multiLang.endVisit, multiLang.success].join(" ");
        emit(CheckoutSuccess(message));
      });
    } catch (error) {
      emit(CheckoutFailed(error.toString()));
    }
  }

  Future<void> clickButtonChangeState() async {
    emit(ClickCheckOutState());
  }
}
