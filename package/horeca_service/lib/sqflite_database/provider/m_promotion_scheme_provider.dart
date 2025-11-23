import 'package:horeca_service/sqflite_database/dto/scheme_dto.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_promotion_scheme.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class PromotionSchemeProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTablePromotionScheme() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tablePromotionScheme ( 
          $columnPromotionSchemeId integer primary key, 
          $columnPromotionId integer,
          $columnPriority integer,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<PromotionScheme> insert(PromotionScheme record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.promotionSchemeId =
          await txn.insert(tablePromotionScheme, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<PromotionScheme> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tablePromotionScheme, record);
    }

    //await batch.commit(noResult: true);
  }

  Future<List<SchemeDto>> selectSchemeResult(int schemeId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<SchemeDto> results = [];
    List<dynamic>? arg = [];
    arg.add(schemeId);

    List<Map> resultDBs =
        await database.rawQuery(SQLQuery.SQL_PRO_SCH_001, arg);

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(SchemeDto.fromMap(result));
      }
    }
    return results;
  }

  Future<List<PromotionScheme>> selectByPromotionId(int promotionId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<PromotionScheme> results = [];
    List<dynamic>? arg = [];
    arg.add(promotionId);

    List<Map> resultDBs =
        await database.rawQuery(SQLQuery.SQL_PRO_SCH_002, arg);

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(PromotionScheme.fromMap(result));
      }
    }
    return results;
  }

  Future close() async => database.close();
}
