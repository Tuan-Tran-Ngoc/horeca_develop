import 'package:horeca_service/utils/json_utils.dart';

class UOM {
  int? uomId;
  String? uomCode;
  String? uomName;
  String? status;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  UOM({
    required this.uomId,
    required this.uomCode,
    required this.uomName,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
    required this.version,
  });

  factory UOM.fromJson(Map<String, dynamic> json) {
    return UOM(
      uomId: JsonUtils.toInt(json['uom_id']),
      uomCode: json['uom_code'],
      uomName: json['uom_name'],
      status: json['status'],
      createdBy: JsonUtils.toInt(json['created_by']),
      createdDate: json['created_date'],
      updatedBy: JsonUtils.toInt(json['updated_by']),
      updatedDate: json['updated_date'],
      version: JsonUtils.toInt(json['version']),
    );
  }
  factory UOM.fromMap(Map<dynamic, dynamic> json) {
    return UOM(
      uomId: JsonUtils.toInt(json['uom_id']),
      uomCode: json['uom_code'],
      uomName: json['uom_name'],
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
      'uom_id': uomId,
      'uom_code': uomCode,
      'uom_name': uomName,
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
      'uom_id': uomId,
      'uom_code': uomCode,
      'uom_name': uomName,
      'status': status,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }
}
