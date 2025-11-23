class PromotionResult {
  int? promotionResultId;
  int? productId;
  int? promotionId;
  int? promotionSchemeId;
  double? resultQty;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  PromotionResult(
      this.promotionResultId,
      this.productId,
      this.promotionId,
      this.promotionSchemeId,
      this.resultQty,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version);

  PromotionResult.fromJson(Map<String, dynamic> json) {
    promotionResultId = json['promotion_result_id'];
    productId = json['product_id'];
    promotionId = json['promotion_id'];
    promotionSchemeId = json['promotion_scheme_id'];
    resultQty = json['result_qty'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['promotion_result_id'] = promotionResultId;
    data['product_id'] = productId;
    data['promotion_id'] = promotionId;
    data['promotion_scheme_id'] = promotionSchemeId;
    data['result_qty'] = resultQty;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    data['updated_by'] = updatedBy;
    data['updated_date'] = updatedDate;
    data['version'] = version;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'promotion_result_id': promotionResultId,
      'product_id': productId,
      'promotion_id': promotionId,
      'promotion_scheme_id': promotionSchemeId,
      'result_qty': resultQty,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version
    };
  }

  PromotionResult.fromMap(Map<dynamic, dynamic> map) {
    promotionResultId = map['promotion_result_id'];
    promotionId = map['promotion_id'];
    promotionSchemeId = map['promotion_scheme_id'];
    productId = map['product_id'];
    resultQty = map['result_qty'];
    createdBy = map['created_by'];
    createdDate = map['created_date'];
    updatedBy = map['updated_by'];
    updatedDate = map['updated_date'];
    version = map['version'];
  }
}
