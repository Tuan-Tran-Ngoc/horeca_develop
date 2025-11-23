class AreaLevel {
  int? areaLevelId;
  String? levelCode;
  String? levelName;
  String? status;
  String? isSmallest;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  AreaLevel(
      this.areaLevelId,
      this.levelCode,
      this.levelName,
      this.status,
      this.isSmallest,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version);

  AreaLevel.fromJson(Map<String, dynamic> json) {
    areaLevelId = json['area_level_id'];
    levelCode = json['level_code'];
    levelName = json['level_name'];
    status = json['status'];
    isSmallest = json['is_smallest'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['area_level_id'] = areaLevelId;
    data['level_code'] = levelCode;
    data['level_name'] = levelName;
    data['status'] = status;
    data['is_smallest'] = isSmallest;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    data['updated_by'] = updatedBy;
    data['updated_date'] = updatedDate;
    data['version'] = version;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'area_level_id': areaLevelId,
      'level_code': levelCode,
      'level_name': levelName,
      'status': status,
      'is_smallest': isSmallest,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version
    };
  }

  AreaLevel.fromMap(Map<dynamic, dynamic> map) {
    areaLevelId = map['area_level_id'];
    levelCode = map['level_code'];
    levelName = map['level_name'];
    status = map['status'];
    isSmallest = map['is_smallest'];
    updatedBy = map['updated_by'];
    createdDate = map['created_date'];
    updatedDate = map['updated_date'];
    createdBy = map['created_by'];
    version = map['version'];
  }

  // factory Area.fromJson(String source) =>
  //     Area.fromMap(json.decode(source) as Map<String, dynamic>);
}
