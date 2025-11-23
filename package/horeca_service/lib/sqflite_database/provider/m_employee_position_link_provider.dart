import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_employee_position_link.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class EmployeePositionLinkProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableEmployeePositionLink() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableEmployeePositionLink ( 
          $columnEmployeePositionLinkId integer primary key, 
          $columnEmployeeId integer,
          $columnPositionId integer,
          $columnAreaId integer,
          $columnStartDate text,
          $columnEndDate text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<EmployeePositionLink> insert(EmployeePositionLink record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.employeePositionLinkId =
          await txn.insert(tableEmployeePositionLink, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(
      List<EmployeePositionLink> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableEmployeePositionLink, record);
    }

    // await batch.commit(noResult: true);
  }

  Future<List<EmployeePositionLink>> getInfoByPositionId(int positionId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<EmployeePositionLink> results = [];
    List<int?>? arg = [];
    arg.add(positionId);

    List<Map> resultDBs =
        await database.rawQuery(SQLQuery.SQL_EMPLOY_POS_LIK_001, arg);

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(EmployeePositionLink.fromMap(result));
      }
    }
    return results;
  }

  Future close() async => database.close();
}
