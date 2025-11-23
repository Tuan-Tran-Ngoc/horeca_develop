import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_customer_liabilities.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class CustomerLiabilitiesProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableCustomerLiabilities() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableCustomerLiabilities ( 
          $columnCustomerLibilitiesId integer primary key, 
          $columnBusinessArea text,
          $columnCustomerCode text,
          $columnCustomerName text,
          $columnDistributionChanel text,
          $columnInvoiceDate text,
          $columnNetDueDate text,
          $columnDocumentCurrencyValueOriginal integer,
          $columnPayment integer,
          $columnDocumentCurrencyValueRemain integer,
          $columnUsedDebtLimit integer,
          $columnOrderDebtLimit integer,
          $columnRemainDebtLimit integer,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<CustomerLiabilities> insert(CustomerLiabilities record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.customerLiabilitiesId =
          await txn.insert(tableCustomerLiabilities, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(
      List<CustomerLiabilities> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableCustomerLiabilities, record);
    }

    //await batch.commit(noResult: true);
  }

  Future<List<CustomerLiabilities>> select(
      String customerCode, Transaction? txn) async {
    List<CustomerLiabilities> results = [];
    List<Map> resultDBs = [];
    List<String?>? arg = [];
    arg.add(customerCode);

    if (txn != null) {
      resultDBs = await txn.rawQuery(SQLQuery.SQL_CUS_LIA_001, arg);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);

      resultDBs = await database.rawQuery(SQLQuery.SQL_CUS_LIA_001, arg);
    }

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(CustomerLiabilities.fromMap(result));
      }
    }
    return results;
  }

  Future close() async => database.close();
}
