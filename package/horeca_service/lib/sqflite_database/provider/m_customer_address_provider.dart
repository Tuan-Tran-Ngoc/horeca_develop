import 'package:horeca_service/sqflite_database/dto/address_visit_dto.dart';
import 'package:horeca_service/sqflite_database/model/m_customer_address.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class CustomerAddressProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableCustomerAddress() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableCustomerAddress ( 
          $columnCustomerAddressId integer primary key,
          $columnCustomerId integer,
          $columnProvinceId integer,
          $columnDistrictId integer,
          $columnWardId integer,
          $columnStreetName text,
          $columnAddressDetail text,
          $columnTelNo text,
          $columnFaxNo text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer,
          $columnDefaultAddress text,
          $columnAddressCode text,
          $columnOldAddressCode text,
          $columnAddressStartDate text,
          $columnAddressEndDate text
          )
        ''');
    // db.close();
  }

  Future<CustomerAddress> insert(CustomerAddress customer) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);

    await database.transaction((txn) async {
      customer.customerId =
          await txn.insert(tableCustomerAddress, customer.toMap());
      print('insert data $tableCustomerAddress: ${customer.customerAddressId}');
    });
    return customer;
  }

  Future insertMultipleRow(
      List<CustomerAddress> listCustomerAddress, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var listCustomerAddresss =
        listCustomerAddress.map((data) => data.toMap()).toList();

    //var batch = database.batch();
    listCustomerAddresss.forEach((data) async {
      batch.insert(tableCustomerAddress, data);
    });
    //await batch.commit(noResult: true);
  }

  Future<CustomerAddress?> getCutomerVisit(int id) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps = await database.rawQuery(
        'SELECT * FROM m_customer_address where customer_id = ?', [id]);

    if (maps.isNotEmpty) {
      return CustomerAddress.fromMap(maps.first);
    }
    return null;
  }

  Future<List<CustomerAddress>> getAllCustomerAddress() async {
    List<CustomerAddress> listSurvey = [];
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps =
        await database.rawQuery('SELECT * FROM m_customer_address');

    if (maps.isNotEmpty) {
      for (final item in maps) {
        listSurvey.add(CustomerAddress.fromMap(item));
      }

      return listSurvey;
    }
    return [];
  }

  Future<List<AddressVisitDto>> getAddressByCustomerId(int customerId) async {
    List<AddressVisitDto> results = [];
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<int?>? arg = [];
    arg.add(customerId);

    print('SQL_CUS_ADR_001 Query: ${SQLQuery.SQL_CUS_ADR_001}');
    print('SQL_CUS_ADR_001 Args: $arg');
    
    List<Map> maps = await database.rawQuery(SQLQuery.SQL_CUS_ADR_001, arg);

    print('SQL_CUS_ADR_001 Result count: ${maps.length}');
    if (maps.isNotEmpty) {
      print('SQL_CUS_ADR_001 First result: ${maps[0]}');
      for (final item in maps) {
        results.add(AddressVisitDto.fromMap(item));
      }

      return results;
    }
    print('SQL_CUS_ADR_001 No addresses found for customer $customerId');
    return [];
  }

  Future<List<AddressVisitDto>> getAddressCustomerVistting(
      int customerVisitId) async {
    List<AddressVisitDto> results = [];
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<int?>? arg = [];
    arg.add(customerVisitId);

    List<Map> maps = await database.rawQuery(SQLQuery.SQL_CUS_ADR_002, arg);

    if (maps.isNotEmpty) {
      for (final item in maps) {
        results.add(AddressVisitDto.fromMap(item));
      }
    }
    return results;
  }

  Future<int> delete(int id) async {
    return await database.delete(tableCustomerAddress,
        where: '$columnCustomerAddressId = ?', whereArgs: [id]);
  }

  Future<int> update(CustomerAddress customer) async {
    return await database.update(tableCustomerAddress, customer.toMap(),
        where: '$columnCustomerAddressId = ?',
        whereArgs: [customer.customerAddressId]);
  }

  Future close() async => database.close();
}
