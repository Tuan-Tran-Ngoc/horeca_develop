// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey_result_save_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurveyResultSaveResponse _$SurveyResultSaveResponseFromJson(
        Map<String, dynamic> json) =>
    SurveyResultSaveResponse(
      json['surveyResultId'] as int?,
      json['surveyId'] as int?,
      json['surveyDate'] as String?,
      json['customerVisitId'] as int?,
      json['employeeId'] as int?,
      json['employeeName'] as String?,
      json['baPositionId'] as int?,
      json['supPositionId'] as int?,
      json['cityLeaderPositionId'] as int?,
    );

Map<String, dynamic> _$SurveyResultSaveResponseToJson(
        SurveyResultSaveResponse instance) =>
    <String, dynamic>{
      'surveyResultId': instance.surveyResultId,
      'surveyId': instance.surveyId,
      'surveyDate': instance.surveyDate,
      'customerVisitId': instance.customerVisitId,
      'employeeId': instance.employeeId,
      'employeeName': instance.employeeName,
      'baPositionId': instance.baPositionId,
      'supPositionId': instance.supPositionId,
      'cityLeaderPositionId': instance.cityLeaderPositionId,
    };
