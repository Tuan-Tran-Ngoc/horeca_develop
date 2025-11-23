import 'package:horeca_service/sqflite_database/model/m_shift.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class ShiftProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableShift() async {
    try {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);

      await database.execute('''
        create table $tableShift ( 
          $columnShiftId integer primary key, 
          $columnShiftCode text not null,
          $columnShiftName text,
          $columnStatus text,
          $columnStartTime text,
          $columnEndTime text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedDate text ,
          $columnUpdatedBy integer,
          $columnVersion integer)
        ''');
    } finally {
      await database.close();
    }
    // db.close();
  }

  Future<Shift> insert(Shift record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.shiftId = await txn.insert(tableShift, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<Shift> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableShift, record);
    }

    //await batch.commit(noResult: true);
  }

  Future<List<Shift>> getShift() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Shift> results = [];
    List<String?>? arg = [];
    arg.add('01');

    List<Map> resultDBs = await database.rawQuery(SQLQuery.SQL_SHIFT_001, arg);

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(Shift.fromMap(result));
      }
    }
    return results;
  }

  Future close() async => database.close();
}
