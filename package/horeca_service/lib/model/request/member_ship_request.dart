import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member_ship_request.g.dart';

@JsonSerializable()
class MembershipModelRequest extends Equatable {
  @JsonKey(name: 'telNo')
  final String telNo;
  @JsonKey(name: 'customerVisitId')
  final int customerVisitId;
  @JsonKey(name: 'baPositionId')
  final int baPositionId;

  const MembershipModelRequest(
      this.telNo, this.customerVisitId, this.baPositionId);

  factory MembershipModelRequest.fromJson(Map<String, dynamic> json) =>
      _$MembershipModelRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MembershipModelRequestToJson(this);

  @override
  List<Object?> get props => [baPositionId, customerVisitId, telNo];
}
