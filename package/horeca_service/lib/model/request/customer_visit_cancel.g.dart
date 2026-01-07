// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_visit_cancel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerVisitCancelRequest _$CustomerVisitCancelRequestFromJson(
        Map<String, dynamic> json) =>
    CustomerVisitCancelRequest(
      shiftCode: json['shiftCode'] as String,
      shiftReportId: json['shiftReportId'] as int,
      baPositionId: json['baPositionId'] as int,
      reasonId: json['reasonId'] as int,
      customerId: json['customerId'] as int,
      customerAddressId: json['customerAddressId'] as int,
      visitDate: json['visitDate'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CustomerVisitCancelRequestToJson(
        CustomerVisitCancelRequest instance) =>
    <String, dynamic>{
      'shiftReportId': instance.shiftReportId,
      'reasonId': instance.reasonId,
      'baPositionId': instance.baPositionId,
      'customerId': instance.customerId,
      'customerAddressId': instance.customerAddressId,
      'visitDate': instance.visitDate,
      'shiftCode': instance.shiftCode,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
