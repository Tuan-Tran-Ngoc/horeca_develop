import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/s_order_promotion_result.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class OrderPromotionResultProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableOrderPromotionResult() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableOrderPromotionResult ( 
          $columnOrderPromotionResultId integer primary key AUTOINCREMENT, 
          $columnOrderPromotionResultIdSync integer,
          $columnOrderId integer,
          $columnPromotionId integer,
          $columnPromotionSchemeId integer,
          $columnProductId text,
          $columnQty double,
          $columnDescription text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<OrderPromotionResult> insert(
      OrderPromotionResult record, Transaction txn) async {
    // database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    // await database.transaction((txn) async {
    // });
    record.orderPromotionResultId =
        await txn.insert(tableOrderPromotionResult, record.toMap());

    return record;
  }

  Future insertMultipleRow(
      List<OrderPromotionResult> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMapSync()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableOrderPromotionResult, record);
    }

    //await batch.commit(noResult: true);
  }

  Future<List<OrderPromotionResult>> getListOrderPromotionResult(
      int orderId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<OrderPromotionResult> lstResult = [];
    List<int> args = [];
    args.add(orderId);
    String sqlQuery = '''
    SELECT * FROM s_order_promotion_result WHERE order_id = ? ;
''';

    List<Map> results = await database.rawQuery(sqlQuery, args);

    if (results.isNotEmpty) {
      for (var result in results) {
        lstResult.add(OrderPromotionResult.fromMap(result));
      }
    }

    return lstResult;
  }

  Future<int> updateSyncId(
      OrderPromotionResult promotion, Transaction? txn) async {
    if (txn != null) {
      return await txn.update(
          tableOrderPromotionResult,
          {
            columnOrderPromotionResultIdSync:
                promotion.orderPromotionResultIdSync,
            columnUpdatedBy: promotion.updatedBy,
            columnUpdatedDate: promotion.updatedDate
          },
          where: '$columnPromotionResultId = ?',
          whereArgs: [promotion.orderPromotionResultId]);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      return await database.update(
          tableOrderPromotionResult,
          {
            columnOrderPromotionResultIdSync:
                promotion.orderPromotionResultIdSync,
            columnUpdatedBy: promotion.updatedBy,
            columnUpdatedDate: promotion.updatedDate
          },
          where: '$columnPromotionResultId = ?',
          whereArgs: [promotion.orderPromotionResultId]);
    }
  }

  Future close() async => database.close();
}
