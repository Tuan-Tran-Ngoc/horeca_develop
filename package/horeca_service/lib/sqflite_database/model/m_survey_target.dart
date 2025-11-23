class SurveyTarget {
  int? surveyTargetId;
  int? surveyId;
  String? targetType;
  int? targetId;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  SurveyTarget(
      this.surveyTargetId,
      this.surveyId,
      this.targetType,
      this.targetId,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version);

  SurveyTarget.fromJson(Map<String, dynamic> json) {
    surveyTargetId = json['survey_target_id'];
    surveyId = json['survey_id'];
    targetType = json['target_type'];
    targetId = json['target_id'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['survey_target_id'] = surveyTargetId;
    data['survey_id'] = surveyId;
    data['target_type'] = targetType;
    data['target_id'] = targetId;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    data['updated_by'] = updatedBy;
    data['updated_date'] = updatedDate;
    data['version'] = version;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'survey_target_id': surveyTargetId,
      'survey_id': surveyId,
      'target_type': targetType,
      'target_id': targetId,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version
    };
  }

  SurveyTarget.fromMap(Map<dynamic, dynamic> map) {
    surveyTargetId = map['reason_id'];
    surveyId = map['reason_type'];
    targetType = map['reason_content'];
    targetId = map['status'];
    createdBy = map['created_by'];
    createdDate = map['created_date'];
    updatedBy = map['updated_by'];
    updatedDate = map['updated_date'];
    version = map['version'];
  }
}
