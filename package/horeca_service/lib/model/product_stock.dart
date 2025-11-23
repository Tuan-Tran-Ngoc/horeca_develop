class ProductStock {
  int? productId;
  String? productName;
  String? type;
  String? uom;
  double? priceCost;
  double? allocationStock;
  double? availableStock;
  double? orderUsedStock;
  double? promotionUsedStock;

  ProductStock(
      {this.priceCost,
      this.productId,
      this.productName,
      this.type,
      this.uom,
      this.allocationStock,
      this.availableStock,
      this.orderUsedStock,
      this.promotionUsedStock});

  factory ProductStock.fromMap(Map<dynamic, dynamic> json) {
    return ProductStock(
      productId: json['product_id'],
      productName: json['product_name'],
      type: json['type_name'],
      uom: json['uom_name'],
      priceCost: json['price_cost'],
      allocationStock: json['allocating_stock'],
      availableStock: json['available_stock'],
      orderUsedStock: json['order_used_stock'],
      promotionUsedStock: json['promotion_used_stock'],
    );
  }
}
