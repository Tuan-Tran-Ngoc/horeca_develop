import 'package:horeca_service/horeca_service.dart';

class SurveyDto extends Survey {
  int? isComplete;

  SurveyDto(
      {super.surveyId,
      super.surveyCode,
      super.surveyTitle,
      super.description,
      super.startDate,
      super.endDate,
      super.status,
      super.createdBy,
      super.createdDate,
      super.updatedBy,
      super.updatedDate,
      super.version,
      this.isComplete});

  factory SurveyDto.fromMap(Map<dynamic, dynamic> map) {
    return SurveyDto(
        surveyId: map['survey_id'],
        surveyCode: map['survey_code'],
        surveyTitle: map['survey_title'],
        description: map['description'],
        startDate: map['start_date'],
        endDate: map['end_date'],
        status: map['status'],
        createdBy: map['created_by'],
        createdDate: map['created_date'],
        updatedBy: map['updated_by'],
        updatedDate: map['updated_date'],
        version: map['version'],
        isComplete: map['is_complete']);
  }
}
