import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_survey_target.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class SurveyTargetProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableReason() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableSurveyTarget ( 
          $columnSurveyTargetId integer primary key, 
          $columnSurveyId text,
          $columnTargetType text,
          $columnTargetId text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<SurveyTarget> insert(SurveyTarget record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.surveyTargetId =
          await txn.insert(tableSurveyTarget, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<SurveyTarget> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableSurveyTarget, record);
    }

    //await batch.commit(noResult: true);
  }

  Future close() async => database.close();
}
