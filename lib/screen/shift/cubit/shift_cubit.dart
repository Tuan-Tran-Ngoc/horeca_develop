import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:horeca/language_setting.dart';
import 'package:horeca/service/sync_service.dart';
import 'package:horeca/utils/call_api_utils.dart';
import 'package:horeca/utils/code_list_utils.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca/utils/message_utils.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/model/request/shift_end_request.dart';
import 'package:horeca_service/model/response/api_response_header.dart';
import 'package:horeca_service/model/shift_report.dart';
import 'package:horeca_service/network/apis.dart';
import 'package:horeca_service/sqflite_database/dto/error_info_dto.dart';
import 'package:horeca_service/sqflite_database/dto/shift_header_dto.dart';
import 'package:horeca_service/sqflite_database/dto/shift_visit_dto.dart';
import 'package:horeca_service/sqflite_database/model/m_sync_offline.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

part 'shift_state.dart';

class ShiftCubit extends Cubit<ShiftState> {
  final BuildContext context;
  ShiftCubit(this.context) : super(ShiftInitial());
  SyncOfflineProvider syncOfflineProvider = SyncOfflineProvider();
  ShiftReportProvider shiftReportProvider = ShiftReportProvider();
  CustomerVisitProvider customerVisitProvider = CustomerVisitProvider();
  SyncService syncService = SyncService();

  late Database database;
  DatabaseProvider db = DatabaseProvider();
  String message = "";

  late SharedPreferences prefs;
  Future<void> init() async {
    emit(LoadingInit());

    prefs = await SharedPreferences.getInstance();

    var shiftReportId = prefs.getInt(Session.shiftReportId.toString());
    var baPositionId = prefs.getInt(Session.baPositionId.toString());

    print(
        'shift_cubit init - shiftReportId: $shiftReportId, baPositionId: $baPositionId');

    final listOrderInCurrentShift =
        await shiftReportProvider.getListOrderInCurrentShift(shiftReportId);
    // print('list order in current shift $listOrderInCurrentShift');
    int index = 0;
    double totalAmount = 0.0;
    List<List<String>> rowDataOrders = listOrderInCurrentShift.map((data) {
      index++;
      totalAmount += data.grandTotalAmount ?? 0.0;
      List<String> result = [];
      result.add(index.toString());
      result.add(data.orderCd.toString());
      result.add(data.customerName.toString());
      result.add(data.fullAddress.toString());
      result.add(NumberFormat.currency(locale: 'vi')
          .format(data.grandTotalAmount ?? 0));
      result.add(
          CodeListUtils.getMessage(Constant.clHorecaSts, data.horecaStatus) ??
              '');
      return result;
    }).toList();
    final listProductInCurrentShift =
        await shiftReportProvider.getListProductInCurrentShift(shiftReportId);

    double totalProductQuantity = 0;

    index = 0;
    List<List<String>> rowDataProducts = listProductInCurrentShift.map((data) {
      index++;
      totalProductQuantity += data.quantity ?? 0;
      List<String> result = [];
      result.add(index.toString());
      result.add(data.productCd.toString());
      result.add(data.productName.toString());

      result.add(NumberFormat.decimalPattern().format(data.quantity));
      result.add(
          NumberFormat.currency(locale: 'vi').format(data.totalAmount ?? 0));
      return result;
    }).toList();
    var shiftReport = await shiftReportProvider.getReport(shiftReportId, null);

    var shiftReportHeader = await shiftReportProvider.getShiftReportInformation(
        shiftReportId, baPositionId);

    if (shiftReportHeader != null) {
      shiftReportHeader.totalOrderAmount = totalAmount;
      shiftReportHeader.totalProductQuantity = totalProductQuantity.toInt();
      shiftReportHeader.totalOrderQuantity = rowDataOrders.length;
      DateTime? originalDate =
          DateTime.tryParse(shiftReportHeader.workingDate ?? '');
      shiftReportHeader.workingDate =
          DateFormat(Constant.dateFormatterDDMMYYYY).format(originalDate!);
      emit(ShiftInitSuccess(
          rowDataOrders,
          listOrderInCurrentShift,
          rowDataProducts,
          listProductInCurrentShift,
          shiftReport!,
          shiftReportHeader));
    }
  }

