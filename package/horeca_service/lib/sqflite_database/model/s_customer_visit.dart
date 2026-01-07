class CustomerVisit {
  int? customerVisitId;
  int? customerVisitIdSync;
  int? shiftReportId;
  int? customerId;
  int? customerAddressId;
  int? baPositionId;
  int? employeeId;
  String? employeeName;
  int? supPositionId;
  int? cityLeaderPositionId;
  String? visitDate;
  String? startTime;
  String? endTime;
  String? shiftCode;
  double? totalCashBack;
  double? totalCollection;
  int? newMembership;
  String? signature;
  String? visitStatus;
  double? longitude;
  double? latitude;
  String? reason;
  int? createdBy;
  String? createdDate;
  int? updatedBy;
  String? updatedDate;
  int? version;
  int? visitTimes;
  int? parentCustomerVisitId;
  bool? isSample;
  bool? isStockCheckCompleted;
  bool? isSurveyCompleted;
  int? reasonId;
  int? totalApproached;
  int? totalSmoker;
  int? totalGift;

  CustomerVisit({
    this.customerVisitId,
    this.customerVisitIdSync,
    this.shiftReportId,
    this.customerId,
    this.customerAddressId,
    this.baPositionId,
    this.employeeId,
    this.employeeName,
    this.supPositionId,
    this.cityLeaderPositionId,
    this.visitDate,
    this.startTime,
    this.endTime,
    this.shiftCode,
    this.totalCashBack,
    this.totalCollection,
    this.newMembership,
    this.signature,
    this.visitStatus,
    this.longitude,
    this.latitude,
    this.reason,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.version,
    this.visitTimes,
    this.parentCustomerVisitId,
    this.isSample,
    this.isStockCheckCompleted,
    this.isSurveyCompleted,
    this.reasonId,
    this.totalApproached,
    this.totalSmoker,
    this.totalGift,
  });

  factory CustomerVisit.fromJson(Map<String, dynamic> json) {
    return CustomerVisit(
      customerVisitId: json['customer_visit_id'],
      customerVisitIdSync: json['customer_visit_id_sync'],
      shiftReportId: json['shift_report_id'],
      customerId: json['customer_id'],
      customerAddressId: json['customer_address_id'],
      baPositionId: json['ba_position_id'],
      employeeId: json['employee_id'],
      employeeName: json['employee_name'],
      supPositionId: json['sup_position_id'],
      cityLeaderPositionId: json['city_leader_position_id'],
      visitDate: json['visit_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      shiftCode: json['shift_code'],
      totalCashBack: json['total_cash_back'],
      totalCollection: json['total_collection'],
      newMembership: json['new_membership'],
      signature: json['signature'],
      visitStatus: json['visit_status'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      reason: json['reason'],
      createdBy: json['created_by'],
      createdDate: json['created_date'],
      updatedBy: json['updated_by'],
      updatedDate: json['updated_date'],
      version: json['version'],
      visitTimes: json['visit_times'],
      parentCustomerVisitId: json['parent_customer_visit_id'],
      isSample: json['is_sample'],
      isStockCheckCompleted: json['is_stock_check_completed'],
      isSurveyCompleted: json['is_survey_completed'],
      reasonId: json['reason_id'],
      totalApproached: json['total_approached'],
      totalSmoker: json['total_smoker'],
      totalGift: json['total_gift'],
    );
  }

  factory CustomerVisit.fromMap(Map<dynamic, dynamic> json) {
    return CustomerVisit(
      customerVisitId: json['customer_visit_id'],
      customerVisitIdSync: json['customer_visit_id_sync'],
      shiftReportId: json['shift_report_id'],
      customerId: json['customer_id'],
      customerAddressId: json['customer_address_id'],
      baPositionId: json['ba_position_id'],
      employeeId: json['employee_id'],
      employeeName: json['employee_name'],
      supPositionId: json['sup_position_id'],
      cityLeaderPositionId: json['city_leader_position_id'],
      visitDate: json['visit_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      shiftCode: json['shift_code'],
      totalCashBack: json['total_cash_back'],
      totalCollection: json['total_collection'],
      newMembership: json['new_membership'],
      signature: json['signature'],
      visitStatus: json['visit_status'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      reason: json['reason'],
      createdBy: json['created_by'],
      createdDate: json['created_date'],
      updatedBy: json['updated_by'],
      updatedDate: json['updated_date'],
      version: json['version'],
      visitTimes: json['visit_times'],
      parentCustomerVisitId: json['parent_customer_visit_id'],
      isSample: json['is_sample'] == 1 ? true : false,
      isStockCheckCompleted:
          json['is_stock_check_completed'] == 1 ? true : false,
      isSurveyCompleted: json['is_survey_completed'] == 1 ? true : false,
      reasonId: json['reason_id'],
      totalApproached: json['total_approached'],
      totalSmoker: json['total_smoker'],
      totalGift: json['total_gift'],
    );
  }

  factory CustomerVisit.copyWith(CustomerVisit obj) {
    return CustomerVisit(
      customerVisitId: obj.customerVisitId,
      customerVisitIdSync: obj.customerVisitIdSync,
      shiftReportId: obj.shiftReportId,
      customerId: obj.customerId,
      customerAddressId: obj.customerAddressId,
      baPositionId: obj.baPositionId,
      employeeId: obj.employeeId,
      employeeName: obj.employeeName,
      supPositionId: obj.supPositionId,
      cityLeaderPositionId: obj.cityLeaderPositionId,
      visitDate: obj.visitDate,
      startTime: obj.startTime,
      endTime: obj.endTime,
      shiftCode: obj.shiftCode,
      totalCashBack: obj.totalCashBack,
      totalCollection: obj.totalCollection,
      newMembership: obj.newMembership,
      signature: obj.signature,
      visitStatus: obj.visitStatus,
      longitude: obj.longitude,
      latitude: obj.latitude,
      reason: obj.reason,
      createdBy: obj.createdBy,
      createdDate: obj.createdDate,
      updatedBy: obj.updatedBy,
      updatedDate: obj.updatedDate,
      version: obj.version,
      visitTimes: obj.visitTimes,
      parentCustomerVisitId: obj.parentCustomerVisitId,
      isSample: obj.isSample,
      isStockCheckCompleted: obj.isStockCheckCompleted,
      isSurveyCompleted: obj.isSurveyCompleted,
      reasonId: obj.reasonId,
      totalApproached: obj.totalApproached,
      totalSmoker: obj.totalSmoker,
      totalGift: obj.totalGift,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_visit_id': customerVisitId,
      'customer_visit_id_sync': customerVisitIdSync,
      'shift_report_id': shiftReportId,
      'customer_id': customerId,
      'customer_address_id': customerAddressId,
      'ba_position_id': baPositionId,
      'employee_id': employeeId,
      'employee_name': employeeName,
      'sup_position_id': supPositionId,
      'city_leader_position_id': cityLeaderPositionId,
      'visit_date': visitDate,
      'start_time': startTime,
      'end_time': endTime,
      'shift_code': shiftCode,
      'total_cash_back': totalCashBack,
      'total_collection': totalCollection,
      'new_membership': newMembership,
      'signature': signature,
      'visit_status': visitStatus,
      'longitude': longitude,
      'latitude': latitude,
      'reason': reason,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
      'visit_times': visitTimes,
      'parent_customer_visit_id': parentCustomerVisitId,
      'is_sample': isSample,
      'is_stock_check_completed': isStockCheckCompleted,
      'is_survey_completed': isSurveyCompleted,
      'reason_id': reasonId,
      'total_approached': totalApproached,
      'total_smoker': totalSmoker,
      'total_gift': totalGift,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'customer_visit_id': customerVisitId,
      'customer_visit_id_sync': customerVisitIdSync,
      'shift_report_id': shiftReportId,
      'customer_id': customerId,
      'customer_address_id': customerAddressId,
      'ba_position_id': baPositionId,
      'employee_id': employeeId,
      'employee_name': employeeName,
      'sup_position_id': supPositionId,
      'city_leader_position_id': cityLeaderPositionId,
      'visit_date': visitDate,
      'start_time': startTime,
      'end_time': endTime,
      'shift_code': shiftCode,
      'total_cash_back': totalCashBack,
      'total_collection': totalCollection,
      'new_membership': newMembership,
      'signature': signature,
      'visit_status': visitStatus,
      'longitude': longitude,
      'latitude': latitude,
      'reason': reason,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
      'visit_times': visitTimes,
      'parent_customer_visit_id': parentCustomerVisitId,
      'is_sample': isSample,
      'is_stock_check_completed': isStockCheckCompleted,
      'is_survey_completed': isSurveyCompleted,
      'reason_id': reasonId,
      'total_approached': totalApproached,
      'total_smoker': totalSmoker,
      'total_gift': totalGift,
    };
  }

  Map<String, dynamic> toMapSync() {
    return <String, dynamic>{
      'customer_visit_id': customerVisitId,
      'customer_visit_id_sync': customerVisitId,
      'shift_report_id': shiftReportId,
      'customer_id': customerId,
      'customer_address_id': customerAddressId,
      'ba_position_id': baPositionId,
      'employee_id': employeeId,
      'employee_name': employeeName,
      'sup_position_id': supPositionId,
      'city_leader_position_id': cityLeaderPositionId,
      'visit_date': visitDate,
      'start_time': startTime,
      'end_time': endTime,
      'shift_code': shiftCode,
      'total_cash_back': totalCashBack,
      'total_collection': totalCollection,
      'new_membership': newMembership,
      'signature': signature,
      'visit_status': visitStatus,
      'longitude': longitude,
      'latitude': latitude,
      'reason': reason,
      'created_by': createdBy,
      'created_date': createdDate,
      'updated_by': updatedBy,
      'updated_date': updatedDate,
      'version': version,
      'visit_times': visitTimes,
      'parent_customer_visit_id': parentCustomerVisitId,
      'is_sample': isSample,
      'is_stock_check_completed': isStockCheckCompleted,
      'is_survey_completed': isSurveyCompleted,
      'reason_id': reasonId,
      'total_approached': totalApproached,
      'total_smoker': totalSmoker,
      'total_gift': totalGift,
    };
  }
}
