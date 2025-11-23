import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/w_transfer_dtl.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class TransferDtlProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableTransferDtl() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableTransferDtl ( 
          $columnTransferDtlId integer primary key, 
          $columnTransferRequestId integer,
          $columnProductId integer,
          $columnTransferQty integer,
          $columnIsGood integer,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedDate text ,
          $columnUpdatedBy integer,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<TransferDtl> insert(TransferDtl record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.transferDtlId = await txn.insert(tableTransferDtl, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<TransferDtl> records) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableTransferDtl, record);
    }

    await batch.commit(noResult: true);
  }

  Future close() async => database.close();
}
