import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_latest_request.g.dart';

@JsonSerializable()
class UpdateLatestRequest extends Equatable {
  @JsonKey(name: 'positionId')
  final int? positionId;
  @JsonKey(name: 'imei')
  final String? imei;
  @JsonKey(name: 'updateStatus')
  final String? updateStatus;
  @JsonKey(name: 'updateDate')
  final String? updateDate;
  @JsonKey(name: 'mappingErrorObject')
  final MappingErrorObject? mappingErrorObject;

  const UpdateLatestRequest(
      {this.positionId,
      this.imei,
      this.updateDate,
      this.mappingErrorObject,
      this.updateStatus});

  factory UpdateLatestRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateLatestRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateLatestRequestToJson(this);

  @override
  List<Object?> get props =>
      [positionId, imei, updateStatus, updateDate, mappingErrorObject];
}

@JsonSerializable()
class MappingErrorObject extends Equatable {
  @JsonKey(name: 'objectFail')
  final String objectFail;
  @JsonKey(name: 'log')
  final String log;

  const MappingErrorObject({required this.objectFail, required this.log});

  factory MappingErrorObject.fromJson(Map<String, dynamic> json) =>
      _$MappingErrorObjectFromJson(json);

  Map<String, dynamic> toJson() => _$MappingErrorObjectToJson(this);

  @override
  List<Object?> get props => [objectFail, log];
}
