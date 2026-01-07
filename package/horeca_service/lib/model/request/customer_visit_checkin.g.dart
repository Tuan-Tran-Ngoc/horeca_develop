// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_visit_checkin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerVisitCheckinRequest _$CustomerVisitCheckinRequestFromJson(
        Map<String, dynamic> json) =>
    CustomerVisitCheckinRequest(
      json['customerId'] as int,
      json['customerAddressId'] as int,
      json['baPositionId'] as int,
      json['visitDate'] as String,
      json['startTime'] as String,
      json['shiftReportId'] as int,
      json['shiftCode'] as String,
      (json['latitude'] as num?)?.toDouble(),
      (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CustomerVisitCheckinRequestToJson(
        CustomerVisitCheckinRequest instance) =>
    <String, dynamic>{
      'customerId': instance.customerId,
      'customerAddressId': instance.customerAddressId,
      'baPositionId': instance.baPositionId,
      'visitDate': instance.visitDate,
      'startTime': instance.startTime,
      'shiftReportId': instance.shiftReportId,
      'shiftCode': instance.shiftCode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
