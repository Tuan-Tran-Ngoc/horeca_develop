class StockBalance {
  int? stockBalanceId;
  int? positionId;
  int? productId;
  double? allocatingStock;
  double? availableStock;
  bool? isGood;
  bool? isReceived;
  String? allocateDate;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  StockBalance({
    this.stockBalanceId,
    this.positionId,
    this.productId,
    this.allocatingStock,
    this.availableStock,
    this.isGood,
    this.isReceived,
    this.allocateDate,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.version,
  });

  factory StockBalance.fromJson(Map<String, dynamic> json) {
    return StockBalance(
      stockBalanceId: json['stock_balance_id'],
      positionId: json['position_id'],
      productId: json['product_id'],
      allocatingStock: json['allocating_stock'],
      availableStock: json['available_stock'],
      isGood: json['is_good'],
      isReceived: json['is_received'],
      allocateDate: json['allocate_date'],
      createdBy: json['created_by'],
      createdDate: json['created_date'],
      updatedBy: json['updated_by'],
      updatedDate: json['updated_date'],
      version: json['version'],
    );
  }

  factory StockBalance.fromMap(Map<dynamic, dynamic> json) {
    return StockBalance(
      stockBalanceId: json['stock_balance_id'],
      positionId: json['position_id'],
      productId: json['product_id'],
      allocatingStock: json['allocating_stock'],
      availableStock: json['available_stock'],
      isGood: json['is_good'] == 1 ? true : false,
      isReceived: json['is_received'] == 1 ? true : false,
      allocateDate: json['allocate_date'],
      createdBy: json['created_by'],
      createdDate: json['created_date'],
      updatedBy: json['updated_by'],
      updatedDate: json['updated_date'],
      version: json['version'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'stock_balance_id': stockBalanceId,
      'position_id': positionId,
      'product_id': productId,
      'allocating_stock': allocatingStock,
      'available_stock': availableStock,
      'is_good': isGood,
      'is_received': isReceived,
      'allocate_date': allocateDate,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stock_balance_id': stockBalanceId,
      'position_id': positionId,
      'product_id': productId,
      'allocating_stock': allocatingStock,
      'available_stock': availableStock,
      'is_good': isGood == true ? 1 : 0,
      'is_received': isReceived == true ? 1 : 0,
      'allocate_date': allocateDate,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }
}
