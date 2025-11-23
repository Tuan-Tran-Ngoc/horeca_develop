class SyncManageLog {
  int? logId;
  int? baPositionId;
  String? imeiDevice;
  String? objectFail;
  String? log;

  SyncManageLog(this.logId, this.baPositionId, this.imeiDevice, this.objectFail,
      this.log);

  SyncManageLog.fromJson(Map<String, dynamic> json) {
    logId = json['log_id'];
    baPositionId = json['ba_position_id'];
    imeiDevice = json['imei_device'];
    objectFail = json['object_fail'];
    log = json['log'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['log_id'] = logId;
    data['ba_position_id'] = baPositionId;
    data['imei_device'] = imeiDevice;
    data['object_fail'] = objectFail;
    data['log'] = log;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'log_id': logId,
      'ba_position_id': baPositionId,
      'imei_device': imeiDevice,
      'object_fail': objectFail,
      'log': log
    };
  }

  SyncManageLog.fromMap(Map<dynamic, dynamic> map) {
    logId = map['log_id'];
    baPositionId = map['ba_position_id'];
    imeiDevice = map['imei_device'];
    objectFail = map['object_fail'];
    log = map['log'];
  }
}
