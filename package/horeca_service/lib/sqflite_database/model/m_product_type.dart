import 'package:horeca_service/utils/json_utils.dart';

class ProductType {
  int? productTypeId;
  String? typeName;
  String? typeCode;
  String? status;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  ProductType({
    required this.productTypeId,
    required this.typeName,
    required this.typeCode,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
    required this.version,
  });

  factory ProductType.fromJson(Map<String, dynamic> json) {
    return ProductType(
      productTypeId: JsonUtils.toInt(json['product_type_id']),
      typeName: json['type_name'],
      typeCode: json['type_code'],
      status: json['status'],
      createdBy: JsonUtils.toInt(json['created_by']),
      createdDate: json['created_date'],
      updatedBy: JsonUtils.toInt(json['updated_by']),
      updatedDate: json['updated_date'],
      version: JsonUtils.toInt(json['version']),
    );
  }

  factory ProductType.fromMap(Map<dynamic, dynamic> json) {
    return ProductType(
      productTypeId: JsonUtils.toInt(json['product_type_id']),
      typeName: json['type_name'],
      typeCode: json['type_code'],
      status: json['status'],
      createdBy: JsonUtils.toInt(json['created_by']),
      createdDate: json['created_date'],
      updatedBy: JsonUtils.toInt(json['updated_by']),
      updatedDate: json['updated_date'],
      version: JsonUtils.toInt(json['version']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_type_id': productTypeId,
      'type_name': typeName,
      'type_code': typeCode,
      'status': status,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product_type_id': productTypeId,
      'type_name': typeName,
      'type_code': typeCode,
      'status': status,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }
}
