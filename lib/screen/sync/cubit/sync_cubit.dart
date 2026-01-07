import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horeca/screen/sync/cubit/sync_state.dart';
import 'package:horeca/service/create_data_service.dart';
import 'package:horeca/service/initial_data_service.dart';
import 'package:horeca/service/sync_service.dart';
import 'package:horeca/service/update_data_service.dart';
import 'package:horeca/utils/call_api_utils.dart';
import 'package:horeca/utils/common_utils.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca_service/contants/network.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/model/request/customer_visit_cancel.dart';
import 'package:horeca_service/model/request/customer_visit_checkin.dart';
import 'package:horeca_service/model/request/customer_visit_checkout.dart';
import 'package:horeca_service/model/request/revisit_request.dart';
import 'package:horeca_service/model/request/shift_end_request.dart';
import 'package:horeca_service/model/request/shift_start_request.dart';
import 'package:horeca_service/model/request/survey_result_save_request.dart';
import 'package:horeca_service/model/response/survey_result_save_response.dart';
import 'package:horeca_service/model/response/customer_visit_response.dart';
import 'package:horeca_service/network/apis.dart';
import 'package:horeca_service/sqflite_database/model/m_sync_offline.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:unique_identifier/unique_identifier.dart';

class SyncCubit extends Cubit<SyncState> {
  final BuildContext context;
  SyncCubit(this.context) : super(SyncOfflineInitial());

  ShiftReportProvider shiftReportProvider = ShiftReportProvider();
  SyncOfflineProvider syncOfflineProvider = SyncOfflineProvider();
  CustomerVisitProvider customerVisitProvider = CustomerVisitProvider();
  CustomerStockProvider customerStockProvider = CustomerStockProvider();
  CustomerPriceProvider customerPriceProvider = CustomerPriceProvider();
  OrderProvider orderProvider = OrderProvider();
  OrderDetailProvider orderDetailProvider = OrderDetailProvider();
  OrderDiscountResultProvider orderDiscountResultProvider =
      OrderDiscountResultProvider();
  OrderPromotionResultProvider orderPromotionResultProvider =
      OrderPromotionResultProvider();
  TransferUpdateLogProvider transferUpdateLogProvider =
      TransferUpdateLogProvider();
  SurveyResultProvider surveyResultProvider = SurveyResultProvider();
  SyncService syncService = SyncService();
  late SharedPreferences prefs;
  String message = "";
  List<Map<String, dynamic>> lstDataSynchronize = [];

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    int? baPositionId = prefs.getInt('baPositionId');
    // AppLocalizations multiLang = AppLocalizations.of(context)!;
    List<SyncOffline> lstSyncOffline =
        await syncOfflineProvider.selectForDisplay();

    // get date lastest update
    TransferUpdateLog? transferUpdateLog =
        await transferUpdateLogProvider.select(baPositionId ?? 0);
    String lastestUpdate = transferUpdateLog?.dateLastestUpdate ?? '';
    if (lastestUpdate != '') {
      lastestUpdate = CommonUtils.convertDate(
          lastestUpdate, Constant.dateFormatterYYYYMMDDHHMM);
    }

