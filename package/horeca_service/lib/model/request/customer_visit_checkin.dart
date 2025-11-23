import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer_visit_checkin.g.dart';

@JsonSerializable()
class CustomerVisitCheckinRequest extends Equatable {
  @JsonKey(name: 'customerId')
  final int customerId;
  @JsonKey(name: 'customerAddressId')
  final int customerAddressId;
  @JsonKey(name: 'baPositionId')
  final int baPositionId;
  @JsonKey(name: 'visitDate')
  final String visitDate;
  @JsonKey(name: 'startTime')
  final String startTime;
  @JsonKey(name: 'shiftReportId')
  final int shiftReportId;
  @JsonKey(name: 'shiftCode')
  final String shiftCode;

  const CustomerVisitCheckinRequest(
      this.customerId,
      this.customerAddressId,
      this.baPositionId,
      this.visitDate,
      this.startTime,
      this.shiftReportId,
      this.shiftCode);

  factory CustomerVisitCheckinRequest.fromJson(Map<String, dynamic> json) =>
      _$CustomerVisitCheckinRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerVisitCheckinRequestToJson(this);

  @override
  List<Object?> get props => [
        customerId,
        customerAddressId,
        baPositionId,
        visitDate,
        startTime,
        shiftReportId,
        shiftCode,
      ];
}
