class Discount {
  int? discountId;
  String? discountCode;
  String? discountName;
  String? startDate;
  String? endDate;
  String? status;
  String? conditionType;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  Discount(
      this.discountId,
      this.discountCode,
      this.discountName,
      this.startDate,
      this.endDate,
      this.status,
      this.conditionType,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version);

  Discount.fromJson(Map<String, dynamic> json) {
    discountId = json['discount_id'];
    discountCode = json['discount_code'];
    discountName = json['discount_name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
    conditionType = json['condition_type'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['discount_id'] = discountId;
    data['discount_code'] = discountCode;
    data['discount_name'] = discountName;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['status'] = status;
    data['condition_type'] = conditionType;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    data['updated_by'] = updatedBy;
    data['updated_date'] = updatedDate;
    data['version'] = version;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'discount_id': discountId,
      'discount_code': discountCode,
      'discount_name': discountName,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
      'condition_type': conditionType,
      'updated_by': updatedBy,
      'created_date': createdDate,
      'updated_date': updatedDate,
      'created_by': createdBy,
      'version': version
    };
  }

  Discount.fromMap(Map<dynamic, dynamic> map) {
    discountId = map['discount_id'];
    discountCode = map['discount_code'];
    discountName = map['discount_name'];
    startDate = map['start_date'];
    endDate = map['end_date'];
    status = map['status'];
    conditionType = map['condition_type'];
    createdBy = map['created_by'];
    createdDate = map['created_date'];
    updatedBy = map['updated_by'];
    updatedDate = map['updated_date'];
    version = map['version'];
  }
}
