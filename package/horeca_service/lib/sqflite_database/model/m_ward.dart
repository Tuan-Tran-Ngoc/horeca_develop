// ward_id
// ward_name
// ward_code
// district_id
// created_by
// created_date
// updated_by
// updated_date
// version

// wardId
// wardName
// wardCode
// districtId
// createdBy
// createdDate
// updatedBy
// updatedDate
// version

class Ward {
  int? wardId;
  String? wardName;
  String? wardCode;
  int? districtId;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  Ward(
      {required this.wardId,
      required this.wardName,
      required this.wardCode,
      required this.districtId,
      required this.createdBy,
      required this.createdDate,
      required this.updatedBy,
      required this.updatedDate,
      required this.version});

  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
      wardId: json['ward_id'],
      wardName: json['ward_name'],
      wardCode: json['ward_code'],
      districtId: json['district_id'],
      createdBy: json['created_by'],
      createdDate: json['created_date'],
      updatedBy: json['updated_by'],
      updatedDate: json['updated_date'],
      version: json['version'],
    );
  }

  factory Ward.fromMap(Map<dynamic, dynamic> json) {
    return Ward(
      wardId: json['ward_id'],
      wardName: json['ward_name'],
      wardCode: json['ward_code'],
      districtId: json['district_id'],
      createdBy: json['created_by'],
      createdDate: json['created_date'],
      updatedBy: json['updated_by'],
      updatedDate: json['updated_date'],
      version: json['version'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ward_id': wardId,
      'ward_name': wardName,
      'ward_code': wardCode,
      'district_id': districtId,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'ward_id': wardId,
      'ward_name': wardName,
      'ward_code': wardCode,
      'district_id': districtId,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }
}
