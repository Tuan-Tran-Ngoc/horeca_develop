import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:horeca/screen/customer_detail/product/cubit/cancel_visit_dialog_state.dart';
import 'package:horeca/utils/call_api_utils.dart';
import 'package:horeca/utils/common_utils.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/model/request/customer_visit_cancel.dart';
import 'package:horeca_service/model/response/customer_visit_response.dart';
import 'package:horeca_service/network/apis.dart';
import 'package:horeca_service/sqflite_database/model/m_sync_offline.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CancelVisitDialogCubit extends Cubit<CancelVisitDialogState> {
  final BuildContext context;
  CancelVisitDialogCubit(this.context) : super(CancelVisitDialogInitial());

  ReasonProvider reasonProvider = ReasonProvider();
  CustomerVisitProvider customerVisitProvider = CustomerVisitProvider();
  EmployeeProvider employeeProvider = EmployeeProvider();
  ShiftReportProvider shiftReportProvider = ShiftReportProvider();
  SyncOfflineProvider syncOfflineProvider = SyncOfflineProvider();
  RouteAssignmentProvider routeAssignmentProvider = RouteAssignmentProvider();
  DatabaseProvider db = DatabaseProvider();
  late Database database;
  String message = "";

  late SharedPreferences prefs;
  Future<void> init() async {
    List<Reason> lstReason =
        await reasonProvider.select(Constant.REASON_TYPE_CANCEL_VISIT);
    emit(LoadingInit(lstReason));
  }

  Future<void> cancelVisit(
      int routeId, int customerId, int customerAddressId, int reasonId) async {
    emit(ReloadControl());
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    prefs = await SharedPreferences.getInstance();
    int? shiftReportId = prefs.getInt(Session.shiftReportId.toString());
    int? baPositionId = prefs.getInt(Session.baPositionId.toString());
    String? shiftCode = prefs.getString(Session.shiftCode.toString());
    try {
      if (!(await CommonUtils.checkShiftForToday())) {
        throw multiLang.mandatoryFinishShift;
      }
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);

      print('path: $path');
      await database.transaction((txn) async {
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

        if (customerAddressId == 0) {
          // throw Exception('Vui lòng chọn địa chỉ viếng thăm');
          message = multiLang.enter(multiLang.customerVisitAddress);
          throw message;
        }

        employInfo = lstEmployInfo[0];

        DateTime now = DateTime.now();
        String endTime = DateFormat(Constant.dateTimeFormatter).format(now);
        String startTime = endTime;

        //get lat/long
        LocationPermission permission = await Geolocator.checkPermission();

        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        CustomerVisit customerVisit = CustomerVisit(
            shiftReportId: shiftReportId,
            customerId: customerId,
            baPositionId: baPositionId,
            employeeId: employInfo.employeeId,
            employeeName: employInfo.employeeName,
            customerAddressId: customerAddressId,
            visitDate: startTime,
            startTime: startTime,
            shiftCode: shiftCode,
            latitude: position.latitude,
            longitude: position.longitude,
            createdBy: baPositionId,
            createdDate: startTime,
            updatedBy: baPositionId,
            updatedDate: startTime,
            visitStatus: Constant.canceledVisit,
            visitTimes: 1,
            version: 1,
            reasonId: reasonId,
            endTime: endTime);
        customerVisit = await customerVisitProvider.insert(customerVisit, txn);

        var connect = await Connectivity().checkConnectivity();
        if (connect == ConnectivityResult.wifi ||
            connect == ConnectivityResult.mobile) {
          ShiftReport? shiftReportExisted =
              await shiftReportProvider.getReport(shiftReportId, txn);
          if (shiftReportExisted?.shiftReportIdSync == null) {
            // throw Exception(
            // 'Thông tin ca làm việc chưa được đồng bộ, vui lòng đồng bộ ca làm việc');
            message = multiLang.syncNotYetAndDo(multiLang.shift);
            throw message;
          }
          CallApiUtils<CustomerVisitResponse> sendRequest =
              CallApiUtils<CustomerVisitResponse>();
          CustomerVisitCancelRequest requestBody = CustomerVisitCancelRequest(
              shiftCode: shiftCode ?? '',
              shiftReportId: shiftReportExisted?.shiftReportIdSync ?? -1,
              baPositionId: baPositionId,
              reasonId: reasonId,
              customerId: customerId,
              customerAddressId: customerAddressId,
              latitude: position.latitude,
              longitude: position.longitude,
              visitDate: startTime,
              startTime: startTime,
              endTime: startTime);
          String requestBodyJson = jsonEncode(requestBody);
          APIResponseEntity<CustomerVisitResponse> response =
              await sendRequest.callApiPostMethod(
                  APIs.cancel, requestBodyJson, CustomerVisitResponse.fromJson);
          customerVisit.customerVisitIdSync = response.data?.customerVisitId;
          await customerVisitProvider.updateSyncId(customerVisit, txn);
        }
        if (connect == ConnectivityResult.none) {
          SyncOffline syncOffline = SyncOffline(
              positionId: baPositionId,
              type: SyncType.cancelVisit.toString(),
              status: Constant.STS_ACT,
              createdDate: startTime,
              relatedId: customerVisit.customerVisitId);
          await syncOfflineProvider.insert(syncOffline, txn);
        }
      });
      message = [multiLang.cancelVisit, multiLang.success].join(" ");
      emit(CancelVisitSuccessfully(message));
    } catch (error) {
      emit(CancelVisitFailed(error));
    }
// get info employee
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
}
