class Order {
  int? orderId;
  int? orderIdSync;
  String? orderCd;
  int? customerId;
  int? customerVisitId;
  int? membershipId;
  int? baPositionId;
  int? employeeId;
  String? employeeName;
  int? supPositionId;
  int? cityLeaderPositionId;
  String? membershipName;
  String? buyerTelNo;
  String? orderDate;
  String? expectDeliveryDate;
  String? poNo;
  double? totalAmount;
  double? vat;
  double? totalDiscount;
  double? cashBackAmount;
  double? collection;
  String? remark;
  double? grandTotalAmount;
  String? orderType;
  int? visitTimes;
  String? sapStatus;
  String? sapOrderNo;
  String? status;
  String? horecaStatus;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;
  int? shiftReportId;

  Order({
    this.orderId,
    this.orderIdSync,
    this.orderCd,
    this.customerId,
    this.customerVisitId,
    this.membershipId,
    this.baPositionId,
    this.employeeId,
    this.employeeName,
    this.supPositionId,
    this.cityLeaderPositionId,
    this.membershipName,
    this.buyerTelNo,
    this.orderDate,
    this.expectDeliveryDate,
    this.poNo,
    this.totalAmount,
    this.vat,
    this.totalDiscount,
    this.cashBackAmount,
    this.collection,
    this.remark,
    this.grandTotalAmount,
    this.orderType,
    this.visitTimes,
    this.sapStatus,
    this.sapOrderNo,
    this.status,
    this.horecaStatus,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.version,
    this.shiftReportId,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['order_id'],
      orderIdSync: json['order_id_sync'],
      orderCd: json['order_cd'],
      customerId: json['customer_id'],
      customerVisitId: json['customer_visit_id'],
      membershipId: json['membership_id'],
      baPositionId: json['ba_position_id'],
      employeeId: json['employee_id'],
      employeeName: json['employee_name'],
      supPositionId: json['sup_position_id'],
      cityLeaderPositionId: json['city_leader_position_id'],
      membershipName: json['membership_name'],
      buyerTelNo: json['buyer_tel_no'],
      orderDate: json['order_date'],
      expectDeliveryDate: json['expect_delivery_date'],
      poNo: json['po_no'],
      totalAmount: json['total_amount'],
      vat: json['vat'],
      totalDiscount: json['total_discount'],
      cashBackAmount: json['cash_back_amount'],
      collection: json['collection'],
      remark: json['remark'],
      grandTotalAmount: json['grand_total_amount'],
      orderType: json['order_type'],
      visitTimes: json['visit_times'],
      sapStatus: json['sap_status'],
      sapOrderNo: json['sap_order_no'],
      status: json['status'],
      horecaStatus: json['horeca_status'],
      createdBy: json['created_by'],
      createdDate: json['created_date'],
      updatedBy: json['updated_by'],
      updatedDate: json['updated_date'],
      version: json['version'],
    );
  }

  factory Order.fromMap(Map<dynamic, dynamic> map) {
    return Order(
      orderId: map['order_id'],
      orderIdSync: map['order_id_sync'],
      orderCd: map['order_cd'],
      customerId: map['customer_id'],
      customerVisitId: map['customer_visit_id'],
      membershipId: map['membership_id'],
      baPositionId: map['ba_position_id'],
      employeeId: map['employee_id'],
      employeeName: map['employee_name'],
      supPositionId: map['sup_position_id'],
      cityLeaderPositionId: map['city_leader_position_id'],
      membershipName: map['membership_name'],
      buyerTelNo: map['buyer_tel_no'],
      orderDate: map['order_date'],
      expectDeliveryDate: map['expect_delivery_date'],
      poNo: map['po_no'],
      totalAmount: map['total_amount'],
      vat: map['vat'],
      totalDiscount: map['total_discount'],
      cashBackAmount: map['cash_back_amount'],
      collection: map['collection'],
      remark: map['remark'],
      grandTotalAmount: map['grand_total_amount'],
      orderType: map['order_type'],
      visitTimes: map['visit_times'],
      sapStatus: map['sap_status'],
      sapOrderNo: map['sap_order_no'],
      status: map['status'],
      horecaStatus: map['horeca_status'],
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
      'order_id_sync': orderIdSync,
      'order_cd': orderCd,
      'customer_id': customerId,
      'customer_visit_id': customerVisitId,
      'membership_id': membershipId,
      'ba_position_id': baPositionId,
      'employee_id': employeeId,
      'employee_name': employeeName,
      'sup_position_id': supPositionId,
      'city_leader_position_id': cityLeaderPositionId,
      'membership_name': membershipName,
      'buyer_tel_no': buyerTelNo,
      'order_date': orderDate,
      'expect_delivery_date': expectDeliveryDate,
      'po_no': poNo,
      'total_amount': totalAmount,
      'vat': vat,
      'total_discount': totalDiscount,
      'cash_back_amount': cashBackAmount,
      'collection': collection,
      'remark': remark,
      'grand_total_amount': grandTotalAmount,
      'order_type': orderType,
      'visit_times': visitTimes,
      'sap_status': sapStatus,
      'sap_order_no': sapOrderNo,
      'status': status,
      'horeca_status': horecaStatus,
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
      'order_id_sync': orderIdSync,
      'order_cd': orderCd,
      'customer_id': customerId,
      'customer_visit_id': customerVisitId,
      'membership_id': membershipId,
      'shift_report_id': shiftReportId,
      'ba_position_id': baPositionId,
      'employee_id': employeeId,
      'employee_name': employeeName,
      'sup_position_id': supPositionId,
      'city_leader_position_id': cityLeaderPositionId,
      'membership_name': membershipName,
      'buyer_tel_no': buyerTelNo,
      'order_date': orderDate,
      'expect_delivery_date': expectDeliveryDate,
      'po_no': poNo,
      'total_amount': totalAmount,
      'vat': vat,
      'total_discount': totalDiscount,
      'cash_back_amount': cashBackAmount,
      'collection': collection,
      'remark': remark,
      'grand_total_amount': grandTotalAmount,
      'order_type': orderType,
      'visit_times': visitTimes,
      'sap_status': sapStatus,
      'sap_order_no': sapOrderNo,
      'status': status,
      'horeca_status': horecaStatus,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }

  Map<String, dynamic> toMapSync() {
    return <String, dynamic>{
      'order_id': orderId,
      'order_id_sync': orderId,
      'order_cd': orderCd,
      'customer_id': customerId,
      'customer_visit_id': customerVisitId,
      'membership_id': membershipId,
      'shift_report_id': shiftReportId,
      'ba_position_id': baPositionId,
      'employee_id': employeeId,
      'employee_name': employeeName,
      'sup_position_id': supPositionId,
      'city_leader_position_id': cityLeaderPositionId,
      'membership_name': membershipName,
      'buyer_tel_no': buyerTelNo,
      'order_date': orderDate,
      'expect_delivery_date': expectDeliveryDate,
      'total_amount': totalAmount,
      'vat': vat,
      'total_discount': totalDiscount,
      'cash_back_amount': cashBackAmount,
      'collection': collection,
      'remark': remark,
      'grand_total_amount': grandTotalAmount,
      'order_type': orderType,
      'visit_times': visitTimes,
      'sap_status': sapStatus,
      'sap_order_no': sapOrderNo,
      'status': status,
      'horeca_status': horecaStatus,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }
}
