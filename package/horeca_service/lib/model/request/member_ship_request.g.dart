// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_ship_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MembershipModelRequest _$MembershipModelRequestFromJson(
        Map<String, dynamic> json) =>
    MembershipModelRequest(
      json['telNo'] as String,
      json['customerVisitId'] as int,
      json['baPositionId'] as int,
    );

Map<String, dynamic> _$MembershipModelRequestToJson(
        MembershipModelRequest instance) =>
    <String, dynamic>{
      'telNo': instance.telNo,
      'customerVisitId': instance.customerVisitId,
      'baPositionId': instance.baPositionId,
    };
