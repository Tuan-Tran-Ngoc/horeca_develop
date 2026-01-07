import 'package:horeca_service/utils/json_utils.dart';

class EmployeePositionLink {
  int? employeePositionLinkId;
  int? employeeId;
  int? positionId;
  int? areaId;
  String? startDate;
  String? endDate;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  EmployeePositionLink(
      this.employeePositionLinkId,
      this.employeeId,
      this.positionId,
      this.areaId,
      this.startDate,
      this.endDate,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version);

  EmployeePositionLink.fromJson(Map<String, dynamic> json) {
    employeePositionLinkId = JsonUtils.toInt(json['employee_position_link_id']);
    employeeId = JsonUtils.toInt(json['employee_id']);
    positionId = JsonUtils.toInt(json['position_id']);
    areaId = JsonUtils.toInt(json['area_id']);
    startDate = json['start_date'];
    endDate = json['end_date'];
    createdBy = JsonUtils.toInt(json['created_by']);
    createdDate = json['created_date'];
    updatedBy = JsonUtils.toInt(json['updated_by']);
    updatedDate = json['updated_date'];
    version = JsonUtils.toInt(json['version']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_position_link_id'] = employeePositionLinkId;
    data['employee_id'] = employeeId;
    data['position_id'] = positionId;
    data['area_id'] = areaId;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    data['updated_by'] = updatedBy;
    data['updated_date'] = updatedDate;
    data['version'] = version;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'employee_position_link_id': employeePositionLinkId,
      'employee_id': employeeId,
      'position_id': positionId,
      'area_id': areaId,
      'start_date': startDate,
      'end_date': endDate,
      'updated_by': updatedBy,
      'created_date': createdDate,
      'updated_date': updatedDate,
      'created_by': createdBy,
      'version': version
    };
  }

  EmployeePositionLink.fromMap(Map<dynamic, dynamic> map) {
    employeePositionLinkId = JsonUtils.toInt(map['employee_position_link_id']);
    employeeId = JsonUtils.toInt(map['employee_id']);
    positionId = JsonUtils.toInt(map['position_id']);
    areaId = JsonUtils.toInt(map['area_id']);
    startDate = map['start_date'];
    endDate = map['end_date'];
    createdBy = JsonUtils.toInt(map['created_by']);
    createdDate = map['created_date'];
    updatedBy = JsonUtils.toInt(map['updated_by']);
    updatedDate = map['updated_date'];
    version = JsonUtils.toInt(map['version']);
  }
}
