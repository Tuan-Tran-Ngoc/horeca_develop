import 'package:horeca_service/sqflite_database/model/common_column.dart';

class ShiftReport {
  int? shiftReportId;
  int? shiftReportIdSync;
  int? baPositionId;
  int? employeeId;
  String? employeeName;
  int? supPositionId;
  int? cityLeaderPositionId;
  String? workingDate;
  String? shiftCode;
  String? startTime;
  String? endTime;
  double? totalCashBack;
  double? totalCollection;
  int? newMembership;
  int? newSmoker;
  int? totalSmoker;
  int? totalApproached;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  ShiftReport({
    this.shiftReportIdSync,
    this.shiftReportId,
    this.baPositionId,
    this.employeeId,
    this.employeeName,
    this.supPositionId,
    this.cityLeaderPositionId,
    this.workingDate,
    this.shiftCode,
    this.startTime,
    this.endTime,
    this.totalCashBack,
    this.totalCollection,
    this.newMembership,
    this.newSmoker,
    this.totalSmoker,
    this.totalApproached,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.version,
  });

  factory ShiftReport.fromJson(Map<String, dynamic> json) {
    return ShiftReport(
      shiftReportId: json['shift_report_id'],
      shiftReportIdSync: json['shift_report_id_sync'],
      baPositionId: json['ba_position_id'],
      employeeId: json['employee_id'],
      employeeName: json['employee_name'],
      supPositionId: json['sup_position_id'],
      cityLeaderPositionId: json['city_leader_position_id'],
      workingDate: json['working_date'],
      shiftCode: json['shift_code'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      totalCashBack: json['total_cash_back'],
      totalCollection: json['total_collection'],
      newMembership: json['new_membership'],
      newSmoker: json['new_smoker'],
      totalSmoker: json['total_smoker'],
      totalApproached: json['total_approached'],
      createdBy: json['created_by'],
      createdDate: json['created_date'],
      updatedBy: json['updated_by'],
      updatedDate: json['updated_date'],
      version: json['version'],
    );
  }

  factory ShiftReport.fromMap(Map<dynamic, dynamic> map) {
    return ShiftReport(
      shiftReportId: map[columnShiftReportId],
      shiftReportIdSync: map[columnShiftReportIdSync],
      baPositionId: map[columnBaPositionId],
      employeeId: map[columnEmployeeId],
      employeeName: map[columnEmployeeName],
      supPositionId: map[columnSupPositionId],
      cityLeaderPositionId: map[columnCityLeaderPositionId],
      workingDate: map[columnWorkingDate],
      shiftCode: map[columnShiftCode],
      startTime: map[columnStartTime],
      endTime: map[columnEndTime],
      // totalCashBack: map[columnTotalCashBack],
      // totalCollection: map[columnTotalCollection],
      // newMembership: map[columnNewMembership],
      // newSmoker: map[columnNewSmoker],
      // totalSmoker: map[columnTotalSmoker],
      // totalApproached: map[columnTotalApproached],
      createdBy: map[columnCreatedBy],
      createdDate: map[columnCreatedDate],
      updatedBy: map[columnUpdatedBy],
      updatedDate: map[columnUpdatedDate],
      version: map[columnVersion],
    );
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      columnShiftReportId: shiftReportId,
      columnShiftReportIdSync: shiftReportIdSync,
      columnBaPositionId: baPositionId,
      columnEmployeeId: employeeId,
      columnEmployeeName: employeeName,
      columnSupPositionId: supPositionId,
      columnCityLeaderPositionId: cityLeaderPositionId,
      columnWorkingDate: workingDate,
      columnShiftCode: shiftCode,
      columnStartTime: startTime,
      columnEndTime: endTime,
      columnTotalCashBack: totalCashBack,
      columnTotalCollection: totalCollection,
      columnNewMembership: newMembership,
      columnNewSmoker: newSmoker,
      columnTotalSmoker: totalSmoker,
      columnTotalApproached: totalApproached,
      columnCreatedBy: createdBy,
      columnCreatedDate: createdDate,
      columnUpdatedBy: updatedBy,
      columnUpdatedDate: updatedDate,
      columnVersion: version,
    };
  }

  Map<String, dynamic> toMapSync() {
    return <String, dynamic>{
      columnShiftReportId: shiftReportId,
      columnShiftReportIdSync: shiftReportId,
      columnBaPositionId: baPositionId,
      columnEmployeeId: employeeId,
      columnEmployeeName: employeeName,
      columnSupPositionId: supPositionId,
      columnCityLeaderPositionId: cityLeaderPositionId,
      columnWorkingDate: workingDate,
      columnShiftCode: shiftCode,
      columnStartTime: startTime,
      columnEndTime: endTime,
      columnTotalCashBack: totalCashBack,
      columnTotalCollection: totalCollection,
      columnNewMembership: newMembership,
      columnNewSmoker: newSmoker,
      columnTotalSmoker: totalSmoker,
      columnTotalApproached: totalApproached,
      columnCreatedBy: createdBy,
      columnCreatedDate: createdDate,
      columnUpdatedBy: updatedBy,
      columnUpdatedDate: updatedDate,
      columnVersion: version,
    };
  }

  @override
  String toString() {
    return 'ShiftReportModel(shiftReportId: $shiftReportId'
        'createdBy: $createdBy, createdDate: $createdDate, updatedBy: $updatedBy, '
        'updatedDate: $updatedDate, version: $version)';
  }
}
