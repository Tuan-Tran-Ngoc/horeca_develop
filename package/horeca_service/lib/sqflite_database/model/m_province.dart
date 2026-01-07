import 'package:horeca_service/utils/json_utils.dart';

// province_id
// province_name
// province_code
// updated_by
// created_date
// updated_date
// created_by
// version

// provinceId
// provinceName
// provinceCode
// updatedBy
// createdDate
// updatedDate
// createdBy
// version

class Province {
  int? provinceId;
  String? provinceName;
  String? provinceCode;
  int? createdBy;
  int? version;
  int? updatedBy;
  String? createdDate;
  String? updatedDate;

  Province({
    required this.provinceId,
    required this.provinceName,
    required this.provinceCode,
    required this.createdBy,
    required this.updatedBy,
    required this.version,
    required this.createdDate,
    required this.updatedDate,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      provinceId: JsonUtils.toInt(json['province_id']),
      provinceName: json['province_name'],
      provinceCode: json['province_code'],
      version: JsonUtils.toInt(json['version']),
      updatedBy: JsonUtils.toInt(json['updated_by']),
      createdBy: JsonUtils.toInt(json['created_by']),
      updatedDate: json['updated_date'],
      createdDate: json['created_date'],
    );
  }

  factory Province.fromMap(Map<dynamic, dynamic> json) {
    return Province(
      provinceId: JsonUtils.toInt(json['province_id']),
      provinceName: json['province_name'],
      provinceCode: json['province_code'],
      version: JsonUtils.toInt(json['version']),
      updatedBy: JsonUtils.toInt(json['updated_by']),
      createdBy: JsonUtils.toInt(json['created_by']),
      updatedDate: json['updated_date'],
      createdDate: json['created_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'province_id': provinceId,
      'province_name': provinceName,
      'province_code': provinceCode,
      'version': version,
      'updated_by': updatedBy,
      'created_by': createdBy,
      'updated_date': updatedDate,
      'created_date': createdDate,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'province_id': provinceId,
      'province_name': provinceName,
      'province_code': provinceCode,
      'version': version,
      'updated_by': updatedBy,
      'created_by': createdBy,
      'updated_date': updatedDate,
      'created_date': createdDate,
    };
  }
}
