class SalesInPriceTarget {
  int? salesInPriceTargetId;
  int? salesInPriceId;
  String? targetType;
  int? targetId;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  SalesInPriceTarget(
      this.salesInPriceTargetId,
      this.salesInPriceId,
      this.targetType,
      this.targetId,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version);

  SalesInPriceTarget.fromJson(Map<String, dynamic> json) {
    salesInPriceTargetId = json['sales_in_price_target_id'];
    salesInPriceId = json['sales_in_price_id'];
    targetType = json['target_type'];
    targetId = json['target_id'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sales_in_price_target_id'] = salesInPriceTargetId;
    data['sales_in_price_id'] = salesInPriceId;
    data['target_type'] = targetType;
    data['target_id'] = targetId;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    data['updated_by'] = updatedBy;
    data['updated_date'] = updatedDate;
    data['version'] = version;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sales_in_price_target_id': salesInPriceTargetId,
      'sales_in_price_id': salesInPriceId,
      'target_type': targetType,
      'target_id': targetId,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version
    };
  }

  SalesInPriceTarget.fromMap(Map<dynamic, dynamic> map) {
    salesInPriceTargetId = map['sales_in_price_target_id'];
    salesInPriceId = map['sales_in_price_id'];
    targetType = map['target_type'];
    targetId = map['target_id'];
    createdBy = map['created_by'];
    createdDate = map['created_date'];
    updatedBy = map['updated_by'];
    updatedDate = map['updated_date'];
    version = map['version'];
  }
}
