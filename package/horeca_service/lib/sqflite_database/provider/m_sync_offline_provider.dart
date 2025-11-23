import 'dart:async';

import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_sync_offline.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';
import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class SyncOfflineProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableSyncOffline() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableSyncOffline ( 
          $columnSyncOfflineId integer primary key AUTOINCREMENT, 
          $columnRequestId integer,
          $columnPositionId integer,
          $columnType text,
          $columnRelatedId integer,
          $columnSequence integer,
          $columnStatus text,
          $columnRemark text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text
          )
        ''');
    // db.close();
  }

  // Future<SyncOffline> insert(SyncOffline record, Transaction txn) async {
  //   // database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
  //   // await database.transaction((txn) async {
  //   // });
  //   await txn.insert(tableSyncOffline, record.toMap());

  //   return record;
  // }

  Future<int> insert(SyncOffline record, Transaction? txn) async {
    if (txn != null) {
      return await txn.insert(tableSyncOffline, record.toMap());
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      return await database.insert(tableSyncOffline, record.toMap());
    }
  }

  Future insertMultipleRow(List<SyncOffline> records) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableSyncOffline, record);
    }

    await batch.commit(noResult: true);
  }

  Future<List<SyncOffline>> selectForDisplay() async {
    List<SyncOffline> result = [];
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> mapResult = await database
        .rawQuery("SELECT * FROM $tableSyncOffline WHERE status = '00' ");
    if (mapResult.isNotEmpty) {
      for (var item in mapResult) {
        result.add(SyncOffline.fromMap(item));
      }
    }

    return result;
  }

  Future<bool> existedCustomerStock(customerVisitId, txn, type, status) async {
    List<Map> mapResult = [];
    if (txn != null) {
      mapResult = await txn.rawQuery(
          'SELECT * FROM $tableSyncOffline WHERE related_id = $customerVisitId AND type = \'$type\' AND status =\'$status\';');
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      mapResult = await database.rawQuery(
          'SELECT * FROM $tableSyncOffline WHERE related_id = $customerVisitId;');
    }
    return mapResult.isNotEmpty;
  }

  Future<List<SyncOffline>> selectForServerSynchronize() async {
    List<SyncOffline> result = [];
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> mapResult = await database.rawQuery(
        "SELECT * FROM $tableSyncOffline WHERE status = '00' ORDER BY created_date ASC;");
    if (mapResult.isNotEmpty) {
      for (var item in mapResult) {
        result.add(SyncOffline.fromMap(item));
      }
    }

    return result;
  }

  Future<int> update(SyncOffline syncOffline) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    return await database.update(tableSyncOffline, syncOffline.toMap(),
        where: 'sync_offline_id = ?', whereArgs: [syncOffline.syncOfflineId]);
  }

  Future<int> updateStatus(SyncOffline syncOffline) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    return await database.update(
        tableSyncOffline,
        {
          columnStatus: syncOffline.status,
          columnUpdatedDate: syncOffline.updatedDate,
          columnUpdatedBy: syncOffline.updatedBy,
        },
        where: 'sync_offline_id = ?',
        whereArgs: [syncOffline.syncOfflineId]);
  }

  Future<String> getNameSyncCancelVisit() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> results = await database.rawQuery("""
    SELECT DISTINCT c.customer_code, c.customer_name
FROM s_customer_visit cs
INNER JOIN m_customer c ON c.customer_id = cs.customer_id
INNER JOIN m_sync_offline so ON so.related_id = cs.customer_visit_id 
WHERE so.status = '01' AND cs.reason_id IS NOT NULL
""");
    if (results.isNotEmpty) {
      Map mapResult = results.first;
      String result = mapResult['customer_code'].toString() +
          mapResult['customer_name'].toString();
      return result;
    }
    return "";
  }

  Future<String> getContentVisitSync(customerVisitId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> results = await database.rawQuery("""
    SELECT c.customer_code
FROM m_sync_offline so 
INNER JOIN s_customer_visit cs ON so.related_id = cs.customer_visit_id 
INNER JOIN m_customer c ON c.customer_id = cs.customer_id
WHERE cs.customer_visit_id = $customerVisitId
""");
    if (results.isNotEmpty) {
      return results.first['customer_code'].toString();
    }
    return "";
  }

  Future<String> getContentShiftSync(shiftReportId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> results = await database.rawQuery("""
    SELECT DISTINCT sh.shift_name
FROM m_sync_offline so
INNER JOIN s_shift_report sr ON sr.shift_report_id = so.related_id
INNER JOIN m_shift sh ON sh.shift_code = sr.shift_code
WHERE sr.shift_report_id = $shiftReportId ;
""");
    if (results.isNotEmpty) {
      return results.first['shift_name'].toString();
    }
    return "";
  }

  Future<String> getContentOrderSync(orderId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> results = await database.rawQuery("""
    SELECT DISTINCT o.order_cd
FROM m_sync_offline so
INNER JOIN s_order o ON o.order_id = so.related_id
WHERE o.order_id = $orderId ;
""");
    if (results.isNotEmpty) {
      return results.first['order_cd'].toString();
    }
    return "";
  }

  Future<String> getContentSurveySync(surveyResultId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> results = await database.rawQuery("""
    select tb03.customer_code from s_survey_result tb01
inner join s_customer_visit tb02 on tb02.customer_visit_id = tb01.customer_visit_id
inner join m_customer tb03 on tb03.customer_id = tb02.customer_id
where tb01.survey_result_id = $surveyResultId ;
""");
    if (results.isNotEmpty) {
      return results.first['customer_code'].toString();
    }
    return "";
  }

  Future<List<SyncOffline>> selectByBaPosition(
      int baPositionId, Transaction? txn) async {
    List<SyncOffline> result = [];
    List<Map> mapResult = [];
    List<dynamic>? arg = [];
    arg.add(baPositionId);
    arg.add('00');

    if (txn != null) {
      mapResult = await txn.rawQuery(SQLQuery.SQL_SYNC_OFF_001, arg);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      mapResult = await database.rawQuery(SQLQuery.SQL_SYNC_OFF_001, arg);
    }
    if (mapResult.isNotEmpty) {
      for (var item in mapResult) {
        result.add(SyncOffline.fromMap(item));
      }
    }

    return result;
  }

  Future<int?> countSyncVisit(int? customerVisitId, Transaction? txn) async {
    int? result = 0;

    String query = """
        select count(*) 
        from m_sync_offline so 
        inner join s_customer_visit cv on cv.customer_visit_id = so.related_id
        where so.status = '00'
        and so.type in ('SyncType.checkinVisit','SyncType.checkoutVisit')
        and cv.customer_visit_id = $customerVisitId
    """;
    if (txn == null) {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      result = Sqflite.firstIntValue(await database.rawQuery(query));
    } else {
      result = Sqflite.firstIntValue(await txn.rawQuery(query));
    }

    return result;
  }

  Future close() async => database.close();
}
