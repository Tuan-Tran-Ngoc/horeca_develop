import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_customer_property.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class CustomerPropertyProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableCustomerProperty() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableCustomerProperty ( 
          $columnCustomerPropertyId integer primary key,
          $columnPropertyTypeCode text,
          $columnCustomerPropertyCode text,
          $columnCustomerPropertyName text,
          $columnParentId integer,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<CustomerProperty> insert(CustomerProperty customerProperty) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);

    await database.transaction((txn) async {
      customerProperty.customerPropertyId =
          await txn.insert(tableCustomerProperty, customerProperty.toMap());
      print(
          'insert data $tableCustomerProperty: ${customerProperty.customerPropertyId}');
    });
    return customerProperty;
  }

  Future insertMultipleRow(
      List<CustomerProperty> listCustomerProperty, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var list = listCustomerProperty.map((data) => data.toMap()).toList();

    //var batch = database.batch();
    list.forEach((data) async {
      batch.insert(tableCustomerProperty, data);
    });
    // await batch.commit(noResult: true);
  }

  Future close() async => database.close();
}
