class PromotionDisplayResultDto {
  int? promotionResultId;
  int? productId;
  String? productName;
  double? resultQty;

  PromotionDisplayResultDto(
      {this.promotionResultId,
      this.productId,
      this.productName,
      this.resultQty});

  factory PromotionDisplayResultDto.fromMap(Map<dynamic, dynamic> map) {
    return PromotionDisplayResultDto(
        promotionResultId: map['promotion_result_id'],
        productId: map['product_id'],
        productName: map['product_name'],
        resultQty: map['result_qty']);
  }
}
