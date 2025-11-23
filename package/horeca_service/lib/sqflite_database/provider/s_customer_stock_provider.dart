import 'package:horeca_service/model/product_stock.dart';
import 'package:horeca_service/sqflite_database/dto/product_dto.dart';
import 'package:horeca_service/sqflite_database/model/s_customer_stock.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class CustomerStockProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableCustomerStock() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableCustomerStock ( 
          $columnCustomerStockId integer primary key AUTOINCREMENT,
          $columnCustomerStockIdSync integer,
          $columnCustomerId integer,
          $columnBaPositionId integer,
          $columnCustomerVisitId integer,
          $columnProductId integer,
          $columnAvailableStock double,
          $columnLastUpdate text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<CustomerStock> insert(
      CustomerStock customerStock, Transaction txn) async {
    customerStock.customerStockId =
        await txn.insert(tableCustomerStock, customerStock.toMap());

    print('insert data $tableCustomerStock: ${customerStock.customerStockId}');

    return customerStock;
  }

  Future<CustomerStock> update(CustomerStock record, Transaction? txn) async {
    if (txn != null) {
      record.customerStockId = await txn.update(
          tableCustomerStock,
          {
            columnCustomerStockIdSync: record.customerStockIdSync,
            columnUpdatedDate: record.updatedDate,
            columnUpdatedBy: record.updatedBy,
            columnLastUpdate: record.lastUpdate
          },
          where: '$columnCustomerStockId = ?',
          whereArgs: [record.customerStockId]);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      record.customerStockId = await database.update(
          tableCustomerStock,
          {
            columnCustomerStockIdSync: record.customerStockIdSync,
            columnUpdatedDate: record.updatedDate,
            columnUpdatedBy: record.updatedBy,
            columnLastUpdate: record.lastUpdate
          },
          where: '$columnCustomerStockId = ?',
          whereArgs: [record.customerStockId]);
    }

    return record;
  }

  Future insertMultipleRow(
      List<CustomerStock> listCustomerStock, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var listCustomerStocks =
        listCustomerStock.map((data) => data.toMapSync()).toList();

//var batch = database.batch();
    listCustomerStocks.forEach((data) async {
      batch.insert(tableCustomerStock, data);
    });
//await batch.commit(noResult: true);
  }

  Future<CustomerStock?> getCutomerStock(int id) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps = await database.rawQuery(
        'SELECT * FROM s_customer_stock where customer_stock_id = ?', [id]);

    if (maps.isNotEmpty) {
      return CustomerStock.fromMap(maps.first);
    }
    return null;
  }

  String getListCustomerStockQuery =
      '''SELECT cs.product_id,p.product_name,pt.type_name ,u.uom_name, p.price_cost, cs.available_stock 
      FROM s_customer_Stock cs, m_product p, m_uom u, m_product_type pt
      WHERE cs.product_id = p.product_id AND p.uom_id = u.uom_id AND p.product_type_id = pt.product_type_id''';
  // Future<List<CustomerStock>> getAllCustomerStock() async {
  //   List<CustomerStock> listCustomerStock = [];
  //   database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
  //   List<Map> maps = await database.rawQuery('SELECT * FROM s_customer_Stock');

  //   if (maps.isNotEmpty) {
  //     for (final item in maps) {
  //       // print(item);
  //       listCustomerStock.add(CustomerStock.fromMap(item));
  //     }
  //     return listCustomerStock;
  //   }
  //   return [];
  // }

  Future<List<ProductStock>> getListCustomerStock() async {
    List<ProductStock> lstProductStock = [];
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps = await database.rawQuery(getListCustomerStockQuery);

    if (maps.isNotEmpty) {
      for (final item in maps) {
        // print(item);
        lstProductStock.add(ProductStock.fromMap(item));
      }
      return lstProductStock;
    }
    return [];
  }

  Future<List<ProductDto>> getAllCustomerStock(
      int customerId, int customerAddressId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<ProductDto> results = [];
    List<int?>? arg = [];
    arg.add(customerAddressId);
    arg.add(customerId);
    arg.add(customerAddressId);
    arg.add(customerId);

    List<Map> resultDBs =
        await database.rawQuery(SQLQuery.SQL_CUS_PRI_001, arg);
    print('SQL ${SQLQuery.SQL_CUS_PRI_001}');
    print('arg $arg');
    print('result $resultDBs');
    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(ProductDto.fromMap(result));
      }
    }
    return results;
  }

  Future<List<CustomerStock>> getAllCustomerStockByVisit(
      customerVisitId, Transaction? txn) async {
    List<CustomerStock> lstCustomerStock = [];
    List<Map> resultsDB = [];

    if (txn != null) {
      resultsDB = await txn.rawQuery(
          'SELECT * FROM $tableCustomerStock WHERE customer_visit_id = $customerVisitId');
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      resultsDB = await database.rawQuery(
          'SELECT * FROM $tableCustomerStock WHERE customer_visit_id = $customerVisitId');
    }

    if (resultsDB.isNotEmpty) {
      for (var result in resultsDB) {
        lstCustomerStock.add(CustomerStock.fromMap(result));
      }
    }

    return lstCustomerStock;
  }

  Future<int> delete(int id) async {
    return await database.delete(tableCustomerStock,
        where: '$columnCustomerStockId = ?', whereArgs: [id]);
  }

  Future<int> deleteByCustomerVisitId(
      int customerVisitId, Transaction? txn) async {
    if (txn != null) {
      return await txn.delete(tableCustomerStock,
          where: '$columnCustomerVisitId = ?', whereArgs: [customerVisitId]);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      return await database.delete(tableCustomerStock,
          where: '$columnCustomerVisitId = ?', whereArgs: [customerVisitId]);
    }
  }

  Future close() async => database.close();
}
