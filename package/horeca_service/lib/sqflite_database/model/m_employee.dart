class Employee {
  int? employeeId;
  String? employeeCode;
  String? employeeName;
  String? status;
  String? phoneNumber;
  String? email;
  String? birthdate;
  int? provinceId;
  int? districtId;
  int? wardId;
  String? streetName;
  String? addressDetail;
  String? remark;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  Employee(
      this.employeeId,
      this.employeeCode,
      this.employeeName,
      this.status,
      this.phoneNumber,
      this.email,
      this.birthdate,
      this.provinceId,
      this.districtId,
      this.wardId,
      this.streetName,
      this.addressDetail,
      this.remark,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version);

  Employee.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    employeeCode = json['employee_code'];
    employeeName = json['employee_name'];
    status = json['status'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    birthdate = json['birthdate'];
    provinceId = json['province_id'];
    districtId = json['district_id'];
    wardId = json['ward_id'];
    streetName = json['street_name'];
    addressDetail = json['address_detail'];
    remark = json['remark'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = employeeId;
    data['employee_code'] = employeeCode;
    data['employee_name'] = employeeName;
    data['status'] = status;
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['birthdate'] = birthdate;
    data['province_id'] = provinceId;
    data['district_id'] = districtId;
    data['ward_id'] = wardId;
    data['street_name'] = streetName;
    data['address_detail'] = addressDetail;
    data['remark'] = remark;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    data['updated_by'] = updatedBy;
    data['updated_date'] = updatedDate;
    data['version'] = version;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'employee_id': employeeId,
      'employee_code': employeeCode,
      'employee_name': employeeName,
      'status': status,
      'phone_number': phoneNumber,
      'email': email,
      'birthdate': birthdate,
      'province_id': provinceId,
      'district_id': districtId,
      'ward_id': wardId,
      'street_name': streetName,
      'address_detail': addressDetail,
      'remark': remark,
      'updated_by': updatedBy,
      'created_date': createdDate,
      'updated_date': updatedDate,
      'created_by': createdBy,
      'version': version
    };
  }

  Employee.fromMap(Map<dynamic, dynamic> map) {
    employeeId = map['employee_id'];
    employeeCode = map['employee_code'];
    employeeName = map['employee_name'];
    status = map['status'];
    phoneNumber = map['phone_number'];
    email = map['email'];
    birthdate = map['birthdate'];
    provinceId = map['province_id'];
    districtId = map['district_id'];
    wardId = map['ward_id'];
    streetName = map['street_name'];
    addressDetail = map['address_detail'];
    remark = map['remark'];
    createdBy = map['created_by'];
    createdDate = map['created_date'];
    updatedBy = map['updated_by'];
    updatedDate = map['updated_date'];
    version = map['version'];
  }
}
