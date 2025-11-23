import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'request_update_request.g.dart';

@JsonSerializable()
class RequestUpdateRequest extends Equatable {
  @JsonKey(name: 'baPositionId')
  final int? baPositionId;
  @JsonKey(name: 'imeiDevice')
  final String? imeiDevice;
  @JsonKey(name: 'dateLastestUpdate')
  final String? dateLastestUpdate;

  const RequestUpdateRequest(
      {this.baPositionId, this.imeiDevice, this.dateLastestUpdate});

  factory RequestUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$RequestUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RequestUpdateRequestToJson(this);

  @override
  List<Object?> get props => [baPositionId, imeiDevice, dateLastestUpdate];
}
