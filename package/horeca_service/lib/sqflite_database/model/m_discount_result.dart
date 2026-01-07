import 'package:horeca_service/utils/json_utils.dart';

class DiscountResult {
  int? discountResultId;
  int? discountId;
  int? discountSchemeId;
  String? discountType;
  double? resultQty;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  DiscountResult(
      this.discountResultId,
      this.discountId,
      this.discountSchemeId,
      this.discountType,
      this.resultQty,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version);

  DiscountResult.fromJson(Map<String, dynamic> json) {
    discountResultId = JsonUtils.toInt(json['discount_result_id']);
    discountId = JsonUtils.toInt(json['discount_id']);
    discountSchemeId = JsonUtils.toInt(json['discount_scheme_id']);
    discountType = json['discount_type'];
    resultQty = json['result_qty'];
    createdBy = JsonUtils.toInt(json['created_by']);
    createdDate = json['created_date'];
    updatedBy = JsonUtils.toInt(json['updated_by']);
    updatedDate = json['updated_date'];
    version = JsonUtils.toInt(json['version']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['discount_result_id'] = discountResultId;
    data['discount_id'] = discountId;
    data['discount_scheme_id'] = discountSchemeId;
    data['discount_type'] = discountType;
    data['result_qty'] = resultQty;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    data['updated_by'] = updatedBy;
    data['updated_date'] = updatedDate;
    data['version'] = version;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'discount_result_id': discountResultId,
      'discount_id': discountId,
      'discount_scheme_id': discountSchemeId,
      'discount_type': discountType,
      'result_qty': resultQty,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version
    };
  }

  DiscountResult.fromMap(Map<dynamic, dynamic> map) {
    discountResultId = JsonUtils.toInt(map['discount_result_id']);
    discountId = JsonUtils.toInt(map['discount_id']);
    discountSchemeId = JsonUtils.toInt(map['discount_scheme_id']);
    discountType = map['discount_type'];
    resultQty = map['result_qty'];
    createdBy = JsonUtils.toInt(map['created_by']);
    createdDate = map['created_date'];
    updatedBy = JsonUtils.toInt(map['updated_by']);
    updatedDate = map['updated_date'];
    version = JsonUtils.toInt(map['version']);
  }
}
