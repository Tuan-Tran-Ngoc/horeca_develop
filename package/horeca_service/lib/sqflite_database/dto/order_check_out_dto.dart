class OrderCheckOutDTO {
  int? orderId;
  String? orderCd;
  int? customerId;
  String? customerName;
  String? customerCode;
  String? addressDetail;
  String? streetName;
  double? grandTotalAmount;
  String? fullAddress;
  double? availableStock;
  String? horecaStatus;

  OrderCheckOutDTO(
      {this.orderId,
      this.orderCd,
      this.customerId,
      this.customerName,
      this.customerCode,
      this.addressDetail,
      this.streetName,
      this.grandTotalAmount,
      this.fullAddress,
      this.horecaStatus});

  factory OrderCheckOutDTO.fromMap(Map<dynamic, dynamic> json) {
    return OrderCheckOutDTO(
        orderId: json['order_id'],
        orderCd: json['order_cd'],
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
