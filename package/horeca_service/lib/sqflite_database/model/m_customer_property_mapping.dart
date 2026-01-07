import 'package:horeca_service/utils/json_utils.dart';

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
      propertyMappingId: JsonUtils.toInt(json['property_mapping_id']),
      customerPropertyId: JsonUtils.toInt(json['customer_property_id']),
      customerId: JsonUtils.toInt(json['customer_id']),
      createdBy: JsonUtils.toInt(json['created_by']),
      createdDate: json['created_date'],
      updatedBy: JsonUtils.toInt(json['updated_by']),
      updatedDate: json['updated_date'],
      version: JsonUtils.toInt(json['version']),
    );
  }
  factory CustomerPropertyMapping.fromMap(Map<dynamic, dynamic> map) {
    return CustomerPropertyMapping(
      propertyMappingId: JsonUtils.toInt(map['property_mapping_id']),
      customerPropertyId: JsonUtils.toInt(map['customer_property_id']),
      customerId: JsonUtils.toInt(map['customer_id']),
      createdBy: JsonUtils.toInt(map['created_by']),
      createdDate: map['created_date'],
      updatedBy: JsonUtils.toInt(map['updated_by']),
      updatedDate: map['updated_date'],
      version: JsonUtils.toInt(map['version']),
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
