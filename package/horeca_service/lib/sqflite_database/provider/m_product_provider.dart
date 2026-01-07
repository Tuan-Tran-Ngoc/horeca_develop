import 'package:horeca_service/sqflite_database/dto/product_dto.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_product.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class ProductProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableProduct() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableProduct ( 
          $columnProductId integer primary key,
          $columnProductCd text,
          $columnProductTypeId integer,
          $columnProductName text,
          $columnPriceCost REAL,
          $columnPriority integer,
          $columnCategoryId integer,
          $columnUomId integer,
          $columnBrandId integer,
          $columnProductImg text,
          $columnIsSalable integer,
          $columnStatus text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<Product> insert(Product product) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);

    await database.transaction((txn) async {
      product.productId = await txn.insert(tableProduct, product.toMap());
      print('insert data $tableProduct: ${product.productId}');
    });
    return product;
  }

  Future insertMultipleRow(List<Product> listProductType, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var listProducts = listProductType.map((data) => data.toMap()).toList();

    //var batch = database.batch();
    listProducts.forEach((data) async {
      batch.insert(tableProduct, data);
    });
    //await batch.commit(noResult: true);
  }

  Future<Product?> getProduct(int id) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps = await database
        .rawQuery('SELECT * FROM m_product where product_id = ?', [id]);

    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Product>> getAllProduct() async {
    List<Product> listProduct = [];
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps = await database.rawQuery('SELECT * FROM m_product');

    if (maps.isNotEmpty) {
      for (final item in maps) {
        // print(item);
        listProduct.add(Product.fromMap(item));
      }
      return listProduct;
    }
    return [];
  }

  Future<List<ProductDto>> getAllInfoProduct(
      int customerId, int baPositionId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<ProductDto> results = [];
    List<int>? arg = [];
    arg.add(customerId);
    arg.add(customerId);
    arg.add(customerId);
    arg.add(customerId);
    arg.add(baPositionId);

    List<Map> resultDBs = await database.rawQuery(SQLQuery.SQL_PRD_001, arg);

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(ProductDto.fromMap(result));
      }
    }
    return results;
  }

  Future<int> delete(int id) async {
    return await database
        .delete(tableProduct, where: '$columnProductId = ?', whereArgs: [id]);
  }

  Future<int> update(Product product) async {
    return await database.update(tableStockBalance, product.toMap(),
        where: '$columnStockBalanceId = ?', whereArgs: [product.productId]);
  }

  Future<List<Product>> getProductByBrand(int brandId) async {
    List<Product> lstProduct = [];
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps = await database.query(tableProduct,
        columns: [
          columnProductId,
          columnProductCd,
          columnProductName,
          columnProductImg,
          columnPriceCost
        ],
        where: '$columnBrandId = ?',
        whereArgs: [brandId]);
    if (maps.isNotEmpty) {
      for (final item in maps) {
        lstProduct.add(Product.fromMap(item));
      }
    }
    return lstProduct;
  }

  Future close() async => database.close();
}
