import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/data_delete.dart';
import 'package:horeca_service/sqflite_database/model/m_account.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class DataDeleteProvide {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  List<String> lstTableSync = [
    's_customer_price',
    's_customer_stock',
    's_customer_visit',
    's_order',
    's_order_dtl',
    's_order_promotion_result',
    's_order_discount_result',
    's_shift_report',
    's_survey_result'
  ];

  List<String> lstTableExist = [
    's_customer_price',
    's_customer_stock',
    's_customer_visit',
    's_order',
    's_order_dtl',
    's_order_promotion_result',
    's_order_discount_result',
    's_shift_report',
    's_survey_result',
    'm_brand',
    'm_customer_address',
    'm_customer_liabilities',
    'm_customer',
    'm_discount_condition',
    'm_discount_result',
    'm_discount_scheme',
    'm_discount_target',
    'm_discount',
    'm_messages',
    'm_product_type',
    'm_product',
    'm_promotion_condition',
    'm_promotion_result',
    'm_promotion_scheme',
    'm_promotion_target',
    'm_promotion',
    'm_resource',
    'm_route_assignment',
    'm_shift',
    'm_survey_target',
    'm_survey',
    's_order_discount_result',
    's_order_dtl',
    's_order_promotion_result',
    's_order',
    's_shift_report',
    'w_stock_balance',
    'm_customer_property',
    'm_customer_property_mapping',
    'm_sales_in_price',
    'm_sales_in_price_dtl',
    'm_sales_in_price_target',
    'm_customers_group',
    'm_customers_group_detail',
    's_sap_order_delivery',
    'm_product_branch_mapping'
  ];

  Future<Account> insert(Account record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.accountId = await txn.insert(tableAccount, record.toMap());
    });

    return record;
  }

  Future deleteMultipleRow(List<DataDelete> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);

    for (var record in records) {
      if (record.primaryKey != null &&
          record.primaryKey != '' &&
          record.lstDeleteIds!.isNotEmpty &&
          lstTableExist.any((element) => element == record.tableName)) {
        if (lstTableSync.any((element) => element == record.tableName)) {
          record.primaryKey = '${record.primaryKey}_sync';
        }
        print('record.tableName: ${record.tableName}---${record.lstDeleteIds}');
        List<List<dynamic>> chunks = [];
        int maxSize = 200; // Số lượng biến SQL tối đa mà SQLite hỗ trợ
        for (int i = 0; i < record.lstDeleteIds!.length; i += maxSize) {
          chunks.add(record.lstDeleteIds!.sublist(
              i,
              (i + maxSize) > record.lstDeleteIds!.length
                  ? record.lstDeleteIds!.length
                  : i + maxSize));
        }

        for (var chunk in chunks) {
          batch.delete(record.tableName!,
              where:
                  '${record.primaryKey} in (${List.filled(chunk.length, '?').join(',')})',
              whereArgs: chunk);
        }
      }
    }
  }

  Future close() async => database.close();
}
