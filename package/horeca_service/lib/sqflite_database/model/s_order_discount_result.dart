class OrderDiscountResult {
  int? orderDiscountResultId;
  int? orderDiscountResultIdSync;
  int? orderId;
  int? discountId;
  int? discountSchemeId;
  String? discountType;
  double? discountValue;
  double? totalDiscount;
  int? productId;
  String? description;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  OrderDiscountResult({
    this.orderDiscountResultId,
    this.orderDiscountResultIdSync,
    this.orderId,
    this.discountId,
    this.discountSchemeId,
    this.discountType,
    this.discountValue,
    this.totalDiscount,
    this.productId,
    this.description,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.version,
  });

  factory OrderDiscountResult.fromJson(Map<String, dynamic> json) {
    return OrderDiscountResult(
      orderDiscountResultId: json['discount_result_id'],
      orderDiscountResultIdSync: json['discount_result_id_sync'],
      orderId: json['order_id'],
      discountId: json['discount_id'],
      discountSchemeId: json['discount_scheme_id'],
      discountType: json['discount_type'],
      discountValue: json['discount_value'],
      totalDiscount: json['total_discount'],
      productId: json['product_id'],
      description: json['description'],
      createdBy: json['created_by'],
      createdDate: json['created_date'],
      updatedBy: json['updated_by'],
      updatedDate: json['updated_date'],
      version: json['version'],
    );
  }
  factory OrderDiscountResult.fromMap(Map<dynamic, dynamic> map) {
    return OrderDiscountResult(
      orderDiscountResultId: map['discount_result_id'],
      orderDiscountResultIdSync: map['discount_result_id_sync'],
      orderId: map['order_id'],
      discountId: map['discount_id'],
      discountSchemeId: map['discount_scheme_id'],
      discountType: map['discount_type'],
      discountValue: map['discount_value'],
      totalDiscount: map['total_discount'],
      productId: map['product_id'],
      description: map['description'],
      createdBy: map['created_by'],
      createdDate: map['created_date'],
      updatedBy: map['updated_by'],
      updatedDate: map['updated_date'],
      version: map['version'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'discount_result_id': orderDiscountResultId,
      'discount_result_id_sync': orderDiscountResultIdSync,
      'order_id': orderId,
      'discount_id': discountId,
      'discount_scheme_id': discountSchemeId,
      'discount_type': discountType,
      'discount_value': discountValue,
      'total_discount': totalDiscount,
      'product_id': productId,
      'description': description,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'discount_result_id': orderDiscountResultId,
      'discount_result_id_sync': orderDiscountResultIdSync,
      'order_id': orderId,
      'discount_id': discountId,
      'discount_scheme_id': discountSchemeId,
      'discount_type': discountType,
      'discount_value': discountValue,
      'total_discount': totalDiscount,
      'product_id': productId,
      'description': description,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }

  Map<String, dynamic> toMapSync() {
    return <String, dynamic>{
      'discount_result_id': orderDiscountResultId,
      'discount_result_id_sync': orderDiscountResultId,
      'order_id': orderId,
      'discount_id': discountId,
      'discount_scheme_id': discountSchemeId,
      'discount_type': discountType,
      'discount_value': discountValue,
      'total_discount': totalDiscount,
      'product_id': productId,
      'description': description,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }
}
