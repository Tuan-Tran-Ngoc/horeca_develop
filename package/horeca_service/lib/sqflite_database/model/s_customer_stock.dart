class CustomerStock {
  int? customerStockId;
  int? customerStockIdSync;
  int? customerId;
  int? baPositionId;
  int? customerVisitId;
  int? productId;
  double? availableStock;
  String? lastUpdate;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  CustomerStock({
    this.customerStockId,
    this.customerStockIdSync,
    this.customerId,
    this.baPositionId,
    this.customerVisitId,
    this.productId,
    this.availableStock,
    this.lastUpdate,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.version,
  });

  factory CustomerStock.fromJson(Map<String, dynamic> json) {
    return CustomerStock(
      customerStockId: json['customer_stock_id'],
      customerStockIdSync: json['customer_stock_id_sync'],
      customerId: json['customer_id'],
      baPositionId: json['ba_position_id'],
      customerVisitId: json['customer_visit_id'],
      productId: json['product_id'],
      availableStock: json['available_stock'],
      lastUpdate: json['last_update'],
      createdBy: json['created_by'],
      createdDate: json['created_date'],
      updatedBy: json['updated_by'],
      updatedDate: json['updated_date'],
      version: json['version'],
    );
  }
  factory CustomerStock.fromMap(Map<dynamic, dynamic> json) {
    return CustomerStock(
      customerStockId: json['customer_stock_id'],
      customerStockIdSync: json['customer_stock_id_sync'],
      customerId: json['customer_id'],
      baPositionId: json['ba_position_id'],
      customerVisitId: json['customer_visit_id'],
      productId: json['product_id'],
      availableStock: json['available_stock'],
      lastUpdate: json['last_update'],
      createdBy: json['created_by'],
      createdDate: json['created_date'],
      updatedBy: json['updated_by'],
      updatedDate: json['updated_date'],
      version: json['version'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_stock_id': customerStockId,
      'customer_stock_id_sync': customerStockIdSync,
      'customer_id': customerId,
      'ba_position_id': baPositionId,
      'customer_visit_id': customerVisitId,
      'product_id': productId,
      'available_stock': availableStock,
      'last_update': lastUpdate,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'customer_stock_id': customerStockId,
      'customer_stock_id_sync': customerStockIdSync,
      'customer_id': customerId,
      'ba_position_id': baPositionId,
      'customer_visit_id': customerVisitId,
      'product_id': productId,
      'available_stock': availableStock,
      'last_update': lastUpdate,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }

  Map<String, dynamic> toMapSync() {
    return <String, dynamic>{
      'customer_stock_id': customerStockId,
      'customer_stock_id_sync': customerStockId,
      'customer_id': customerId,
      'ba_position_id': baPositionId,
      'customer_visit_id': customerVisitId,
      'product_id': productId,
      'available_stock': availableStock,
      'last_update': lastUpdate,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }

  factory CustomerStock.copyWith(CustomerStock obj, int customerVisitId) {
    return CustomerStock(
      customerId: obj.customerId,
      baPositionId: obj.baPositionId,
      customerVisitId: customerVisitId,
      productId: obj.productId,
      availableStock: obj.availableStock,
      lastUpdate: obj.lastUpdate,
      createdBy: obj.createdBy,
      createdDate: obj.createdDate,
      updatedBy: obj.updatedBy,
      updatedDate: obj.updatedDate,
      version: obj.version,
    );
  }
}
