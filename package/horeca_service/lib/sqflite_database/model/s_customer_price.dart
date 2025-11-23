class CustomerPrice {
  int? customerPriceId;
  int? customerPriceIdSync;
  int? customerId;
  int? baPositionId;
  int? customerVisitId;
  String? lastUpdate;
  int? productId;
  double? price;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  CustomerPrice(
      {this.customerPriceId,
      this.customerPriceIdSync,
      this.customerId,
      this.baPositionId,
      this.customerVisitId,
      this.lastUpdate,
      this.productId,
      this.price,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version});

  CustomerPrice.fromJson(Map<String, dynamic> json) {
    customerPriceId = json['customer_price_id'];
    customerPriceIdSync = json['customer_price_id_sync'];
    customerId = json['customer_id'];
    baPositionId = json['ba_position_id'];
    customerVisitId = json['customer_visit_id'];
    lastUpdate = json['last_update'];
    productId = json['product_id'];
    price = json['price'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_price_id'] = customerPriceId;
    data['customer_price_id_sync'] = customerPriceIdSync;
    data['customer_id'] = customerId;
    data['ba_position_id'] = baPositionId;
    data['customer_visit_id'] = customerVisitId;
    data['last_update'] = lastUpdate;
    data['product_id'] = productId;
    data['price'] = price;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    data['updated_by'] = updatedBy;
    data['updated_date'] = updatedDate;
    data['version'] = version;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'customer_price_id': customerPriceId,
      'customer_price_id_sync': customerPriceIdSync,
      'customer_id': customerId,
      'ba_position_id': baPositionId,
      'customer_visit_id': customerVisitId,
      'last_update': lastUpdate,
      'product_id': productId,
      'price': price,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version
    };
  }

  Map<String, dynamic> toMapSync() {
    return <String, dynamic>{
      'customer_price_id': customerPriceId,
      'customer_price_id_sync': customerPriceId,
      'customer_id': customerId,
      'ba_position_id': baPositionId,
      'customer_visit_id': customerVisitId,
      'last_update': lastUpdate,
      'product_id': productId,
      'price': price,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version
    };
  }

  CustomerPrice.fromMap(Map<dynamic, dynamic> map) {
    customerPriceId = map['customer_price_id'];
    customerPriceIdSync = map['customer_price_id_sync'];
    customerId = map['customer_id'];
    baPositionId = map['ba_position_id'];
    customerVisitId = map['customer_visit_id'];
    lastUpdate = map['last_update'];
    productId = map['product_id'];
    price = map['price'];
    createdBy = map['created_by'];
    createdDate = map['created_date'];
    updatedBy = map['updated_by'];
    updatedDate = map['updated_date'];
    version = map['version'];
  }

  factory CustomerPrice.copyWith(CustomerPrice obj, int customerVisitId) {
    return CustomerPrice(
      customerId: obj.customerId,
      baPositionId: obj.baPositionId,
      customerVisitId: customerVisitId,
      lastUpdate: obj.lastUpdate,
      productId: obj.productId,
      price: obj.price,
      createdBy: obj.createdBy,
      createdDate: obj.createdDate,
      updatedBy: obj.updatedBy,
      updatedDate: obj.updatedDate,
      version: obj.version,
    );
  }
}
