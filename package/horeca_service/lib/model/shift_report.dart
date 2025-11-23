// import 'dart:ffi';

class ListOrderInShift {
  int? orderId;
  String? orderCd;
  String? orderDate;
  int? customerId;
  String? customerName;
  String? customerCode;
  String? addressDetail;
  String? streetName;
  double? grandTotalAmount;
  String? fullAddress;
  String? horecaStatus;

  double? availableStock;
  ListOrderInShift(
      {this.orderId,
      this.orderCd,
      this.orderDate,
      this.customerId,
      this.customerName,
      this.customerCode,
      this.addressDetail,
      this.streetName,
      this.grandTotalAmount,
      this.fullAddress,
      this.horecaStatus});

  factory ListOrderInShift.fromMap(Map<dynamic, dynamic> json) {
    return ListOrderInShift(
        orderId: json['order_id'],
        orderCd: json['order_cd'],
        orderDate: json['order_date'],
        customerId: json['customer_id'],
        customerName: json['customer_name'],
        customerCode: json['customer_code'],
        addressDetail: json['address_detail'],
        streetName: json['street_name'],
        grandTotalAmount: json['grand_total_amount'],
        fullAddress: json['full_address'],
        horecaStatus: json['horeca_status']);
  }
}

class ListProductsInShift {
  int? productId;
  String? productCd;
  String? productName;
  double? quantity;
  double? totalAmount;

  ListProductsInShift({
    this.productId,
    this.productCd,
    this.productName,
    this.quantity,
    this.totalAmount,
  });

  factory ListProductsInShift.fromMap(Map<dynamic, dynamic> json) {
    return ListProductsInShift(
      productId: json['product_id'],
      productCd: json['product_cd'],
      productName: json['product_name'],
      quantity: json['quantity'],
      totalAmount: json['total_amount'],
    );
  }
}
