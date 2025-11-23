class CustomersGroupDetail {
  int? customersGroupDetailId;
  int? customerId;
  int? customersGroupId;
  String? status;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  CustomersGroupDetail(
      this.customersGroupDetailId,
      this.customerId,
      this.customersGroupId,
      this.status,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version);

  CustomersGroupDetail.fromJson(Map<String, dynamic> json) {
    customersGroupDetailId = json['customers_group_detail_id'];
    customerId = json['customer_id'];
    customersGroupId = json['customers_group_id'];
    status = json['status'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customers_group_detail_id'] = customersGroupDetailId;
    data['customer_id'] = customerId;
    data['customers_group_id'] = customersGroupId;
    data['status'] = status;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    data['updated_by'] = updatedBy;
    data['updated_date'] = updatedDate;
    data['version'] = version;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'customers_group_detail_id': customersGroupDetailId,
      'customer_id': customerId,
      'customers_group_id': customersGroupId,
      'status': status,
      'updated_by': updatedBy,
      'created_date': createdDate,
      'updated_date': updatedDate,
      'created_by': createdBy,
      'version': version
    };
  }

  CustomersGroupDetail.fromMap(Map<dynamic, dynamic> map) {
    customersGroupDetailId = map['customers_group_detail_id'];
    customerId = map['customer_id'];
    customersGroupId = map['customers_group_id'];
    status = map['status'];
    createdBy = map['created_by'];
    createdDate = map['created_date'];
    updatedBy = map['updated_by'];
    updatedDate = map['updated_date'];
    version = map['version'];
  }
}
