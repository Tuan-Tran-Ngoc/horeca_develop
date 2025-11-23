// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redeem_save_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RedeemSaveRequest _$RedeemSaveRequestFromJson(Map<String, dynamic> json) =>
    RedeemSaveRequest(
      json['customerVisitId'] as int,
      json['baPositionId'] as int,
      json['customerId'] as int,
      json['redeemDate'] as String,
      (json['redeemOrderDtls'] as List<dynamic>)
          .map((e) => RedeemOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['redeemOrderResults'] as List<dynamic>)
          .map((e) => RedeemOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RedeemSaveRequestToJson(RedeemSaveRequest instance) =>
    <String, dynamic>{
      'customerId': instance.customerId,
      'customerVisitId': instance.customerVisitId,
      'baPositionId': instance.baPositionId,
      'redeemDate': instance.redeemDate,
      'redeemOrderDtls': instance.redeemOrderDtls,
      'redeemOrderResults': instance.redeemOrderResults,
    };

RedeemOrder _$RedeemOrderFromJson(Map<String, dynamic> json) => RedeemOrder(
      json['productId'] as int,
      json['qty'] as int,
      json['redeemId'] as int,
      json['redeemSchemeId'] as int,
    );

Map<String, dynamic> _$RedeemOrderToJson(RedeemOrder instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'qty': instance.qty,
      'redeemId': instance.redeemId,
      'redeemSchemeId': instance.redeemSchemeId,
    };
