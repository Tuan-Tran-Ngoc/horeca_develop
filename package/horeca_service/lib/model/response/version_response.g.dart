// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VersionResponse _$VersionResponseFromJson(Map<String, dynamic> json) =>
    VersionResponse(
      json['masterUrlFile'] as String?,
      json['baUrlFile'] as String?,
      json['dateCreateFile'] as String?,
      json['version'] as String?,
    );

Map<String, dynamic> _$VersionResponseToJson(VersionResponse instance) =>
    <String, dynamic>{
      'masterUrlFile': instance.masterUrlFile,
      'baUrlFile': instance.baUrlFile,
      'dateCreateFile': instance.dateCreateFile,
      'version': instance.version,
    };
