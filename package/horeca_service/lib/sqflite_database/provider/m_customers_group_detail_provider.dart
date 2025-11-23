import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_customers_group_detail.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class CustomersGroupDetailProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableCustomersGroupDetail() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableCustomersGroupDetail ( 
          $columnCustomersGroupDetailId integer primary key, 
          $columnCustomerId integer,
          $columnCustomersGroupId integer,
          $columnStatus text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<CustomersGroupDetail> insert(CustomersGroupDetail record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.customersGroupDetailId =
          await txn.insert(tableCustomersGroupDetail, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(
      List<CustomersGroupDetail> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    for (var record in recordsMap) {
      batch.insert(tableCustomersGroupDetail, record);
    }
  }

  Future close() async => database.close();
}
