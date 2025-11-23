class PromotionContentDto {
  int? promotionId;
  int? promotionSchemeId;
  int? promotionConditionId;
  int? conditionProductId;
  String? conditionProductName;
  String? totalType;
  double? conditionQty;
  int? promotionResultId;
  int? resultProductId;
  String? resultProductName;
  double? resultQty;

  PromotionContentDto(
      {this.promotionId,
      this.promotionSchemeId,
      this.promotionConditionId,
      this.conditionProductId,
      this.conditionProductName,
      this.totalType,
      this.conditionQty,
      this.promotionResultId,
      this.resultProductId,
      this.resultProductName,
      this.resultQty});

  factory PromotionContentDto.fromMap(Map<dynamic, dynamic> map) {
    return PromotionContentDto(
      promotionId: map['promotion_id'],
      promotionSchemeId: map['promotion_scheme_id'],
      promotionConditionId: map['promotion_condition_id'],
      conditionProductId: map['condition_product_id'],
      conditionProductName: map['condition_product_name'],
      totalType: map['total_type'],
      conditionQty: map['condition_qty'],
      promotionResultId: map['promotion_result_id'],
      resultProductId: map['result_product_id'],
      resultProductName: map['result_product_name'],
      resultQty: map['result_qty'],
    );
  }
}
