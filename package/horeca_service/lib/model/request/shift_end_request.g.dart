// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_end_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftEndRequest _$ShiftEndRequestFromJson(Map<String, dynamic> json) =>
    ShiftEndRequest(
      json['shiftCode'] as String,
      json['workingDate'] as String,
      json['baPositionId'] as int,
      json['endTime'] as String,
      json['shiftReportId'] as int,
    );

Map<String, dynamic> _$ShiftEndRequestToJson(ShiftEndRequest instance) =>
    <String, dynamic>{
      'baPositionId': instance.baPositionId,
      'shiftCode': instance.shiftCode,
      'workingDate': instance.workingDate,
      'endTime': instance.endTime,
      'shiftReportId': instance.shiftReportId,
    };
