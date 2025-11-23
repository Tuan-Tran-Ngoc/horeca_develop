class TransferUpdateLog {
  int? transferUpdateLogId;
  int? baPositionId;
  String? imeiDevice;
  String? dateLastestUpdate;
  String? status;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  TransferUpdateLog({
    this.transferUpdateLogId,
    this.baPositionId,
    this.imeiDevice,
    this.dateLastestUpdate,
    this.status,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.version,
  });

  factory TransferUpdateLog.fromJson(Map<String, dynamic> json) {
    return TransferUpdateLog(
      transferUpdateLogId: json['transfer_update_log_id'],
      baPositionId: json['ba_position_id'],
      imeiDevice: json['imei_device'],
      dateLastestUpdate: json['date_lastest_update'],
      status: json['status'],
      createdBy: json['created_by'],
      createdDate: json['created_date'],
      updatedBy: json['updated_by'],
      updatedDate: json['updated_date'],
      version: json['version'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transfer_update_log_id': transferUpdateLogId,
      'ba_position_id': baPositionId,
      'imei_device': imeiDevice,
      'date_lastest_update': dateLastestUpdate,
      'status': status,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
    };
  }

  factory TransferUpdateLog.fromMap(Map<dynamic, dynamic> map) {
    return TransferUpdateLog(
      transferUpdateLogId: map['transfer_update_log_id'],
      baPositionId: map['ba_position_id'],
      imeiDevice: map['imei_device'],
      dateLastestUpdate: map['date_lastest_update'],
      status: map['status'],
      createdBy: map['created_by'],
      createdDate: map['created_date'],
      updatedBy: map['updated_by'],
      updatedDate: map['updated_date'],
      version: map['version'],
    );
  }
}
