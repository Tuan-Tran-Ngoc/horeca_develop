class OrderPromotionResult {
  int? orderPromotionResultId;
  int? orderPromotionResultIdSync;
  int? orderId;
  int? promotionId;
  int? promotionSchemeId;
  int? productId;
  double? qty;
  String? description;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  OrderPromotionResult({
    this.orderPromotionResultId,
    this.orderPromotionResultIdSync,
    this.orderId,
    this.promotionId,
    this.promotionSchemeId,
    this.productId,
    this.qty,
    this.description,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.version,
  });

  factory OrderPromotionResult.fromJson(Map<String, dynamic> json) {
    return OrderPromotionResult(
      orderPromotionResultId: json['promotion_result_id'],
      orderPromotionResultIdSync: json['promotion_result_id_sync'],
      orderId: json['order_id'],
      promotionId: json['promotion_id'],
      promotionSchemeId: json['promotion_scheme_id'],
      productId: json['product_id'] is String
          ? int.parse(json['product_id'])
          : json['product_id'],
      qty: json['qty'],
      description: json['description'],
      createdBy: json['created_by'],
      createdDate: json['created_date'],
      updatedBy: json['updated_by'],
      updatedDate: json['updated_date'],
      version: json['version'],
    );
  }
  factory OrderPromotionResult.fromMap(Map<dynamic, dynamic> map) {
    return OrderPromotionResult(
      orderPromotionResultId: map['promotion_result_id'],
      orderPromotionResultIdSync: map['promotion_result_id_sync'],
      orderId: map['order_id'],
      promotionId: map['promotion_id'],
      promotionSchemeId: map['promotion_scheme_id'],
      productId: map['product_id'] is String
          ? int.parse(map['product_id'])
          : map['product_id'],
      qty: map['qty'],
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
      'promotion_result_id': orderPromotionResultId,
      'promotion_result_id_sync': orderPromotionResultIdSync,
      'order_id': orderId,
      'promotion_id': promotionId,
      'promotion_scheme_id': promotionSchemeId,
      'product_id': productId,
      'qty': qty,
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
      'promotion_result_id': orderPromotionResultId,
      'promotion_result_id_sync': orderPromotionResultIdSync,
      'order_id': orderId,
      'promotion_id': promotionId,
      'promotion_scheme_id': promotionSchemeId,
      'qty': qty,
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
      'promotion_result_id': orderPromotionResultId,
      'promotion_result_id_sync': orderPromotionResultId,
      'order_id': orderId,
      'promotion_id': promotionId,
      'promotion_scheme_id': promotionSchemeId,
      'qty': qty,
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
