// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorInfoDTO _$ErrorInfoDTOFromJson(Map<String, dynamic> json) => ErrorInfoDTO(
      code: json['code'] as String?,
      parameter: (json['parameter'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ErrorInfoDTOToJson(ErrorInfoDTO instance) =>
    <String, dynamic>{
      'code': instance.code,
      'parameter': instance.parameter,
      'message': instance.message,
    };
