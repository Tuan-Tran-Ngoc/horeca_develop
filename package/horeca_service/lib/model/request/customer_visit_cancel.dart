import 'package:chopper/chopper.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer_visit_cancel.g.dart';

@JsonSerializable()
class CustomerVisitCancelRequest extends Equatable {
  @JsonKey(name: 'shiftReportId')
  final int shiftReportId;
  @JsonKey(name: 'reasonId')
  final int reasonId;
  @JsonKey(name: 'baPositionId')
  final int baPositionId;
  @JsonKey(name: 'customerId')
  final int customerId;
  @JsonKey(name: 'customerAddressId')
  final int customerAddressId;
  @JsonKey(name: 'visitDate')
  final String visitDate;
  @JsonKey(name: 'shiftCode')
  final String shiftCode;
  @JsonKey(name: 'startTime')
  final String startTime;
  @JsonKey(name: 'endTime')
  final String endTime;

  const CustomerVisitCancelRequest(
      {required this.shiftCode,
      required this.shiftReportId,
      required this.baPositionId,
      required this.reasonId,
      required this.customerId,
      required this.customerAddressId,
      required this.visitDate,
      required this.startTime,
      required this.endTime});

  factory CustomerVisitCancelRequest.fromJson(Map<String, dynamic> json) =>
      _$CustomerVisitCancelRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerVisitCancelRequestToJson(this);

  @override
  List<Object?> get props =>
      [baPositionId, shiftCode, customerId, visitDate, shiftReportId, reasonId];
}
