import 'package:horeca_service/sqflite_database/dto/promotion_display_result_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_result_info_dto.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_promotion_result.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class PromotionResultProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTablePromotionResult() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tablePromotionResult ( 
          $columnPromotionResultId integer primary key, 
          $columnProductId integer,
          $columnPromotionId integer,
          $columnPromotionSchemeId integer,
          $columnResultQty double,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<PromotionResult> insert(PromotionResult record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.promotionResultId =
          await txn.insert(tablePromotionResult, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<PromotionResult> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tablePromotionResult, record);
    }

    //await batch.commit(noResult: true);
  }

  Future<List<PromotionResultInfoDto>> selectPromotionResultInfo(
      int promotionId, int schemeId, Transaction? txn) async {
    List<PromotionResultInfoDto> results = [];
    List<int>? arg = [];
    arg.add(promotionId);
    arg.add(schemeId);

    if (txn != null) {
      List<Map> resultDBs = await txn.rawQuery(SQLQuery.SQL_PRO_RES_001, arg);

      if (resultDBs.isNotEmpty) {
        for (var result in resultDBs) {
          results.add(PromotionResultInfoDto.fromMap(result));
        }
      }
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      List<Map> resultDBs =
          await database.rawQuery(SQLQuery.SQL_PRO_RES_001, arg);

      if (resultDBs.isNotEmpty) {
        for (var result in resultDBs) {
          results.add(PromotionResultInfoDto.fromMap(result));
        }
      }
    }
    return results;
  }

  Future<List<PromotionDisplayResultDto>> selectPromotionDisplayResult(
      int promotionId, int schemeId) async {
    List<PromotionDisplayResultDto> results = [];
    List<int>? arg = [];
    arg.add(promotionId);
    arg.add(schemeId);

    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> resultDBs =
        await database.rawQuery(SQLQuery.SQL_PRO_RES_002, arg);

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(PromotionDisplayResultDto.fromMap(result));
      }
    }
    return results;
  }

  Future close() async => database.close();
}
