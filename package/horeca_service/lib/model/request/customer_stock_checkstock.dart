import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer_stock_checkstock.g.dart';

@JsonSerializable()
class CustomerStockCheckStockRequest extends Equatable {
  @JsonKey(name: 'customerVisitId')
  final int? customerVisitId;
  @JsonKey(name: 'lstCustomerPrices')
  final List<LstCustomerPrices>? lstCustomerPrices;
  @JsonKey(name: 'lstCustomerStocks')
  final List<LstCustomerStocks>? lstCustomerStocks;

  const CustomerStockCheckStockRequest(
      {this.customerVisitId, this.lstCustomerPrices, this.lstCustomerStocks});

  factory CustomerStockCheckStockRequest.fromJson(Map<String, dynamic> json) =>
      _$CustomerStockCheckStockRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerStockCheckStockRequestToJson(this);

  @override
  List<Object?> get props =>
      [customerVisitId, lstCustomerPrices, lstCustomerStocks];
}

@JsonSerializable()
class LstCustomerStocks extends Equatable {
  @JsonKey(name: 'customerStockId')
  final int? customerStockId;
  @JsonKey(name: 'customerId')
  final int? customerId;
  @JsonKey(name: 'baPositionId')
  final int? baPositionId;
  @JsonKey(name: 'lastUpdate')
  final String? lastUpdate;
  @JsonKey(name: 'productId')
  final int? productId;
  @JsonKey(name: 'customerVisitId')
  final int? customerVisitId;
  @JsonKey(name: 'availableStock')
  final double? availableStock;

  const LstCustomerStocks(
      {this.customerStockId,
      this.customerId,
      this.baPositionId,
      this.lastUpdate,
      this.availableStock,
      this.customerVisitId,
      this.productId});

  factory LstCustomerStocks.fromJson(Map<String, dynamic> json) =>
      _$LstCustomerStocksFromJson(json);

  Map<String, dynamic> toJson() => _$LstCustomerStocksToJson(this);

  @override
  List<Object?> get props => [
        customerId,
        baPositionId,
        lastUpdate,
        productId,
        customerVisitId,
        availableStock
      ];
}

@JsonSerializable()
class LstCustomerPrices extends Equatable {
  @JsonKey(name: 'customerPriceId')
  final int? customerPriceId;
  @JsonKey(name: 'customerId')
  final int? customerId;
  @JsonKey(name: 'baPositionId')
  final int? baPositionId;
  @JsonKey(name: 'lastUpdate')
  final String? lastUpdate;
  @JsonKey(name: 'productId')
  final int? productId;
  @JsonKey(name: 'customerVisitId')
  final int? customerVisitId;
  @JsonKey(name: 'price')
  final double? price;

  const LstCustomerPrices(
      {this.customerPriceId,
      this.customerId,
      this.baPositionId,
      this.lastUpdate,
      this.price,
      this.customerVisitId,
      this.productId});

  factory LstCustomerPrices.fromJson(Map<String, dynamic> json) =>
      _$LstCustomerPricesFromJson(json);

  Map<String, dynamic> toJson() => _$LstCustomerPricesToJson(this);

  @override
  List<Object?> get props =>
      [customerId, baPositionId, lastUpdate, productId, customerVisitId, price];
}
