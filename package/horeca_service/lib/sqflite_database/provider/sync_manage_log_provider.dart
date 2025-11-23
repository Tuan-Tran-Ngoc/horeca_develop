import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/sync_manage_log.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class SyncManageLogProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableSyncManageLog() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableSyncManageLog ( 
          $columnLogId integer primary key AUTOINCREMENT, 
          $columnBaPositionId integer,
          $columnImeiDevice text,
          $columnObjectFail text,
          $columnLog text)
        ''');
    // db.close();
  }

  Future<SyncManageLog> insert(SyncManageLog record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      await txn.insert(tableSyncManageLog, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<SyncManageLog> records) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableSyncManageLog, record);
    }

    await batch.commit(noResult: true);
  }

  Future close() async => database.close();
}
