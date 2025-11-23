// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_latest_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateLatestRequest _$UpdateLatestRequestFromJson(Map<String, dynamic> json) =>
    UpdateLatestRequest(
      positionId: json['positionId'] as int?,
      imei: json['imei'] as String?,
      updateDate: json['updateDate'] as String?,
      mappingErrorObject: json['mappingErrorObject'] == null
          ? null
          : MappingErrorObject.fromJson(
              json['mappingErrorObject'] as Map<String, dynamic>),
      updateStatus: json['updateStatus'] as String?,
    );

Map<String, dynamic> _$UpdateLatestRequestToJson(
        UpdateLatestRequest instance) =>
    <String, dynamic>{
      'positionId': instance.positionId,
      'imei': instance.imei,
      'updateStatus': instance.updateStatus,
      'updateDate': instance.updateDate,
      'mappingErrorObject': instance.mappingErrorObject,
    };

MappingErrorObject _$MappingErrorObjectFromJson(Map<String, dynamic> json) =>
    MappingErrorObject(
      objectFail: json['objectFail'] as String,
      log: json['log'] as String,
    );

Map<String, dynamic> _$MappingErrorObjectToJson(MappingErrorObject instance) =>
    <String, dynamic>{
      'objectFail': instance.objectFail,
      'log': instance.log,
    };
