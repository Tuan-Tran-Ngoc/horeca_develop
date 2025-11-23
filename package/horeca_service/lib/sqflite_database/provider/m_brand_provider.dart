import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_brand.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class BrandProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableBrand() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableBrand ( 
          $columnBrandId integer primary key, 
          $columnBrandCd text not null,
          $columnBrandName text,
          $columnBrandImg text,     
          $columnStatus text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text ,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<Brand> insert(Brand brand) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      brand.brandId = await txn.insert(tableBrand, brand.toMap());
      print('insert data $tableBrand: ${brand.brandId}');
    });

    return brand;
  }

  Future insertMultipleRow(List<Brand> listBrand, Batch batch) async {
    //database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var listBrands = listBrand.map((data) => data.toMap()).toList();

    //var batch = database.batch();
    listBrands.forEach((data) async {
      batch.insert(tableBrand, data);
    });
    //await batch.commit(noResult: true);
  }

  Future<Brand?> getBrand(int id) async {
    List<Map> maps = await database.query(tableBrand,
        columns: [columnBrandId, columnBrandCd, columnBrandName],
        where: '$columnBrandId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Brand.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Brand>> getBrandByStatus(String status) async {
    List<Brand> lstBrand = [];
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    // List<Map> maps = await database.query(tableBrand,
    //     columns: [
    //       columnBrandId,
    //       columnBrandCd,
    //       columnBrandName,
    //       columnBrandImg
    //     ],
    //     where: '$columnStatus = ?',
    //     whereArgs: [status]);
    List<Map> maps = await database.rawQuery(SQLQuery.SQL_BRAND_001, [status]);
    if (maps.isNotEmpty) {
      for (final item in maps) {
        lstBrand.add(Brand.fromMap(item));
      }
    }
    return lstBrand;
  }

  Future<int> delete(int id) async {
    return await database
        .delete(tableBrand, where: '$columnBrandId = ?', whereArgs: [id]);
  }

  Future<int> update(Brand brand) async {
    return await database.update(tableBrand, brand.toMap(),
        where: '$columnBrandId = ?', whereArgs: [brand.brandId]);
  }

  Future close() async => database.close();
}
