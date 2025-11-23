import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_update_data_request.g.dart';

@JsonSerializable()
class GetUpdateDataRequest extends Equatable {
  @JsonKey(name: 'baPositionId')
  final int baPositionId;
  @JsonKey(name: 'imeiDevice')
  final String imeiDevice;
  @JsonKey(name: 'dateCreate')
  final String dateCreate;
  @JsonKey(name: 'jobSeqId')
  final String jobSeqId;

  const GetUpdateDataRequest(
      this.baPositionId, this.imeiDevice, this.dateCreate, this.jobSeqId);

  factory GetUpdateDataRequest.fromJson(Map<String, dynamic> json) =>
      _$GetUpdateDataRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetUpdateDataRequestToJson(this);

  @override
  List<Object?> get props => [baPositionId, imeiDevice, dateCreate, jobSeqId];
}
