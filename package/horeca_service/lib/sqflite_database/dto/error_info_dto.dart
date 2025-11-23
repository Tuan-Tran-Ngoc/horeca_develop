import 'package:json_annotation/json_annotation.dart';
part 'error_info_dto.g.dart';

@JsonSerializable()
class ErrorInfoDTO {
  @JsonKey(name: 'code')
  String? code;
  @JsonKey(name: 'parameter')
  List<String>? parameter;
  @JsonKey(name: 'message')
  String? message;

  ErrorInfoDTO({this.code, this.parameter, this.message});

  factory ErrorInfoDTO.fromJson(Map<String, dynamic> json) =>
      _$ErrorInfoDTOFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorInfoDTOToJson(this);
}
