import 'package:horeca_service/sqflite_database/model/m_customer.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class CustomerProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableCustomer() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableCustomer ( 
          $columnCustomerId integer primary key,
          $columnCustomerCode text,
          $columnCustomerName text,
          $columnRepresentativeName text,
          $columnAreaId integer,
          $columnVersion integer,
          $columnDistributorId integer,
          $columnIsUsed text,
          $columnIsTax integer,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnStatus text)
        ''');
    // db.close();
  }

  Future<Customer> insert(Customer customer) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);

    await database.transaction((txn) async {
      customer.customerId = await txn.insert(tableCustomer, customer.toMap());
      print('insert data $tableCustomer: ${customer.customerId}');
    });
    return customer;
  }

  Future insertMultipleRow(List<Customer> listCustomer, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var listCustomers = listCustomer.map((data) => data.toMap()).toList();

    //var batch = database.batch();
    listCustomers.forEach((data) async {
      batch.insert(tableCustomer, data);
    });
    // await batch.commit(noResult: true);
  }

  Future<Customer?> getCutomerVisit(int id) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps = await database
        .rawQuery('SELECT * FROM m_customer where customer_id = ?', [id]);

    if (maps.isNotEmpty) {
      return Customer.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Customer>> getAllCustomer() async {
    List<Customer> listSurvey = [];
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps = await database.rawQuery('SELECT * FROM m_customer');

    if (maps.isNotEmpty) {
      for (final item in maps) {
        // print(item);
        listSurvey.add(Customer.fromMap(item));
      }
      return listSurvey;
    }
    return [];
  }

  Future<List<Customer>> select(int? customerId, Transaction? txn) async {
    List<Customer> results = [];
    List<Map> resultDBs = [];
    List<int?>? arg = [];
    arg.add(customerId);

    if (txn != null) {
      resultDBs = await txn.rawQuery(SQLQuery.SQL_CUS_001, arg);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      resultDBs = await database.rawQuery(SQLQuery.SQL_CUS_001, arg);
    }

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(Customer.fromMap(result));
      }
    }
    return results;
  }

  Future<int> delete(int id) async {
    return await database
        .delete(tableCustomer, where: '$columnCustomerId = ?', whereArgs: [id]);
  }

  Future<int> update(Customer customer) async {
    return await database.update(tableCustomer, customer.toMap(),
        where: '$columnCustomerId = ?', whereArgs: [customer.customerId]);
  }

  Future close() async => database.close();
}
