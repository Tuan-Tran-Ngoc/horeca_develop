class PromotionConditionInfoDto {
  int? productId;
  String? totalType;
  double? conditionQty;

  PromotionConditionInfoDto(
      {this.productId, this.totalType, this.conditionQty});

  factory PromotionConditionInfoDto.fromMap(Map<dynamic, dynamic> map) {
    return PromotionConditionInfoDto(
      productId: map['product_id'],
      totalType: map['total_type'],
      conditionQty: map['condition_qty'],
    );
  }
}
