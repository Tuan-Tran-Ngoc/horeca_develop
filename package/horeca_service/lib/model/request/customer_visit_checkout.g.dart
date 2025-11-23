// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_visit_checkout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerVisitCheckoutRequest _$CustomerVisitCheckoutRequestFromJson(
        Map<String, dynamic> json) =>
    CustomerVisitCheckoutRequest(
      json['customerVisitId'] as int,
      json['signature'] as String,
      json['endTime'] as String,
    );

Map<String, dynamic> _$CustomerVisitCheckoutRequestToJson(
        CustomerVisitCheckoutRequest instance) =>
    <String, dynamic>{
      'customerVisitId': instance.customerVisitId,
      'signature': instance.signature,
      'endTime': instance.endTime,
    };
