class SummaryOrderDto {
  double? totalAmount;
  double? totalQuantity;
  double? discountAmount;
  double? promotionAmount;
  double? vatAmount;
  double? grandTotalAmount;
  int? isTax;

  SummaryOrderDto({
    this.totalAmount = 0,
    this.totalQuantity = 0,
    this.discountAmount = 0,
    this.promotionAmount = 0,
    this.vatAmount = 0,
    this.grandTotalAmount = 0,
  });
}
