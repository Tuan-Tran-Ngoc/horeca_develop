// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_stock_checkstock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerStockCheckStockRequest _$CustomerStockCheckStockRequestFromJson(
        Map<String, dynamic> json) =>
    CustomerStockCheckStockRequest(
      customerVisitId: json['customerVisitId'] as int?,
      lstCustomerPrices: (json['lstCustomerPrices'] as List<dynamic>?)
          ?.map((e) => LstCustomerPrices.fromJson(e as Map<String, dynamic>))
          .toList(),
      lstCustomerStocks: (json['lstCustomerStocks'] as List<dynamic>?)
          ?.map((e) => LstCustomerStocks.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomerStockCheckStockRequestToJson(
        CustomerStockCheckStockRequest instance) =>
    <String, dynamic>{
      'customerVisitId': instance.customerVisitId,
      'lstCustomerPrices': instance.lstCustomerPrices,
      'lstCustomerStocks': instance.lstCustomerStocks,
    };

LstCustomerStocks _$LstCustomerStocksFromJson(Map<String, dynamic> json) =>
    LstCustomerStocks(
      customerStockId: json['customerStockId'] as int?,
      customerId: json['customerId'] as int?,
      baPositionId: json['baPositionId'] as int?,
      lastUpdate: json['lastUpdate'] as String?,
      availableStock: (json['availableStock'] as num?)?.toDouble(),
      customerVisitId: json['customerVisitId'] as int?,
      productId: json['productId'] as int?,
    );

Map<String, dynamic> _$LstCustomerStocksToJson(LstCustomerStocks instance) =>
    <String, dynamic>{
      'customerStockId': instance.customerStockId,
      'customerId': instance.customerId,
      'baPositionId': instance.baPositionId,
      'lastUpdate': instance.lastUpdate,
      'productId': instance.productId,
      'customerVisitId': instance.customerVisitId,
      'availableStock': instance.availableStock,
    };

LstCustomerPrices _$LstCustomerPricesFromJson(Map<String, dynamic> json) =>
    LstCustomerPrices(
      customerPriceId: json['customerPriceId'] as int?,
      customerId: json['customerId'] as int?,
      baPositionId: json['baPositionId'] as int?,
      lastUpdate: json['lastUpdate'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      customerVisitId: json['customerVisitId'] as int?,
      productId: json['productId'] as int?,
    );

Map<String, dynamic> _$LstCustomerPricesToJson(LstCustomerPrices instance) =>
    <String, dynamic>{
      'customerPriceId': instance.customerPriceId,
      'customerId': instance.customerId,
      'baPositionId': instance.baPositionId,
      'lastUpdate': instance.lastUpdate,
      'productId': instance.productId,
      'customerVisitId': instance.customerVisitId,
      'price': instance.price,
    };
