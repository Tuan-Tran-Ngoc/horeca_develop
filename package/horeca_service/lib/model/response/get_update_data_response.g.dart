// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_update_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUpdateDataResponse _$GetUpdateDataResponseFromJson(
        Map<String, dynamic> json) =>
    GetUpdateDataResponse(
      fileName: json['fileName'] as String?,
      dataType: json['dataType'] as String?,
      dateCreateFile: json['dateCreateFile'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$GetUpdateDataResponseToJson(
        GetUpdateDataResponse instance) =>
    <String, dynamic>{
      'fileName': instance.fileName,
      'dataType': instance.dataType,
      'dateCreateFile': instance.dateCreateFile,
      'status': instance.status,
    };
