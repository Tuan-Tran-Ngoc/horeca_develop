import 'package:horeca_service/sqflite_database/model/m_product_type.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class ProductTypeProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableProductType() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableProductType ( 
          $columnProductTypeId integer primary key,
          $columnTypeName text,
          $columnTypeCode text,
          $columnStatus text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<ProductType> insert(ProductType productType) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      productType.productTypeId =
          await txn.insert(tableProductType, productType.toMap());
      print('insert data $tableProductType: ${productType.productTypeId}');
    });

    return productType;
  }

  Future insertMultipleRow(
      List<ProductType> listProductType, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var listProductTypes = listProductType.map((data) => data.toMap()).toList();

    //var batch = database.batch();
    listProductTypes.forEach((data) async {
      batch.insert(tableProductType, data);
    });
    //await batch.commit(noResult: true);
  }

  Future<ProductType?> getProductType(int id) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps = await database.rawQuery(
        'SELECT * FROM m_product_type where product_type_id = ?', [id]);

    if (maps.isNotEmpty) {
      return ProductType.fromMap(maps.first);
    }
    return null;
  }

  Future<List<ProductType>> getAllProductType() async {
    List<ProductType> listProductType = [];
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps = await database.rawQuery('SELECT * FROM m_product_type');

    if (maps.isNotEmpty) {
      for (final item in maps) {
        // print(item);
        listProductType.add(ProductType.fromMap(item));
      }
      return listProductType;
    }
    return [];
  }

  Future<int> delete(int id) async {
    return await database.delete(tableProductType,
        where: '$columnProductTypeId = ?', whereArgs: [id]);
  }

  Future<int> update(ProductType productType) async {
    return await database.update(tableProductType, productType.toMap(),
        where: '$columnProductTypeId = ?',
        whereArgs: [productType.productTypeId]);
  }

  Future close() async => database.close();
}
