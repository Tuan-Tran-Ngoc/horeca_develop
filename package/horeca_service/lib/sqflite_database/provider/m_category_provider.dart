import 'package:horeca_service/sqflite_database/model/m_category.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class CategoryProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableCategory() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableCategory ( 
          $columnCategoryId integer primary key, 
          $columnCategoryCode text not null,
          $columnCategoryName text,     
          $columnVersion integer,
          $columnStatus text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedDate text ,
          $columnUpdatedBy integer)
        ''');
    // db.close();
  }

  Future<MCategory> insert(MCategory category) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    category.categoryId =
        await database.insert(tableCategory, category.toMap());
    print('insert data: ${category.categoryId}');
    return category;
  }

  Future<void> insertMultipleRow(List<MCategory> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var data in recordsMap) {
      batch.insert(tableCategory, data);
    }

    //await batch.commit(noResult: true);
  }

  Future<MCategory?> getArea(int id) async {
    List<Map> maps = await database.query(tableCategory,
        columns: [columnCategoryId, columnCategoryCode, columnCategoryName],
        where: '$columnCategoryId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return MCategory.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await database
        .delete(tableCategory, where: '$columnCategoryId = ?', whereArgs: [id]);
  }

  Future<int> update(MCategory category) async {
    return await database.update(tableCategory, category.toMap(),
        where: '$columnCategoryId = ?', whereArgs: [category.categoryId]);
  }

  Future close() async => database.close();
}
