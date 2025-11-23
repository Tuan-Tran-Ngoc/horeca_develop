import 'dart:async';

import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_account.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class AccountProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableAccount() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableAccount ( 
          $columnAccountId integer primary key, 
          $columnUsername text,
          $columnPassword text,
          $columnAccountNonExpired integer,
          $columnAccountNonLocked integer,
          $columnCredentialsNonExpired integer,
          $columnAccountRuleDefinitionId integer,
          $columnForceChangePassword integer,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<Account> insert(Account record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.accountId = await txn.insert(tableAccount, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<Account> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableAccount, record);
    }

    //await batch.commit(noResult: true);
  }

  Future<List<Account>> getAccountByUsername(String username) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Account> results = [];
    List<String?>? arg = [];
    arg.add(username);

    List<Map> resultDBs = await database.rawQuery(SQLQuery.SQL_ACC_001, arg);

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(Account.fromMap(result));
      }
    }
    return results;
  }

  Future<int> updatePassword(Account account, Transaction? txn) async {
    if (txn != null) {
      return txn.update(
          tableAccount,
          {
            columnPassword: account.password,
            columnUpdatedDate: account.updatedDate
          },
          where: '$columnAccountId = ?',
          whereArgs: [account.accountId]);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      return database.update(
          tableAccount,
          {
            columnPassword: account.password,
            columnUpdatedBy: account.updatedBy,
            columnUpdatedDate: account.updatedDate
          },
          where: '$columnAccountId = ?',
          whereArgs: [account.accountId]);
    }
  }

  Future close() async => database.close();
}
