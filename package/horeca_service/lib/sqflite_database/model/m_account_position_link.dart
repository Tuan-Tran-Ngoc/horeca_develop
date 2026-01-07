import 'package:horeca_service/utils/json_utils.dart';

class AccountPositionLink {
  int? positionId;
  int? accountId;
  String? status;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  AccountPositionLink(
      this.positionId,
      this.accountId,
      this.status,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version);

  AccountPositionLink.fromJson(Map<String, dynamic> json) {
    positionId = JsonUtils.toInt(json['position_id']);
    accountId = JsonUtils.toInt(json['account_id']);
    status = json['status'];
    createdBy = JsonUtils.toInt(json['created_by']);
    createdDate = json['created_date'];
    updatedBy = JsonUtils.toInt(json['updated_by']);
    updatedDate = json['updated_date'];
    version = JsonUtils.toInt(json['version']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['position_id'] = positionId;
    data['account_id'] = accountId;
    data['status'] = status;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    data['updated_by'] = updatedBy;
    data['updated_date'] = updatedDate;
    data['version'] = version;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'position_id': positionId,
      'account_id': accountId,
      'status': status,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version
    };
  }

  AccountPositionLink.fromMap(Map<dynamic, dynamic> map) {
    positionId = JsonUtils.toInt(map['position_id']);
    accountId = JsonUtils.toInt(map['account_id']);
    status = map['status'];
    createdBy = JsonUtils.toInt(map['created_by']);
    createdDate = map['created_date'];
    updatedBy = JsonUtils.toInt(map['updated_by']);
    updatedDate = map['updated_date'];
    version = JsonUtils.toInt(map['version']);
  }
}
