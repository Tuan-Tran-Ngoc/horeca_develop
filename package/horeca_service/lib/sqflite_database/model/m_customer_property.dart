import 'package:horeca_service/utils/json_utils.dart';

class CustomerProperty {
  int? customerPropertyId;
  String? propertyTypeCode;
  String? customerPropertyCode;
  String? customerPropertyName;
  int? parentId;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  CustomerProperty({
    this.customerPropertyId,
    this.propertyTypeCode,
    this.customerPropertyCode,
    this.customerPropertyName,
    this.parentId,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.version,
  });

  factory CustomerProperty.fromJson(Map<String, dynamic> json) {
    return CustomerProperty(
      customerPropertyId: JsonUtils.toInt(json['customer_property_id']),
      propertyTypeCode: json['property_type_code'],
      customerPropertyCode: json['customer_property_code'],
      customerPropertyName: json['customer_property_name'],
      parentId: JsonUtils.toInt(json['parent_id']),
      createdBy: JsonUtils.toInt(json['created_by']),
      createdDate: json['created_date'],
      updatedBy: JsonUtils.toInt(json['updated_by']),
      updatedDate: json['updated_date'],
      version: JsonUtils.toInt(json['version']),
    );
  }
  factory CustomerProperty.fromMap(Map<dynamic, dynamic> map) {
    return CustomerProperty(
      customerPropertyId: JsonUtils.toInt(map['customer_property_id']),
      propertyTypeCode: map['property_type_code'],
      customerPropertyCode: map['customer_property_code'],
      customerPropertyName: map['customer_property_name'],
      parentId: JsonUtils.toInt(map['parent_id']),
      createdBy: JsonUtils.toInt(map['created_by']),
      createdDate: map['created_date'],
      updatedBy: JsonUtils.toInt(map['updated_by']),
      updatedDate: map['updated_date'],
      version: JsonUtils.toInt(map['version']),
    );
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'customer_property_id': customerPropertyId,
      'property_type_code': propertyTypeCode,
      'customer_property_code': customerPropertyCode,
      'customer_property_name': customerPropertyName,
      'parent_id': parentId,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_date': createdDate,
      'updated_date': updatedDate,
      'version': version,
    };
  }
}
