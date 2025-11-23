import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_uom.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class UOMProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableUOM() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableUOM ( 
          $columnUomId integer primary key,
          $columnUomCode text,
          $columnUomName text,
          $columnStatus text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<UOM> insert(UOM uom) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      uom.uomId = await txn.insert(tableUOM, uom.toMap());
      print('insert data $tableUOM: ${uom.uomId}');
    });

    return uom;
  }

  Future insertMultipleRow(List<UOM> listUOM, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var listUOMs = listUOM.map((data) => data.toMap()).toList();

    //var batch = database.batch();
    listUOMs.forEach((data) async {
      batch.insert(tableUOM, data);
    });
    //await batch.commit(noResult: true);
  }

  Future<UOM?> getUOM(int id) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps =
        await database.rawQuery('SELECT * FROM m_uom where uom_id = ?', [id]);

    if (maps.isNotEmpty) {
      return UOM.fromMap(maps.first);
    }
    return null;
  }

  Future<List<UOM>> getAllUOM() async {
    List<UOM> listUOM = [];
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps = await database.rawQuery('SELECT * FROM m_uom');

    if (maps.isNotEmpty) {
      for (final item in maps) {
        // print(item);
        listUOM.add(UOM.fromMap(item));
      }
      return listUOM;
    }
    return [];
  }

  Future<int> delete(int id) async {
    return await database
        .delete(tableUOM, where: '$columnUomId = ?', whereArgs: [id]);
  }

  Future<int> update(UOM uom) async {
    return await database.update(tableUOM, uom.toMap(),
        where: '$columnUomId = ?', whereArgs: [uom.uomId]);
  }

  Future close() async => database.close();
}
