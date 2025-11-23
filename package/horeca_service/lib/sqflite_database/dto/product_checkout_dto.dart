class ProductCheckoutDto {
  String? productCd;
  String? productName;
  int? totalQty;
  double? totalAmount;

  ProductCheckoutDto(
      {this.productCd, this.productName, this.totalQty, this.totalAmount});

  factory ProductCheckoutDto.fromMap(Map<dynamic, dynamic> map) {
    return ProductCheckoutDto(
        productCd: map['product_cd'],
        productName: map['product_name'],
        totalQty: (map['total_qty'] as num?)?.toInt(),
        totalAmount: map['total_amount']);
  }
}
