import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/s_customer_price.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class CustomerPriceProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableCustomerPrice() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableCustomerPrice ( 
          $columnCustomerPriceId integer primary key AUTOINCREMENT, 
          $columnCustomerPriceIdSync integer,
          $columnCustomerId integer,
          $columnBaPositionId integer,
          $columnCustomerVisitId integer,
          $columnLastUpdate text,
          $columnProductId integer,
          $columnPrice double,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<CustomerPrice> insert(CustomerPrice record, Transaction txn) async {
    record.customerPriceId =
        await txn.insert(tableCustomerPrice, record.toMap());

    return record;
  }

  Future<CustomerPrice> update(CustomerPrice record, Transaction? txn) async {
    if (txn != null) {
      record.customerPriceId = await txn.update(
          tableCustomerPrice,
          {
            columnCustomerPriceIdSync: record.customerPriceIdSync,
            columnUpdatedDate: record.updatedDate,
            columnUpdatedBy: record.updatedBy,
            columnLastUpdate: record.lastUpdate
          },
          where: '$columnCustomerPriceId = ?',
          whereArgs: [record.customerPriceId]);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      record.customerPriceId = await database.update(
          tableCustomerPrice,
          {
            columnCustomerPriceIdSync: record.customerPriceIdSync,
            columnUpdatedDate: record.updatedDate,
            columnUpdatedBy: record.updatedBy,
            columnLastUpdate: record.lastUpdate
          },
          where: '$columnCustomerPriceId = ?',
          whereArgs: [record.customerPriceId]);
    }

    return record;
  }

  Future insertMultipleRow(List<CustomerPrice> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMapSync()).toList();

    // var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableCustomerPrice, record);
    }

    // await batch.commit(noResult: true);
  }

  Future<List<CustomerPrice>> getAllCustomerPriceByVisit(
      customerVisitId, Transaction? txn) async {
    List<CustomerPrice> lstCustomerPrice = [];
    List<Map> resultsDB = [];

    if (txn != null) {
      resultsDB = await txn.rawQuery(
          'SELECT * FROM $tableCustomerPrice WHERE customer_visit_id = $customerVisitId');
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      resultsDB = await database.rawQuery(
          'SELECT * FROM $tableCustomerPrice WHERE customer_visit_id = $customerVisitId');
    }

    if (resultsDB.isNotEmpty) {
      for (var result in resultsDB) {
        lstCustomerPrice.add(CustomerPrice.fromMap(result));
      }
    }
    return lstCustomerPrice;
  }

  Future<int> deleteByCustomerVisitId(
      int customerVisitId, Transaction? txn) async {
    if (txn != null) {
      return await txn.delete(tableCustomerPrice,
          where: '$columnCustomerVisitId = ?', whereArgs: [customerVisitId]);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      return await database.delete(tableCustomerPrice,
          where: '$columnCustomerVisitId = ?', whereArgs: [customerVisitId]);
    }
  }

  Future close() async => database.close();
}
