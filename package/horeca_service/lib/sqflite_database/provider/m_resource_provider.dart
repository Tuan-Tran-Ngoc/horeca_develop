import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_resource.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class ResourceProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableResource() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableResource( 
          $columnResourceId integer primary key, 
          $columnCategoryCd text not null,
          $columnResourceCd text,
          $columnValue1 text,
          $columnValue2 text,
          $columnValue3 text,
          $columnValue4 text,
          $columnValue5 text,
          $columnResourceType text,
          $columnDeleteFlg interger)
        ''');
    // db.close();
  }

  Future<Resource> insert(Resource resource) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      resource.resourceId = await txn.insert(tableResource, resource.toMap());
      print('insert data $tableResource: ${resource.resourceId}');
    });

    return resource;
  }

  Future insertMultipleRow(List<Resource> listResource, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var listResources =
        listResource.map((resource) => resource.toMap()).toList();

    //var batch = database.batch();
    listResources.forEach((resource) async {
      batch.insert(tableResource, resource);
    });
    //await batch.commit(noResult: true);
  }

  Future<List<Resource>> getResourceByCategoryCd(String categoryCd) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Resource> lstShift = [];

    List<Map> maps = await database.query(tableResource,
        columns: [
          columnResourceId,
          columnCategoryCd,
          columnResourceCd,
          columnValue1,
          columnValue2,
          columnValue3,
          columnValue4,
          columnValue5
        ],
        where: '$columnCategoryCd = ?',
        whereArgs: [categoryCd]);
    if (maps.isNotEmpty) {
      for (final item in maps) {
        lstShift.add(Resource.fromMap(item));
      }
    }
    return lstShift;
  }

  Future<List<Resource>> select() async {
    List<Resource> results = [];
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps = await database.rawQuery('select *from m_resource');

    if (maps.isNotEmpty) {
      for (final item in maps) {
        // print(item);
        results.add(Resource.fromMap(item));
      }
    }
    return results;
  }

  Future close() async => database.close();
}
