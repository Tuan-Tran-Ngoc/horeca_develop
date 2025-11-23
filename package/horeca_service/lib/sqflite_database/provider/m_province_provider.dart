import 'package:horeca_service/sqflite_database/model/m_province.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class ProvinceProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableProvince() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableProvince ( 
          $columnProvinceId integer primary key,
          $columnProvinceCode text,
          $columnProvinceName text,
          $columnVersion integer,
          $columnUpdatedBy integer,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedDate text
         )
        ''');
    // db.close();
  }

  Future<Province> insert(Province province) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    province.provinceId =
        await database.insert(tableProvince, province.toMap());
    // print('insert data: ${province.provinceId}');
    return province;
  }

  Future<void> insertMultipleRow(List<Province> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var data in recordsMap) {
      batch.insert(tableProvince, data);
    }

    //await batch.commit(noResult: true);
  }

  Future<int> delete(int id) async {
    return await database
        .delete(tableProvince, where: '$columnProvinceId = ?', whereArgs: [id]);
  }

  Future<int> update(Province province) async {
    return await database.update(tableProvince, province.toMap(),
        where: '$columnProvinceId = ?', whereArgs: [province.provinceId]);
  }

  Future close() async => database.close();
}
