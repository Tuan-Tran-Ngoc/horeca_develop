import 'dart:async';

import 'package:horeca_service/model/customer_visit.dart';
import 'package:horeca_service/sqflite_database/dto/shift_visit_dto.dart';
import 'package:horeca_service/sqflite_database/model/s_customer_visit.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class CustomerVisitProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableCustomerVisit() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableCustomerVisit ( 
          $columnCustomerVisitId integer primary key AUTOINCREMENT,
          $columnCustomerVisitIdSync integer,
          $columnShiftReportId integer,
          $columnCustomerId integer,
          $columnCustomerAddressId integer,
          $columnBaPositionId integer,
          $columnEmployeeId integer,
          $columnEmployeeName text,
          $columnSupPositionId integer,
          $columnCityLeaderPositionId integer,
          $columnVisitDate text,
          $columnStartTime text,
          $columnEndTime text,
          $columnShiftCode text,
          $columnTotalCashBack double,
          $columnTotalCollection double,
          $columnNewMembership integer,
          $columnSignature text,
          $columnVisitStatus text,
          $columnLongitude integer,
          $columnLatitude integer,
          $columnReason integer,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer,
          $columnVisitTimes integer,
          $columnParentCustomerVisitId integer,
          $columnIsSample integer,
          $columnIsStockCheckCompleted integer,
          $columnIsSurveyCompleted integer,
          $columnReasonId integer,
          $columnTotalApproached integer,
          $columnTotalSmoker integer,
          $columnTotalGift integer)
        ''');
    // db.close();
  }

  Future<CustomerVisit> insert(
      CustomerVisit customerVisit, Transaction? txn) async {
    if (txn != null) {
      customerVisit.customerVisitId =
          await txn.insert(tableCustomerVisit, customerVisit.toMap());
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      customerVisit.customerVisitId =
          await database.insert(tableCustomerVisit, customerVisit.toMap());
    }

    print('insert data $tableCustomerVisit: ${customerVisit.customerVisitId}');
    return customerVisit;
  }

  Future insertMultipleRow(
      List<CustomerVisit> listCustomerVisit, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var listCustomerVisits =
        listCustomerVisit.map((data) => data.toMapSync()).toList();

    //var batch = database.batch();
    listCustomerVisits.forEach((data) async {
      batch.insert(tableCustomerVisit, data);
    });
    //await batch.commit(noResult: true);
  }

  Future<CustomerVisit?> getCutomerVisit(int id) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps = await database.query(tableCustomerVisit,
        columns: [columnCustomerVisitId],
        where: '$columnCustomerVisitId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return CustomerVisit.fromMap(maps.first);
    }
    return null;
  }

  Future<List<CustomerVisit>> getAllCustomerVisit() async {
    List<CustomerVisit> listSurvey = [];
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps = await database.rawQuery('SELECT * FROM s_customer_visit');

    if (maps.isNotEmpty) {
      for (final item in maps) {
        listSurvey.add(CustomerVisit.fromMap(item));
      }
      return listSurvey;
    }
    return [];
  }

  String query =
      '''SELECT sc.customer_visit_id, sc.shift_report_id,sc.customer_id,sc.visit_date,sc.start_time,sc.end_time,
                sc.shift_code,sc.visit_times,mc.customer_name,mc.customer_code, mca.address_detail, mca.street_name  
         FROM s_customer_visit sc, m_customer mc, m_customer_address mca  
         WHERE sc.customer_id = mc.customer_id and  sc.customer_id = mca.customer_address_id ''';

  Future<List<ListCustomerVisit>> getAllFullNameCustomerVisit() async {
    List<ListCustomerVisit> listSurvey = [];
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps = await database.rawQuery(query);
    // print(maps);
    if (maps.isNotEmpty) {
      for (final item in maps) {
        listSurvey.add(ListCustomerVisit.fromMap(item));
      }
      return listSurvey;
    }
    return [];
  }

  Future<List<ShiftVisitDto>> getPlanCustomerVisit(
      int? shiftReportId, Transaction? txn) async {
    List<ShiftVisitDto> results = [];
    List<int?>? arg = [];
    arg.add(shiftReportId);
    arg.add(shiftReportId);
    List<Map> resultDBs = [];
    if (txn != null) {
      resultDBs = await txn.rawQuery(SQLQuery.SQL_CUS_VST_001, arg);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      resultDBs = await database.rawQuery(SQLQuery.SQL_CUS_VST_001, arg);
    }

    print(
        'SQLQuery.SQL_CUS_VST_001 ${SQLQuery.SQL_CUS_VST_001}====$shiftReportId');
    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(ShiftVisitDto.fromMap(result));
      }
    }

    return results;
  }

  Future<List<ShiftVisitDto>> getPlanCustomerVisitSearch(
      int shiftReportId,
      String customerName,
      List<int> lstIndDay,
      List<String> lstShiftCode) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<ShiftVisitDto> results = [];

    String days = lstIndDay.map((_) => '?').join(',');
    String shifts = lstShiftCode.map((_) => '?').join(',');
    List<dynamic> arg = [
      shiftReportId,
      shiftReportId,
      '%${customerName.toUpperCase()}%',
      '%${customerName.toUpperCase()}%',
      ...lstIndDay,
      ...lstShiftCode
    ];

    List<Map> resultDBs = await database.rawQuery(
        SQLQuery.SQL_CUS_VST_004
            .replaceAll('#lstDays#', days)
            .replaceAll('#lstShift#', shifts),
        arg);

    print('SQLQuery.SQL_CUS_VST_001 ${SQLQuery.SQL_CUS_VST_004}');
    print('days $lstIndDay');
    print('shifts $lstShiftCode');

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(ShiftVisitDto.fromMap(result));
      }
    }
    return results;
  }

  Future<List<CustomerVisit>> getCustomerVisit(int? customerId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<CustomerVisit> results = [];
    List<int?>? arg = [];
    arg.add(customerId);

    List<Map> resultDBs =
        await database.rawQuery(SQLQuery.SQL_CUS_VST_002, arg);

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(CustomerVisit.fromMap(result));
      }
    }
    return results;
  }

  Future<int> delete(int id) async {
    return await database.delete(tableCustomerVisit,
        where: '$columnCustomerVisitId = ?', whereArgs: [id]);
  }

  Future<int> update(CustomerVisit customerVisit, Transaction? txn) async {
    if (txn != null) {
      return await txn.update(
          tableCustomerVisit,
          {
            columnEndTime: customerVisit.endTime,
            columnVisitStatus: customerVisit.visitStatus,
            columnUpdatedBy: customerVisit.updatedBy,
            columnUpdatedDate: customerVisit.updatedDate
          },
          where: '$columnCustomerVisitId = ?',
          whereArgs: [customerVisit.customerVisitId]);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      return await database.update(
          tableCustomerVisit,
          {
            columnEndTime: customerVisit.endTime,
            columnVisitStatus: customerVisit.visitStatus,
            columnUpdatedBy: customerVisit.updatedBy,
            columnUpdatedDate: customerVisit.updatedDate
          },
          where: '$columnCustomerVisitId = ?',
          whereArgs: [customerVisit.customerVisitId]);
    }
  }

  Future<int> updateSyncId(
      CustomerVisit customerVisit, Transaction? txn) async {
    if (txn != null) {
      return await txn.update(
          tableCustomerVisit,
          {
            columnCustomerVisitIdSync: customerVisit.customerVisitIdSync,
            columnUpdatedBy: customerVisit.updatedBy,
            columnUpdatedDate: customerVisit.updatedDate
          },
          where: '$columnCustomerVisitId = ?',
          whereArgs: [customerVisit.customerVisitId]);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      return await database.update(
          tableCustomerVisit,
          {
            columnCustomerVisitIdSync: customerVisit.customerVisitIdSync,
            columnUpdatedBy: customerVisit.updatedBy,
            columnUpdatedDate: customerVisit.updatedDate
          },
          where: '$columnCustomerVisitId = ?',
          whereArgs: [customerVisit.customerVisitId]);
    }
  }

  Future<int> revisit(CustomerVisit customerVisit, Transaction? txn) async {
    int result = 0;
    if (txn != null) {
      result = await txn.update(
          tableCustomerVisit,
          {
            columnEndTime: null,
            columnVisitTimes: customerVisit.visitTimes,
            columnUpdatedBy: customerVisit.updatedBy,
            columnUpdatedDate: customerVisit.updatedDate
          },
          where: '$columnCustomerVisitId = ?',
          whereArgs: [customerVisit.customerVisitId]);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      result = await database.update(
          tableCustomerVisit,
          {
            columnEndTime: null,
            columnVisitTimes: customerVisit.visitTimes,
            columnUpdatedBy: customerVisit.updatedBy,
            columnUpdatedDate: customerVisit.updatedDate
          },
          where: '$columnCustomerVisitId = ?',
          whereArgs: [customerVisit.customerVisitId]);
    }

    return result;
  }

  Future<List<CustomerVisit>> getCustomerVisiting(
      int shiftReportId, int customerId, int customerVisitId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<CustomerVisit> lstResults = [];
    List<int?>? arg = [];
    arg.add(shiftReportId);
    arg.add(customerId);
    arg.add(customerVisitId);

    List<Map> resultDBs =
        await database.rawQuery(SQLQuery.SQL_CUS_VIS_001, arg);

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        lstResults.add(CustomerVisit.fromMap(result));
      }
    }
    return lstResults;
  }

  Future<CustomerVisit?> select(int customerVisitId, Transaction? txn) async {
    List<Map> resultDBs = [];
    List<int?>? arg = [];
    arg.add(customerVisitId);

    //List<Map> maps = await database.rawQuery(SQLQuery.countStartVisit, arg);
    if (txn != null) {
      resultDBs = await txn.rawQuery(SQLQuery.SQL_CUS_VST_003, arg);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      resultDBs = await database.rawQuery(SQLQuery.SQL_CUS_VST_003, arg);
    }

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        return CustomerVisit.fromMap(result);
      }
    }
    return null;
  }

  Future<int> checkout(CustomerVisit customerVisit) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    return await database.update(tableShiftReport, customerVisit.toMap(),
        where: '$columnShiftReportId = ?',
        whereArgs: [customerVisit.customerVisitId]);
  }

  Future<void> clearTable() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.delete(tableCustomerVisit);
  }

  Future<int> selectMaxVisitTimesByParent(int visitId, Transaction? txn) async {
    String query =
        "SELECT COALESCE(MAX($columnVisitTimes),1) AS visit_times FROM s_customer_visit WHERE $columnParentCustomerVisitId = $visitId OR $columnCustomerVisitId = $visitId;";
    List<Map> resultDBs = [];
    if (txn != null) {
      resultDBs = await txn.rawQuery(query);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      resultDBs = await database.rawQuery(query);
    }
    if (resultDBs.isNotEmpty) return resultDBs.first['visit_times'];
    return 0;
  }

  Future<int> updateSurveyStatus(
      CustomerVisit customerVisit, Transaction? txn) async {
    int result = 0;
    if (txn != null) {
      result = await txn.update(
          tableCustomerVisit,
          {
            columnIsSurveyCompleted:
                customerVisit.isSurveyCompleted == true ? 1 : 0,
            columnUpdatedBy: customerVisit.updatedBy,
            columnUpdatedDate: customerVisit.updatedDate
          },
          where: '$columnCustomerVisitId = ?',
          whereArgs: [customerVisit.customerVisitId]);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      result = await database.update(
          tableCustomerVisit,
          {
            columnIsSurveyCompleted:
                customerVisit.isSurveyCompleted == true ? 1 : 0,
            columnUpdatedBy: customerVisit.updatedBy,
            columnUpdatedDate: customerVisit.updatedDate
          },
          where: '$columnCustomerVisitId = ?',
          whereArgs: [customerVisit.customerVisitId]);
    }

    return result;
  }

  Future<int> updateStockCheckStatus(
      CustomerVisit customerVisit, Transaction? txn) async {
    int result = 0;
    if (txn != null) {
      result = await txn.update(
          tableCustomerVisit,
          {
            columnIsStockCheckCompleted:
                customerVisit.isStockCheckCompleted == true ? 1 : 0,
            columnUpdatedBy: customerVisit.updatedBy,
            columnUpdatedDate: customerVisit.updatedDate
          },
          where: '$columnCustomerVisitId = ?',
          whereArgs: [customerVisit.customerVisitId]);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      result = await database.update(
          tableCustomerVisit,
          {
            columnIsStockCheckCompleted:
                customerVisit.isStockCheckCompleted == true ? 1 : 0,
            columnUpdatedBy: customerVisit.updatedBy,
            columnUpdatedDate: customerVisit.updatedDate
          },
          where: '$columnCustomerVisitId = ?',
          whereArgs: [customerVisit.customerVisitId]);
    }

    return result;
  }

  Future<List<CustomerVisit>> selectByAddress(
      int? shiftReportId, int? customerId, int? customerAddressId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<CustomerVisit> results = [];
    List<int?>? arg = [];
    arg.add(shiftReportId);
    arg.add(customerId);
    arg.add(customerAddressId);

    List<Map> resultDBs =
        await database.rawQuery(SQLQuery.SQL_CUS_VST_006, arg);

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(CustomerVisit.fromMap(result));
      }
    }
    return results;
  }

  Future<List<CustomerVisit>?> getCustomerVisitByShiftReport(
      int shiftReportId, Transaction txn) async {
    List<CustomerVisit> lstResult = [];
    String query = '''
      SELECT * FROM s_customer_visit 
      WHERE shift_report_id = $shiftReportId
      AND (end_time IS NULL OR visit_status = '01');
    ''';
    List<Map> result = [];
    if (txn != null) {
      result = await txn.rawQuery(query);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      result = await database.rawQuery(query);
    }
    if (result.isNotEmpty)
      for (var item in result) lstResult.add(CustomerVisit.fromMap(item));

    return lstResult;
  }

  Future<int> countVisiting(
      int? shiftReportId, String visitingCode, Transaction? txn) async {
    List<dynamic>? arg = [];
    arg.add(shiftReportId);
    arg.add(visitingCode);
    int? count = 0;
    if (txn != null) {
      count = Sqflite.firstIntValue(
          await txn.rawQuery(SQLQuery.SQL_CUS_VST_007, arg));
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      count = Sqflite.firstIntValue(
          await database.rawQuery(SQLQuery.SQL_CUS_VST_007, arg));
    }

    return count ?? 0;
  }

  Future<int> selectVisitLastest(int customerId, int customerAddressId,
      int newCustomerVisitId, Transaction? txn) async {
    List<dynamic>? arg = [];
    arg.add(customerAddressId);
    arg.add(customerId);
    arg.add(newCustomerVisitId);
    int? customerVisitId;
    if (txn != null) {
      customerVisitId = Sqflite.firstIntValue(
          await txn.rawQuery(SQLQuery.SQL_CUS_VST_008, arg));
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      customerVisitId = Sqflite.firstIntValue(
          await database.rawQuery(SQLQuery.SQL_CUS_VST_008, arg));
    }

    return customerVisitId ?? 0;
  }

  Future close() async => database.close();
}
