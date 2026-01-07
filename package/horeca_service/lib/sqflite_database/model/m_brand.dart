import 'package:horeca_service/utils/json_utils.dart';

class Brand {
  int? brandId;
  String? brandCd;
  String? brandName;
  String? brandImg;
  String? status;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  Brand({
    this.brandId,
    this.brandCd,
    this.brandName,
    this.brandImg,
    this.status,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.version,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      brandId: JsonUtils.toInt(json['brand_id']),
      brandCd: json['brand_cd'],
      brandName: json['brand_name'],
      brandImg: json['brand_img'],
      status: json['status'],
      createdBy: JsonUtils.toInt(json['created_by']),
      createdDate: json['created_date'],
      updatedBy: JsonUtils.toInt(json['updated_by']),
      updatedDate: json['updated_date'],
      version: JsonUtils.toInt(json['version']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'brand_id': brandId,
      'brand_cd': brandCd,
      'brand_name': brandName,
      'brand_img': brandImg,
      'status': status,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }

  factory Brand.fromMap(Map<dynamic, dynamic> map) {
    return Brand(
      brandId: map['brand_id'],
      brandCd: map['brand_cd'],
      brandName: map['brand_name'],
      brandImg: map['brand_img'],
      status: map['status'],
      createdBy: map['created_by'],
      createdDate: map['created_date'],
      updatedBy: map['updated_by'],
      updatedDate: map['updated_date'],
      version: map['version'],
    );
  }
}
