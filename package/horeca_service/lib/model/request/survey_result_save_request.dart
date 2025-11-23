import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'survey_result_save_request.g.dart';

@JsonSerializable()
class SurveyResultSaveRequest extends Equatable {
  @JsonKey(name: 'baPositionId')
  final int baPositionId;
  @JsonKey(name: 'employeeId')
  final int employeeId;
  @JsonKey(name: 'employeeName')
  final String employeeName;
  @JsonKey(name: 'surveyId')
  final int surveyId;
  @JsonKey(name: 'surveyDate')
  final String surveyDate;
  @JsonKey(name: 'customerVisitId')
  final int customerVisitId;
  @JsonKey(name: 'resultDetail')
  final String resultDetail;

  const SurveyResultSaveRequest(
      this.baPositionId,
      this.employeeId,
      this.employeeName,
      this.surveyId,
      this.surveyDate,
      this.customerVisitId,
      this.resultDetail);

  factory SurveyResultSaveRequest.fromJson(Map<String, dynamic> json) =>
      _$SurveyResultSaveRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SurveyResultSaveRequestToJson(this);

  @override
  List<Object?> get props => [
        baPositionId,
        employeeId,
        employeeName,
        surveyId,
        surveyDate,
        customerVisitId,
        resultDetail
      ];
}
