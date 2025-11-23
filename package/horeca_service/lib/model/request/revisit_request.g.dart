// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revisit_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RevisitRequest _$RevisitRequestFromJson(Map<String, dynamic> json) =>
    RevisitRequest(
      customerVisitId: json['customerVisitId'] as int?,
      baPositionId: json['baPositionId'] as int?,
      reVisit: json['reVisit'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$RevisitRequestToJson(RevisitRequest instance) =>
    <String, dynamic>{
      'customerVisitId': instance.customerVisitId,
      'baPositionId': instance.baPositionId,
      'reVisit': instance.reVisit,
    };
