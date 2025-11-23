class Customer {
  String? representativeName;
  int? areaId;
  int? createdBy;
  int? version;
  int? distributorId;
  int? updatedBy;
  String? customerName;
  String? createdDate;
  String? updatedDate;
  int? customerId;
  String? isUse;
  int? isTax;
  String? customerCode;
  String? status;

  Customer({
    this.representativeName,
    this.areaId,
    this.createdBy,
    this.version,
    this.distributorId,
    this.updatedBy,
    this.customerName,
    this.createdDate,
    this.updatedDate,
    this.customerId,
    this.isUse,
    this.isTax,
    this.customerCode,
    this.status,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      representativeName: json['representative_name'],
      areaId: json['area_id'],
      createdBy: json['created_by'],
      version: json['version'],
      distributorId: json['distributor_id'],
      updatedBy: json['updated_by'],
      customerName: json['customer_name'],
      createdDate: json['created_date'],
      updatedDate: json['updated_date'],
      customerId: json['customer_id'],
      isUse: json['is_use'],
      isTax: json['is_tax'],
      customerCode: json['customer_code'],
      status: json['status'],
    );
  }

  factory Customer.fromMap(Map<dynamic, dynamic> json) {
    return Customer(
      representativeName: json['representative_name'],
      areaId: json['area_id'],
      createdBy: json['created_by'],
      version: json['version'],
      distributorId: json['distributor_id'],
      updatedBy: json['updated_by'],
      customerName: json['customer_name'],
      createdDate: json['created_date'],
      updatedDate: json['updated_date'],
      customerId: json['customer_id'],
      isUse: json['is_use'],
      isTax: json['is_tax'],
      customerCode: json['customer_code'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'representative_name': representativeName,
      'area_id': areaId,
      'created_by': createdBy,
      'version': version,
      'distributor_id': distributorId,
      'updated_by': updatedBy,
      'customer_name': customerName,
      'created_date': createdDate,
      'updated_date': updatedDate,
      'customer_id': customerId,
      'is_use': isUse,
      'is_tax': isTax,
      'customer_code': customerCode,
      'status': status,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'representative_name': representativeName,
      'area_id': areaId,
      'created_by': createdBy,
      'version': version,
      'distributor_id': distributorId,
      'updated_by': updatedBy,
      'customer_name': customerName,
      'created_date': createdDate,
      'updated_date': updatedDate,
      'customer_id': customerId,
      'is_use': isUse,
      'is_tax': isTax,
      'customer_code': customerCode,
      'status': status,
    };
  }
}
