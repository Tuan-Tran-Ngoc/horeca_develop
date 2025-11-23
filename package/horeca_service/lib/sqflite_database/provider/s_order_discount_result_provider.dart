import 'dart:async';

import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/s_order_discount_result.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class OrderDiscountResultProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableOrderDiscountResult() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableOrderDiscountResult ( 
          $columnOrderDiscountResultId integer primary key AUTOINCREMENT, 
          $columnOrderDiscountResultIdSync integer,
          $columnOrderId integer,
          $columnDiscountId integer,
          $columnDiscountSchemeId integer,
          $columnDiscountType text,
          $columnDiscountValue double,
          $columnTotalDiscount double,
          $columnProductId integer,
          $columnDescription text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<OrderDiscountResult> insert(
      OrderDiscountResult record, Transaction txn) async {
    // database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    // await database.transaction((txn) async {
    // });
    record.orderDiscountResultId =
        await txn.insert(tableOrderDiscountResult, record.toMap());

    return record;
  }

  Future insertMultipleRow(
      List<OrderDiscountResult> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMapSync()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableOrderDiscountResult, record);
    }

    //await batch.commit(noResult: true);
  }

  Future<List<OrderDiscountResult>> getOrderDiscountResult(int orderId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<OrderDiscountResult> lstResult = [];
    List<int> args = [];
    args.add(orderId);
    String sqlQuery = '''
    SELECT * FROM s_order_discount_result WHERE order_id = ? ;
''';
    List<Map> results = await database.rawQuery(sqlQuery, args);
    if (results.isNotEmpty) {
      for (var result in results) {
        lstResult.add(OrderDiscountResult.fromMap(result));
      }
    }
    return lstResult;
  }

  Future<int> updateSyncId(
      OrderDiscountResult discount, Transaction? txn) async {
    if (txn != null) {
      return await txn.update(
          tableOrderDiscountResult,
          {
            columnOrderDiscountResultIdSync: discount.orderDiscountResultIdSync,
            columnUpdatedBy: discount.updatedBy,
            columnUpdatedDate: discount.updatedDate
          },
          where: '$columnDiscountResultId = ?',
          whereArgs: [discount.orderDiscountResultId]);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      return await database.update(
          tableOrderDiscountResult,
          {
            columnOrderDiscountResultIdSync: discount.orderDiscountResultIdSync,
            columnUpdatedBy: discount.updatedBy,
            columnUpdatedDate: discount.updatedDate
          },
          where: '$columnDiscountResultId = ?',
          whereArgs: [discount.orderDiscountResultId]);
    }
  }

  Future close() async => database.close();
}
