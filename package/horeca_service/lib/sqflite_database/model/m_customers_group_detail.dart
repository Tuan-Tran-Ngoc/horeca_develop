import 'package:horeca_service/utils/json_utils.dart';

class CustomersGroupDetail {
  int? customersGroupDetailId;
  int? customerId;
  int? customersGroupId;
  String? status;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  CustomersGroupDetail(
      this.customersGroupDetailId,
      this.customerId,
      this.customersGroupId,
      this.status,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version);

  CustomersGroupDetail.fromJson(Map<String, dynamic> json) {
    customersGroupDetailId = JsonUtils.toInt(json['customers_group_detail_id']);
    customerId = JsonUtils.toInt(json['customer_id']);
    customersGroupId = JsonUtils.toInt(json['customers_group_id']);
    status = json['status'];
    createdBy = JsonUtils.toInt(json['created_by']);
    createdDate = json['created_date'];
    updatedBy = JsonUtils.toInt(json['updated_by']);
    updatedDate = json['updated_date'];
    version = JsonUtils.toInt(json['version']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customers_group_detail_id'] = customersGroupDetailId;
    data['customer_id'] = customerId;
    data['customers_group_id'] = customersGroupId;
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
      'customers_group_detail_id': customersGroupDetailId,
      'customer_id': customerId,
      'customers_group_id': customersGroupId,
      'status': status,
      'updated_by': updatedBy,
      'created_date': createdDate,
      'updated_date': updatedDate,
      'created_by': createdBy,
      'version': version
    };
  }

  CustomersGroupDetail.fromMap(Map<dynamic, dynamic> map) {
    customersGroupDetailId = JsonUtils.toInt(map['customers_group_detail_id']);
    customerId = JsonUtils.toInt(map['customer_id']);
    customersGroupId = JsonUtils.toInt(map['customers_group_id']);
    status = map['status'];
    createdBy = JsonUtils.toInt(map['created_by']);
    createdDate = map['created_date'];
    updatedBy = JsonUtils.toInt(map['updated_by']);
    updatedDate = map['updated_date'];
    version = JsonUtils.toInt(map['version']);
  }
}
