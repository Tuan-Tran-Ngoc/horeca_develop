import 'package:horeca_service/utils/json_utils.dart';

class CustomersGroup {
  int? customersGroupId;
  String? customersGroupCode;
  String? customersGroupName;
  int? branchId;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  CustomersGroup(
      this.customersGroupId,
      this.customersGroupCode,
      this.customersGroupName,
      this.branchId,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version);

  CustomersGroup.fromJson(Map<String, dynamic> json) {
    customersGroupId = JsonUtils.toInt(json['customers_group_id']);
    customersGroupCode = json['customers_group_code'];
    customersGroupName = json['customers_group_name'];
    branchId = JsonUtils.toInt(json['branch_id']);
    createdBy = JsonUtils.toInt(json['created_by']);
    createdDate = json['created_date'];
    updatedBy = JsonUtils.toInt(json['updated_by']);
    updatedDate = json['updated_date'];
    version = JsonUtils.toInt(json['version']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customers_group_id'] = customersGroupId;
    data['customers_group_code'] = customersGroupCode;
    data['customers_group_name'] = customersGroupName;
    data['branch_id'] = branchId;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    data['updated_by'] = updatedBy;
    data['updated_date'] = updatedDate;
    data['version'] = version;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'customers_group_id': customersGroupId,
      'customers_group_code': customersGroupCode,
      'customers_group_name': customersGroupName,
      'branch_id': branchId,
      'updated_by': updatedBy,
      'created_date': createdDate,
      'updated_date': updatedDate,
      'created_by': createdBy,
      'version': version
    };
  }

  CustomersGroup.fromMap(Map<dynamic, dynamic> map) {
    customersGroupId = JsonUtils.toInt(map['customers_group_id']);
    customersGroupCode = map['customers_group_code'];
    customersGroupName = map['customers_group_name'];
    branchId = JsonUtils.toInt(map['branch_id']);
    createdBy = JsonUtils.toInt(map['created_by']);
    createdDate = map['created_date'];
    updatedBy = JsonUtils.toInt(map['updated_by']);
    updatedDate = map['updated_date'];
    version = JsonUtils.toInt(map['version']);
  }
}
