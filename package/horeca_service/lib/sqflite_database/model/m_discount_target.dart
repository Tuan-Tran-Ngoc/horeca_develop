import 'package:horeca_service/utils/json_utils.dart';

class DiscountTarget {
  int? discountTargetId;
  int? discountId;
  String? targetType;
  int? targetId;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  DiscountTarget(
      this.discountTargetId,
      this.discountId,
      this.targetType,
      this.targetId,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version);

  DiscountTarget.fromJson(Map<String, dynamic> json) {
    discountTargetId = JsonUtils.toInt(json['discount_target_id']);
    discountId = JsonUtils.toInt(json['discount_id']);
    targetType = json['target_type'];
    targetId = JsonUtils.toInt(json['target_id']);
    createdBy = JsonUtils.toInt(json['created_by']);
    createdDate = json['created_date'];
    updatedBy = JsonUtils.toInt(json['updated_by']);
    updatedDate = json['updated_date'];
    version = JsonUtils.toInt(json['version']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['discount_target_id'] = discountTargetId;
    data['discount_id'] = discountId;
    data['target_type'] = targetType;
    data['target_id'] = targetId;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    data['updated_by'] = updatedBy;
    data['updated_date'] = updatedDate;
    data['version'] = version;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'discount_target_id': discountTargetId,
      'discount_id': discountId,
      'target_type': targetType,
      'target_id': targetId,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version
    };
  }

  DiscountTarget.fromMap(Map<dynamic, dynamic> map) {
    discountTargetId = JsonUtils.toInt(map['discount_target_id']);
    discountId = JsonUtils.toInt(map['discount_id']);
    targetType = map['target_type'];
    targetId = JsonUtils.toInt(map['target_id']);
    createdBy = JsonUtils.toInt(map['created_by']);
    createdDate = map['created_date'];
    updatedBy = JsonUtils.toInt(map['updated_by']);
    updatedDate = map['updated_date'];
    version = JsonUtils.toInt(map['version']);
  }
}
