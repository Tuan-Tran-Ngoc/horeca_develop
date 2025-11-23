import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'survey_result_save_response.g.dart';

@JsonSerializable()
class SurveyResultSaveResponse extends Equatable {
  @JsonKey(name: 'surveyResultId')
  final int? surveyResultId;
  @JsonKey(name: 'surveyId')
  final int? surveyId;
  @JsonKey(name: 'surveyDate')
  final String? surveyDate;
  @JsonKey(name: 'customerVisitId')
  final int? customerVisitId;
  @JsonKey(name: 'employeeId')
  final int? employeeId;
  @JsonKey(name: 'employeeName')
  final String? employeeName;
  @JsonKey(name: 'baPositionId')
  final int? baPositionId;
  @JsonKey(name: 'supPositionId')
  final int? supPositionId;
  @JsonKey(name: 'cityLeaderPositionId')
  final int? cityLeaderPositionId;

  const SurveyResultSaveResponse(
      this.surveyResultId,
      this.surveyId,
      this.surveyDate,
      this.customerVisitId,
      this.employeeId,
      this.employeeName,
      this.baPositionId,
      this.supPositionId,
      this.cityLeaderPositionId);

  @override
  List<Object?> get props => [
        surveyResultId,
        surveyId,
        surveyDate,
        customerVisitId,
        employeeId,
        employeeName,
        baPositionId,
        supPositionId,
        cityLeaderPositionId
      ];

  factory SurveyResultSaveResponse.fromJson(Map<String, dynamic> json) =>
      _$SurveyResultSaveResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SurveyResultSaveResponseToJson(this);

  factory SurveyResultSaveResponse.fromMap(Map<String, dynamic> map) =>
      SurveyResultSaveResponse.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}
