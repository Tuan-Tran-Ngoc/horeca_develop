class ShiftReportHeaderDTO {
  int? shiftReportId;
  int? baPositionId;
  int? employeeId;
  String? employeeName;
  int? supPositionId;
  int? cityLeaderPositionId;
  String? workingDate;
  String? shiftCode;
  String? startTime;
  String? endTime;
  int? visitedQuantity;
  int? cancelledQuantity;
  int? customerOffline;
  int? totalOrderQuantity;
  int? totalProductQuantity;
  double? totalOrderAmount;
  int? visitPlanQuantity;

  ShiftReportHeaderDTO({
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
    this.visitedQuantity,
    this.cancelledQuantity,
    this.customerOffline,
    this.totalOrderQuantity,
    this.totalProductQuantity,
    this.totalOrderAmount,
    this.visitPlanQuantity,
  });

  factory ShiftReportHeaderDTO.fromJson(Map<dynamic, dynamic> json) {
    return ShiftReportHeaderDTO(
      shiftReportId: json['shift_report_id'],
      baPositionId: json['ba_position_id'],
      employeeId: json['employee_id'],
      employeeName: json['employee_name'],
      supPositionId: json['sup_position_id'],
      cityLeaderPositionId: json['city_leader_position_id'],
      workingDate: json['working_date'],
      shiftCode: json['shift_code'],
      startTime: json['start_time'],
      endTime: json['end_date'],
      visitedQuantity: json['visited_quantity'],
      cancelledQuantity: json['cancelled_quantity'],
      customerOffline: json['customer_offline'],
      totalOrderAmount: json['total_order_amount'],
      totalOrderQuantity: json['total_order_quantity'],
      totalProductQuantity: json['total_product_quantity'],
      visitPlanQuantity: json['visit_plan_quantity'],
    );
  }
}
