import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_sales_in_price_dtl.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class SalesInPriceDtlProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableSalesInPriceDtl() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableSalesInPriceDtl ( 
          $columnSalesInPriceDtlId integer primary key, 
          $columnSalesInPriceId integer,
          $columnProductId integer,
          $columnPrice real,
          $columnPriceVat real,
          $columnVat real,
          $columnStartDate text,
          $columnEndDate text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<SalesInPriceDtl> insert(SalesInPriceDtl record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.salesInPriceDtlId =
          await txn.insert(tableSalesInPriceDtl, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<SalesInPriceDtl> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    for (var record in recordsMap) {
      batch.insert(tableSalesInPriceDtl, record);
    }
  }

  Future close() async => database.close();
}
