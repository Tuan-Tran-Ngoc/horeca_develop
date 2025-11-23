// String tableDistrict = 'm_district';
// String columnDistrictId = 'district_id';
// String columnDistrictName = 'district_name';
// String columnDistrictCode = 'district_code';
// String columnProvinceId = 'province_id';

// district_name
// province_id
// district_code
// updated_by
// district_id
// created_date
// updated_date
// created_by
// version

// districtId
// provinceId
// districtName
// districtCode
// version
// updatedBy
// createdBy
// createdDate
// updatedDate

class District {
  int? districtId;
  String? districtName;
  String? districtCode;
  int? provinceId;
  int? createdBy;
  int? version;
  int? updatedBy;
  String? createdDate;
  String? updatedDate;

  District({
    required this.districtId,
    required this.districtName,
    required this.districtCode,
    required this.provinceId,
    required this.createdBy,
    required this.updatedBy,
    required this.version,
    required this.createdDate,
    required this.updatedDate,
  });
// district_name
// province_id
// district_code
// updated_by
// district_id
// created_date
// updated_date
// created_by
// version
  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      districtId: json['district_id'],
      districtName: json['district_name'],
      districtCode: json['district_code'],
      version: json['version'],
      provinceId: json['province_id'],
      updatedBy: json['updated_by'],
      createdBy: json['created_by'],
      updatedDate: json['updated_date'],
      createdDate: json['created_date'],
    );
  }

  factory District.fromMap(Map<dynamic, dynamic> json) {
    return District(
      districtId: json['district_id'],
      districtName: json['district_name'],
      districtCode: json['district_code'],
      version: json['version'],
      provinceId: json['province_id'],
      updatedBy: json['updated_by'],
      createdBy: json['created_by'],
      updatedDate: json['updated_date'],
      createdDate: json['created_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'district_id': districtId,
      'district_name': districtName,
      'district_code': districtCode,
      'version': version,
      'province_id': provinceId,
      'updated_by': updatedBy,
      'created_by': createdBy,
      'updated_date': updatedDate,
      'created_date': createdDate,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'district_id': districtId,
      'district_name': districtName,
      'district_code': districtCode,
      'version': version,
      'province_id': provinceId,
      'updated_by': updatedBy,
      'created_by': createdBy,
      'updated_date': updatedDate,
      'created_date': createdDate,
    };
  }
}
