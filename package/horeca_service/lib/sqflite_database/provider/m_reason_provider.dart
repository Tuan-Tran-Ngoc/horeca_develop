import 'dart:async';

import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_reason.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class ReasonProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableReason() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableReason ( 
          $columnReasonId integer primary key, 
          $columnReasonType text,
          $columnReasonContent text,
          $columnStatus text,
          $columnSort integer,
          $columnIsOther integer,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<Reason> insert(Reason record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.reasonId = await txn.insert(tableReason, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<Reason> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableReason, record);
    }

    //await batch.commit(noResult: true);
  }

  Future<List<Reason>> select(String reasonType) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Reason> lstReason = [];
    String sqlQuery =
        "SELECT * FROM $tableReason WHERE reason_type = '$reasonType';";
    print(sqlQuery);
    List<Map> lstResult = await database.rawQuery(sqlQuery);
    if (lstResult.isNotEmpty) {
      for (var item in lstResult) lstReason.add(Reason.fromMap(item));
    }
    return lstReason;
  }

  Future close() async => database.close();
}