  Future<void> endShift(ShiftReport? shiftReport) async {
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    try {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      // Use transaction to ensure atomicity - if API fails, DB changes are rolled back
      await database.transaction((txn) async {
        var connect = await Connectivity().checkConnectivity();

        DateTime now = DateTime.now();
        String endTime = DateFormat(Constant.dateTimeFormatter).format(now);
        prefs = await SharedPreferences.getInstance();

        var baPositionId = prefs.getInt(Session.baPositionId.toString());

        print('endShift - baPositionId: $baPositionId');

        // check sync data
        if (await syncService.checkSyncCurrent(
            baPositionId ?? 0, SyncType.endShift, null, txn)) {
          throw multiLang.msgCheckSync;
        }

        if (shiftReport != null) {
          int countVisiting = await customerVisitProvider.countVisiting(
              shiftReport.shiftReportId, Constant.visiting, txn);

          if (countVisiting > 0) {
            throw multiLang.warningCustomerVisitting;
          }

          ShiftReport newData = shiftReport;
          // List<ShiftVisitDto> lstCustomerVisit = await customerVisitProvider
          //     .getPlanCustomerVisit(newData.shiftReportId, txn);
          // bool allVisitCheckout =
          //     lstCustomerVisit.every((element) => element.endTime != null);
          // if (!allVisitCheckout) {
          //   throw Exception(
          //       "Kết thúc ca thất bại, vui lòng hoàn thành viếng thăm");
          // }
          newData.endTime = endTime;
          await shiftReportProvider.updateEndTime(newData, txn);
          if (connect == ConnectivityResult.wifi ||
              connect == ConnectivityResult.mobile) {
            CallApiUtils<dynamic> sendRequest = CallApiUtils();
            ShiftEndRequest requestBody = ShiftEndRequest(
                newData.shiftCode!,
                '${newData.workingDate} 00:00:00.000',
                newData.baPositionId ?? 0,
                endTime,
                newData.shiftReportIdSync ?? 0);
            String requestBodyJson = jsonEncode(requestBody);
            print('EndShift API Request: $requestBodyJson');

            APIResponseHeader response = await sendRequest.sendRequestAPI(
                APIs.endShift, requestBodyJson);

            print('EndShift API Response: ${response.toString()}');
            print('EndShift API Error: ${response.error?.toString()}');

            // Check if API call failed
            if (response.error != null) {
              // Rollback the database changes by throwing an exception
              String errorMessage = response.error?.message ??
                  response.error?.code ??
                  'End shift API call failed';
              throw Exception(
                  '${multiLang.endShift} ${multiLang.failed}: $errorMessage');
            }

            // Only proceed if API call was successful
            message = [multiLang.endShift, multiLang.success].join(" ");

            // Clear session variables when shift ends
            prefs.remove(Session.shiftReportId.toString());
            prefs.remove(Session.shiftCode.toString());
            prefs.remove(Session.workingDate.toString());
          } else if (connect == ConnectivityResult.none) {
            // List<CustomerVisit>? lstVisiting = await customerVisitProvider
            //     .getCustomerVisitByShiftReport(newData.shiftReportId ?? 0, txn);
            // if (lstVisiting!.isNotEmpty) {
            //   message =
            //       MessageUtils.getMessages(code: 'err.ws.shiftreport.0008');
            //   throw message;
            // }
            SyncOffline syncOffline = SyncOffline(
                positionId: newData.baPositionId!,
                type: SyncType.endShift.toString(),
                status: Constant.STS_ACT,
                relatedId: newData.shiftReportId,
                createdDate: endTime);
            await syncOfflineProvider.insert(syncOffline, txn);
            message = [multiLang.endShift, multiLang.success].join(" ");

            // Clear session variables when shift ends
            prefs.remove(Session.shiftReportId.toString());
            prefs.remove(Session.shiftCode.toString());
            prefs.remove(Session.workingDate.toString());
          }

          // Emit success only after all operations complete successfully
          emit(EndShiftSucces(message));
        } else {
          throw 'Thông tin ca không được tìm thấy';
        }
      });
    } catch (error) {
      print('EndShift Error: $error');
      // Ensure any database changes are rolled back
      String errorMessage = error.toString();
      if (errorMessage.contains('Exception:')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }
      emit(EndShiftFailed(errorMessage));
    }
  }

  Future<void> clickButtonChangeState() async {
    emit(ClickEndShiftState());
  }
}
