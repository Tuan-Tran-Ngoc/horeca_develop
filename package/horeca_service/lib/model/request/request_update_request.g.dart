// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestUpdateRequest _$RequestUpdateRequestFromJson(
        Map<String, dynamic> json) =>
    RequestUpdateRequest(
      baPositionId: json['baPositionId'] as int?,
      imeiDevice: json['imeiDevice'] as String?,
      dateLastestUpdate: json['dateLastestUpdate'] as String?,
    );

Map<String, dynamic> _$RequestUpdateRequestToJson(
        RequestUpdateRequest instance) =>
    <String, dynamic>{
      'baPositionId': instance.baPositionId,
      'imeiDevice': instance.imeiDevice,
      'dateLastestUpdate': instance.dateLastestUpdate,
    };
