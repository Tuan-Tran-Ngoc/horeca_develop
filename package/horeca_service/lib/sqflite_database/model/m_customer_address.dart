import 'package:horeca_service/utils/json_utils.dart';

class CustomerAddress {
  int? customerAddressId;
  int? customerId;
  int? provinceId;
  int? districtId;
  int? wardId;
  String? streetName;
  String? addressDetail;
  String? telNo;
  String? faxNo;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;
  String? defaultAddress;
  String? addressCode;
  String? oldAddressCode;
  String? addressStartDate;
  String? addressEndDate;

  CustomerAddress(
      {this.customerAddressId,
      this.customerId,
      this.provinceId,
      this.districtId,
      this.wardId,
      this.streetName,
      this.addressDetail,
      this.telNo,
      this.faxNo,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version,
      this.defaultAddress,
      this.addressCode,
      this.oldAddressCode,
      this.addressStartDate,
      this.addressEndDate});

  factory CustomerAddress.fromJson(Map<String, dynamic> json) {
    return CustomerAddress(
      customerAddressId: JsonUtils.toInt(json['customer_address_id']),
      customerId: JsonUtils.toInt(json['customer_id']),
      provinceId: JsonUtils.toInt(json['province_id']),
      districtId: JsonUtils.toInt(json['district_id']),
      wardId: JsonUtils.toInt(json['ward_id']),
      streetName: json['street_name'],
      addressDetail: json['address_detail'],
      telNo: json['tel_no'],
      faxNo: json['fax_no'],
      createdBy: JsonUtils.toInt(json['created_by']),
      createdDate: json['created_date'],
      updatedBy: JsonUtils.toInt(json['updated_by']),
      updatedDate: json['updated_date'],
      version: JsonUtils.toInt(json['version']),
      defaultAddress: json['default_address'],
      addressCode: json['address_code'],
      oldAddressCode: json['old_address_code'],
      addressStartDate: json['address_start_date'],
      addressEndDate: json['address_end_date'],
    );
  }

  factory CustomerAddress.fromMap(Map<dynamic, dynamic> json) {
    return CustomerAddress(
      customerAddressId: json['customer_address_id'],
      customerId: json['customer_id'],
      provinceId: json['province_id'],
      districtId: json['district_id'],
      wardId: json['ward_id'],
      streetName: json['street_name'],
      addressDetail: json['address_detail'],
      telNo: json['tel_no'],
      faxNo: json['fax_no'],
      createdBy: json['created_by'],
      createdDate: json['created_date'],
      updatedBy: json['updated_by'],
      updatedDate: json['updated_date'],
      version: json['version'],
      defaultAddress: json['default_address'],
      addressCode: json['address_code'],
      oldAddressCode: json['old_address_code'],
      addressStartDate: json['address_start_date'],
      addressEndDate: json['address_end_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_address_id': customerAddressId,
      'customer_id': customerId,
      'province_id': provinceId,
      'district_id': districtId,
      'ward_id': wardId,
      'street_name': streetName,
      'address_detail': addressDetail,
      'tel_no': telNo,
      'fax_no': faxNo,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
      'default_address': defaultAddress,
      'address_code': addressCode,
      'old_address_code': oldAddressCode,
      'address_start_date': addressStartDate,
      'address_end_date': addressEndDate,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'customer_address_id': customerAddressId,
      'customer_id': customerId,
      'province_id': provinceId,
      'district_id': districtId,
      'ward_id': wardId,
      'street_name': streetName,
      'address_detail': addressDetail,
      'tel_no': telNo,
      'fax_no': faxNo,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
      'default_address': defaultAddress,
      'address_code': addressCode,
      'old_address_code': oldAddressCode,
      'address_start_date': addressStartDate,
      'address_end_date': addressEndDate,
    };
  }
}
