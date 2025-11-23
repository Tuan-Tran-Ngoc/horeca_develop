import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/w_transfer_request.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class TransferRequestProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableTransferRequest() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableTransferRequest ( 
          $columnTransferRequestId integer primary key, 
          $columnTransferCode text,
          $columnTransferName integer,
          $columnPositionTransferId integer,
          $columnPositionTransferFromId integer,
          $columnDateTransfer text,
          $columnStatus text,
          $columConfirmedDate text,
          $columnReasonId integer,
          $columnRemark text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedDate text ,
          $columnUpdatedBy integer,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<TransferRequest> insert(TransferRequest record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.transferRequestId =
          await txn.insert(tableTransferRequest, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<TransferRequest> records) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableTransferRequest, record);
    }

    await batch.commit(noResult: true);
  }

  Future close() async => database.close();
}
