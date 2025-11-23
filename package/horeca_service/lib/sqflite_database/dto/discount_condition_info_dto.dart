class DiscountConditionInfoDto {
  int? productId;
  double? conditionQty;

  DiscountConditionInfoDto({this.productId, this.conditionQty});

  factory DiscountConditionInfoDto.fromMap(Map<dynamic, dynamic> map) {
    return DiscountConditionInfoDto(
      productId: map['product_id'],
      conditionQty: map['condition_qty'],
    );
  }
}
