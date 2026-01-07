import 'package:horeca_service/utils/json_utils.dart';

class Promotion {
  int? promotionId;
  String? promotionCode;
  String? promotionName;
  String? startDate;
  String? endDate;
  String? status;
  String? conditionType;
  String? promotionType;
  String? remark;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  Promotion(
      this.promotionId,
      this.promotionCode,
      this.promotionName,
      this.startDate,
      this.endDate,
      this.status,
      this.conditionType,
      this.promotionType,
      this.remark,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version);

  Promotion.fromJson(Map<String, dynamic> json) {
    promotionId = JsonUtils.toInt(json['promotion_id']);
    promotionCode = json['promotion_code'];
    promotionName = json['promotion_name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
    conditionType = json['condition_type'];
    promotionType = json['promotion_type'];
    remark = json['remark'];
    createdBy = JsonUtils.toInt(json['created_by']);
    createdDate = json['created_date'];
    updatedBy = JsonUtils.toInt(json['updated_by']);
    updatedDate = json['updated_date'];
    version = JsonUtils.toInt(json['version']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['promotion_id'] = promotionId;
    data['promotion_code'] = promotionCode;
    data['promotion_name'] = promotionName;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['status'] = status;
    data['condition_type'] = conditionType;
    data['promotion_type'] = promotionType;
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
      'promotion_id': promotionId,
      'promotion_code': promotionCode,
      'promotion_name': promotionName,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
      'condition_type': conditionType,
      'promotion_type': promotionType,
      'remark': remark,
      'updated_by': updatedBy,
      'created_date': createdDate,
      'updated_date': updatedDate,
      'created_by': createdBy,
      'version': version
    };
  }

  Promotion.fromMap(Map<dynamic, dynamic> map) {
    promotionId = map['promotion_id'];
    promotionCode = map['promotion_code'];
    promotionName = map['promotion_name'];
    startDate = map['start_date'];
    endDate = map['end_date'];
    status = map['status'];
    conditionType = map['condition_type'];
    promotionType = map['promotion_type'];
    remark = map['remark'];
    createdBy = map['created_by'];
    createdDate = map['created_date'];
    updatedBy = map['updated_by'];
    updatedDate = map['updated_date'];
    version = map['version'];
  }
}
