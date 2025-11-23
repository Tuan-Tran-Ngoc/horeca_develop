import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/sap_order.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class SapOrderProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableSapOrder() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableSapOrder ( 
          $columnOrderId integer primary key, 
          $columnOrderNo text,
          $columnCustomerCd text,
          $columnCustomerName text,
          $columnShipToPartyName text,
          $columnShipToParty text,
          $columnTotalNetValue double,
          $columnOrderDate text,
          $columnStatus text,
          $columnPoHrc text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedDate text ,
          $columnUpdatedBy integer,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<SapOrder> insert(SapOrder record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.orderId = await txn.insert(tableSapOrder, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<SapOrder> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableSapOrder, record);
    }

    //await batch.commit(noResult: true);
  }

  Future close() async => database.close();
}
