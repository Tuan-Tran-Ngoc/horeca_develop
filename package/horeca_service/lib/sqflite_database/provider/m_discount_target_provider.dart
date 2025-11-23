import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_discount_target.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class DiscountTargetProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableDiscountTarget() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableDiscountTarget ( 
          $columnDiscountTargetId integer primary key, 
          $columnDiscountId integer,
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

  Future<DiscountTarget> insert(DiscountTarget record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.discountTargetId =
          await txn.insert(tableDiscountTarget, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<DiscountTarget> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableDiscountTarget, record);
    }

    //await batch.commit(noResult: true);
  }

  Future close() async => database.close();
}
