import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_account_offline.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class AccountOfflineProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableAccountOffline() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableAccountOffline ( 
          $columnAccountOfflineId integer primary key, 
          $columnPositionId integer,
          $columnUsername text,
          $columnPassword text,
          $columnLastLogin text,
          $columnOauthString text,
          $columnUpdatedDate text)
        ''');
    // db.close();
  }

  Future<AccountOffline> insert(AccountOffline record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.accountOfflineId =
          await txn.insert(tableAccountOffline, record.toMap());
    });

    return record;
  }

  Future<void> insertMultipleRow(
      List<AccountOffline> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var data in recordsMap) {
      batch.insert(tableAccountOffline, data);
    }

    //await batch.commit(noResult: true);
  }

  Future close() async => database.close();
}
