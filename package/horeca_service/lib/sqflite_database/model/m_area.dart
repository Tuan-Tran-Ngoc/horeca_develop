import 'package:horeca_service/utils/json_utils.dart';

class Area {
  int? areaId;
  String? areaName;
  int? parentId;
  String? areaCode;
  String? levelCode;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;
  String? status;

  Area(
    this.areaId,
    this.levelCode,
    this.areaCode,
    this.areaName,
    this.parentId,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.version,
    this.status,
  );

  Area.fromJson(Map<String, dynamic> json) {
    areaId = JsonUtils.toInt(json['area_id']);
    levelCode = json['level_code'];
    areaCode = json['area_code'];
    areaName = json['area_name'];
    parentId = JsonUtils.toInt(json['parent_id']);
    createdBy = JsonUtils.toInt(json['created_by']);
    createdDate = json['created_date'];
    updatedBy = JsonUtils.toInt(json['updated_by']);
    updatedDate = json['updated_date'];
    version = JsonUtils.toInt(json['version']);
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['area_id'] = areaId;
    data['level_code'] = levelCode;
    data['area_code'] = areaCode;
    data['area_name'] = areaName;
    data['parent_id'] = parentId;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    data['updated_by'] = updatedBy;
    data['updated_date'] = updatedDate;
    data['version'] = version;
    data['status'] = status;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'area_id': areaId,
      'level_code': levelCode,
      'area_code': areaCode,
      'area_name': areaName,
      'parent_id': parentId,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
      'status': status,
    };
  }

  Area.fromMap(Map<dynamic, dynamic> map) {
    areaId = map['area_id'];
    levelCode = map['level_code'];
    areaCode = map['area_code'];
    areaName = map['area_name'];
    parentId = map['parent_id'];
    createdBy = map['created_by'];
    createdDate = map['created_date'];
    updatedBy = map['updated_by'];
    updatedDate = map['updated_date'];
    version = map['version'];
    status = map['status'];
  }

  // factory Area.fromJson(String source) =>
  //     Area.fromMap(json.decode(source) as Map<String, dynamic>);
}
