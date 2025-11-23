import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_brand.dart';
import 'package:horeca_service/sqflite_database/model/w_transfer_update_log.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class TransferUpdateLogProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableTransferUpdateLog() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableTransferUpdateLog ( 
          $columnTransferUpdateLogId integer primary key, 
          $columnBaPositionId integer,
          $columnImeiDevice text,
          $columnDateLastestUpdate text,
          $columnStatus text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text ,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<TransferUpdateLog> insertForDaily(
      TransferUpdateLog record, Transaction? txn) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.transferUpdateLogId =
          await txn.insert(tableTransferUpdateLog, record.toMap());
      print(
          'insert data $tableTransferUpdateLog: ${record.transferUpdateLogId}');
    });

    return record;
  }

  Future<TransferUpdateLog?> select(int baPositionId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps = await database.query(tableTransferUpdateLog,
        columns: [columnDateLastestUpdate],
        where: '$columnBaPositionId = ? and $columnStatus = ?',
        whereArgs: [baPositionId, '01'],
        orderBy: '$columnUpdatedDate DESC');
    if (maps.isNotEmpty) {
      return TransferUpdateLog.fromMap(maps.first);
    }
    return null;
  }

  Future softDelete(int baPositionId, String nowTime, Batch batch) async {
    batch.update(
        tableTransferUpdateLog,
        {
          columnStatus: '00',
          columnUpdatedBy: baPositionId,
          columnUpdatedDate: nowTime
        },
        where: '$columnBaPositionId = ?',
        whereArgs: [baPositionId]);
  }

  Future insertForInit(TransferUpdateLog record, Batch batch) async {
    batch.insert(tableTransferUpdateLog, record.toMap());
  }

  Future close() async => database.close();
}
