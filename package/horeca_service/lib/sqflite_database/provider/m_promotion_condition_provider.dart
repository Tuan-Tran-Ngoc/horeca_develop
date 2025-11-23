import 'package:horeca_service/sqflite_database/dto/promotion_condition_info_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_display_condition_dto.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_promotion_condition.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class PromotionConditionProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTablePromotionCondition() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tablePromotionCondition ( 
          $columnPromotionConditionId integer primary key, 
          $columnPromotionId integer,
          $columnPromotionSchemeId integer,
          $columnPromotionType text,
          $columnTotalType text,
          $columnProductId integer,
          $columnConditionQty double,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<PromotionCondition> insert(PromotionCondition record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.promotionConditionId =
          await txn.insert(tablePromotionCondition, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(
      List<PromotionCondition> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tablePromotionCondition, record);
    }

    //await batch.commit(noResult: true);
  }

  Future<List<PromotionConditionInfoDto>> selectPromotionConditionInfo(
      int promotionId, int schemeId, Transaction? txn) async {
    List<PromotionConditionInfoDto> results = [];
    List<int>? arg = [];
    arg.add(promotionId);
    arg.add(schemeId);

    if (txn != null) {
      List<Map> resultDBs = await txn.rawQuery(SQLQuery.SQL_PRO_COND_001, arg);

      if (resultDBs.isNotEmpty) {
        for (var result in resultDBs) {
          results.add(PromotionConditionInfoDto.fromMap(result));
        }
      }
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);

      List<Map> resultDBs =
          await database.rawQuery(SQLQuery.SQL_PRO_COND_001, arg);

      if (resultDBs.isNotEmpty) {
        for (var result in resultDBs) {
          results.add(PromotionConditionInfoDto.fromMap(result));
        }
      }
    }
    return results;
  }

  Future<List<PromotionDisplayConditionDto>> selectPromotionDisplayCondition(
      int promotionId, int schemeId) async {
    List<PromotionDisplayConditionDto> results = [];
    List<int>? arg = [];
    arg.add(promotionId);
    arg.add(schemeId);

    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);

    List<Map> resultDBs =
        await database.rawQuery(SQLQuery.SQL_PRO_COND_002, arg);

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(PromotionDisplayConditionDto.fromMap(result));
      }
    }
    return results;
  }

  Future close() async => database.close();
}
