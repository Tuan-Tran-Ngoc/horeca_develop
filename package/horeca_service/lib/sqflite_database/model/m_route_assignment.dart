import 'package:horeca_service/sqflite_database/model/common_column.dart';

class RouteAssignment {
  int? routeId;
  int? baPositionId;
  int? customerId;
  int? dayOfWeek;
  String? shiftCode;
  String? frequency;
  int? isUpdate;
  String? startDate;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;

  RouteAssignment({
    this.routeId,
    this.baPositionId,
    this.customerId,
    this.dayOfWeek,
    this.shiftCode,
    this.frequency,
    this.isUpdate,
    this.startDate,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.version,
  });

  factory RouteAssignment.fromJson(Map<String, dynamic> json) {
    return RouteAssignment(
      routeId: json['route_id'],
      baPositionId: json['ba_position_id'],
      customerId: json['customer_id'],
      dayOfWeek: json['day_of_week'],
      shiftCode: json['shift_code'],
      frequency: json['frequency'],
      isUpdate: json['is_update'],
      startDate: json['start_date'],
      createdBy: json['created_by'],
      createdDate: json['created_date'],
      updatedBy: json['updated_by'],
      updatedDate: json['updated_date'],
      version: json['version'],
    );
  }

  factory RouteAssignment.fromMap(Map<dynamic, dynamic> map) {
    return RouteAssignment(
      routeId: map['route_id'],
      baPositionId: map['ba_position_id'],
      customerId: map['customer_id'],
      dayOfWeek: map['day_of_week'],
      shiftCode: map['shift_code'],
      frequency: map['frequency'],
      isUpdate: map['is_update'],
      startDate: map['start_date'],
      createdBy: map['created_by'],
      createdDate: map['created_date'],
      updatedBy: map['updated_by'],
      updatedDate: map['updated_date'],
      version: map['version'],
    );
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      columnRouteId: routeId,
      columnBaPositionId: baPositionId,
      columnCustomerId: customerId,
      columnDayOfWeek: dayOfWeek,
      columnShiftCode: shiftCode,
      columnFrequency: frequency,
      columnIsUpdate: isUpdate,
      columnStartDate: startDate,
      columnCreatedBy: createdBy,
      columnCreatedDate: createdDate,
      columnUpdatedBy: updatedBy,
      columnUpdatedDate: updatedDate,
      columnVersion: version,
    };
  }

  @override
  String toString() {
    return 'RouteAssignmentModel(routeId: $routeId, baPositionId: $baPositionId, customerId: $customerId, '
        'dayOfWeek: $dayOfWeek, shiftCode: $shiftCode, frequency: $frequency, isUpdate: $isUpdate, startDate: $startDate'
        'createdBy: $createdBy, createdDate: $createdDate, updatedBy: $updatedBy, '
        'updatedDate: $updatedDate, version: $version)';
  }
}