    // List<Map<String, dynamic>> lstDataSynchronize = [];
    for (var itemSync in lstSyncOffline) {
      String content = "";
      if (itemSync.type == SyncType.cancelVisit.toString()) {
        content =
            "${AppLocalizations.of(context)!.cancelVisit}: ${await syncOfflineProvider.getContentVisitSync(itemSync.relatedId)}";
      } else if (itemSync.type == SyncType.checkinVisit.toString()) {
        content =
            "${AppLocalizations.of(context)!.startVisit}: ${await syncOfflineProvider.getContentVisitSync(itemSync.relatedId)}";
      } else if (itemSync.type == SyncType.checkoutVisit.toString()) {
        content =
            "${AppLocalizations.of(context)!.endVisit}: ${await syncOfflineProvider.getContentVisitSync(itemSync.relatedId)}";
      } else if (itemSync.type == SyncType.revisit.toString()) {
        content =
            "${AppLocalizations.of(context)!.revisit}: ${await syncOfflineProvider.getContentVisitSync(itemSync.relatedId)}";
      } else if (itemSync.type == SyncType.startShift.toString()) {
        content =
            "${AppLocalizations.of(context)!.startShift}: ${await syncOfflineProvider.getContentShiftSync(itemSync.relatedId)}";
      } else if (itemSync.type == SyncType.endShift.toString()) {
        content =
            "${AppLocalizations.of(context)!.endShift}: ${await syncOfflineProvider.getContentShiftSync(itemSync.relatedId)}";
      } else if (itemSync.type == SyncType.order.toString()) {
        content =
            "${AppLocalizations.of(context)!.order}: ${await syncOfflineProvider.getContentOrderSync(itemSync.relatedId)}";
      } else if (itemSync.type == SyncType.survey.toString()) {
        content =
            "${AppLocalizations.of(context)!.survey}: ${await syncOfflineProvider.getContentSurveySync(itemSync.relatedId)}";
      } else if (itemSync.type == SyncType.customerStock.toString()) {
        content =
            "${AppLocalizations.of(context)!.customerStock}: ${await syncOfflineProvider.getContentVisitSync(itemSync.relatedId)}";
      }

      Map<String, dynamic> map = {
        'id': itemSync.syncOfflineId,
        'syncName': content,
        'startDate': itemSync.createdDate != null
            ? DateFormat("dd/MM/yyyy HH:mm:ss")
                .format(DateTime.parse(itemSync.createdDate!))
            : '',
        'endDate': itemSync.updatedDate != null
            ? DateFormat("dd/MM/yyyy HH:mm:ss")
                .format(DateTime.parse(itemSync.updatedDate!))
            : '',
        'status': itemSync.status == Constant.STS_ACT
            ? AppLocalizations.of(context)!.notSynced
            : AppLocalizations.of(context)!.synced
      };
      lstDataSynchronize.add(map);
    }

