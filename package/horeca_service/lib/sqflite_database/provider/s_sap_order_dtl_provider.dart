import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/sap_order_dtl.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class SapOrderDtlProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableSapOrderDtl() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableSapOrderDtl ( 
          $columnOrderDetailId integer primary key, 
          $columnOrderId integer,
          $columnProductCd text,
          $columnProductName text,
          $columnItemCategory text,
          $columnUnit text,
          $columnQty double,
          $columnShippedQty double,
          $columnUnitPrice double,
          $columnDiscount double,
          $columnUnitPriceAfterDiscount double,
          $columnNetValue double,
          $columnTaxAmount double,
          $columnVat double,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedDate text ,
          $columnUpdatedBy integer,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<SapOrderDtl> insert(SapOrderDtl record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.orderDtlId = await txn.insert(tableSapOrderDtl, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<SapOrderDtl> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableSapOrderDtl, record);
    }

    //await batch.commit(noResult: true);
  }

  Future<List<SapOrderDtl>> selectSapOrderDtl(int orderId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<SapOrderDtl> results = [];
    List<int?>? arg = [];
    arg.add(orderId);

    List<Map> resultDBs =
        await database.rawQuery(SQLQuery.SQL_SAP_ORD_DTL_001, arg);
    print('SQLIYTE ${SQLQuery.SQL_ORD_009}');
    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(SapOrderDtl.fromMap(result));
      }
    }
    return results;
  }

  Future close() async => database.close();
}
