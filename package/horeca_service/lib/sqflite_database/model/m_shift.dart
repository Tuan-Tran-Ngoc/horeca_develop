class Shift {
  int? shiftId;
  String? shiftCode;
  String? shiftName;
  String? status;
  String? startTime;
  String? endTime;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  Shift({
    this.shiftId,
    this.shiftCode,
    this.shiftName,
    this.status,
    this.startTime,
    this.endTime,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.version,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      shiftId: json['shift_id'],
      shiftCode: json['shift_code'],
      shiftName: json['shift_name'],
      status: json['status'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      createdBy: json['created_by'],
      createdDate: json['created_date'],
      updatedBy: json['updated_by'],
      updatedDate: json['updated_date'],
      version: json['version'],
    );
  }

  factory Shift.fromMap(Map<dynamic, dynamic> map) {
    return Shift(
      shiftId: map['shift_id'],
      shiftCode: map['shift_code'],
      shiftName: map['shift_name'],
      status: map['status'],
      startTime: map['start_time'],
      endTime: map['end_time'],
      createdBy: map['created_by'],
      createdDate: map['created_date'],
      updatedBy: map['updated_by'],
      updatedDate: map['updated_date'],
      version: map['version'],
    );
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shift_id': shiftId,
      'shift_code': shiftCode,
      'shift_name': shiftName,
      'status': status,
      'start_time': startTime,
      'end_time': endTime,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': createdBy,
    };
  }
}
