class SalesInPrice {
  int? salesInPriceId;
  String? priceCode;
  String? priceName;
  String? status;
  String? startDate;
  String? endDate;
  String? remark;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  SalesInPrice(
      this.salesInPriceId,
      this.priceCode,
      this.priceName,
      this.status,
      this.startDate,
      this.endDate,
      this.remark,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version);

  SalesInPrice.fromJson(Map<String, dynamic> json) {
    salesInPriceId = json['sales_in_price_id'];
    priceCode = json['price_code'];
    priceName = json['price_name'];
    status = json['status'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    remark = json['remark'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sales_in_price_id'] = salesInPriceId;
    data['price_code'] = priceCode;
    data['price_name'] = priceName;
    data['status'] = status;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
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
      'sales_in_price_id': salesInPriceId,
      'price_code': priceCode,
      'price_name': priceName,
      'status': status,
      'start_date': startDate,
      'end_date': endDate,
      'remark': remark,
      'updated_by': updatedBy,
      'created_date': createdDate,
      'updated_date': updatedDate,
      'created_by': createdBy,
      'version': version
    };
  }

  SalesInPrice.fromMap(Map<dynamic, dynamic> map) {
    salesInPriceId = map['sales_in_price_id'];
    priceCode = map['price_code'];
    priceName = map['price_name'];
    status = map['status'];
    startDate = map['start_date'];
    endDate = map['end_date'];
    remark = map['remark'];
    createdBy = map['created_by'];
    createdDate = map['created_date'];
    updatedBy = map['updated_by'];
    updatedDate = map['updated_date'];
    version = map['version'];
  }
}
