class SyncOffline {
  int? syncOfflineId;
  String? requestId;
  int? positionId;
  String? type;
  int? relatedId;
  String? sequence;
  String? status;
  String? remark;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;

  SyncOffline(
      {this.syncOfflineId,
      this.requestId,
      this.positionId,
      this.type,
      this.relatedId,
      this.sequence,
      this.status,
      this.remark,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate});

  SyncOffline.fromMap(Map<dynamic, dynamic> map) {
    syncOfflineId = map['sync_offline_id'];
    requestId = map['request_id'];
    positionId = map['position_id'];
    type = map['type'];
    relatedId = map['related_id'];
    sequence = map['sequence'];
    status = map['status'];
    remark = map['remark'];
    createdBy = map['created_by'];
    createdDate = map['created_date'];
    updatedBy = map['updated_by'];
    createdDate = map['created_date'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sync_offline_id': syncOfflineId,
      'request_id': requestId,
      'position_id': positionId,
      'type': type,
      'related_id': relatedId,
      'sequence': sequence,
      'status': status,
      'remark': remark,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate
    };
  }
}
