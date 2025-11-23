class DiscountContentDto {
  int? discountId;
  String? conditionType;
  int? discountSchemeId;
  int? discountConditionId;
  int? conditionProductId;
  String? conditionProductName;
  double? conditionQty;
  String? totalType;
  int? discountResultId;
  int? resultProductId;
  String? resultProductName;
  String? discountType;
  double? resultQty;

  DiscountContentDto(
      {this.discountId,
      this.conditionType,
      this.discountSchemeId,
      this.discountConditionId,
      this.conditionProductId,
      this.conditionProductName,
      this.conditionQty,
      this.totalType,
      this.discountResultId,
      this.resultProductId,
      this.resultProductName,
      this.discountType,
      this.resultQty});

  factory DiscountContentDto.fromMap(Map<dynamic, dynamic> map) {
    return DiscountContentDto(
      discountId: map['discount_id'],
      conditionType: map['condition_type'],
      discountSchemeId: map['discount_scheme_id'],
      discountConditionId: map['discount_condition_id'],
      conditionProductId: map['condition_product_id'],
      conditionProductName: map['condition_product_name'],
      conditionQty: map['condition_qty'],
      totalType: map['total_type'],
      discountResultId: map['discount_result_id'],
      resultProductId: map['result_product_id'],
      resultProductName: map['result_product_name'],
      discountType: map['discount_type'],
      resultQty: map['result_qty'],
    );
  }
}
