import 'package:horeca/utils/constants.dart';
import 'package:horeca_service/sqflite_database/model/s_customer_stock.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/sqflite_database/dto/customer_stock_price_dto.dart';

class StockService {
  CustomerStockProvider customerStockProvider = CustomerStockProvider();
  CustomerPriceProvider customerPriceProvider = CustomerPriceProvider();
  Future<CustomerStockPriceDto> copyStockIntoNewVisit(int? oldCustomerVisitId,
      int? newCustomerVisitId, String dateTimeStr, Transaction txn) async {
    // get customer stock available
    List<CustomerStock> lstCustomerStockAvailable = await customerStockProvider
        .getAllCustomerStockByVisit(oldCustomerVisitId, txn);

    List<CustomerStock> lstCustomerStock = [];
    for (var customerStock in lstCustomerStockAvailable) {
      lstCustomerStock
          .add(CustomerStock.copyWith(customerStock, newCustomerVisitId ?? 0));
    }

    // reset lastest customerStock
    lstCustomerStock = lstCustomerStock.map((e) {
      e.lastUpdate = dateTimeStr;
      return e;
    }).toList();

    // get customer price available
    List<CustomerPrice> lstCustomerPriceAvailable = await customerPriceProvider
        .getAllCustomerPriceByVisit(oldCustomerVisitId, txn);

    List<CustomerPrice> lstCustomerPrice = [];

    for (var customerPrice in lstCustomerPriceAvailable) {
      lstCustomerPrice
          .add(CustomerPrice.copyWith(customerPrice, newCustomerVisitId ?? 0));
    }

    // reset lastest customerPrice
    lstCustomerPrice = lstCustomerPrice.map((e) {
      e.lastUpdate = dateTimeStr;
      return e;
    }).toList();

    // insert local s_customer_price
    for (CustomerPrice customerPrice in lstCustomerPrice) {
      await customerPriceProvider.insert(customerPrice, txn);
    }

    // insert local s_customer_stock
    for (CustomerStock customerStock in lstCustomerStock) {
      await customerStockProvider.insert(customerStock, txn);
    }

    CustomerStockPriceDto result = CustomerStockPriceDto(
        lstCustomerPrice: lstCustomerPrice, lstCustomerStock: lstCustomerStock);

    return result;
  }
}
