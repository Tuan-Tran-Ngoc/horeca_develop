class CustomerPropertyMapping {
  int? propertyMappingId;
  int? customerPropertyId;
  int? customerId;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  CustomerPropertyMapping({
    this.propertyMappingId,
    this.customerPropertyId,
    this.customerId,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.version,
  });

  factory CustomerPropertyMapping.fromJson(Map<String, dynamic> json) {
    return CustomerPropertyMapping(
      propertyMappingId: json['property_mapping_id'],
      customerPropertyId: json['customer_property_id'],
      customerId: json['customer_id'],
      createdBy: json['created_by'],
      createdDate: json['created_date'],
      updatedBy: json['updated_by'],
      updatedDate: json['updated_date'],
      version: json['version'],
    );
  }
  factory CustomerPropertyMapping.fromMap(Map<dynamic, dynamic> map) {
    return CustomerPropertyMapping(
      propertyMappingId: map['property_mapping_id'],
      customerPropertyId: map['customer_property_id'],
      customerId: map['customer_id'],
      createdBy: map['created_by'],
      createdDate: map['created_date'],
      updatedBy: map['updated_by'],
      updatedDate: map['updated_date'],
      version: map['version'],
    );
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'property_mapping_id': propertyMappingId,
      'customer_property_id': customerPropertyId,
      'customer_id': customerId,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_date': createdDate,
      'updated_date': updatedDate,
      'version': version,
    };
  }
}
