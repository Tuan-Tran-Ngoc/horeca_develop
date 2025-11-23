import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/s_survey_result.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class SurveyResultProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableSurveyResult() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableSurveyResult ( 
          $columnSurveyResultId integer primary key AUTOINCREMENT,
          $columnSurveyResultIdSync integer, 
          $columnSurveyId integer,
          $columnSurveyQuestionId integer,
          $columnSurveyAnswerId integer,
          $columnSurveyAnswer text,
          $columnSurveyDate text,
          $columnResultDetail text,
          $columnBaPositionId integer,
          $columnEmployeeId integer,
          $columnEmployeeName text,
          $columnSupPositionId integer,
          $columnCustomerVisitId integer,
          $columnCityLeaderPositionId integer,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedDate text ,
          $columnUpdatedBy integer,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<SurveyResult> insert(SurveyResult record, Transaction txn) async {
    record.surveyResultId = await txn.insert(tableSurveyResult, record.toMap());

    return record;
  }

  Future insertMultipleRow(List<SurveyResult> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMapSync()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableSurveyResult, record);
    }

    //await batch.commit(noResult: true);
  }

  Future<SurveyResult?> findById(int surveyResultID, Transaction? txn) async {
    String query =
        'SELECT * FROM $tableSurveyResult WHERE $columnSurveyResultId = $surveyResultID';
    List<Map> resultsMap = [];
    if (txn != null) {
      resultsMap = await txn.rawQuery(query);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      resultsMap = await database.rawQuery(query);
    }
    if (resultsMap.isNotEmpty) {
      return SurveyResult.fromMap(resultsMap.first);
    }

    return null;
  }

  Future<int> updateSyncId(SurveyResult surveyResult, Transaction? txn) async {
    if (txn != null) {
      return await txn.update(
          tableSurveyResult,
          {
            columnSurveyResultIdSync: surveyResult.surveyResultIdSync,
            columnUpdatedDate: surveyResult.updatedDate,
            columnUpdatedBy: surveyResult.updatedBy
          },
          where: '$columnSurveyResultId = ?',
          whereArgs: [surveyResult.surveyResultId]);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      return await database.update(
          tableSurveyResult,
          {
            columnSurveyResultIdSync: surveyResult.surveyResultIdSync,
            columnUpdatedDate: surveyResult.updatedDate,
            columnUpdatedBy: surveyResult.updatedBy
          },
          where: '$columnSurveyResultId = ?',
          whereArgs: [surveyResult.surveyResultId]);
    }
  }

  Future close() async => database.close();
}
