import 'package:horeca_service/utils/json_utils.dart';

class DiscountScheme {
  int? discountSchemeId;
  int? discountId;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  DiscountScheme(this.discountSchemeId, this.discountId, this.createdBy,
      this.createdDate, this.updatedBy, this.updatedDate, this.version);

  DiscountScheme.fromJson(Map<String, dynamic> json) {
    discountSchemeId = JsonUtils.toInt(json['discount_scheme_id']);
    discountId = JsonUtils.toInt(json['discount_id']);
    createdBy = JsonUtils.toInt(json['created_by']);
    createdDate = json['created_date'];
    updatedBy = JsonUtils.toInt(json['updated_by']);
    updatedDate = json['updated_date'];
    version = JsonUtils.toInt(json['version']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'discount_scheme_id': discountSchemeId,
      'discount_id': discountId,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version
    };
  }
}
