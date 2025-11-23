// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_check_stock_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerCheckStockResponse _$CustomerCheckStockResponseFromJson(
        Map<String, dynamic> json) =>
    CustomerCheckStockResponse(
      customerVisitId: json['customerVisitId'] as int?,
      lstCustomerPrices: (json['lstCustomerPrices'] as List<dynamic>?)
          ?.map((e) => LstCustomerPrices.fromJson(e as Map<String, dynamic>))
          .toList(),
      lstCustomerStocks: (json['lstCustomerStocks'] as List<dynamic>?)
          ?.map((e) => LstCustomerStocks.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomerCheckStockResponseToJson(
        CustomerCheckStockResponse instance) =>
    <String, dynamic>{
      'customerVisitId': instance.customerVisitId,
      'lstCustomerPrices': instance.lstCustomerPrices,
      'lstCustomerStocks': instance.lstCustomerStocks,
    };
