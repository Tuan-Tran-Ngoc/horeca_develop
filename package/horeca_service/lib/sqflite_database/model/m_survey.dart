import 'package:horeca_service/sqflite_database/model/common_column.dart';

class Survey {
  int? surveyId;
  String? surveyCode;
  String? surveyTitle;
  String? description;
  String? startDate;
  String? endDate;
  String? status;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  Survey({
    this.surveyId,
    this.surveyCode,
    this.surveyTitle,
    this.description,
    this.startDate,
    this.endDate,
    this.status,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.version,
  });

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      surveyId: json['survey_id'],
      surveyCode: json['survey_code'],
      surveyTitle: json['survey_title'],
      description: json['description'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      status: json['status'],
      createdBy: json['created_by'],
      createdDate: json['created_date'],
      updatedBy: json['updated_by'],
      updatedDate: json['updated_date'],
      version: json['version'],
    );
  }

  factory Survey.fromMap(Map<dynamic, dynamic> map) {
    return Survey(
      surveyId: map[columnSurveyId],
      surveyCode: map[columnSurveyCode],
      surveyTitle: map[columnSurveyTitle],
      description: map[columnDescription],
      startDate: map[columnStartDate],
      endDate: map[columnEndDate],
      status: map[columnStatus],
      createdBy: map[columnCreatedBy],
      createdDate: map[columnCreatedDate],
      updatedBy: map[columnUpdatedBy],
      updatedDate: map[columnUpdatedDate],
      version: map[columnVersion],
    );
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'survey_id': surveyId,
      'survey_code': surveyCode,
      'survey_title': surveyTitle,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_date': updatedDate,
      'updated_by': updatedBy,
      'version': version,
    };
  }

  @override
  String toString() {
    return 'SurveyModel(surveyId: $surveyId, surveyCode: $surveyCode, surveyTitle: $surveyTitle, '
        'description: $description, startDate: $startDate, endDate: $endDate, status: $status, '
        'createdBy: $createdBy, createdDate: $createdDate, updatedBy: $updatedBy, '
        'updatedDate: $updatedDate, version: $version)';
  }
}
