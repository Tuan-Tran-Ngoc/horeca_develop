import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_customer_property_mapping.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class CustomerPropertyMappingProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableCustomerPropertyMapping() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableCustomerPropertyMapping ( 
          $columnPropertyMappingId integer primary key, 
          $columnCustomerPropertyId integer,
          $columnCustomerId integer,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<CustomerPropertyMapping> insert(CustomerPropertyMapping record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.propertyMappingId =
          await txn.insert(tableCustomerPropertyMapping, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(
      List<CustomerPropertyMapping> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableCustomerPropertyMapping, record);
    }

    //await batch.commit(noResult: true);
  }

  Future close() async => database.close();
}
