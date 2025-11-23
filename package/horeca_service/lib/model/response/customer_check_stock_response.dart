import 'package:equatable/equatable.dart';
import 'package:horeca_service/model/request/customer_stock_checkstock.dart';
import 'package:json_annotation/json_annotation.dart';
part 'customer_check_stock_response.g.dart';

@JsonSerializable()
class CustomerCheckStockResponse extends Equatable {
  int? customerVisitId;
  @JsonKey(name: 'lstCustomerPrices')
  List<LstCustomerPrices>? lstCustomerPrices;
  @JsonKey(name: 'lstCustomerStocks')
  List<LstCustomerStocks>? lstCustomerStocks;

  CustomerCheckStockResponse(
      {this.customerVisitId, this.lstCustomerPrices, this.lstCustomerStocks});

  factory CustomerCheckStockResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomerCheckStockResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerCheckStockResponseToJson(this);

  factory CustomerCheckStockResponse.fromMap(Map<String, dynamic> map) =>
      CustomerCheckStockResponse.fromJson(map);
  Map<String, dynamic> toMap() => toJson();

  @override
  // TODO: implement props
  List<Object?> get props =>
      [customerVisitId, lstCustomerPrices, lstCustomerStocks];
}
