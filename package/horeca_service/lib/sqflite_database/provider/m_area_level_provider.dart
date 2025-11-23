import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_area_level.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class AreaLevelProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableAreaLevelProvider() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableAreaLevel ( 
          $columnAreaId integer primary key, 
          $columnLevelCode text,
          $columnLevelName text,
          $columnStatus text,
          $columnIsSmallest integer,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<AreaLevel> insert(AreaLevel record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.areaLevelId = await txn.insert(tableAreaLevel, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<AreaLevel> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableAreaLevel, record);
    }

    //await batch.commit(noResult: true);
  }

  Future close() async => database.close();
}
