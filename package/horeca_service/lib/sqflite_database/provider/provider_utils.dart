import 'package:horeca_service/model/product_stock.dart';
import 'package:horeca_service/sqflite_database/model/w_stock_balance.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class ProviderUtils {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future<void> deleteShiftReport() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    print(
        'DELETE FROM s_shift_report WHERE shift_report_id = (SELECT shift_report_id FROM s_shift_report ORDER BY shift_report_id DESC LIMIT 1);');
    await database.rawQuery(
        'DELETE FROM s_shift_report WHERE shift_report_id = (SELECT shift_report_id FROM s_shift_report ORDER BY shift_report_id DESC LIMIT 1);');
  }

  Future<void> updatePosition() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.rawQuery(
        'UPDATE m_employee_position_link SET position_id = 8 WHERE employee_id = 3; ');
    await database.rawQuery(
        'UPDATE m_account_position_link SET position_id = 8 WHERE account_id = 3; ');
    await database.rawQuery('UPDATE w_stock_balance SET position_id = 8; ');
  }

  Future<void> clearDataForShiftModule() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    print('DELETE FROM s_shift_report;');
    await database.rawQuery('DELETE FROM s_shift_report;');
    await database.rawQuery('DELETE FROM s_customer_visit;');
    await database.rawQuery('DELETE FROM s_order;');
    await database.rawQuery('DELETE FROM s_order_dtl;');
    await database.rawQuery('DELETE FROM m_sync_offline;');
  }

  Future<void> clearDataRevisit(customerVisitId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.rawQuery(
        'DELETE FROM s_customer_visit WHERE customer_visit_id = $customerVisitId;');
  }

  Future<void> deleteStockBalanceData() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    print('DELETE FROM w_stock_balance;');
    await database
        .rawQuery('DELETE FROM w_stock_balance WHERE stock_balance_id = 55;');
  }

  Future<void> updateStockBalanceData() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    print(
        'UPDATE w_stock_balance SET allocating_stock = 1000 AND available_stock = 900;');
    await database.rawQuery(
        'UPDATE w_stock_balance SET allocating_stock = 1000, available_stock = 900;');
  }
}
