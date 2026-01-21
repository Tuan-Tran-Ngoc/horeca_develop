import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horeca/screen/shift/cubit/shift_popup_state.dart';
import 'package:horeca/service/sync_service.dart';
import 'package:horeca/utils/call_api_utils.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/model/request/shift_start_request.dart';
import 'package:horeca_service/network/apis.dart';
import 'package:horeca_service/sqflite_database/model/m_sync_offline.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

class ShiftPopupCubit extends Cubit<ShiftPopupState> {
  final BuildContext context;
  ShiftPopupCubit(this.context) : super(ShiftPopupInitial());
  ShiftProvider shiftProvider = ShiftProvider();
  ShiftReportProvider shiftReportProvider = ShiftReportProvider();
  EmployeeProvider employeeProvider = EmployeeProvider();
  SyncOfflineProvider syncOfflineProvider = SyncOfflineProvider();
  SyncService syncService = SyncService();
  late Database database;
  DatabaseProvider db = DatabaseProvider();
  late SharedPreferences prefs;
  List<Shift> lstInitialShift = [];
  List<List<String>> lstShift = [];
  String message = "";

  Future<void> init() async {
    // emit(LoadingInit());
    await getInitData();
  }

  Future<void> getInitData() async {
    List<Shift> lstShift = await shiftProvider.getShift();
    emit(ShiftPopupInitialSuccess(lstShift));
  }

  Future<void> insertShiftReport(String shiftCode) async {
    emit(ChooseShiftSuccess());
    try {
      AppLocalizations multiLang = AppLocalizations.of(context)!;
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      await database.transaction((txn) async {
        DateTime now = DateTime.now();
        String workingDate = DateFormat(Constant.dateTimeFormatter).format(now);
        String startTime = DateFormat(Constant.dateTimeFormatter).format(now);
        int timestamp = now.millisecondsSinceEpoch;
        int? shiftReportIdSync;
        ShiftReport? shiftReport;

        prefs = await SharedPreferences.getInstance();

        int? baPositionId = prefs.getInt(Session.baPositionId.toString());

        // check sync data
        if (await syncService.checkSyncCurrent(
            baPositionId ?? 0, SyncType.startShift, null, txn)) {
          throw multiLang.msgCheckSync;
        }

        // get info employee
        List<Employee> lstEmployInfo =
            await employeeProvider.getEmployByPosId(baPositionId!, txn);

        if (lstEmployInfo.isEmpty) {
          // throw Exception(
          // 'Thông tin nhân viên không tìm thấy. Vui lòng đăng nhập lại.');
          // emit(StartShiftFail(
          //     'Thông tin nhân viên không tìm thấy. Vui lòng đăng nhập lại.'));
          message = [
            multiLang.notFound(
                [multiLang.information, multiLang.employee].join(" ")),
            multiLang.loginAgain
          ].join(".\n");
          throw message;
        }

        // check reStartShift
        List<ShiftReport> reStartShift =
            await shiftReportProvider.selectReStartShift(shiftCode, txn);

        if (reStartShift.isNotEmpty) {
          shiftReport = reStartShift[0];
          int isUpdate =
              await shiftReportProvider.updateReStartShift(shiftReport, txn);

          if (isUpdate == -1) {
            // throw Exception('Bắt đầu ca thất bại');
            message = [multiLang.startShift, multiLang.failed].join(" ");
            throw message;
          }
          // setting info old shift
          startTime = shiftReport.startTime ?? '';
        } else {
          Employee employInfo = lstEmployInfo[0];

          // create dto shift report
          ShiftReport record = ShiftReport(
              baPositionId: baPositionId,
              employeeId: employInfo.employeeId,
              employeeName: employInfo.employeeName,
              workingDate: workingDate,
              shiftCode: shiftCode,
              startTime: startTime,
              createdBy: baPositionId,
              createdDate: startTime,
              updatedBy: baPositionId,
              updatedDate: startTime,
              version: 0);

          shiftReport = await shiftReportProvider.insert(record, txn);
        }

        // sync data
        var connect = await Connectivity().checkConnectivity();
        if (connect == ConnectivityResult.none) {
          SyncOffline syncOffline = SyncOffline(
              positionId: baPositionId,
              type: SyncType.startShift.toString(),
              status: Constant.STS_ACT,
              relatedId: shiftReport?.shiftReportId,
              createdDate: startTime);
          await syncOfflineProvider.insert(syncOffline, txn);
        } else if (connect == ConnectivityResult.wifi ||
            connect == ConnectivityResult.mobile) {
          //call api -> 302 status
          // final authService = NetworkService.client.getService<AuthService>();
          // final response = await authService.startShift(request);

          ShiftStartRequest request =
              ShiftStartRequest(shiftCode, baPositionId, startTime, startTime);

          Map<String, dynamic> jsonMapping = request.toJson();
          String json = jsonEncode(jsonMapping);

          CallApiUtils<StartShiftResponse> sendRequest = CallApiUtils();
          APIResponseEntity<StartShiftResponse> response =
              await sendRequest.callApiPostMethod(
                  APIs.startShift, json, StartShiftResponse.fromJson);

          shiftReportIdSync = response.data!.shiftReportId!;
          shiftReport?.shiftReportIdSync = shiftReportIdSync;

          int isUpdate =
              await shiftReportProvider.updateSyncId(shiftReport!, txn);

          if (isUpdate < 1) {
            // throw Exception('Xảy ra lỗi: line 145');
            message = [multiLang.sync, multiLang.shift].join(" ");
            throw message;
          }
        }

        //setting shiftReportId into global varibale
        prefs.setInt(
            Session.shiftReportId.toString(), shiftReport?.shiftReportId ?? 0);
        prefs.setString(Session.shiftCode.toString(), shiftCode);
        prefs.setString(Session.workingDate.toString(), workingDate);

        //setting state
        emit(StartShiftSuccess(shiftReport?.shiftReportId));
      });
    } catch (error) {
      // no commit
      emit(StartShiftFail(error.toString()));
    }
  }
}
