import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/sqflite_database/dto/product_checkout_dto.dart';
import 'package:horeca_service/sqflite_database/dto/product_dto.dart';
import 'package:horeca_service/sqflite_database/model/s_order_dtl.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class OrderDetailProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableOrderDetail() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableOrderDetail ( 
          $columnOrderDetailId integer primary key AUTOINCREMENT,
          $columnOrderDtlIdSync integer,
          $columnOrderId integer,
          $columnProductId integer,
          $columnStockType text,
          $columnQuantity double,
          $columnSalesPrice double,
          $columnSalesInPrice double,
          $columnTotalAmount double,
          $columnCashBackAmount double,
          $columnCollection double,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<OrderDetail> insert(OrderDetail orderDetail, Transaction txn) async {
    //database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);

    orderDetail.orderDetailId =
        await txn.insert(tableOrderDetail, orderDetail.toMap());
    print('insert data $tableOrderDetail: ${orderDetail.orderDetailId}');
    return orderDetail;
  }

  Future insertMultipleRow(
      List<OrderDetail> listOrderDetail, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var listOrderDetails =
        listOrderDetail.map((orderDetail) => orderDetail.toMapSync()).toList();

    //var batch = database.batch();
    listOrderDetails.forEach((orderDetail) async {
      batch.insert(tableOrderDetail, orderDetail);
    });
    //await batch.commit(noResult: true);
  }

  Future<int> delete(int id) async {
    return await database.delete(tableOrderDetail,
        where: '$columnOrderDetailId = ?', whereArgs: [id]);
  }

  Future<int> update(OrderDetail orderDetail) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    return await database.update(tableOrder, orderDetail.toMap(),
        where: '$columnOrderDetailId = ?',
        whereArgs: [orderDetail.orderDetailId]);
  }

  Future<int> updateSyncId(OrderDetail orderDetail, Transaction? txn) async {
    if (txn != null) {
      return await txn.update(
          tableOrderDetail,
          {
            columnOrderDtlIdSync: orderDetail.orderDetailIdSync,
            columnUpdatedBy: orderDetail.updatedBy,
            columnUpdatedDate: orderDetail.updatedDate
          },
          where: '$columnOrderDetailId = ?',
          whereArgs: [orderDetail.orderDetailId]);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      return await database.update(
          tableOrderDetail,
          {
            columnOrderDtlIdSync: orderDetail.orderDetailIdSync,
            columnUpdatedBy: orderDetail.updatedBy,
            columnUpdatedDate: orderDetail.updatedDate
          },
          where: '$columnOrderDetailId = ?',
          whereArgs: [orderDetail.orderDetailId]);
    }
  }

  Future<List<OrderDetail>> selectByOrderId(int orderId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<OrderDetail> results = [];
    List<int?>? arg = [];
    arg.add(orderId);

    List<Map> resultDBs =
        await database.rawQuery(SQLQuery.SQL_ORD_DTL_001, arg);

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(OrderDetail.fromMap(result));
      }
    }
    return results;
  }

  Future<List<ProductCheckoutDto>> selectReportCheckoutProduct(
      int shiftReportId, int customerId, int? customerAddressId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<ProductCheckoutDto> results = [];
    List<int?>? arg = [];
    arg.add(shiftReportId);
    arg.add(customerId);

    String query = SQLQuery.SQL_ORD_DTL_004;
    if (customerAddressId != null) {
      arg.add(customerAddressId);
      query = SQLQuery.SQL_ORD_DTL_002;
    }

    List<Map> resultDBs = await database.rawQuery(query, arg);
    print(SQLQuery.SQL_ORD_DTL_002);
    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(ProductCheckoutDto.fromMap(result));
      }
    }
    return results;
  }

  Future<List<ProductDto>> selectOrderDtl(int orderId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<ProductDto> results = [];
    List<int?>? arg = [];
    arg.add(orderId);

    List<Map> resultDBs =
        await database.rawQuery(SQLQuery.SQL_ORD_DTL_003, arg);

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(ProductDto.fromMap(result));
      }
    }
    return results;
  }

  Future close() async => database.close();
}
