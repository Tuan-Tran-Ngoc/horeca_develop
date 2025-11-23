class PromotionDisplayConditionDto {
  int? promotionConditionId;
  int? productId;
  String? productName;
  String? totalType;
  double? conditionQty;

  PromotionDisplayConditionDto(
      {this.promotionConditionId,
      this.productId,
      this.productName,
      this.totalType,
      this.conditionQty});

  factory PromotionDisplayConditionDto.fromMap(Map<dynamic, dynamic> map) {
    return PromotionDisplayConditionDto(
        promotionConditionId: map['promotion_condition_id'],
        productId: map['product_id'],
        productName: map['product_name'],
        totalType: map['total_type'],
        conditionQty: map['condition_qty']);
  }
}
