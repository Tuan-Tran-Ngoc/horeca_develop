import 'package:horeca_service/sqflite_database/dto/discount_result_info_dto.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_discount_result.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class DiscountResultProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableDiscountResult() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableDiscountResult ( 
          $columnDiscountResultId integer primary key, 
          $columnDiscountId integer,
          $columnDiscountSchemeId integer,
          $columnDiscountType text,
          $columnResultQty double,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<DiscountResult> insert(DiscountResult record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.discountResultId =
          await txn.insert(tableDiscountResult, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<DiscountResult> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableDiscountResult, record);
    }

    // await batch.commit(noResult: true);
  }

  Future<List<DiscountResultInfoDto>> selectDiscountResultInfo(
      int promotionId, int schemeId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<DiscountResultInfoDto> results = [];
    List<int>? arg = [];
    arg.add(promotionId);
    arg.add(schemeId);

    List<Map> resultDBs =
        await database.rawQuery(SQLQuery.SQL_PRO_RES_001, arg);

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(DiscountResultInfoDto.fromMap(result));
      }
    }
    return results;
  }

  Future close() async => database.close();
}
