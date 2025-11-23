import 'package:horeca_service/sqflite_database/dto/error_info_dto.dart';
import 'package:json_annotation/json_annotation.dart';
part 'api_response_header.g.dart';

@JsonSerializable()
class APIResponseHeader {
  @JsonKey(name: 'status')
  String? status;
  @JsonKey(name: 'code')
  int? code;
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'error')
  ErrorInfoDTO? error;

  APIResponseHeader({this.status, this.code, this.message, this.error});

  factory APIResponseHeader.fromJson(Map<String, dynamic> json) =>
      _$APIResponseHeaderFromJson(json);
  Map<String, dynamic> toJson() => _$APIResponseHeaderToJson(this);
}

