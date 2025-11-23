import 'package:equatable/equatable.dart';
import 'package:horeca_service/sqflite_database/model/s_customer_visit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'revisit_request.g.dart';

@JsonSerializable()
class RevisitRequest extends Equatable {
  @JsonKey(name: 'customerVisitId')
  final int? customerVisitId;
  @JsonKey(name: 'baPositionId')
  final int? baPositionId;
  @JsonKey(name: 'reVisit')
  final Map? reVisit;

  const RevisitRequest({this.customerVisitId, this.baPositionId, this.reVisit});

  factory RevisitRequest.fromJson(Map<String, dynamic> json) =>
      _$RevisitRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RevisitRequestToJson(this);

  @override
  List<Object?> get props => [customerVisitId];
}
