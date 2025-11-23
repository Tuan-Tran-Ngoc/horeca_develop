import 'package:horeca_service/sqflite_database/model/m_district.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class DistrictProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableDistrict() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableDistrict ( 
          $columnDistrictId integer primary key,
          $columnProvinceId integer,
          $columnDistrictName text,
          $columnDistrictCode text,
          $columnVersion integer,
          $columnUpdatedBy integer,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedDate text
         )
        ''');
    // db.close();
  }

  Future<District> insert(District district) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    district.districtId =
        await database.insert(tableDistrict, district.toMap());
    // print('insert data: ${district.districtId}');
    return district;
  }

  Future<void> insertMultipleRow(List<District> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var data in recordsMap) {
      batch.insert(tableDistrict, data);
    }

    //await batch.commit(noResult: true);
  }

  Future<District?> getDistrict(int id) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps = await database
        .rawQuery('SELECT * FROM m_district where district_id = ?', [id]);

    if (maps.isNotEmpty) {
      return District.fromMap(maps.first);
    }
    return null;
  }

  Future<List<District>> getAllDistrict() async {
    List<District> listSurvey = [];
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps = await database.rawQuery('SELECT * FROM m_district');

    if (maps.isNotEmpty) {
      for (final item in maps) {
        print(item);
        listSurvey.add(District.fromMap(item));
      }
      return listSurvey;
    }
    return [];
  }

  Future<int> delete(int id) async {
    return await database
        .delete(tableDistrict, where: '$columnDistrictId = ?', whereArgs: [id]);
  }

  Future<int> update(District district) async {
    return await database.update(tableDistrict, district.toMap(),
        where: '$columnDistrictId = ?', whereArgs: [district.districtId]);
  }

  Future close() async => database.close();
}
