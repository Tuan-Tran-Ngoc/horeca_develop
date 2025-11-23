import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/s_sap_order_delivery.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class SapOrderDeliveryProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableSapOrderDelivery() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableSapOrderDelivery ( 
          $columnOrderDeliveryId integer primary key, 
          $columnOrderId integer,
          $columnDeliveryNo text,
          $columnDeliveryDate text,
          $columnDeliveryStatus text,
          $columnTruckId text,
          $columnRemark text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<SapOrderDelivery> insert(SapOrderDelivery record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.orderDeliveryId =
          await txn.insert(tableSapOrderDelivery, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<SapOrderDelivery> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    for (var record in recordsMap) {
      batch.insert(tableSapOrderDelivery, record);
    }
  }

  Future<List<SapOrderDelivery>> selectSapOrderDelivery(int sapOrderId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<SapOrderDelivery> results = [];
    List<int?>? arg = [];
    arg.add(sapOrderId);

    List<Map> resultDBs =
        await database.rawQuery(SQLQuery.SQL_SAP_ORD_DEL_001, arg);
    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(SapOrderDelivery.fromMap(result));
      }
    }
    return results;
  }

  Future close() async => database.close();
}
