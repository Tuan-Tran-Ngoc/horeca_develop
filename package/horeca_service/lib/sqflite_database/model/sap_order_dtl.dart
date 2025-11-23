class SapOrderDtl {
  int? orderDtlId;
  int? orderId;
  String? productCd;
  String? productName;
  String? itemCategory;
  String? unit;
  double? qty;
  double? shippedQty;
  double? unitPrice;
  double? discount;
  double? unitPriceAfterDiscount;
  double? netValue;
  double? taxAmount;
  double? vat;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  SapOrderDtl({
    this.orderDtlId,
    this.orderId,
    this.productCd,
    this.productName,
    this.itemCategory,
    this.unit,
    this.qty,
    this.shippedQty,
    this.unitPrice,
    this.discount,
    this.unitPriceAfterDiscount,
    this.netValue,
    this.taxAmount,
    this.vat,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.version,
  });

  factory SapOrderDtl.fromJson(Map<String, dynamic> json) {
    return SapOrderDtl(
      orderDtlId: json['order_dtl_id'],
      orderId: json['order_id'],
      productCd: json['product_cd'],
      productName: json['product_name'],
      itemCategory: json['item_category'],
      unit: json['unit'],
      qty: json['qty'],
      shippedQty: json['shipped_qty'],
      unitPrice: json['unit_price'],
      discount: json['discount'],
      unitPriceAfterDiscount: json['unit_price_after_discount'],
      netValue: json['net_value'],
      taxAmount: json['tax_amount'],
      vat: json['vat'],
      createdBy: json['created_by'],
      createdDate: json['created_date'],
      updatedBy: json['updated_by'],
      updatedDate: json['updated_date'],
      version: json['version'],
    );
  }

  factory SapOrderDtl.fromMap(Map<dynamic, dynamic> map) {
    return SapOrderDtl(
      orderDtlId: map['order_dtl_id'],
      orderId: map['order_id'],
      productCd: map['product_cd'],
      productName: map['product_name'],
      itemCategory: map['item_category'],
      unit: map['unit'],
      qty: map['qty'],
      shippedQty: map['shipped_qty'],
      unitPrice: map['unit_price'],
      discount: map['discount'],
      unitPriceAfterDiscount: map['unit_price_after_discount'],
      netValue: map['net_value'],
      taxAmount: map['tax_amount'],
      vat: map['vat'],
      createdBy: map['created_by'],
      createdDate: map['created_date'],
      updatedBy: map['updated_by'],
      updatedDate: map['updated_date'],
      version: map['version'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'order_dtl_id': orderDtlId,
      'order_id': orderId,
      'product_cd': productCd,
      'product_name': productName,
      'item_category': itemCategory,
      'unit': unit,
      'qty': qty,
      'shipped_qty': shippedQty,
      'unit_price': unitPrice,
      'discount': discount,
      'unit_price_after_discount': unitPriceAfterDiscount,
      'net_value': netValue,
      'tax_amount': taxAmount,
      'vat': vat,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }
}
