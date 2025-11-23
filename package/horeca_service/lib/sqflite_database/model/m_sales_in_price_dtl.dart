class SalesInPriceDtl {
  int? salesInPriceDtlId;
  int? salesInPriceId;
  int? productId;
  double? price;
  double? priceVat;
  double? vat;
  String? startDate;
  String? endDate;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  SalesInPriceDtl(
      this.salesInPriceDtlId,
      this.salesInPriceId,
      this.productId,
      this.price,
      this.priceVat,
      this.vat,
      this.startDate,
      this.endDate,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version);

  SalesInPriceDtl.fromJson(Map<String, dynamic> json) {
    salesInPriceDtlId = json['sales_in_price_dtl_id'];
    salesInPriceId = json['sales_in_price_id'];
    productId = json['product_id'];
    price = json['price'];
    priceVat = json['price_vat'];
    vat = json['vat'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sales_in_price_dtl_id'] = salesInPriceDtlId;
    data['sales_in_price_id'] = salesInPriceId;
    data['product_id'] = productId;
    data['price'] = price;
    data['price_vat'] = priceVat;
    data['vat'] = vat;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    data['updated_by'] = updatedBy;
    data['updated_date'] = updatedDate;
    data['version'] = version;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sales_in_price_dtl_id': salesInPriceDtlId,
      'sales_in_price_id': salesInPriceId,
      'product_id': productId,
      'price': price,
      'price_vat': priceVat,
      'vat': vat,
      'start_date': startDate,
      'end_date': endDate,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version
    };
  }

  SalesInPriceDtl.fromMap(Map<dynamic, dynamic> map) {
    salesInPriceDtlId = map['sales_in_price_dtl_id'];
    salesInPriceId = map['sales_in_price_id'];
    productId = map['product_id'];
    price = map['price'];
    priceVat = map['price_vat'];
    vat = map['vat'];
    startDate = map['start_date'];
    endDate = map['end_date'];
    createdBy = map['created_by'];
    createdDate = map['created_date'];
    updatedBy = map['updated_by'];
    updatedDate = map['updated_date'];
    version = map['version'];
  }
}
