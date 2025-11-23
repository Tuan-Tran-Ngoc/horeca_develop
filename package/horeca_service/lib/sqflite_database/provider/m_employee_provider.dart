import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_employee.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class EmployeeProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableEmployee() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableEmployee ( 
          $columnEmployeeId integer primary key, 
          $columnEmployeeCode integer,
          $columnEmployeeName integer,
          $columnStatus integer,
          $columnPhoneNumber text,
          $columnEmail text,
          $columnBirthdate text,
          $columnProvinceId integer,
          $columnDistrictId integer,
          $columnWardId integer,
          $columnStreetName text,
          $columnAddressDetail text,
          $columnRemark text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<Employee> insert(Employee record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.employeeId = await txn.insert(tableEmployee, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<Employee> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableEmployee, record);
    }

    //await batch.commit(noResult: true);
  }

  Future<List<Employee>> getEmployByPosId(
      int positionId, Transaction? txn) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Employee> results = [];
    List<int?>? arg = [];
    arg.add(positionId);

    if (txn != null) {
      List<Map> resultDBs = await txn.rawQuery(SQLQuery.SQL_EMP_001, arg);
      print('SQLQuery.SQL_EMP_001 ${SQLQuery.SQL_EMP_001}--$arg');
      if (resultDBs.isNotEmpty) {
        for (var result in resultDBs) {
          results.add(Employee.fromMap(result));
        }
      }
    } else {
      List<Map> resultDBs = await database.rawQuery(SQLQuery.SQL_EMP_001, arg);

      if (resultDBs.isNotEmpty) {
        for (var result in resultDBs) {
          results.add(Employee.fromMap(result));
        }
      }
    }
    return results;
  }

  Future close() async => database.close();
}
