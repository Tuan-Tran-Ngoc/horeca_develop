class SurveyResult {
  int? surveyResultId;
  int? surveyResultIdSync;
  int? surveyId;
  int? surveyQuestionId;
  int? surveyAnswerId;
  String? surveyAnswer;
  String? surveyDate;
  String? resultDetail;
  int? baPositionId;
  int? employeeId;
  String? employeeName;
  int? supPositionId;
  int? customerVisitId;
  int? cityLeaderPositionId;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  SurveyResult({
    this.surveyResultId,
    this.surveyResultIdSync,
    this.surveyId,
    this.surveyQuestionId,
    this.surveyAnswerId,
    this.surveyAnswer,
    this.surveyDate,
    this.resultDetail,
    this.baPositionId,
    this.employeeId,
    this.employeeName,
    this.supPositionId,
    this.customerVisitId,
    this.cityLeaderPositionId,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.version,
  });

  factory SurveyResult.fromJson(Map<String, dynamic> json) {
    return SurveyResult(
      surveyResultId: json['survey_result_id'],
      surveyResultIdSync: json['survey_result_id_sync'],
      surveyId: json['survey_id'],
      surveyQuestionId: json['survey_question_id'],
      surveyAnswerId: json['survey_answer_id'],
      surveyAnswer: json['survey_answer'],
      surveyDate: json['survey_date'],
      resultDetail: json['result_detail'],
      baPositionId: json['ba_position_id'],
      employeeId: json['employee_id'],
      employeeName: json['employee_name'],
      supPositionId: json['sup_position_id'],
      customerVisitId: json['customer_visit_id'],
      cityLeaderPositionId: json['city_leader_position_id'],
      createdBy: json['created_by'],
      createdDate: json['created_date'],
      updatedBy: json['updated_by'],
      updatedDate: json['updated_date'],
      version: json['version'],
    );
  }

  factory SurveyResult.fromMap(Map<dynamic, dynamic> map) {
    return SurveyResult(
      surveyResultId: map['survey_result_id'],
      surveyResultIdSync: map['survey_result_id_sync'],
      surveyId: map['survey_id'],
      surveyQuestionId: map['survey_question_id'],
      surveyAnswerId: map['survey_answer_id'],
      surveyAnswer: map['survey_answer'],
      surveyDate: map['survey_date'],
      resultDetail: map['result_detail'],
      baPositionId: map['ba_position_id'],
      employeeId: map['employee_id'],
      employeeName: map['employee_name'],
      supPositionId: map['sup_position_id'],
      customerVisitId: map['customer_visit_id'],
      cityLeaderPositionId: map['city_leader_position_id'],
      createdBy: map['created_by'],
      createdDate: map['created_date'],
      updatedBy: map['updated_by'],
      updatedDate: map['updated_date'],
      version: map['version'],
    );
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'survey_result_id': surveyResultId,
      'survey_result_id_sync': surveyResultIdSync,
      'survey_id': surveyId,
      'survey_question_id': surveyQuestionId,
      'survey_answer_id': surveyAnswerId,
      'survey_answer': surveyAnswer,
      'survey_date': surveyDate,
      'result_detail': resultDetail,
      'ba_position_id': baPositionId,
      'employee_id': employeeId,
      'employee_name': employeeName,
      'sup_position_id': supPositionId,
      'customer_visit_id': customerVisitId,
      'city_leader_position_id': cityLeaderPositionId,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_date': updatedDate,
      'updated_by': updatedBy,
      'version': version,
    };
  }

  Map<String, dynamic> toMapSync() {
    return <String, dynamic>{
      'survey_result_id': surveyResultId,
      'survey_result_id_sync': surveyResultId,
      'survey_id': surveyId,
      'survey_question_id': surveyQuestionId,
      'survey_answer_id': surveyAnswerId,
      'survey_answer': surveyAnswer,
      'survey_date': surveyDate,
      'result_detail': resultDetail,
      'ba_position_id': baPositionId,
      'employee_id': employeeId,
      'employee_name': employeeName,
      'sup_position_id': supPositionId,
      'customer_visit_id': customerVisitId,
      'city_leader_position_id': cityLeaderPositionId,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_date': updatedDate,
      'updated_by': updatedBy,
      'version': version,
    };
  }
}
