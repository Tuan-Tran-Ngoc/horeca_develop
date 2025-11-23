import 'package:horeca_service/sqflite_database/dto/error_info_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_response_entity.g.dart';

@JsonSerializable()
class APIResponseEntity<T> {
  @JsonKey(name: 'status')
  String? status;
  @JsonKey(name: 'code')
  int? code;
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'error')
  ErrorInfoDTO? error;
  @JsonKey(name: 'data')
  T? data;

  APIResponseEntity(
      {this.status, this.code, this.message, this.error, this.data});

  factory APIResponseEntity.fromJson(Map<String, dynamic> json,
          T Function(Map<String, dynamic>)? fromJsonData) =>
      _$APIResponseEntityFromJson(json, fromJsonData);

  Map<String, dynamic> toJson() => _$APIResponseEntityToJson(this);
}
