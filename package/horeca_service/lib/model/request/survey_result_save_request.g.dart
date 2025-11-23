// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey_result_save_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurveyResultSaveRequest _$SurveyResultSaveRequestFromJson(
        Map<String, dynamic> json) =>
    SurveyResultSaveRequest(
      json['baPositionId'] as int,
      json['employeeId'] as int,
      json['employeeName'] as String,
      json['surveyId'] as int,
      json['surveyDate'] as String,
      json['customerVisitId'] as int,
      json['resultDetail'] as String,
    );

Map<String, dynamic> _$SurveyResultSaveRequestToJson(
        SurveyResultSaveRequest instance) =>
    <String, dynamic>{
      'baPositionId': instance.baPositionId,
      'employeeId': instance.employeeId,
      'employeeName': instance.employeeName,
      'surveyId': instance.surveyId,
      'surveyDate': instance.surveyDate,
      'customerVisitId': instance.customerVisitId,
      'resultDetail': instance.resultDetail,
    };
