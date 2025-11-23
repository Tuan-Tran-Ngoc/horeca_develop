import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_sales_in_price_target.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class SalesInPriceTargetProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableSalesInPriceTarget() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableSalesInPriceTarget ( 
          $columnSalesInPriceTargetId integer primary key, 
          $columnSalesInPriceId integer,
          $columnTargetType text,
          $columnTargetId integer,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<SalesInPriceTarget> insert(SalesInPriceTarget record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.salesInPriceTargetId =
          await txn.insert(tableSalesInPriceTarget, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(
      List<SalesInPriceTarget> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    for (var record in recordsMap) {
      batch.insert(tableSalesInPriceTarget, record);
    }
  }

  Future close() async => database.close();
}
