import 'package:horeca_service/sqflite_database/dto/discount_condition_info_dto.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_discount_condition.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class DiscountConditionProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableDiscountCondition() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableDiscountCondition ( 
          $columnDiscountConditionId integer primary key, 
          $columnDiscountId integer,
          $columnDiscountSchemeId integer,
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

  Future<DiscountCondition> insert(DiscountCondition record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.discountConditionId =
          await txn.insert(tableDiscountCondition, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<DiscountCondition> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableDiscountCondition, record);
    }

    //await batch.commit(noResult: true);
  }

  Future<List<DiscountConditionInfoDto>> selectDiscountConditionInfo(
      int promotionId, int schemeId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<DiscountConditionInfoDto> results = [];
    List<int>? arg = [];
    arg.add(promotionId);
    arg.add(schemeId);

    List<Map> resultDBs =
        await database.rawQuery(SQLQuery.SQL_DIS_COND_001, arg);

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(DiscountConditionInfoDto.fromMap(result));
      }
    }
    return results;
  }

  Future close() async => database.close();
}
