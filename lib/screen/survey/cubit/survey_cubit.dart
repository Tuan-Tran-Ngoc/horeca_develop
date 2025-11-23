import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:horeca/service/sync_service.dart';
import 'package:horeca/utils/call_api_utils.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/model/response/survey_result_save_response.dart';
import 'package:horeca_service/network/apis.dart';
import 'package:horeca_service/sqflite_database/model/m_sync_offline.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:horeca_service/model/request/survey_result_save_request.dart';

part 'survey_state.dart';

class SurveyCubit extends Cubit<SurveyState> {
  final BuildContext context;
  SurveyCubit(this.context) : super(SurveyInitial());
  SurveyProvider surveyProvider = SurveyProvider();
  EmployeeProvider employeeProvider = EmployeeProvider();
  SurveyResultProvider surveyResultProvider = SurveyResultProvider();
  SyncOfflineProvider syncOfflineProvider = SyncOfflineProvider();
  CustomerVisitProvider customerVisitProvider = CustomerVisitProvider();
  SyncService syncService = SyncService();
  DatabaseProvider db = DatabaseProvider();
  late Database database;
  late SharedPreferences prefs;
  String message = "";

  Future<void> init(int surveyId) async {
    prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    var databasesPath = await getDatabasesPath();
    String pathFolder = '$databasesPath/$username/genHtml/';
    // String pathFolder = '/data/user/0/com.example.horeca/files/genHtml/';
    print('imagePath $pathFolder');

    Survey? surveyInfo = await surveyProvider.getSurvey(surveyId, null);

    if (surveyInfo != null) {
      String htmlPath = '$pathFolder${surveyInfo.surveyCode}.html';
      emit(LoadingInitSuccess(htmlPath));
    } else {
      emit(LoadingInitFail());
    }
  }

  Future<void> saveSurveyResult(
      int customerVisitId, int surveyId, String resultDetail) async {
    print('start survey commit');
    try {
      AppLocalizations multiLang = AppLocalizations.of(context)!;
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      await database.transaction((txn) async {
        prefs = await SharedPreferences.getInstance();
        SurveyResult surveyResult = SurveyResult();
        var baPositionId = prefs.getInt('baPositionId');

        // check sync data
        if (await syncService.checkSyncCurrent(
            baPositionId ?? 0, SyncType.survey, customerVisitId, txn)) {
          throw multiLang.msgCheckSync;
        }

        DateTime now = DateTime.now();
        String dateTimeStr = DateFormat(Constant.dateTimeFormatter).format(now);
        // get info employee
        List<Employee> lstEmployInfo =
            await employeeProvider.getEmployByPosId(baPositionId!, txn);

        Employee employInfo;

        if (lstEmployInfo.isEmpty) {
          // emit(CreateOrderFail(
          //     'Thông tin nhân viên không tìm thấy. Vui lòng đăng nhập lại'));
          // return;
          // throw Exception(
          //     'Thông tin nhân viên không tìm thấy. Vui lòng đăng nhập lại');
          message = [
            multiLang.notFound(
                [multiLang.information, multiLang.employee].join(" ")),
            multiLang.loginAgain
          ].join(".\n");
          throw message;
        }

        // get CustomerVisitSync
        CustomerVisit? customerVisit =
            await customerVisitProvider.select(customerVisitId, txn);

        if (customerVisit == null) {
          // throw Exception('Thông tin viếng thăm không tìm thấy');
          message = multiLang
              .notFound([multiLang.information, multiLang.visit].join(" "));
          throw message;
        }

        // if (customerVisit.customerVisitIdSync == null) {
        //   throw Exception('Vui lòng đồng bộ dữ liệu trước khi khảo sát');
        // }

        Survey? surveyInfo = await surveyProvider.getSurvey(surveyId, txn);

        if (surveyInfo != null) {
          employInfo = lstEmployInfo[0];
          surveyResult = SurveyResult(
              baPositionId: baPositionId,
              surveyId: surveyInfo.surveyId,
              employeeId: employInfo.employeeId,
              employeeName: employInfo.employeeName,
              customerVisitId: customerVisit.customerVisitId,
              surveyDate: dateTimeStr,
              resultDetail: resultDetail,
              createdBy: baPositionId,
              createdDate: dateTimeStr,
              updatedBy: baPositionId,
              updatedDate: dateTimeStr);

          surveyResult = await surveyResultProvider.insert(surveyResult, txn);

          print('surveyResult.detail ${surveyResult.resultDetail}');

          if ((surveyResult.surveyResultId ?? 0) < 1) {
            // throw Exception('Xảy ra lôĩ trong quá trình lưu kết quả khảo sát');
            message = multiLang.errorOccur(multiLang.doSurvey);
            throw message;
          }
        } else {
          // throw Exception(
          //     'Ghi nhận thông tin khảo sát lỗi. Thông tin khảo sát không được tìm thấy');
          message = multiLang.errorOccur(multiLang.doSurvey);
          throw message;
        }
        // update complete customer visit
        if (!(customerVisit.isSurveyCompleted ?? false)) {
          customerVisit.isSurveyCompleted = true;
          int isUpdate = await customerVisitProvider.updateSurveyStatus(
              customerVisit, txn);

          if (isUpdate < 1) {
            // throw Exception('Cập nhật trạng thái khảo sát thấy bại');
            message = [
              multiLang.update,
              multiLang.status,
              multiLang.survey,
              multiLang.failed
            ].join(" ");
            throw message;
          }
        }

        // sync data
        var connect = await Connectivity().checkConnectivity();

        if (connect == ConnectivityResult.none) {
          SyncOffline syncOffline = SyncOffline(
              positionId: baPositionId,
              type: SyncType.survey.toString(),
              status: Constant.STS_ACT,
              relatedId: surveyResult.surveyResultId,
              createdDate: dateTimeStr);
          await syncOfflineProvider.insert(syncOffline, txn);
        } else if (connect == ConnectivityResult.wifi ||
            connect == ConnectivityResult.mobile) {
          SurveyResultSaveRequest request = SurveyResultSaveRequest(
            baPositionId,
            employInfo.employeeId ?? 0,
            employInfo.employeeName ?? '',
            surveyInfo.surveyId ?? 0,
            dateTimeStr,
            customerVisit.customerVisitIdSync ?? 0,
            resultDetail,
          );

          String requestBodyJson = jsonEncode(request.toJson());
          CallApiUtils<SurveyResultSaveResponse> sendRequest = CallApiUtils();
          APIResponseEntity<SurveyResultSaveResponse> response =
              await sendRequest.callApiPostMethod(APIs.survey, requestBodyJson,
                  SurveyResultSaveResponse.fromJson);
          surveyResult.surveyResultIdSync = response.data?.surveyResultId;
          surveyResult.updatedBy = baPositionId;
          surveyResult.updatedDate =
              DateFormat(Constant.dateTimeFormatter).format(DateTime.now());
          await surveyResultProvider.updateSyncId(surveyResult, txn);
        }
        message = [multiLang.doSurvey, multiLang.success].join(" ");
        emit(SaveSurveyResultSuccess(message));
      });
    } catch (error) {
      print(error.toString());
      emit(SaveSurveyResultFail(error.toString()));
    }
  }
}
