class SummaryOrderDto {
  double? totalAmount;
  double? discountAmount;
  double? promotionAmount;
  double? vatAmount;
  double? grandTotalAmount;
  double? totalQuantity;
  int? isTax;

  SummaryOrderDto(
      {this.totalAmount = 0,
      this.discountAmount = 0,
      this.promotionAmount = 0,
      this.vatAmount = 0,
      this.grandTotalAmount = 0,
      this.totalQuantity = 0});
}
