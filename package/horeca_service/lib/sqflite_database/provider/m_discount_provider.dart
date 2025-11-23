import 'package:horeca_service/sqflite_database/dto/discount_content_dto.dart';
import 'package:horeca_service/sqflite_database/dto/discount_dto.dart';
import 'package:horeca_service/sqflite_database/dto/discount_info_dto.dart';
import 'package:horeca_service/sqflite_database/dto/discount_result_order_dto.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_discount.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class DiscountProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableDiscount() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableDiscount ( 
          $columnDiscountId integer primary key, 
          $columnDiscountCode text,
          $columnDiscountName text,
          $columnStartDate text,
          $columnEndDate text,
          $columnStatus text,
          $columnConditionType text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<Discount> insert(Discount record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.discountId = await txn.insert(tableDiscount, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<Discount> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableDiscount, record);
    }

    //await batch.commit(noResult: true);
  }

  Future<List<DiscountDto>> selectDiscountByCustomerId(int customerId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<DiscountDto> results = [];
    List<dynamic>? arg = [];
    arg.add(customerId);
    arg.add(customerId);
    arg.add(customerId);
    arg.add(customerId);

    List<Map> resultDBs = await database.rawQuery(SQLQuery.SQL_DIS_001, arg);

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(DiscountDto.fromMap(result));
      }
    }
    return results;
  }

  Future<List<DiscountContentDto>> selectDiscountContent(int discountId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<DiscountContentDto> results = [];
    List<dynamic>? arg = [];
    arg.add(discountId);

    List<Map> resultDBs = await database.rawQuery(SQLQuery.SQL_DIS_002, arg);
    print('discountId $discountId');
    print(SQLQuery.SQL_DIS_002);
    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(DiscountContentDto.fromMap(result));
      }
    }
    return results;
  }

  Future<List<DiscountInfoDto>> selectDiscountSchemeByCustomerId(
      List<int> lstDiscountId, String conditionType, Transaction? txn) async {
    List<DiscountInfoDto> results = [];
    List<Map> resultDBs = [];
    if (lstDiscountId.isEmpty) {
      return results;
    }
    List<dynamic> arg = [conditionType, ...lstDiscountId];
    String discountIds = lstDiscountId.map((_) => '?').join(',');

    if (txn != null) {
      resultDBs = await txn.rawQuery(
          SQLQuery.SQL_DIS_004.replaceAll('#lstDiscountId#', discountIds), arg);
      print(
          'SQQQQ ${SQLQuery.SQL_DIS_004.replaceAll('#lstDiscountId#', discountIds)}');
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      resultDBs = await database.rawQuery(
          SQLQuery.SQL_DIS_004.replaceAll('#lstDiscountId#', discountIds), arg);
      print(
          'SQQQQ ${SQLQuery.SQL_DIS_004.replaceAll('#lstDiscountId#', discountIds)}');
    }

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(DiscountInfoDto.fromMap(result));
      }
    }

    return results;
  }

  Future<List<DiscountResultOrderDto>> selectDiscountByOrder(
      int orderId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<DiscountResultOrderDto> results = [];
    List<dynamic>? arg = [];
    arg.add(orderId);

    List<Map> resultDBs = await database.rawQuery(SQLQuery.SQL_DIS_005, arg);

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(DiscountResultOrderDto.fromMap(result));
      }
    }
    return results;
  }

  Future close() async => database.close();
}