    emit(LoadingInit(lstDataSynchronize, lastestUpdate));
  }

  Future<void> synchronize() async {
    emit(OnClickSynchronizeData());
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    var connect = await Connectivity().checkConnectivity();
    if (connect == ConnectivityResult.none) {
      message =
          multiLang.turnOnInternet([multiLang.sync, multiLang.data].join(" "));
      print(message);
      emit(SynchronizeDataFail(message));
    } else if (connect == ConnectivityResult.wifi ||
        connect == ConnectivityResult.mobile) {
      List<SyncOffline> lstSyncOffline =
          await syncOfflineProvider.selectForServerSynchronize();
      try {
        for (var itemSync in lstSyncOffline) {
          if (itemSync.type == SyncType.startShift.toString() ||
              itemSync.type == SyncType.endShift.toString()) {
            await synchronizeShiftReport(itemSync);
          } else if (itemSync.type == SyncType.cancelVisit.toString() ||
              itemSync.type == SyncType.checkoutVisit.toString() ||
              itemSync.type == SyncType.checkinVisit.toString() ||
              itemSync.type == SyncType.revisit.toString()) {
            await synchronizeCustomerVisit(itemSync);
          } else if (itemSync.type == SyncType.order.toString()) {
            await synchronizeOrder(itemSync);
          } else if (itemSync.type == SyncType.customerStock.toString()) {
            await synchronizeCustomerCheckStock(itemSync);
          } else if (itemSync.type == SyncType.survey.toString()) {
            await synchronizeSurvey(itemSync);
          }
          Map<String, dynamic> element = lstDataSynchronize
              .firstWhere((element) => element['id'] == itemSync.syncOfflineId);
          int index = lstDataSynchronize.indexOf(element);
          element['endDate'] =
              DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.now());
          element['status'] = multiLang.synced;
          lstDataSynchronize[index] = element;
        }
        message = [multiLang.sync, multiLang.data, multiLang.success].join(" ");
        emit(SynchronizeDataSuccess(message));
        //emit(LoadingInit(lstDataSynchronize));
      } catch (error) {
        // if (error.toString() ==
        //     MessageUtils.getMessages(code: Constant.SESSION_LOGIN_EXPIRED)) {
        //   await CommonUtils.logout();
        //   GoRouter.of(context).go('/');
        // }
        // emit(SynchronizeDataFail(error.toString()));
        message = [
          multiLang.sync,
          multiLang.data,
          multiLang.failed,
          ': ',
          error.toString()
        ].join(" ");
        emit(SynchronizeDataFail(message));
      }
    }
  }

  Future<void> synchronizeSurvey(SyncOffline surveyOffline) async {
    prefs = await SharedPreferences.getInstance();
    int? baPositionId = prefs.getInt('baPositionId');
    try {
      AppLocalizations multiLang = AppLocalizations.of(context)!;
      SurveyResult? surveyResultExisted =
          await surveyResultProvider.findById(surveyOffline.relatedId!, null);
      if (surveyResultExisted == null) {
        message = multiLang.notFound(multiLang.survey);
        throw message;
      }

      CustomerVisit? customerVisitExisted = await customerVisitProvider.select(
          surveyResultExisted.customerVisitId!, null);

      if (customerVisitExisted == null) {
        message = multiLang.notFound(multiLang.survey);
        throw message;
      }

      SurveyResultSaveRequest request = SurveyResultSaveRequest(
          surveyResultExisted.baPositionId!,
          surveyResultExisted.employeeId!,
          surveyResultExisted.employeeName!,
          surveyResultExisted.surveyId!,
          surveyResultExisted.surveyDate!,
          customerVisitExisted.customerVisitIdSync!,
          surveyResultExisted.resultDetail!);

      CallApiUtils<SurveyResultSaveResponse> sendRequest = CallApiUtils();
      APIResponseEntity<SurveyResultSaveResponse> response =
          await sendRequest.callApiPostMethod(APIs.survey, jsonEncode(request),
              SurveyResultSaveResponse.fromJson);

      surveyOffline.status = Constant.STS_INACT;
      surveyOffline.updatedDate =
          DateFormat(Constant.dateTimeFormatter).format(DateTime.now());
      surveyOffline.updatedBy = baPositionId;
      await syncOfflineProvider.updateStatus(surveyOffline);

      surveyResultExisted.surveyResultIdSync = response.data?.surveyResultId;
      surveyResultExisted.updatedBy = baPositionId;
      surveyResultExisted.updatedDate =
          DateFormat(Constant.dateTimeFormatter).format(DateTime.now());
      await surveyResultProvider.updateSyncId(surveyResultExisted, null);
    } catch (error) {
      rethrow;
    }
  }

  // shift report -> visit -> check customer -> order

  Future<void> synchronizeShiftReport(SyncOffline shiftReportOffline) async {
    prefs = await SharedPreferences.getInstance();
    int? baPositionId = prefs.getInt('baPositionId');
    ShiftReport? shiftExisted =
        await shiftReportProvider.getReport(shiftReportOffline.relatedId, null);

    try {
      //sync start shift -> it means the shift were started in local
      if (shiftReportOffline.type == SyncType.startShift.toString()) {
        ShiftStartRequest shiftRequest = ShiftStartRequest(
            shiftExisted?.shiftCode ?? '',
            baPositionId!,
            '${shiftExisted?.workingDate!} 00:00:00',
            shiftExisted?.startTime ?? '');
        String requestBodyJson = jsonEncode(shiftRequest);

        CallApiUtils<StartShiftResponse> sendRequestAPI =
            CallApiUtils<StartShiftResponse>();
        APIResponseEntity<StartShiftResponse> response =
            await sendRequestAPI.callApiPostMethod(
                APIs.startShift, requestBodyJson, StartShiftResponse.fromJson);

        shiftExisted?.shiftReportIdSync = response.data?.shiftReportId;
        await shiftReportProvider.updateSyncId(shiftExisted!, null);
      }
      //sync end shift -> it means the shift were started in local
      else if (shiftReportOffline.type == SyncType.endShift.toString()) {
        ShiftEndRequest shiftRequest = ShiftEndRequest(
            shiftExisted?.shiftCode ?? '',
            '${shiftExisted?.workingDate!} 00:00:00',
            baPositionId!,
            shiftExisted?.endTime ?? '',
            shiftExisted?.shiftReportIdSync ?? -1);
        String requestBodyJson = jsonEncode(shiftRequest);
        CallApiUtils sendRequestAPI = CallApiUtils();
        await sendRequestAPI.sendRequestAPI(APIs.endShift, requestBodyJson);
      }

      shiftReportOffline.status = Constant.STS_INACT;
      shiftReportOffline.updatedDate =
          DateFormat(Constant.dateTimeFormatter).format(DateTime.now());
      shiftReportOffline.updatedBy = baPositionId;
      await syncOfflineProvider.updateStatus(shiftReportOffline);
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  //sync revisit
  // Future<void> synchroinizeRevisit(SyncOffline offlineData) async {
  //   prefs = await SharedPreferences.getInstance();
  //   int? baPositionId = prefs.getInt('baPositionId');
  //   CustomerVisit? customerVisitExisted =
  //       await customerVisitProvider.select(offlineData.relatedId!, null);
  //   ShiftReport? shiftReportExisted = await shiftReportProvider.getReport(
  //       customerVisitExisted?.shiftReportId, null);
  // }

  //sycn stock
  Future<void> synchronizeCustomerCheckStock(SyncOffline offlineData) async {
    prefs = await SharedPreferences.getInstance();
    int? baPositionId = prefs.getInt('baPositionId');
    AppLocalizations multiLang = AppLocalizations.of(context)!;

    try {
      CustomerVisit? customerVisitExisted =
          await customerVisitProvider.select(offlineData.relatedId!, null);
      List<CustomerStock> lstCustomerStockExisted = await customerStockProvider
          .getAllCustomerStockByVisit(offlineData.relatedId, null);
      List<CustomerPrice> lstCustomerPriceExisted = await customerPriceProvider
          .getAllCustomerPriceByVisit(offlineData.relatedId, null);

      await syncService.syncStock(
          lstCustomerPriceExisted,
          lstCustomerStockExisted,
          customerVisitExisted?.customerVisitIdSync,
          null,
          multiLang);

      offlineData.status = Constant.STS_INACT;
      offlineData.updatedDate =
          DateFormat(Constant.dateTimeFormatter).format(DateTime.now());
      offlineData.updatedBy = baPositionId;
      await syncOfflineProvider.updateStatus(offlineData);
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> synchronizeOrder(SyncOffline orderOffline) async {
    prefs = await SharedPreferences.getInstance();
    int? baPositionId = prefs.getInt('baPositionId');
    AppLocalizations multiLang = AppLocalizations.of(context)!;

    try {
      Order? existedOrder =
          await orderProvider.getOrder(orderOffline.relatedId!);
      print('Order existed $existedOrder');

      List<OrderDetail> lstOrderDtl =
          await orderDetailProvider.selectByOrderId(existedOrder!.orderId!);
      List<OrderPromotionResult> lstPromotionResult =
          await orderPromotionResultProvider
              .getListOrderPromotionResult(existedOrder.orderId!);
      List<OrderDiscountResult> lstDiscountResult =
          await orderDiscountResultProvider
              .getOrderDiscountResult(existedOrder.orderId!);

      await syncService.syncCreateOrder(
          lstOrderDtl,
          lstPromotionResult,
          lstDiscountResult,
          existedOrder,
          existedOrder.customerVisitId ?? 0,
          baPositionId ?? 0,
          null,
          multiLang);

      orderOffline.status = Constant.STS_INACT;
      orderOffline.updatedDate =
          DateFormat(Constant.dateTimeFormatter).format(DateTime.now());
      orderOffline.updatedBy = baPositionId;
      await syncOfflineProvider.updateStatus(orderOffline);
    } catch (error) {
      print(error.toString());
      rethrow;
    }
  }

  Future<void> synchronizeCustomerVisit(
      SyncOffline customerVisitOffline) async {
    prefs = await SharedPreferences.getInstance();
    int? baPositionId = prefs.getInt('baPositionId');
    CustomerVisit? customerVisitExisted = await customerVisitProvider.select(
        customerVisitOffline.relatedId!, null);
    ShiftReport? shiftReportExisted = await shiftReportProvider.getReport(
        customerVisitExisted?.shiftReportId, null);
    try {
      //check in
      if (customerVisitOffline.type == SyncType.checkinVisit.toString()) {
        CustomerVisitCheckinRequest requestBody = CustomerVisitCheckinRequest(
            customerVisitExisted?.customerId ?? 0,
            customerVisitExisted?.customerAddressId ?? 0,
            baPositionId!,
            '${customerVisitExisted?.visitDate!} 00:00:00.000',
            customerVisitExisted?.startTime ?? '',
            shiftReportExisted?.shiftReportIdSync ?? 0,
            shiftReportExisted?.shiftCode ?? '');
        String requestBodyJson = jsonEncode(requestBody);

        CallApiUtils<CustomerVisitResponse> sendRequestAPI = CallApiUtils();

        APIResponseEntity<CustomerVisitResponse> response =
            await sendRequestAPI.callApiPostMethod(
                APIs.checkin, requestBodyJson, CustomerVisitResponse.fromJson);
        
        // Check for API errors
        if (response.error != null) {
          print('Sync checkin API error: ${response.error?.code} - ${response.error?.message}');
          throw Exception(response.error?.message ?? 'Failed to sync checkin visit');
        }
        
        if (response.data?.customerVisitId == null) {
          print('Sync checkin API returned null customer visit ID');
          throw Exception('Failed to get customer visit ID from server during sync');
        }
        
        customerVisitExisted?.customerVisitIdSync =
            response.data?.customerVisitId;
        customerVisitProvider.updateSyncId(customerVisitExisted!, null);

        // update stock for new visit
        // get customer stock available
        List<CustomerStock> lstCustomerStock =
            await customerStockProvider.getAllCustomerStockByVisit(
                customerVisitExisted.customerVisitId, null);

        // get customer price available
        List<CustomerPrice> lstCustomerPrice =
            await customerPriceProvider.getAllCustomerPriceByVisit(
                customerVisitExisted.customerVisitId, null);

        AppLocalizations multiLang = AppLocalizations.of(context)!;
        await syncService.syncStock(lstCustomerPrice, lstCustomerStock,
            customerVisitExisted.customerVisitIdSync, null, multiLang);
      }
      //check out
      else if (customerVisitOffline.type == SyncType.checkoutVisit.toString()) {
        CustomerVisitCheckoutRequest requestBody = CustomerVisitCheckoutRequest(
            customerVisitExisted?.customerVisitIdSync ?? 0,
            customerVisitExisted?.signature ?? '',
            customerVisitExisted?.endTime ?? '');
        String requestBodyJson = jsonEncode(requestBody);

        CallApiUtils<CustomerVisitResponse> sendRequestAPI = CallApiUtils();
        APIResponseEntity<CustomerVisitResponse> response =
            await sendRequestAPI.callApiPostMethod(
                APIs.checkout, requestBodyJson, CustomerVisitResponse.fromJson);
        
        // Check for API errors
        if (response.error != null) {
          print('Sync checkout API error: ${response.error?.code} - ${response.error?.message}');
          throw Exception(response.error?.message ?? 'Failed to sync checkout visit');
        }
      }
      //cancel
      else if (customerVisitOffline.type == SyncType.cancelVisit.toString()) {
        CustomerVisitCancelRequest requestBody = CustomerVisitCancelRequest(
            shiftCode: shiftReportExisted?.shiftCode ?? '',
            shiftReportId: shiftReportExisted?.shiftReportIdSync ?? 0,
            baPositionId: baPositionId!,
            reasonId: customerVisitExisted?.reasonId ?? 0,
            customerId: customerVisitExisted?.customerId ?? 0,
            customerAddressId: customerVisitExisted?.customerAddressId ?? 0,
            visitDate: customerVisitExisted?.visitDate ?? '',
            startTime: customerVisitExisted?.startTime ?? '',
            endTime: customerVisitExisted?.endTime ?? '');

        String requestBodyJson = jsonEncode(requestBody);

        CallApiUtils<CustomerVisitResponse> sendRequestAPI = CallApiUtils();

        APIResponseEntity<CustomerVisitResponse> response =
            await sendRequestAPI.callApiPostMethod(
                APIs.cancel, requestBodyJson, CustomerVisitResponse.fromJson);
      } else if (customerVisitOffline.type == SyncType.revisit.toString()) {
        CustomerVisit? parentCustomerVisit = await customerVisitProvider.select(
            customerVisitExisted?.parentCustomerVisitId ?? 0, null);

        RevisitRequest requestBody = RevisitRequest(
            customerVisitId: parentCustomerVisit?.customerVisitIdSync ?? 0,
            baPositionId: baPositionId!,
            reVisit: {
              "startTime": customerVisitExisted?.startTime ?? '',
              "visitDate": "${customerVisitExisted?.visitDate!} 00:00:00.000"
            });
        String requestBodyJson = jsonEncode(requestBody);

        CallApiUtils<CustomerVisitResponse> sendRequest = CallApiUtils();
        APIResponseEntity<CustomerVisitResponse> response =
            await sendRequest.callApiPostMethod(
                APIs.revisit, requestBodyJson, CustomerVisitResponse.fromJson);
        customerVisitExisted?.customerVisitIdSync =
            response.data?.reVisit?.customerVisitId;
        customerVisitProvider.updateSyncId(customerVisitExisted!, null);

        // update stock for new visit
        // get customer stock available
        List<CustomerStock> lstCustomerStock =
            await customerStockProvider.getAllCustomerStockByVisit(
                customerVisitExisted.customerVisitId, null);

        // get customer price available
        List<CustomerPrice> lstCustomerPrice =
            await customerPriceProvider.getAllCustomerPriceByVisit(
                customerVisitExisted.customerVisitId, null);

        AppLocalizations multiLang = AppLocalizations.of(context)!;
        await syncService.syncStock(lstCustomerPrice, lstCustomerStock,
            customerVisitExisted.customerVisitIdSync, null, multiLang);
      }
      customerVisitOffline.status = Constant.STS_INACT;
      customerVisitOffline.updatedDate =
          DateFormat(Constant.dateTimeFormatter).format(DateTime.now());
      customerVisitOffline.updatedBy = baPositionId;
      await syncOfflineProvider.updateStatus(customerVisitOffline);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> initialData() async {
    var connect = await Connectivity().checkConnectivity();
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    emit(ReloadControl(multiLang.initializingData));
    if (connect == ConnectivityResult.wifi ||
        connect == ConnectivityResult.mobile) {
      try {
        InitialDataService initialDataService = InitialDataService();
        CreateDataService createDataService = CreateDataService();
        await initialDataService.createTable();
        await createDataService.createData();
        await getUpdateData();
        await init();
        emit(InitialDataSuccess());
      } catch (error) {
        emit(InitialDataFail(error.toString()));
      }
    } else {
      emit(InitialDataFail(multiLang.turnOnInternet(multiLang.initialData)));
    }
  }

  Future<void> getUpdateData() async {
    // try {
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    emit(OnClickUpdateData());
    emit(ReloadControl(multiLang.updatingData));
    prefs = await SharedPreferences.getInstance();
    int? baPositionId = prefs.getInt('baPositionId');
    UpdateDataService updateDataService = UpdateDataService();
    String message = await updateDataService.syncUpdateData(multiLang);

    if (message.isEmpty) {
      // get date lastest update
      TransferUpdateLog? transferUpdateLog =
          await transferUpdateLogProvider.select(baPositionId ?? 0);
      String lastestUpdate = transferUpdateLog?.dateLastestUpdate ?? '';
      if (lastestUpdate != '') {
        lastestUpdate = CommonUtils.convertDate(
            lastestUpdate, Constant.dateFormatterYYYYMMDDHHMM);
      }
      message = [multiLang.updateData, multiLang.success].join(" ");
      emit(UpdateDataSuccess(message, lastestUpdate));
    } else {
      emit(UpdateDataFail(message));
    }
  }

  Future<void> downloadUnzip(String masterUrlFile, String type) async {
    final headers = <String, String>{
      'Authorization': 'Bearer ${prefs.getString('token')}',
      // Add other headers as needed
    };
    final getDownloadResponse = await http.get(
        Uri.parse(
            '${Network.url}/api/downloadFile?dataType=$type&fileName=$masterUrlFile'),
        headers: headers);
    // final responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    // print(getDownloadResponse.body);
    if (getDownloadResponse.statusCode == 200) {
      // Get the app's temporary directory to store the downloaded file
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;

      // Replace 'downloaded_file.txt' with the desired filename
      final String filePath = '$tempPath/$masterUrlFile';

      // Write the content of the response to the file
      final File file =
          await File(filePath).writeAsBytes(getDownloadResponse.bodyBytes);

      print('File downloaded successfully at: $file');
      await unzipFile(file.path, type);
    }
  }

  Future<void> unzipFile(String zipFilePath, String type) async {
    // Read the Zip file from disk.
    final bytes = File(zipFilePath).readAsBytesSync();

    // Decode the Zip file
    final archive = ZipDecoder().decodeBytes(bytes);
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = '${tempDir.path}/$type';
    print('tempPath: $tempPath');
    // delete old folder
    final Directory oldDirectory = Directory(tempPath);
    if (await oldDirectory.exists()) {
      await oldDirectory.delete(recursive: true);
    }

    final Directory newDirectory = Directory(tempPath);
    await newDirectory.create(recursive: true);
    // Extract the contents of the Zip archive to disk.
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File('$tempPath/$filename')
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory('$tempPath/$filename').create(recursive: true);
      }
    }
  }

  Future<void> copyDirectory(String sourcePath, String destinationPath) async {
    try {
      // check sourcePath exist
      if (!await Directory(sourcePath).exists()) {
        print('tempPath: $sourcePath not exisit');
        return;
      }

      // Lấy danh sách tất cả các tệp và thư mục trong thư mục nguồn
      List<FileSystemEntity> entities =
          Directory(sourcePath).listSync(recursive: true);

      //override old directory
      await Directory(destinationPath).create(recursive: true);

      // Sao chép từng tệp và thư mục sang thư mục đích
      for (var entity in entities) {
        String newPath = entity.path.replaceFirst(sourcePath, destinationPath);
        if (entity is Directory) {
          await Directory(newPath).create(recursive: true);
        } else if (entity is File) {
          await entity.copy(newPath);
        }
      }
    } catch (e) {
      print(
          'Update data: Copy Directory Fail $sourcePath -> $destinationPath: ${e.toString()}');
    }
  }
}
