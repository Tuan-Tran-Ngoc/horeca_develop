import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_ward.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class WardProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableWard() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableWard ( 
          $columnWardId integer primary key,
          $columnWardName text,
          $columnWardCode text,
          $columnDistrictId integer,
          $columnVersion integer,
          $columnUpdatedBy integer,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedDate text
         )
        ''');
    // db.close();
  }

  Future<Ward> insert(Ward ward) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    ward.wardId = await database.insert(tableWard, ward.toMap());
    // print('insert data: ${ward.wardId}');
    return ward;
  }

  Future<void> insertMultipleRow(List<Ward> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var data in recordsMap) {
      batch.insert(tableWard, data);
    }

    //await batch.commit(noResult: true);
  }

  Future<int> delete(int id) async {
    return await database
        .delete(tableWard, where: '$columnWardId = ?', whereArgs: [id]);
  }

  Future<int> update(Ward ward) async {
    return await database.update(tableWard, ward.toMap(),
        where: '$columnWardId = ?', whereArgs: [ward.wardId]);
  }

  Future close() async => database.close();
}
