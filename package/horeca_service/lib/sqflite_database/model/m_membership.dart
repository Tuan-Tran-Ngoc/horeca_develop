class Membership {
  int? membershipRecordId;
  int? membershipId;
  String? membershipCode;
  String? membershipName;
  int? customerVisitId;
  String? status;
  String? telNo;
  int? birthdate;
  int? provinceId;
  int? districtId;
  int? wardId;
  String? streetName;
  String? addressDetail;
  double? totalPoint;
  double? usedPoint;
  double? currentPoint;
  String? remark;
  int? baPositionId;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  Membership(
      this.membershipRecordId,
      this.membershipId,
      this.membershipCode,
      this.membershipName,
      this.customerVisitId,
      this.status,
      this.telNo,
      this.birthdate,
      this.provinceId,
      this.districtId,
      this.wardId,
      this.streetName,
      this.addressDetail,
      this.totalPoint,
      this.usedPoint,
      this.remark,
      this.baPositionId,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version);

  Membership.fromJson(Map<String, dynamic> json) {
    membershipRecordId = json['membership_record_id'];
    membershipId = json['membership_id'];
    membershipCode = json['membership_code'];
    membershipName = json['membership_name'];
    customerVisitId = json['customer_visit_id'];
    status = json['status'];
    telNo = json['tel_no'];
    birthdate = json['birthdate'];
    provinceId = json['province_id'];
    districtId = json['district_id'];
    wardId = json['ward_id'];
    streetName = json['street_name'];
    addressDetail = json['address_detail'];
    totalPoint = json['total_point'];
    usedPoint = json['used_point'];
    remark = json['remark'];
    baPositionId = json['ba_position_id'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    version = json['version'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'membership_record_id': membershipRecordId,
      'membership_id': membershipId,
      'membership_code': membershipCode,
      'membership_name': membershipName,
      'customer_visit_id': customerVisitId,
      'status': status,
      'tel_no': telNo,
      'birthdate': birthdate,
      'province_id': provinceId,
      'district_id': districtId,
      'ward_id': wardId,
      'street_name': streetName,
      'address_detail': addressDetail,
      'total_point': totalPoint,
      'used_point': usedPoint,
      'remark': remark,
      'ba_position_id': baPositionId,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedBy,
      'version': version
    };
  }
}
