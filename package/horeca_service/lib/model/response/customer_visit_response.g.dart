// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_visit_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerVisitResponse _$CustomerVisitResponseFromJson(
        Map<String, dynamic> json) =>
    CustomerVisitResponse(
      customerVisitId: json['customerVisitId'] as int?,
      shiftReportId: json['shiftReportId'] as int?,
      customerId: json['customerId'] as int?,
      customerAddressId: json['customerAddressId'] as int?,
      baPositionId: json['baPositionId'] as int?,
      employeeId: json['employeeId'] as int?,
      employeeName: json['employeeName'] as String?,
      supPositionId: json['supPositionId'] as int?,
      cityLeaderPositionId: json['cityLeaderPositionId'] as int?,
      visitDate: json['visitDate'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      shiftCode: json['shiftCode'] as String?,
      signature: json['signature'] as String?,
      visitStatus: json['visitStatus'] as String?,
      reason: json['reason'] as String?,
      createdBy: json['createdBy'] as int?,
      createdDate: json['createdDate'] as String?,
      updatedBy: json['updatedBy'] as int?,
      updatedDate: json['updatedDate'] as String?,
      version: json['version'] as int?,
      visitTimes: json['visitTimes'] as int?,
      parentCustomerVisitId: json['parentCustomerVisitId'] as int?,
      isStockCheckCompleted: json['isStockCheckCompleted'] as bool?,
      isSurveyCompleted: json['isSurveyCompleted'] as bool?,
      reasonId: json['reasonId'] as int?,
      reVisit: json['reVisit'] == null
          ? null
          : CustomerVisitResponse.fromJson(
              json['reVisit'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CustomerVisitResponseToJson(
        CustomerVisitResponse instance) =>
    <String, dynamic>{
      'customerVisitId': instance.customerVisitId,
      'shiftReportId': instance.shiftReportId,
      'customerId': instance.customerId,
      'customerAddressId': instance.customerAddressId,
      'baPositionId': instance.baPositionId,
      'employeeId': instance.employeeId,
      'employeeName': instance.employeeName,
      'supPositionId': instance.supPositionId,
      'cityLeaderPositionId': instance.cityLeaderPositionId,
      'visitDate': instance.visitDate,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'shiftCode': instance.shiftCode,
      'signature': instance.signature,
      'visitStatus': instance.visitStatus,
      'reason': instance.reason,
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate,
      'updatedBy': instance.updatedBy,
      'updatedDate': instance.updatedDate,
      'version': instance.version,
      'visitTimes': instance.visitTimes,
      'parentCustomerVisitId': instance.parentCustomerVisitId,
      'isStockCheckCompleted': instance.isStockCheckCompleted,
      'isSurveyCompleted': instance.isSurveyCompleted,
      'reasonId': instance.reasonId,
      'reVisit': instance.reVisit,
    };
