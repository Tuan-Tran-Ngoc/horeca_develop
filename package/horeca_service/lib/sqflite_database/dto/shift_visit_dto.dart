class ShiftVisitDto {
  int? routeId;
  int? customerId;
  String? customerCode;
  String? customerName;
  String? shiftCode;
  String? shiftName;
  int? customerVisitId;
  String? visitDate;
  String? startTime;
  String? endTime;
  int? visitTimes;
  int? dayOfWeek;
  String? visitStatus;
  int? parentCustomerVisitId;

  ShiftVisitDto(
      {this.routeId,
      this.customerId,
      this.customerCode,
      this.customerName,
      this.shiftCode,
      this.shiftName,
      this.customerVisitId,
      this.visitDate,
      this.startTime,
      this.endTime,
      this.visitTimes,
      this.dayOfWeek,
      this.visitStatus,
      this.parentCustomerVisitId});

  factory ShiftVisitDto.fromMap(Map<dynamic, dynamic> map) {
    return ShiftVisitDto(
        routeId: map['route_id'],
        customerId: map['customer_id'],
        customerCode: map['customer_code'],
        customerName: map['customer_name'],
        shiftCode: map['shift_code'],
        shiftName: map['shift_name'],
        customerVisitId: map['customer_visit_id'],
        visitDate: map['visit_date'],
        startTime: map['start_time'],
        endTime: map['end_time'],
        visitTimes: map['visit_times'] ?? 0,
        dayOfWeek: map['day_of_week'],
        visitStatus: map['visit_status'],
        parentCustomerVisitId: map['parent_customer_visit_id']);
  }
}
