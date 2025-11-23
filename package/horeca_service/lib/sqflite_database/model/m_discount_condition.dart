class DiscountCondition {
  int? discountConditionId;
  int? discountId;
  int? discountSchemeId;
  String? totalType;
  int? productId;
  double? conditionQty;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  DiscountCondition(
      this.discountConditionId,
      this.discountId,
      this.discountSchemeId,
      this.totalType,
      this.productId,
      this.conditionQty,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version);

  DiscountCondition.fromJson(Map<String, dynamic> json) {
    discountConditionId = json['discount_condition_id'];
    discountId = json['discount_id'];
    discountSchemeId = json['discount_scheme_id'];
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
    data['discount_condition_id'] = discountConditionId;
    data['discount_id'] = discountId;
    data['discount_scheme_id'] = discountSchemeId;
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
      'discount_condition_id': discountConditionId,
      'discount_id': discountId,
      'discount_scheme_id': discountSchemeId,
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

  DiscountCondition.fromMap(Map<dynamic, dynamic> map) {
    discountConditionId = map['discount_condition_id'];
    discountId = map['discount_id'];
    discountSchemeId = map['discount_scheme_id'];
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
