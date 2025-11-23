class SapOrder {
  int? orderId;
  String? orderNo;
  String? customerCd;
  String? customerName;
  String? shipToPartyName;
  String? shipToParty;
  double? totalNetValue;
  String? orderDate;
  String? status;
  String? poHrc;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  SapOrder({
    this.orderId,
    this.orderNo,
    this.customerCd,
    this.customerName,
    this.shipToPartyName,
    this.shipToParty,
    this.totalNetValue,
    this.orderDate,
    this.status,
    this.poHrc,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.version,
  });

  factory SapOrder.fromJson(Map<String, dynamic> json) {
    return SapOrder(
      orderId: json['order_id'],
      orderNo: json['order_no'],
      customerCd: json['customer_cd'],
      customerName: json['customer_name'],
      shipToPartyName: json['ship_to_party_name'],
      shipToParty: json['ship_to_party'],
      totalNetValue: json['total_net_value'],
      orderDate: json['order_date'],
      status: json['status'],
      poHrc: json['po_hrc'],
      createdBy: json['created_by'],
      createdDate: json['created_date'],
      updatedBy: json['updated_by'],
      updatedDate: json['updated_date'],
      version: json['version'],
    );
  }

  factory SapOrder.fromMap(Map<dynamic, dynamic> map) {
    return SapOrder(
      orderId: map['order_id'],
      orderNo: map['order_no'],
      customerCd: map['customer_cd'],
      customerName: map['customer_name'],
      shipToPartyName: map['ship_to_party_name'],
      shipToParty: map['ship_to_party'],
      totalNetValue: map['total_net_value'],
      orderDate: map['order_date'],
      status: map['status'],
      poHrc: map['po_hrc'],
      createdBy: map['created_by'],
      createdDate: map['created_date'],
      updatedBy: map['updated_by'],
      updatedDate: map['updated_date'],
      version: map['version'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'order_no': orderNo,
      'customer_cd': customerCd,
      'customer_name': customerName,
      'ship_to_party_name': shipToPartyName,
      'ship_to_party': shipToParty,
      'total_net_value': totalNetValue,
      'order_date': orderDate,
      'status': status,
      'po_hrc': poHrc,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'order_id': orderId,
      'order_no': orderNo,
      'customer_cd': customerCd,
      'customer_name': customerName,
      'ship_to_party_name': shipToPartyName,
      'ship_to_party': shipToParty,
      'total_net_value': totalNetValue,
      'order_date': orderDate,
      'status': status,
      'po_hrc': poHrc,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }
}
