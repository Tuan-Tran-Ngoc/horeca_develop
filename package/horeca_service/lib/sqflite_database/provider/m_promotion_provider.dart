import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_content_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_dto.dart';
import 'package:horeca_service/sqflite_database/dto/promotion_info_dto.dart';
import 'package:horeca_service/sqflite_database/dto/scheme_dto.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_promotion.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class PromotionProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTablePromotion() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tablePromotion ( 
          $columnPromotionId integer primary key, 
          $columnPromotionCode text,
          $columnPromotionName text,
          $columnStartDate text,
          $columnEndDate text,
          $columnStatus text,
          $columnConditionType text,
          $columnPromotionType text,
          $columnRemark text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<Promotion> insert(Promotion record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.promotionId = await txn.insert(tablePromotion, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<Promotion> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tablePromotion, record);
    }

    //await batch.commit(noResult: true);
  }

  Future<List<PromotionDto>> selectPromotionByCustomerId(
      int customerId, Transaction? txn) async {
    List<PromotionDto> results = [];
    List<Map> resultDBs = [];
    List<dynamic>? arg = [];
    arg.add(customerId);
    arg.add(customerId);
    arg.add(customerId);
    arg.add(customerId);

    if (txn != null) {
      resultDBs = await txn.rawQuery(SQLQuery.SQL_PRO_001, arg);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      resultDBs = await database.rawQuery(SQLQuery.SQL_PRO_001, arg);
    }

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(PromotionDto.fromMap(result));
      }
    }
    return results;
  }

  Future<List<PromotionContentDto>> selectPromotionContent(
      int promotionId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<PromotionContentDto> results = [];
    List<dynamic>? arg = [];
    arg.add(promotionId);

    List<Map> resultDBs = await database.rawQuery(SQLQuery.SQL_PRO_002, arg);

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(PromotionContentDto.fromMap(result));
      }
    }
    return results;
  }

  Future<List<PromotionInfoDto>> selectPromotionSchemeByCustomerId(
      List<int> lstPromotionId, Transaction? txn) async {
    List<PromotionInfoDto> results = [];
    List<Map> resultDBs = [];
    if (lstPromotionId.isEmpty) {
      return results;
    }
    List<dynamic> arg = [...lstPromotionId];
    String promotionIds = lstPromotionId.map((_) => '?').join(',');

    if (txn != null) {
      resultDBs = await txn.rawQuery(
          SQLQuery.SQL_PRO_003.replaceAll('#lstPromotionId#', promotionIds),
          arg);
      print(
          'SQQQQ ${SQLQuery.SQL_PRO_003.replaceAll('#lstPromotionId#', promotionIds)}');
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      resultDBs = await database.rawQuery(
          SQLQuery.SQL_PRO_003.replaceAll('#lstPromotionId#', promotionIds),
          arg);
      print(
          'SQQQQ ${SQLQuery.SQL_PRO_003.replaceAll('#lstPromotionId#', promotionIds)}');
    }

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(PromotionInfoDto.fromMap(result));
      }
    }

    return results;
  }

  Future<List<SchemeDto>> selectPromotioneByOrder(int orderId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<SchemeDto> results = [];
    List<dynamic>? arg = [];
    arg.add(orderId);

    List<Map> resultDBs = await database.rawQuery(SQLQuery.SQL_PRO_004, arg);

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(SchemeDto.fromMap(result));
      }
    }
    return results;
  }

  Future close() async => database.close();
}
