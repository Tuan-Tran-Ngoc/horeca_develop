// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'init_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InitDataResponse _$InitDataResponseFromJson(Map<String, dynamic> json) =>
    InitDataResponse(
      json['masterUrlFile'] as String?,
      json['baUrlFile'] as String?,
      json['dateCreateFile'] as String?,
    );

Map<String, dynamic> _$InitDataResponseToJson(InitDataResponse instance) =>
    <String, dynamic>{
      'masterUrlFile': instance.masterUrlFile,
      'baUrlFile': instance.baUrlFile,
      'dateCreateFile': instance.dateCreateFile,
    };
