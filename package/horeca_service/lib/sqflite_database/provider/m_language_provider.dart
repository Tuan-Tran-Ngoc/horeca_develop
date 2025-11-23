import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_language.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class LanguageProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableLanguage() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableLanguage ( 
          $columnLanguageCode text,
          $columnCountryCode text, 
          $columnLanguageName text,
          $columnRegionCode text)
        ''');
    // db.close();
  }

  Future<Language> insert(Language record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      await txn.insert(tableLanguage, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<Language> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableLanguage, record);
    }

    //await batch.commit(noResult: true);
  }

  Future<List<Language>> select() async {
    List<Language> lstLanguage = [];
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps = await database.rawQuery(
        "select *from m_language where language_code in ('vi', 'en')");

    if (maps.isNotEmpty) {
      for (final item in maps) {
        // print(item);
        lstLanguage.add(Language.fromMap(item));
      }
    }
    return lstLanguage;
  }

  Future close() async => database.close();
}
