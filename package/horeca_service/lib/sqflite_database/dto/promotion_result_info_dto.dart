class PromotionResultInfoDto {
  int? productId;
  String? productName;
  double? resultQty;

  PromotionResultInfoDto({this.productId, this.productName, this.resultQty});

  factory PromotionResultInfoDto.fromMap(Map<dynamic, dynamic> map) {
    return PromotionResultInfoDto(
        productId: map['product_id'],
        productName: map['product_name'],
        resultQty: map['result_qty']);
  }
}
