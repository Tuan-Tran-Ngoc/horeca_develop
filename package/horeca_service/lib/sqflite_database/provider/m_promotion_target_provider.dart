import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_promotion_target.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class PromotionTargetProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTablePromotionTarget() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tablePromotionTarget ( 
          $columnPromotionTargetId integer primary key, 
          $columnPromotionId integer,
          $columnTargetType text,
          $columnTargetId interger,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<PromotionTarget> insert(PromotionTarget record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.promotionTargetId =
          await txn.insert(tablePromotionTarget, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<PromotionTarget> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tablePromotionTarget, record);
    }

    //await batch.commit(noResult: true);
  }

  Future close() async => database.close();
}
