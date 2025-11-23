import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_mesages.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class MessagesProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableMessages() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableMessages ( 
          $columnMessageId integer primary key, 
          $columnLanguageCode text,
          $columnMessageCode text,
          $columnMessageString text,
          $columnCountryCode text,
          $columnRemark text,
          $columnModuleResource text,
          $columnReuseFlag integer)
        ''');
    // db.close();
  }

  Future<Messages> insert(Messages record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.messageId = await txn.insert(tableMessages, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<Messages> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableMessages, record);
    }

    //await batch.commit(noResult: true);
  }

  Future<List<Messages>> select() async {
    List<Messages> listProduct = [];
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps = await database.rawQuery('select *from m_messages');

    if (maps.isNotEmpty) {
      for (final item in maps) {
        // print(item);
        listProduct.add(Messages.fromMap(item));
      }
    }
    return listProduct;
  }

  Future close() async => database.close();
}
