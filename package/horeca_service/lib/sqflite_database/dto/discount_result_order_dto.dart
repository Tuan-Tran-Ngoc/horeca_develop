class DiscountResultOrderDto {
  int? discountId;
  String? conditionType;
  int? schemeId;
  String? discountType;
  double? discountValue;
  double? totalDiscount;
  String? remark;

  DiscountResultOrderDto(
      {this.discountId,
      this.conditionType,
      this.schemeId,
      this.discountType,
      this.discountValue,
      this.totalDiscount,
      this.remark});

  factory DiscountResultOrderDto.fromMap(Map<dynamic, dynamic> map) {
    return DiscountResultOrderDto(
      discountId: map['discount_id'],
      conditionType: map['condition_type'],
      schemeId: map['scheme_id'],
      discountType: map['discount_type'],
      discountValue: map['discount_value'],
      totalDiscount: map['total_discount'],
      remark: map['remark'],
    );
  }
}
