class DiscountResultInfoDto {
  String? discountType;
  double? resultQty;

  DiscountResultInfoDto({this.discountType, this.resultQty});

  factory DiscountResultInfoDto.fromMap(Map<dynamic, dynamic> map) {
    return DiscountResultInfoDto(
      discountType: map['discount_type'],
      resultQty: map['result_qty'],
    );
  }
}
