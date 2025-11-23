import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_discount_scheme.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class DiscountSchemeProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableDiscountScheme() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableDiscountScheme ( 
          $columnDiscountSchemeId integer primary key, 
          $columnDiscountId integer,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<DiscountScheme> insert(DiscountScheme record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.discountSchemeId =
          await txn.insert(tableDiscountScheme, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<DiscountScheme> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableDiscountScheme, record);
    }

    //await batch.commit(noResult: true);
  }

  Future close() async => database.close();
}
