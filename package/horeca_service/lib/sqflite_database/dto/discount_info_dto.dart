class DiscountInfoDto {
  int? discountId;
  String? conditionType; //00: total order, 01: product
  String? discountCode;
  String? discountName;
  int? discountSchemeId;
  int? productId;
  String? totalType;
  double? conditionQty;
  String? discountType; //00: percent, 01: money
  double? resultQty;

  DiscountInfoDto(
      {this.discountId,
      this.conditionType,
      this.discountCode,
      this.discountName,
      this.discountSchemeId,
      this.productId,
      this.totalType,
      this.conditionQty,
      this.discountType,
      this.resultQty});

  factory DiscountInfoDto.fromMap(Map<dynamic, dynamic> map) {
    return DiscountInfoDto(
        discountId: map['discount_id'],
        conditionType: map['condition_type'],
        discountCode: map['discount_code'],
        discountName: map['discount_name'],
        discountSchemeId: map['discount_scheme_id'],
        productId: map['product_id'],
        totalType: map['total_type'],
        conditionQty: map['condition_qty'],
        discountType: map['discount_type'],
        resultQty: map['result_qty']);
  }
}
