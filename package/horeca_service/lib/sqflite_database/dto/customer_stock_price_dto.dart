import 'package:horeca_service/sqflite_database/model/s_customer_price.dart';
import 'package:horeca_service/sqflite_database/model/s_customer_stock.dart';

class CustomerStockPriceDto {
  List<CustomerStock> lstCustomerStock;
  List<CustomerPrice> lstCustomerPrice;

  CustomerStockPriceDto(
      {required this.lstCustomerStock, required this.lstCustomerPrice});
}
