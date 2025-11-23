// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_update_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestUpdateResponse _$RequestUpdateResponseFromJson(
        Map<String, dynamic> json) =>
    RequestUpdateResponse(
      dateCreateFile: json['dateCreateFile'] as String?,
      jobSeqId: json['jobSeqId'] as int?,
    );

Map<String, dynamic> _$RequestUpdateResponseToJson(
        RequestUpdateResponse instance) =>
    <String, dynamic>{
      'dateCreateFile': instance.dateCreateFile,
      'jobSeqId': instance.jobSeqId,
    };
