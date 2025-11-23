import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/model/response/create_order_response.dart';
import 'package:horeca_service/model/shift_report.dart';
import 'package:horeca_service/sqflite_database/dto/order_check_out_dto.dart';
import 'package:horeca_service/sqflite_database/dto/order_header_dto.dart';
import 'package:horeca_service/sqflite_database/model/s_order.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class OrderProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableOrder() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableOrder ( 
          $columnOrderId integer primary key AUTOINCREMENT,
          $columnOrderIdSync integer,
          $columnOrderCd text,
          $columnCustomerId integer,
          $columnShiftReportId integer,
          $columnCustomerVisitId integer,
          $columnMembershipId integer,
          $columnBaPositionId integer,
          $columnEmployeeId integer,
          $columnEmployeeName text,
          $columnSupPositionId  integer,
          $columnCityLeaderPositionId integer,
          $columnMembershipName text,
          $columnBuyerTelNo text,
          $columnOrderDate text,
          $columnExpectDeliveryDate text,
          $columnPoNo text,
          $columnTotalAmount double,
          $columnVat double,
          $columnTotalDiscount double,
          $columnCashBackAmount double,
          $columnCollection double,
          $columnRemark text,
          $columnGrandTotalAmount double,
          $columnOrderType text,
          $columnVisitTimes integer,
          $columnSapStatus text,
          $columnSapOrderNo text,
          $columnStatus text,
          $columnHorecaStatus text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<Order> insert(Order order, Transaction txn) async {
    // database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    // await database.transaction((txn) async {
    // });
    order.orderId = await txn.insert(tableOrder, order.toMap());
    print('insert data $tableOrder: ${order.orderId}');

    return order;
  }

  Future insertMultipleRow(List<Order> listOrder, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var listOrders = listOrder.map((order) => order.toMapSync()).toList();

    //var batch = database.batch();
    listOrders.forEach((order) async {
      batch.insert(tableOrder, order);
    });
//await batch.commit(noResult: true);
  }

  Future<Order?> getOrder(int id) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps = await database
        .rawQuery('SELECT * FROM s_order where order_id = ?', [id]);

    if (maps.isNotEmpty) {
      return Order.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Order>> getAllOrder() async {
    List<Order> listOrder = [];
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps = await database.rawQuery('SELECT * FROM s_order');

    if (maps.isNotEmpty) {
      for (final item in maps) {
        print(item);
        listOrder.add(Order.fromMap(item));
      }
      return listOrder;
    }
    return [];
  }

  // String getListStockBalanceQuery =
  //     '''SELECT cs.product_id,p.product_name,pt.type_name ,u.uom_name, p.price_cost,cs.allocating_stock, cs.available_stock
  //     FROM w_stock_balance cs, m_product p, m_uom u, m_product_type pt
  //     WHERE cs.product_id = p.product_id AND p.uom_id = u.uom_id AND p.product_type_id = pt.product_type_id''';
  // Future<List<ProductStock>> getListStockBalance() async {
  //   List<ProductStock> listStockBalance = [];
  //   database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
  //   List<Map> maps = await database.rawQuery(getListStockBalanceQuery);

  //   if (maps.isNotEmpty) {
  //     for (final item in maps) {
  //       // print(item);
  //       listStockBalance.add(ProductStock.fromMap(item));
  //     }
  //     return listStockBalance;
  //   }
  //   return [];
  // }

  Future<int> delete(int id) async {
    return await database
        .delete(tableOrder, where: '$columnOrderId = ?', whereArgs: [id]);
  }

  Future<int> update(Order order) async {
    return await database.update(tableOrder, order.toMap(),
        where: '$columnOrderId = ?', whereArgs: [order.orderId]);
  }

  Future<Order?> select(int orderId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<int?>? arg = [];
    arg.add(orderId);

    List<Map> resultDBs = await database.rawQuery(SQLQuery.SQL_ORD_001, arg);

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        return Order.fromMap(result);
      }
    }
    return null;
  }

  Future<List<Order>> selectByCustomerVisitId(int customerVisitId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Order> results = [];
    List<int?>? arg = [];
    arg.add(customerVisitId);

    List<Map> resultDBs = await database.rawQuery(SQLQuery.SQL_ORD_002, arg);
    print(SQLQuery.SQL_ORD_002 + customerVisitId.toString());
    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(Order.fromMap(result));
      }
    }
    return results;
  }

  Future<List<OrderCheckOutDTO>> selectByCustomerVisitIdCheckOut(
      int shiftReportId, int customerId, int? customerAddressId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<OrderCheckOutDTO> results = [];

    String SQLQuery = '''SELECT o.order_id, o.order_cd, c.customer_name,
        address_detail as full_address , 
        o.grand_total_amount,
        o.horeca_status
        FROM s_order o
        INNER JOIN s_customer_visit cs ON cs.customer_visit_id = o.customer_visit_id
        INNER JOIN m_customer c on o.customer_id = c.customer_id AND c.customer_id = cs.customer_id
        INNER JOIN m_customer_address ca on ca.customer_address_id = cs.customer_address_id
      WHERE cs.shift_report_id = $shiftReportId
      AND o.customer_id = $customerId''';
    if (customerAddressId != null) {
      String condCusAdd = 'AND ca.customer_address_id = $customerAddressId';
      SQLQuery = '$SQLQuery $condCusAdd';
    }
    List<Map> maps = await database.rawQuery(SQLQuery);
    if (maps.isNotEmpty) {
      for (var result in maps) {
        results.add(OrderCheckOutDTO.fromMap(result));
      }
    }
    return results;
  }

  Future<List<OrderHeaderDto>> selectOrderHeader(int orderId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<OrderHeaderDto> results = [];
    List<int?>? arg = [];
    arg.add(orderId);

    List<Map> resultDBs = await database.rawQuery(SQLQuery.SQL_ORD_003, arg);
    print('SQLIYTE ${SQLQuery.SQL_ORD_003}');
    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(OrderHeaderDto.fromMap(result));
      }
    }
    return results;
  }

  Future<List<ListOrderInShift>> selectOrderByCustomerId(int customerId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<ListOrderInShift> results = [];
    List<int?>? arg = [];
    arg.add(customerId);

    List<Map> resultDBs = await database.rawQuery(SQLQuery.SQL_ORD_004, arg);

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(ListOrderInShift.fromMap(result));
      }
    }
    return results;
  }

  Future<List<ListOrderInShift>> selectOrderCondition(
      int customerId, String productCd) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<ListOrderInShift> results = [];
    List<dynamic>? arg = [];
    arg.add(customerId);
    arg.add('%${productCd.toLowerCase()}%');
    arg.add('%${productCd.toLowerCase()}%');

    List<Map> resultDBs = await database.rawQuery(SQLQuery.SQL_ORD_005, arg);

    print('SQLLL ${SQLQuery.SQL_ORD_005}');

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(ListOrderInShift.fromMap(result));
      }
    }
    return results;
  }

  Future<int> updateOrderCd(
      CreateOrderResponse record, Transaction? txn) async {
    // database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    // await database.transaction((txn) async {
    // });
    int isUpdate = 0;
    if (txn != null) {
      isUpdate = await txn.update(
          tableOrder,
          {
            columnOrderCd: record.orderCd,
            columnSupPositionId: record.supPositionId,
            columnCityLeaderPositionId: record.cityLeaderPositionId
          },
          where: '$columnOrderId = ?',
          whereArgs: [record.tabletOrderId]);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      isUpdate = await database.update(
          tableOrder,
          {
            columnOrderCd: record.orderCd,
            columnSupPositionId: record.supPositionId,
            columnCityLeaderPositionId: record.cityLeaderPositionId
          },
          where: '$columnOrderId = ?',
          whereArgs: [record.tabletOrderId]);
    }

    return isUpdate;
  }

  Future<int> updateOrderSync(Order record, Transaction? txn) async {
    // database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    // await database.transaction((txn) async {
    // });
    int isUpdate = 0;
    if (txn != null) {
      isUpdate = await txn.update(
          tableOrder,
          {
            columnOrderCd: record.orderCd,
            columnOrderIdSync: record.orderIdSync,
            columnSupPositionId: record.supPositionId,
            columnCityLeaderPositionId: record.cityLeaderPositionId,
            columnStatus: record.status,
            columnOrderType: record.orderType,
            columnHorecaStatus: record.horecaStatus
          },
          where: '$columnOrderId = ?',
          whereArgs: [record.orderId]);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      isUpdate = await database.update(
          tableOrder,
          {
            columnOrderCd: record.orderCd,
            columnOrderIdSync: record.orderIdSync,
            columnSupPositionId: record.supPositionId,
            columnCityLeaderPositionId: record.cityLeaderPositionId,
            columnStatus: record.status,
            columnOrderType: record.orderType,
            columnHorecaStatus: record.horecaStatus
          },
          where: '$columnOrderId = ?',
          whereArgs: [record.orderId]);
    }

    return isUpdate;
  }

  Future<int?> countOrderSap(int orderId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<dynamic>? arg = [];
    arg.add(orderId);

    int? count = Sqflite.firstIntValue(
        await database.rawQuery(SQLQuery.SQL_ORD_007, arg));

    return count;
  }

  Future<List<OrderHeaderDto>> selectSapOrderHeader(int orderId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<OrderHeaderDto> results = [];
    List<int?>? arg = [];
    arg.add(orderId);

    List<Map> resultDBs = await database.rawQuery(SQLQuery.SQL_ORD_003, arg);
    print('SQLIYTE ${SQLQuery.SQL_ORD_009}');
    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(OrderHeaderDto.fromMap(result));
      }
    }
    return results;
  }

  Future<double> sumGrandOrder(int customerId, Transaction? txn) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<dynamic>? arg = [];
    List<Map> resultDBs = [];
    arg.add(customerId);

    if (txn != null) {
      resultDBs = await txn.rawQuery(SQLQuery.SQL_ORD_010, arg);
    } else {
      resultDBs = await database.rawQuery(SQLQuery.SQL_ORD_010, arg);
    }
    double? sumGrandTotalAmount =
        resultDBs.isNotEmpty ? resultDBs.first['grand_total_amount'] : null;

    return sumGrandTotalAmount ?? 0;
  }

  Future close() async => database.close();
}
