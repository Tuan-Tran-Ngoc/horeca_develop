import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_area.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class AreaProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableArea() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableArea ( 
          $columnAreaId integer primary key, 
          $columnAreaName text not null,
          $columnParentId integer,
          $columnAreaCode text,
          $columnLevelCode text,
          $columnVersion integer,
          $columnStatus text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedDate text ,
          $columnUpdatedBy integer)
        ''');
    // db.close();
  }

  Future<Area> insert(Area area) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      area.areaId = await txn.insert(tableArea, area.toMap());
    });

    // print('insert data: ${area.areaId}');
    return area;
  }

  Future insertMultipleRow(List<Area> listArea, Batch batch) async {
    //database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var listAreas = listArea.map((data) => data.toMap()).toList();

    //var batch = database.batch();
    listAreas.forEach((data) async {
      batch.insert(tableArea, data);
    });
    //await batch.commit(noResult: true);
  }

  Future<Area?> getArea(int id) async {
    List<Map> maps = await database.query(tableArea,
        columns: [columnAreaId, columnAreaCode, columnAreaName],
        where: '$columnAreaId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Area.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await database
        .delete(tableArea, where: '$columnAreaId = ?', whereArgs: [id]);
  }

  Future<int> update(Area area) async {
    return await database.update(tableArea, area.toMap(),
        where: '$columnAreaId = ?', whereArgs: [area.areaId]);
  }

  Future close() async => database.close();
}
