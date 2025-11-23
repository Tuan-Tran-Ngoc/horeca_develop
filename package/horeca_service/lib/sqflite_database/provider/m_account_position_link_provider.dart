import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_account_position_link.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class AccountPositionLinkProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableAccountPositionLink() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableAccountPositionLink ( 
          $columnPositionId integer primary key, 
          $columnAccountId integer,
          $columnStatus text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<AccountPositionLink> insert(AccountPositionLink record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.positionId =
          await txn.insert(tableAccountPositionLink, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(
      List<AccountPositionLink> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableAccountPositionLink, record);
    }

    // await batch.commit(noResult: true);
  }

  Future<List<AccountPositionLink>> getInfoByAccountId(int accountId) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<AccountPositionLink> results = [];
    List<int?>? arg = [];
    arg.add(accountId);

    List<Map> resultDBs =
        await database.rawQuery(SQLQuery.SQL_ACC_POS_LIK_001, arg);

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(AccountPositionLink.fromMap(result));
      }
    }
    return results;
  }

  Future close() async => database.close();
}
