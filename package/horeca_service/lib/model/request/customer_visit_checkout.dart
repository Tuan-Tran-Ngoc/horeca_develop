import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer_visit_checkout.g.dart';

@JsonSerializable()
class CustomerVisitCheckoutRequest extends Equatable {
  @JsonKey(name: 'customerVisitId')
  final int customerVisitId;
  @JsonKey(name: 'signature')
  final String signature;
  @JsonKey(name: 'endTime')
  final String endTime;

  const CustomerVisitCheckoutRequest(
      this.customerVisitId, this.signature, this.endTime);

  factory CustomerVisitCheckoutRequest.fromJson(Map<String, dynamic> json) =>
      _$CustomerVisitCheckoutRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerVisitCheckoutRequestToJson(this);

  @override
  List<Object?> get props => [customerVisitId, signature, endTime];
}
