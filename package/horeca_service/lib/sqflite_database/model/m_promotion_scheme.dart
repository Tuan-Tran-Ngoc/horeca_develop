class PromotionScheme {
  int? promotionSchemeId;
  int? promotionId;
  int? priority;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  PromotionScheme(
      this.promotionSchemeId,
      this.promotionId,
      this.priority,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version);

  PromotionScheme.fromJson(Map<String, dynamic> json) {
    promotionSchemeId = json['promotion_scheme_id'];
    promotionId = json['promotion_id'];
    priority = json['priority'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    version = json['version'];
  }

  PromotionScheme.fromMap(Map<dynamic, dynamic> map) {
    promotionSchemeId = map['promotion_scheme_id'];
    promotionId = map['promotion_id'];
    priority = map['priority'];
    createdBy = map['created_by'];
    createdDate = map['created_date'];
    updatedBy = map['updated_by'];
    updatedDate = map['updated_date'];
    version = map['version'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'promotion_scheme_id': promotionSchemeId,
      'promotion_id': promotionId,
      'priority': priority,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version
    };
  }
}
