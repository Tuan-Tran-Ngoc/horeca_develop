import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shift_start_request.g.dart';

@JsonSerializable()
class ShiftStartRequest extends Equatable {
  @JsonKey(name: 'baPositionId')
  final int baPositionId;
  @JsonKey(name: 'shiftCode')
  final String shiftCode;
  @JsonKey(name: 'workingDate')
  // final int workingDate;
  final String workingDate;
  @JsonKey(name: 'startTime')
  // final int startTime;
  final String startTime;

  const ShiftStartRequest(
      this.shiftCode, this.baPositionId, this.workingDate, this.startTime);

  factory ShiftStartRequest.fromJson(Map<String, dynamic> json) =>
      _$ShiftStartRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftStartRequestToJson(this);

  @override
  List<Object?> get props => [baPositionId, shiftCode, workingDate, startTime];
}
