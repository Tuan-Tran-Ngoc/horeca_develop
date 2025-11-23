import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shift_end_request.g.dart';

@JsonSerializable()
class ShiftEndRequest extends Equatable {
  @JsonKey(name: 'baPositionId')
  final int baPositionId;
  @JsonKey(name: 'shiftCode')
  final String shiftCode;
  @JsonKey(name: 'workingDate')
  final String workingDate;
  @JsonKey(name: 'endTime')
  final String endTime;
  @JsonKey(name: 'shiftReportId')
  final int shiftReportId;

  const ShiftEndRequest(this.shiftCode, this.workingDate, this.baPositionId,
      this.endTime, this.shiftReportId);

  factory ShiftEndRequest.fromJson(Map<String, dynamic> json) =>
      _$ShiftEndRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftEndRequestToJson(this);

  @override
  List<Object?> get props =>
      [baPositionId, shiftCode, workingDate, endTime, shiftReportId];
}
