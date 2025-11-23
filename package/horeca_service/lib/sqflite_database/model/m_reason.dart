class Reason {
  int? reasonId;
  String? reasonType;
  String? reasonContent;
  String? status;
  int? sort;
  int? isOther;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  Reason(
      this.reasonId,
      this.reasonType,
      this.reasonContent,
      this.status,
      this.sort,
      this.isOther,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.version);

  Reason.fromJson(Map<String, dynamic> json) {
    reasonId = json['reason_id'];
    reasonType = json['reason_type'];
    reasonContent = json['reason_content'];
    status = json['status'];
    sort = json['sort'];
    isOther = json['is_other'] == null ? null : (json['is_other'] ? 1 : 0);
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reason_id'] = reasonId;
    data['reason_type'] = reasonType;
    data['reason_content'] = reasonContent;
    data['status'] = status;
    data['sort'] = sort;
    data['is_other'] = isOther;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    data['updated_by'] = updatedBy;
    data['updated_date'] = updatedDate;
    data['version'] = version;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reason_id': reasonId,
      'reason_type': reasonType,
      'reason_content': reasonContent,
      'status': status,
      'sort': sort,
      'is_other': isOther,
      'updated_by': updatedBy,
      'created_date': createdDate,
      'updated_date': updatedDate,
      'created_by': createdBy,
      'version': version
    };
  }

  Reason.fromMap(Map<dynamic, dynamic> map) {
    reasonId = map['reason_id'];
    reasonType = map['reason_type'];
    reasonContent = map['reason_content'];
    status = map['status'];
    sort = map['sort'];
    isOther = map['is_other'];
    createdBy = map['created_by'];
    createdDate = map['created_date'];
    updatedBy = map['updated_by'];
    updatedDate = map['updated_date'];
    version = map['version'];
  }
}
