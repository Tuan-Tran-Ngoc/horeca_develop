class ListCustomerVisit {
  int customerVisitId;
  int? shiftReportId;
  int? customerId;
  String? customerName;
  String? customerCode;

  // String? address;
  // String? provinceName;
  // String? wardName;
  // String? districtName;
  String? addressDetail;
  String? streetName;

  String? visitDate;
  String? startTime;
  String? endTime;
  String? shiftCode;
  int? visitTimes;

  ListCustomerVisit(
      {required this.customerVisitId,
      required this.shiftReportId,
      required this.customerId,
      required this.visitDate,
      required this.startTime,
      required this.endTime,
      required this.shiftCode,
      required this.visitTimes,
      required this.customerName,
      required this.customerCode,
      // required this.address,
      // required this.provinceName,
      // required this.wardName,
      // required this.districtName,
      required this.addressDetail,
      required this.streetName});

  factory ListCustomerVisit.fromMap(Map<dynamic, dynamic> json) {
    return ListCustomerVisit(
      customerVisitId: json['customer_visit_id'],
      shiftReportId: json['shift_report_id'],
      customerId: json['customer_id'],
      visitDate: json['visit_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      shiftCode: json['shift_code'],
      visitTimes: json['visit_times'],
      customerName: json['customer_name'],
      customerCode: json['customer_code'],
      // address: json['address'],
      // provinceName: json['province_name'],
      // wardName: json['ward_name'],
      // districtName: json['district_name'],
      addressDetail: json['address_detail'],
      streetName: json['street_name'],
    );
  }
}
