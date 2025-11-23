// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_start_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftStartRequest _$ShiftStartRequestFromJson(Map<String, dynamic> json) =>
    ShiftStartRequest(
      json['shiftCode'] as String,
      json['baPositionId'] as int,
      json['workingDate'] as String,
      json['startTime'] as String,
    );

Map<String, dynamic> _$ShiftStartRequestToJson(ShiftStartRequest instance) =>
    <String, dynamic>{
      'baPositionId': instance.baPositionId,
      'shiftCode': instance.shiftCode,
      'workingDate': instance.workingDate,
      'startTime': instance.startTime,
    };
