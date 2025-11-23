class PromotionCondition {
  int? promotionConditionId;
  int? promotionId;
  int? promotionSchemeId;
  String? promotionType;
  String? totalType;
  int? productId;
  double? conditionQty;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  PromotionCondition(
      this.promotionConditionId,
      this.promotionId,
      this.promotionSchemeId,
      this.promotionType,
      this.totalType,
      this.productId,
      this.conditionQty,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version);

  PromotionCondition.fromJson(Map<String, dynamic> json) {
    promotionConditionId = json['promotion_condition_id'];
    promotionId = json['promotion_id'];
    promotionSchemeId = json['promotion_scheme_id'];
    promotionType = json['promotion_type'];
    totalType = json['total_type'];
    productId = json['product_id'];
    conditionQty = json['condition_qty'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['promotion_condition_id'] = promotionConditionId;
    data['promotion_id'] = promotionId;
    data['promotion_scheme_id'] = promotionSchemeId;
    data['promotion_type'] = promotionType;
    data['total_type'] = totalType;
    data['product_id'] = productId;
    data['condition_qty'] = conditionQty;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    data['updated_by'] = updatedBy;
    data['updated_date'] = updatedDate;
    data['version'] = version;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'promotion_condition_id': promotionConditionId,
      'promotion_id': promotionId,
      'promotion_scheme_id': promotionSchemeId,
      'promotion_type': promotionType,
      'total_type': totalType,
      'product_id': productId,
      'condition_qty': conditionQty,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version
    };
  }

  PromotionCondition.fromMap(Map<dynamic, dynamic> map) {
    promotionConditionId = map['promotion_condition_id'];
    promotionId = map['promotion_id'];
    promotionSchemeId = map['promotion_scheme_id'];
    promotionType = map['promotion_type'];
    totalType = map['total_type'];
    productId = map['product_id'];
    conditionQty = map['condition_qty'];
    createdBy = map['created_by'];
    createdDate = map['created_date'];
    updatedBy = map['updated_by'];
    updatedDate = map['updated_date'];
    version = map['version'];
  }
}
