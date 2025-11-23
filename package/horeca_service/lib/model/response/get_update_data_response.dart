import 'package:json_annotation/json_annotation.dart';

part 'get_update_data_response.g.dart';

@JsonSerializable()
class GetUpdateDataResponse {
  @JsonKey(name: 'fileName')
  final String? fileName;
  @JsonKey(name: 'dataType')
  final String? dataType;
  @JsonKey(name: 'dateCreateFile')
  final String? dateCreateFile;
  @JsonKey(name: 'status')
  final String? status;

  GetUpdateDataResponse(
      {this.fileName, this.dataType, this.dateCreateFile, this.status});
  factory GetUpdateDataResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUpdateDataResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetUpdateDataResponseToJson(this);
}
