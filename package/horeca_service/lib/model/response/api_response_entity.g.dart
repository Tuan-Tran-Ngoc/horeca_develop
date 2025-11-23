// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

APIResponseEntity<T> _$APIResponseEntityFromJson<T>(
        Map<String, dynamic> json, fromJsonData) =>
    APIResponseEntity<T>(
      status: json['status'] as String?,
      code: json['code'] as int?,
      message: json['message'] as String?,
      error: json['error'] == null
          ? null
          : ErrorInfoDTO.fromJson(json['error'] as Map<String, dynamic>),
      data: fromJsonData(json['data']),
    );

Map<String, dynamic> _$APIResponseEntityToJson<T>(
        APIResponseEntity<T> instance) =>
    <String, dynamic>{
      'status': instance.status,
      'code': instance.code,
      'message': instance.message,
      'error': instance.error,
      'data': instance.data,
    };
