import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_customers_group.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class CustomersGroupProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableCustomersGroup() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableCustomersGroup ( 
          $columnCustomersGroupId integer primary key, 
          $columnCustomersGroupCode text,
          $columnCustomersGroupName text,
          $columnBranchId real,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<CustomersGroup> insert(CustomersGroup record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.customersGroupId =
          await txn.insert(tableCustomersGroup, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<CustomersGroup> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    for (var record in recordsMap) {
      batch.insert(tableCustomersGroup, record);
    }
  }

  Future close() async => database.close();
}
