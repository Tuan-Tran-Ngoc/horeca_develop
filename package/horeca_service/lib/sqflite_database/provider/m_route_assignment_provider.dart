import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_route_assignment.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class RouteAssignmentProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableRouteAssignment() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableRouteAssignment( 
          $columnRouteId integer primary key, 
          $columnBaPositionId integer,
          $columnCustomerId integer,
          $columnDayOfWeek integer,
          $columnShiftCode text,
          $columnFrequency text,
          $columnIsUpdate integer,
          $columnStartDate text,
          $columnEndDate text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion interger)
        ''');
    // db.close();
  }

  Future<RouteAssignment> insert(RouteAssignment routeAssignment) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);

    await database.transaction((txn) async {
      routeAssignment.routeId =
          await txn.insert(tableRouteAssignment, routeAssignment.toMap());
      print('insert data $tableRouteAssignment: ${routeAssignment.routeId}');
    });
    return routeAssignment;
  }

  Future insertMultipleRow(
      List<RouteAssignment> listRouteAssignment, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var listRouteAssignments =
        listRouteAssignment.map((data) => data.toMap()).toList();

    //var batch = database.batch();
    listRouteAssignments.forEach((data) async {
      batch.insert(tableRouteAssignment, data);
    });
    //await batch.commit(noResult: true);
  }

  Future<List<RouteAssignment>> getRouteAssignment(
      int baPositionId, List<int> lstDayOfWeek) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<RouteAssignment> lstShift = [];
    List<String> lstShiftCode = ['00', '01', '02'];

    List<Map> maps = await database.query(tableRouteAssignment,
        columns: [columnRouteId],
        where:
            '$columnBaPositionId = ? and shift_code in (${List.filled(lstShiftCode.length, '?').join(', ')}) and day_of_week IN (${List.filled(lstDayOfWeek.length, '?').join(', ')})',
        whereArgs: [baPositionId, ...lstShiftCode, ...lstDayOfWeek]);
    if (maps.isNotEmpty) {
      for (final item in maps) {
        lstShift.add(RouteAssignment.fromMap(item));
      }
    }
    return lstShift;
  }

  Future<List<RouteAssignment>> select(int routeId, Transaction? txn) async {
    List<RouteAssignment> results = [];
    List<Map> resultDBs = [];
    List<int?>? arg = [];
    arg.add(routeId);

    if (txn != null) {
      resultDBs = await txn.rawQuery(SQLQuery.SQL_ROU_ASS_001, arg);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      resultDBs = await database.rawQuery(SQLQuery.SQL_ROU_ASS_001, arg);
    }

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(RouteAssignment.fromMap(result));
      }
    }
    return results;
  }

  Future close() async => database.close();
}
