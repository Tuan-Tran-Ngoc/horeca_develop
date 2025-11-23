// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_update_data_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUpdateDataRequest _$GetUpdateDataRequestFromJson(
        Map<String, dynamic> json) =>
    GetUpdateDataRequest(
      json['baPositionId'] as int,
      json['imeiDevice'] as String,
      json['dateCreate'] as String,
      json['jobSeqId'] as String,
    );

Map<String, dynamic> _$GetUpdateDataRequestToJson(
        GetUpdateDataRequest instance) =>
    <String, dynamic>{
      'baPositionId': instance.baPositionId,
      'imeiDevice': instance.imeiDevice,
      'dateCreate': instance.dateCreate,
      'jobSeqId': instance.jobSeqId,
    };
