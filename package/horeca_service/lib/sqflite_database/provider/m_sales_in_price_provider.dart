import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_sales_in_price.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class SalesInPriceProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableSalesInPrice() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableSalesInPrice ( 
          $columnSalesInPriceId integer primary key, 
          $columnPriceCode text,
          $columnPriceName text,
          $columnStatus text,
          $columnStartDate text,
          $columnEndDate text,
          $columnRemark text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<SalesInPrice> insert(SalesInPrice record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.salesInPriceId =
          await txn.insert(tableSalesInPrice, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<SalesInPrice> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    for (var record in recordsMap) {
      batch.insert(tableSalesInPrice, record);
    }
  }

  Future close() async => database.close();
}
