import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_area.dart';
import 'package:horeca_service/sqflite_database/model/m_product_branch_mapping.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class ProductBranchMappingProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableProductBranchMapping() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableProductBranchMapping ( 
          $columnProductBranchMappingId integer primary key, 
          $columnProductId integer,
          $columnBranchId integer,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedDate text ,
          $columnUpdatedBy integer,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future insertMultipleRow(
      List<ProductBranchMapping> lstRecord, Batch batch) async {
    var records = lstRecord.map((data) => data.toMap()).toList();

    records.forEach((data) async {
      batch.insert(tableProductBranchMapping, data);
    });
  }

  Future<List<int>> getProductMapping(int customerId, Transaction? txn) async {
    List<int> results = [];
    List<int?>? arg = [];
    List<Map> resultDBs = [];
    arg.add(customerId);

    if (txn != null) {
      resultDBs = await txn.rawQuery(SQLQuery.SQL_PRD_BRH_MAP_001, arg);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      resultDBs = await database.rawQuery(SQLQuery.SQL_PRD_BRH_MAP_001, arg);
    }
    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(result['product_id']);
      }
    }
    return results;
  }

  Future close() async => database.close();
}
