import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer_visit_revisit.g.dart';

@JsonSerializable()
class CustomerVisitRevisitRequest extends Equatable {
  @JsonKey(name: 'customerVisitId')
  final int customerVisitId;

  const CustomerVisitRevisitRequest(this.customerVisitId);

  factory CustomerVisitRevisitRequest.fromJson(Map<String, dynamic> json) =>
      _$CustomerVisitRevisitRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerVisitRevisitRequestToJson(this);

  @override
  List<Object?> get props => [customerVisitId];
}
