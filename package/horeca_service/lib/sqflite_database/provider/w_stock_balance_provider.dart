import 'package:horeca_service/model/product_stock.dart';
import 'package:horeca_service/sqflite_database/model/w_stock_balance.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class StockBalanceProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableStockBalance() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableStockBalance ( 
          $columnStockBalanceId integer primary key,
          $columnPositionId integer,
          $columnProductId integer,
          $columnAllocatingStoc REAL,
          $columnAvailableStock REAL,
          $columnIsGood integer,
          $columnIsReceived integer,
          $columnAllocateDate text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<StockBalance> insert(StockBalance stockBalance) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      stockBalance.stockBalanceId =
          await txn.insert(tableStockBalance, stockBalance.toMap());
      print('insert data $tableStockBalance: ${stockBalance.stockBalanceId}');
    });

    return stockBalance;
  }

  Future insertMultipleRow(
      List<StockBalance> listStockBalance, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var listStockBalances =
        listStockBalance.map((stockblance) => stockblance.toMap()).toList();

    //var batch = database.batch();
    listStockBalances.forEach((stockblance) async {
      batch.insert(tableStockBalance, stockblance);
    });
    //await batch.commit(noResult: true);
  }

  Future<StockBalance?> getCutomerStock(int id) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps = await database.rawQuery(
        'SELECT * FROM w_stock_balance where stock_balance_id = ?', [id]);

    if (maps.isNotEmpty) {
      return StockBalance.fromMap(maps.first);
    }
    return null;
  }

  Future<List<StockBalance>> getAllStockBalance() async {
    List<StockBalance> listStockBalance = [];
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps = await database.rawQuery('SELECT * FROM s_customer_Stock');

    if (maps.isNotEmpty) {
      for (final item in maps) {
        // print(item);
        listStockBalance.add(StockBalance.fromMap(item));
      }
      return listStockBalance;
    }
    return [];
  }

  Future<List<ProductStock>> getListStockBalance(
      int positionId, String now, Transaction? txn) async {
    // String getListStockBalanceQuery =
    //   '''SELECT cs.product_id,p.product_name,pt.type_name ,u.uom_name, p.price_cost,cs.allocating_stock, cs.available_stock, cs.position_id
    //   FROM w_stock_balance cs
    //   INNER JOIN m_product p ON cs.product_id = p.product_id
    //   INNER JOIN m_uom u ON p.uom_id = u.uom_id
    //   INNER JOIN m_product_type pt ON p.product_type_id = pt.product_type_id
    //   WHERE cs.position_id = ?''';
    String getListStockBalanceQuery = '''WITH product_used_in_order AS
  (SELECT CAST(SUM(od.qty) AS DOUBLE) AS quantity,
          od.product_id
   FROM s_order o
   INNER JOIN s_order_dtl od ON od.order_id = o.order_id
   INNER JOIN s_customer_visit cs ON cs.customer_visit_id = o.customer_visit_id
   WHERE o.horeca_status not in ('01','05')
   AND cs.ba_position_id = ? 
   AND strftime('%Y-%m-%d', o.order_date) = date('now')
   GROUP BY od.product_id),
 product_used_in_promotion AS
  (SELECT CAST(SUM(od.qty) AS DOUBLE) AS quantity,
          od.product_id
   FROM s_order o
   INNER JOIN s_order_promotion_result od ON od.order_id = o.order_id
   INNER JOIN s_customer_visit cs ON cs.customer_visit_id = o.customer_visit_id
   WHERE o.horeca_status not in ('01','05')
   AND cs.ba_position_id = ? 
   AND strftime('%Y-%m-%d', o.order_date) = date('now')
   GROUP BY od.product_id)
SELECT sb.product_id,p.product_name,pt.type_name ,u.uom_name, p.price_cost,sb.allocating_stock, sb.available_stock, sb.position_id,
       COALESCE(puio.quantity,0.0) AS order_used_stock, COALESCE(puip.quantity,0.0) AS promotion_used_stock
FROM w_stock_balance sb
INNER JOIN m_product p ON sb.product_id = p.product_id
                      AND p.is_salable = 1
                      AND p.status = '01'
INNER JOIN m_uom u ON p.uom_id = u.uom_id  
INNER JOIN m_product_type pt ON p.product_type_id = pt.product_type_id
LEFT JOIN product_used_in_order puio ON puio.product_id = sb.product_id
LEFT JOIN product_used_in_promotion puip ON puip.product_id = sb.product_id
WHERE date(sb.allocate_date) = date('now')
and sb.position_id = ?
''';
    List<ProductStock> listStockBalance = [];
    List<Map> maps = [];
    List<dynamic> arg = [];
    arg.add(positionId);
    arg.add(positionId);
    arg.add(positionId);

    if (txn != null) {
      maps = await txn.rawQuery(getListStockBalanceQuery, arg);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      maps = await database.rawQuery(getListStockBalanceQuery, arg);
    }

    print("query stock result $maps");
    if (maps.isNotEmpty) {
      for (final item in maps) {
        listStockBalance.add(ProductStock.fromMap(item));
      }
      return listStockBalance;
    }
    return [];
  }

  Future<List<ProductStock>> getListStockBalancePrice(
      int positionId, int customerId) async {
    List<ProductStock> listStockBalance = [];
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<dynamic> arg = [];
    arg.add(positionId);
    arg.add(positionId);
    arg.add(customerId);
    arg.add(customerId);
    arg.add(customerId);
    arg.add(customerId);
    arg.add(positionId);

    List<Map> maps =
        await database.rawQuery(SQLQuery.SQL_STOCK_BALANCE_001, arg);

    print("query stock result $maps");
    if (maps.isNotEmpty) {
      for (final item in maps) {
        // print(item);
        listStockBalance.add(ProductStock.fromMap(item));
      }
      return listStockBalance;
    }
    return [];
  }

  Future<int> delete(int id) async {
    return await database.delete(tableStockBalance,
        where: '$columnStockBalanceId = ?', whereArgs: [id]);
  }

  Future<int> update(StockBalance stockBalance) async {
    return await database.update(tableStockBalance, stockBalance.toMap(),
        where: '$columnStockBalanceId = ?',
        whereArgs: [stockBalance.stockBalanceId]);
  }

  Future close() async => database.close();
}
