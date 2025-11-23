// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response_header.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

APIResponseHeader _$APIResponseHeaderFromJson(Map<String, dynamic> json) =>
    APIResponseHeader(
      status: json['status'] as String?,
      code: json['code'] as int?,
      message: json['message'] as String?,
      error: json['error'] == null
          ? null
          : ErrorInfoDTO.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$APIResponseHeaderToJson(APIResponseHeader instance) =>
    <String, dynamic>{
      'status': instance.status,
      'code': instance.code,
      'message': instance.message,
      'error': instance.error,
    };
