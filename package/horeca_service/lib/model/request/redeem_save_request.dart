import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'redeem_save_request.g.dart';

@JsonSerializable()
class RedeemSaveRequest extends Equatable {
  @JsonKey(name: 'customerId')
  final int customerId;
  @JsonKey(name: 'customerVisitId')
  final int customerVisitId;
  @JsonKey(name: 'baPositionId')
  final int baPositionId;
  @JsonKey(name: 'redeemDate')
  final String redeemDate;
  @JsonKey(name: 'redeemOrderDtls')
  final List<RedeemOrder> redeemOrderDtls;
  @JsonKey(name: 'redeemOrderResults')
  final List<RedeemOrder> redeemOrderResults;

  const RedeemSaveRequest(
      this.customerVisitId,
      this.baPositionId,
      this.customerId,
      this.redeemDate,
      this.redeemOrderDtls,
      this.redeemOrderResults);

  factory RedeemSaveRequest.fromJson(Map<String, dynamic> json) =>
      _$RedeemSaveRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RedeemSaveRequestToJson(this);

  @override
  List<Object?> get props => [
        customerVisitId,
        baPositionId,
        customerId,
        redeemDate,
        redeemOrderDtls,
        redeemOrderResults
      ];
}

@JsonSerializable()
class RedeemOrder extends Equatable {
  @JsonKey(name: 'productId')
  final int productId;
  @JsonKey(name: 'qty')
  final int qty;
  @JsonKey(name: 'redeemId')
  final int redeemId;
  @JsonKey(name: 'redeemSchemeId')
  final int redeemSchemeId;

  const RedeemOrder(
      this.productId, this.qty, this.redeemId, this.redeemSchemeId);

  factory RedeemOrder.fromJson(Map<String, dynamic> json) =>
      _$RedeemOrderFromJson(json);

  Map<String, dynamic> toJson() => _$RedeemOrderToJson(this);

  @override
  List<Object?> get props => [
        productId,
        qty,
        redeemId,
        redeemSchemeId,
      ];
}
