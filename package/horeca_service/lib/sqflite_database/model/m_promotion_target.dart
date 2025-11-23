class PromotionTarget {
  int? promotionTargetId;
  int? promotionId;
  String? targetType;
  int? targetId;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  PromotionTarget(
      this.promotionTargetId,
      this.promotionId,
      this.targetType,
      this.targetId,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version);

  PromotionTarget.fromJson(Map<String, dynamic> json) {
    promotionTargetId = json['promotion_target_id'];
    promotionId = json['promotion_id'];
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
    data['promotion_target_id'] = promotionTargetId;
    data['promotion_id'] = promotionId;
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
      'promotion_target_id': promotionTargetId,
      'promotion_id': promotionId,
      'target_type': targetType,
      'target_id': targetId,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version
    };
  }

  PromotionTarget.fromMap(Map<dynamic, dynamic> map) {
    promotionTargetId = map['promotion_target_id'];
    promotionId = map['promotion_id'];
    targetType = map['target_type'];
    targetId = map['target_id'];
    createdBy = map['created_by'];
    createdDate = map['created_date'];
    updatedBy = map['updated_by'];
    updatedDate = map['updated_date'];
    version = map['version'];
  }
}
