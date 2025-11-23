class SapOrderDelivery {
  int? orderDeliveryId;
  int? orderId;
  String? deliveryNo;
  String? deliveryDate;
  String? deliveryStatus;
  String? truckId;
  String? remark;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  SapOrderDelivery(
      this.orderDeliveryId,
      this.orderId,
      this.deliveryNo,
      this.deliveryDate,
      this.deliveryStatus,
      this.truckId,
      this.remark,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version);

  SapOrderDelivery.fromJson(Map<String, dynamic> json) {
    orderDeliveryId = json['order_delivery_id'];
    orderId = json['order_id'];
    deliveryNo = json['delivery_no'];
    deliveryDate = json['delivery_date'];
    deliveryStatus = json['delivery_status'];
    truckId = json['truck_id'];
    remark = json['remark'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_delivery_id'] = orderDeliveryId;
    data['order_id'] = orderId;
    data['delivery_no'] = deliveryNo;
    data['delivery_date'] = deliveryDate;
    data['delivery_status'] = deliveryStatus;
    data['truck_id'] = truckId;
    data['remark'] = remark;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    data['updated_by'] = updatedBy;
    data['updated_date'] = updatedDate;
    data['version'] = version;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'order_delivery_id': orderDeliveryId,
      'order_id': orderId,
      'delivery_no': deliveryNo,
      'delivery_date': deliveryDate,
      'delivery_status': deliveryStatus,
      'truck_id': truckId,
      'remark': remark,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version
    };
  }

  SapOrderDelivery.fromMap(Map<dynamic, dynamic> map) {
    orderDeliveryId = map['order_delivery_id'];
    orderId = map['order_id'];
    deliveryNo = map['delivery_no'];
    deliveryDate = map['delivery_date'];
    deliveryStatus = map['delivery_status'];
    truckId = map['truck_id'];
    remark = map['remark'];
    createdBy = map['created_by'];
    createdDate = map['created_date'];
    updatedBy = map['updated_by'];
    updatedDate = map['updated_date'];
    version = map['version'];
  }
}
