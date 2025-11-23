import 'package:json_annotation/json_annotation.dart';

part 'start_shift_response.g.dart';

@JsonSerializable()
class StartShiftResponse {
  @JsonKey(name: 'shiftReportId')
  final int? shiftReportId;
  StartShiftResponse(this.shiftReportId);
  factory StartShiftResponse.fromJson(Map<String, dynamic> json) =>
      _$StartShiftResponseFromJson(json);
  Map<String, dynamic> toJson() => _$StartShiftResponseToJson(this);
}
