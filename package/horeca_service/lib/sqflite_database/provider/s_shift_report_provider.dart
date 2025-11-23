import 'package:flutter/foundation.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/model/shift_report.dart';
import 'package:horeca_service/sqflite_database/dto/shift_header_dto.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/s_shift_report.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class ShiftReportProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableShiftReport() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableShiftReport ( 
          $columnShiftReportId integer primary key AUTOINCREMENT,
          $columnShiftReportIdSync integer,
          $columnBaPositionId integer,
          $columnEmployeeId integer,
          $columnEmployeeName text,
          $columnSupPositionId integer,
          $columnCityLeaderPositionId integer,
          $columnWorkingDate text,
          $columnShiftCode text,
          $columnStartTime text,
          $columnEndTime text,
          $columnTotalCashBack real,
          $columnTotalCollection real,
          $columnNewMembership integer,
          $columnNewSmoker integer,
          $columnTotalSmoker integer,
          $columnTotalApproached integer,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text ,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<ShiftReport?> insert(ShiftReport shiftReport, Transaction txn) async {
    //database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    shiftReport.shiftReportId =
        await txn.insert(tableShiftReport, shiftReport.toMap());
    print('insert data: ${shiftReport.shiftReportId}');
    return shiftReport;
  }

  Future insertMultipleRow(
      List<ShiftReport> listShiftReport, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var listShiftReports =
        listShiftReport.map((shiftReport) => shiftReport.toMapSync()).toList();

    //var batch = database.batch();
    listShiftReports.forEach((shiftReport) async {
      batch.insert(tableShiftReport, shiftReport);
    });
    //await batch.commit(noResult: true);
  }

  Future<List<ShiftReport>> getCurrentReport(int? baPositionId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<ShiftReport> results = [];
    List<int?>? arg = [];
    arg.add(baPositionId);

    List<Map> resultDBs = await database.rawQuery(SQLQuery.SQL_SFT_RP_001, arg);
    print('SQL ${SQLQuery.SQL_SFT_RP_001}');
    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(ShiftReport.fromMap(result));
      }
    }
    return results;
  }

  Future<List<ShiftReport>> selectReStartShift(
      String shiftCode, Transaction? txn) async {
    List<ShiftReport> results = [];
    List<Map> resultDBs = [];
    List<String?>? arg = [];
    arg.add(shiftCode);

    if (txn != null) {
      resultDBs = await txn.rawQuery(SQLQuery.SQL_SFT_RP_003, arg);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      resultDBs = await database.rawQuery(SQLQuery.SQL_SFT_RP_003, arg);
    }

    print('SQL ${SQLQuery.SQL_SFT_RP_001}');
    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(ShiftReport.fromMap(result));
      }
    }
    return results;
  }

  Future<int> updateReStartShift(ShiftReport record, Transaction? txn) async {
    int result = 0;

    if (txn != null) {
      result = await txn.update(
          tableShiftReport,
          {
            columnEndTime: null,
            columnUpdatedDate: record.updatedDate,
            columnUpdatedBy: record.updatedBy
          },
          where: '$columnShiftReportId = ?',
          whereArgs: [record.shiftReportId]);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      result = await database.update(
          tableShiftReport,
          {
            columnEndTime: null,
            columnUpdatedDate: record.updatedDate,
            columnUpdatedBy: record.updatedBy
          },
          where: '$columnShiftReportId = ?',
          whereArgs: [record.shiftReportId]);
    }

    return result;
  }

  Future<int?> getTotalCustomer() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);

    int? count = Sqflite.firstIntValue(await database
        .rawQuery('SELECT COUNT(*) FROM s_order GROUP BY customer_id'));
    return count;
  }

  Future<ShiftReport?> getReport(id, txn) async {
    List<Map> maps = [];
    if (txn == null) {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      maps = await database
          .rawQuery('SELECT * FROM s_shift_report where shift_report_id = $id');
    } else {
      maps = await txn
          .rawQuery('SELECT * FROM s_shift_report where shift_report_id = $id');
    }
    if (maps.isNotEmpty) {
      print(maps.firstOrNull);
      return ShiftReport.fromMap(maps.first);
    }

    return null;
  }

  Future<ShiftReportHeaderDTO?> getShiftReportInformation(
      shiftReportId, baPositionId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);

    List<Map> maps = await database.rawQuery(
        'SELECT * FROM s_shift_report where shift_report_id = $shiftReportId');

    if (maps.isNotEmpty) {
      ShiftReportHeaderDTO dto = ShiftReportHeaderDTO();
      dto = ShiftReportHeaderDTO.fromJson(maps.first as Map<String, dynamic>);

      // List<Map> mapVisitedQuantity = await database.rawQuery('''
      //   SELECT COALESCE(sum(quantity),0) AS quantity
      //   FROM (
      //   SELECT COUNT(distinct customer_id) AS quantity, customer_id FROM s_customer_visit tb01
      //   WHERE tb01.ba_position_id = $baPositionId AND tb01.shift_report_id = $shiftReportId AND tb01.visit_status != '03'
      //   AND EXISTS (
      //       SELECT customer_id
      //       FROM s_shift_report tb03
      //       INNER JOIN m_route_assignment tb04 ON tb04.shift_code = tb03.shift_code
      //       WHERE tb04.day_of_week = (strftime('%w', tb03.working_date) + 1)
      //       AND (tb04.frequency = '00'
      //           OR (strftime('%W', tb03.working_date) % 2 = 0 AND tb04.frequency = '01')
      //           OR (strftime('%W', tb03.working_date) % 2 = 1 AND tb04.frequency = '02'))
      //       AND tb01.customer_id = tb04.customer_id
      //       AND tb01.shift_report_id = tb03.shift_report_id
      //   )
      //   GROUP BY customer_id)
      //   ''');
      // if (mapVisitedQuantity.isNotEmpty) {
      //   dto.visitedQuantity = mapVisitedQuantity.first['quantity'];
      // }

      // List<Map> mapCancelledQuantity = await database.rawQuery('''
      //   SELECT COALESCE(sum(quantity),0) AS quantity
      //   FROM (
      //   SELECT COUNT(distinct customer_id) AS quantity, customer_id FROM s_customer_visit tb01
      //   WHERE tb01.ba_position_id = $baPositionId AND tb01.shift_report_id = $shiftReportId AND tb01.visit_status = '03'
      //   AND NOT EXISTS (
      //     SELECT COUNT(*)
      //     from s_customer_visit
      //     where parent_customer_visit_id = tb01.customer_visit_id
      //   )
      //   AND EXISTS (
      //       SELECT COUNT(*)
      //       FROM s_shift_report tb03
      //       INNER JOIN m_route_assignment tb04 ON tb04.shift_code = tb03.shift_code
      //       WHERE tb04.day_of_week = (strftime('%w', tb03.working_date) + 1)
      //       AND (tb04.frequency = '00'
      //           OR (strftime('%W', tb03.working_date) % 2 = 0 AND tb04.frequency = '01')
      //           OR (strftime('%W', tb03.working_date) % 2 = 1 AND tb04.frequency = '02'))
      //       AND tb01.customer_id = tb04.customer_id
      //       AND tb01.shift_report_id = tb03.shift_report_id
      //   )
      //   GROUP BY customer_id)
      //   ''');

      // if (mapCancelledQuantity.isNotEmpty) {
      //   dto.cancelledQuantity = mapCancelledQuantity.first['quantity'];
      // }

      List<Map> lstMapCustomerActivity = await database.rawQuery('''
        SELECT 
            customer_id, 
            MAX(customer_visit_id) AS min_customer_visit_id,
        visit_status, customer_address_id, start_time
        FROM 
            s_customer_visit tb01
        WHERE 
            ba_position_id = $baPositionId AND shift_report_id = $shiftReportId
        AND EXISTS (
          SELECT customer_id
          FROM s_shift_report tb03
          INNER JOIN m_route_assignment tb04 ON tb04.shift_code = tb03.shift_code
          WHERE tb04.day_of_week = (strftime('%w', tb03.working_date) + 1)
          AND (tb04.frequency = '00'
            OR (strftime('%W', tb03.working_date) % 2 = 0 AND tb04.frequency = '01')
            OR (strftime('%W', tb03.working_date) % 2 = 1 AND tb04.frequency = '02')) 
          AND tb01.customer_id = tb04.customer_id
          AND tb01.shift_report_id = tb03.shift_report_id
        )
        GROUP BY 
            customer_id
    ''');

      List<CustomerVisit> lstCustomerActivity = [];
      if (lstMapCustomerActivity.isNotEmpty) {
        for (var result in lstMapCustomerActivity) {
          lstCustomerActivity.add(CustomerVisit.fromMap(result));
        }
      }

      // customer visited
      dto.visitedQuantity = lstCustomerActivity
          .where((element) => element.visitStatus != '03')
          .toList()
          .length;

      // customer cancel visit
      dto.cancelledQuantity = lstCustomerActivity
          .where((element) => element.visitStatus == '03')
          .toList()
          .length;

      List<Map> lstOfflineCustomer =
          await database.rawQuery('''SELECT distinct customer_id
        FROM s_shift_report tb01
        INNER JOIN s_customer_visit tb02 ON tb02.shift_report_id = tb01.shift_report_id
        WHERE NOT EXISTS (
            SELECT customer_id 
            FROM s_shift_report tb03
            INNER JOIN m_route_assignment tb04 ON tb04.shift_code = tb03.shift_code
            WHERE tb04.day_of_week = (strftime('%w', tb03.working_date) + 1)
            AND (tb04.frequency = '00'
                OR (strftime('%W', tb03.working_date) % 2 = 0 AND tb04.frequency = '01')
                OR (strftime('%W', tb03.working_date) % 2 = 1 AND tb04.frequency = '02')) 
            AND tb02.customer_id = tb04.customer_id
            AND tb01.shift_report_id = tb03.shift_report_id
        )
        AND tb01.shift_report_id = $shiftReportId
        AND tb02.visit_status != '03' ''');

      List<int> args = [];
      args.add(shiftReportId);
      // List<Map> planCustomersVisitQuantity =
      //     await database.rawQuery(SQLQuery.SQL_EMP_001, args);

      // dto.visitPlanQuantity = dto.visitedQuantity! + dto.cancelledQuantity!;
      dto.visitPlanQuantity = Sqflite.firstIntValue(
          await database.rawQuery(SQLQuery.SQL_CUS_VST_005, args));
      dto.customerOffline = lstOfflineCustomer.length;
      print('SQL_CUS_VST_005 ${SQLQuery.SQL_CUS_VST_005}');
      return dto;
    }
    return null;
  }

  Future<ShiftReport?> getCustomer(id) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);

    List<Map> maps = await database
        .rawQuery('SELECT * FROM s_shift_report where shift_report_id = $id');
    if (maps.isNotEmpty) {
      print(maps.firstOrNull);
      return ShiftReport.fromMap(maps.first);
    }
    return null;
  }

  Future<List<ListOrderInShift>> getListOrderInCurrentShift(
      shiftReportId) async {
    List<ListOrderInShift> listOrderInShift = [];
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    // List<Map> maps = await database.rawQuery(
    //     '''SELECT o.order_id, o.order_cd, o.customer_id, c.customer_name, o.grand_total_amount , mca.address_detail, mca.street_name
    //   FROM  s_order o , m_customer c , m_customer_address mca
    //   WHERE o.customer_id = c.customer_id AND c.customer_id = mca.customer_address_id AND o.shift_report_id = $shiftReportId ''');
//     String sqlQuery = '''
//     SELECT o.order_cd, c.customer_name,ca.address_detail,ca.street_name,w.ward_name, d.district_name, p.province_name, o.grand_total_amount
// FROM s_order o
// INNER JOIN s_customer_visit cs ON cs.customer_visit_id = o.customer_visit_id
// INNER JOIN m_customer c on o.customer_id = c.customer_id AND c.customer_id = cs.customer_id
// INNER JOIN m_customer_address ca on ca.customer_address_id = cs.customer_address_id
// INNER JOIN m_province p on p.province_id = ca.province_id
// INNER JOIN m_district d on d.district_id = ca.district_id
// INNER JOIN m_ward w on w.ward_id = ca.ward_id
// ''';
    List<Map> maps = await database
        .rawQuery('''SELECT  o.order_id, o.order_cd, c.customer_name,
 ca.address_detail as full_address , 
 o.grand_total_amount ,
 o.horeca_status
FROM s_order o
INNER JOIN s_customer_visit cs ON cs.customer_visit_id = o.customer_visit_id
INNER JOIN m_customer c on o.customer_id = c.customer_id AND c.customer_id = cs.customer_id
INNER JOIN m_customer_address ca on ca.customer_address_id = cs.customer_address_id
      WHERE cs.shift_report_id = $shiftReportId ''');
    if (kDebugMode) {
      // print(maps);
    }
    if (maps.isNotEmpty) {
      for (final item in maps) {
        // print(item);
        listOrderInShift.add(ListOrderInShift.fromMap(item));
      }
      return listOrderInShift;
    }
    return [];
  }

  Future<List<ListProductsInShift>> getListProductInCurrentShift(
      shiftReportId) async {
    List<ListProductsInShift> listProductsInShift = [];
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    // List<Map> maps = await database.rawQuery(
    //     '''SELECT od.product_id, p.product_cd, p.product_name, SUM(od.qty) as quantity, od.sales_price,  SUM(od.collection) as total_amount
    //   FROM  s_order_dtl od, m_product p , s_order o
    //   WHERE od.product_id = p.product_id AND o.order_id = od.order_id AND o.shift_report_id = $shiftReportId
    //   GROUP BY od.product_id
    //  ''');
    List<Map> maps = await database.rawQuery(
        '''select tb04.product_cd, tb04.product_name, SUM(tb03.qty) AS quantity, SUM(tb03.total_amount) AS total_amount
       from s_customer_visit tb01
       inner join s_order tb02 on tb02.customer_visit_id = tb01.customer_visit_id
       inner join s_order_dtl tb03 on tb03.order_id = tb02.order_id
       inner join m_product tb04 on tb04.product_id = tb03.product_id
       where tb01.shift_report_id = $shiftReportId
	   group by tb04.product_id,tb04.product_cd, tb04.product_name
	   order by tb04.product_id desc
     ''');
    print(maps);
    if (maps.isNotEmpty) {
      for (final item in maps) {
        listProductsInShift.add(ListProductsInShift.fromMap(item));
      }
      return listProductsInShift;
    }
    return [];
  }

  Future<int> update(ShiftReport shift, Transaction? txn) async {
    if (txn != null) {
      return await txn.update(tableShiftReport, shift.toMap(),
          where: '$columnShiftReportId = ?', whereArgs: [shift.shiftReportId]);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      return await database.update(tableShiftReport, shift.toMap(),
          where: '$columnShiftReportId = ?', whereArgs: [shift.shiftReportId]);
    }
  }

  Future<int> updateEndTime(ShiftReport shiftReport, Transaction? txn) async {
    if (txn != null) {
      return txn.update(
          tableShiftReport,
          {
            columnEndTime: shiftReport.endTime,
            columnUpdatedDate: shiftReport.updatedDate,
            columnUpdatedBy: shiftReport.updatedBy
          },
          where: '$columnShiftReportId = ?',
          whereArgs: [shiftReport.shiftReportId]);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      return database.update(
          tableShiftReport,
          {
            columnEndTime: shiftReport.endTime,
            columnUpdatedDate: shiftReport.updatedDate,
            columnUpdatedBy: shiftReport.updatedBy
          },
          where: '$columnShiftReportId = ?',
          whereArgs: [shiftReport.shiftReportId]);
    }
  }

  Future<int> updateSyncId(ShiftReport shiftReport, Transaction? txn) async {
    if (txn != null) {
      return txn.update(
          tableShiftReport,
          {
            columnShiftReportIdSync: shiftReport.shiftReportIdSync,
            columnUpdatedDate: shiftReport.updatedDate,
            columnUpdatedBy: shiftReport.updatedBy
          },
          where: '$columnShiftReportId = ?',
          whereArgs: [shiftReport.shiftReportId]);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      return database.update(
          tableShiftReport,
          {
            columnShiftReportIdSync: shiftReport.shiftReportIdSync,
            columnUpdatedDate: shiftReport.updatedDate,
            columnUpdatedBy: shiftReport.updatedBy
          },
          where: '$columnShiftReportId = ?',
          whereArgs: [shiftReport.shiftReportId]);
    }
  }

  Future<List<ShiftReport>> select(int shiftReportId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<ShiftReport> results = [];
    List<int?>? arg = [];
    arg.add(shiftReportId);

    List<Map> resultDBs = await database.rawQuery(SQLQuery.SQL_SFT_RP_002, arg);
    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(ShiftReport.fromMap(result));
      }
    }
    return results;
  }

  Future close() async => database.close();
}
