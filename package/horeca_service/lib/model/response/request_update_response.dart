import 'package:json_annotation/json_annotation.dart';

part 'request_update_response.g.dart';

@JsonSerializable()
class RequestUpdateResponse {
  @JsonKey(name: 'dateCreateFile')
  final String? dateCreateFile;
  @JsonKey(name: 'jobSeqId')
  final int? jobSeqId;

  RequestUpdateResponse({this.dateCreateFile, this.jobSeqId});
  factory RequestUpdateResponse.fromJson(Map<String, dynamic> json) =>
      _$RequestUpdateResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RequestUpdateResponseToJson(this);
}
