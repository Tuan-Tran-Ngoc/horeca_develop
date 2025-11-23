import 'package:horeca_service/sqflite_database/dto/survey_dto.dart';
import 'package:horeca_service/sqflite_database/model/m_survey.dart';
import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/sql/sql_query.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class SurveyProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableSurvey() async {
    try {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);

      await database.execute('''
        create table $tableSurvey ( 
          $columnSurveyId integer primary key, 
          $columnSurveyCode text not null,
          $columnSurveyTitle text,
          $columnDescription text,
          $columnStartDate text,
          $columnEndDate text,
          $columnStatus text,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text ,
          $columnVersion integer)
        ''');
    } finally {
      await database.close();
    }
    // db.close();
  }

  Future<Survey> insert(Survey survey) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      survey.surveyId = await txn.insert(tableSurvey, survey.toMap());
      print('insert data $tableSurvey: ${survey.surveyId}');
    });

    return survey;
  }

  Future insertMultipleRow(List<Survey> listSurvey, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var listSurveys = listSurvey.map((data) => data.toMap()).toList();

    //var batch = database.batch();
    listSurveys.forEach((data) async {
      batch.insert(tableSurvey, data);
    });
    //await batch.commit(noResult: true);
  }

  Future<Survey?> getSurvey(int id, Transaction? txn) async {
    List<Map> maps = [];
    if (txn != null) {
      maps = await txn.query(tableSurvey,
          columns: [columnSurveyId, columnSurveyCode, columnSurveyTitle],
          where: '$columnSurveyId = ?',
          whereArgs: [id]);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      maps = await database.query(tableSurvey,
          columns: [columnSurveyId, columnSurveyCode, columnSurveyTitle],
          where: '$columnSurveyId = ?',
          whereArgs: [id]);
    }
    if (maps.isNotEmpty) {
      return Survey.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Survey>> getAllSurvey() async {
    List<Survey> listSurvey = [];
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    List<Map> maps = await database.query(
      tableSurvey,
      columns: [
        columnSurveyId,
        columnSurveyCode,
        columnSurveyTitle,
        columnDescription,
        columnStartDate,
        columnEndDate,
        columnCreatedBy,
        columnCreatedDate,
        columnUpdatedBy,
        columnUpdatedDate,
        columnVersion,
        columnStatus
      ],
    );
    if (maps.isNotEmpty) {
      for (final item in maps) {
        print(item);
        listSurvey.add(Survey.fromMap(item));
      }
      return listSurvey;
    }
    return [];
  }

  Future<List<SurveyDto>> selectSurveyByCustomer(
      int customerId, int customerVisitId, Transaction? txn) async {
    List<SurveyDto> results = [];
    List<dynamic>? arg = [];
    List<Map> resultDBs = [];
    arg.add(customerId);
    arg.add(customerId);
    arg.add(customerId);
    arg.add(customerId);
    arg.add(customerVisitId);

    if (txn != null) {
      resultDBs = await txn.rawQuery(SQLQuery.SQL_SUR_001, arg);
    } else {
      database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
      resultDBs = await database.rawQuery(SQLQuery.SQL_SUR_001, arg);
    }

    if (resultDBs.isNotEmpty) {
      for (var result in resultDBs) {
        results.add(SurveyDto.fromMap(result));
      }
    }
    return results;
  }

  Future<int> delete(int id) async {
    return await database
        .delete(tableSurvey, where: '$columnSurveyId = ?', whereArgs: [id]);
  }

  Future<int> update(Survey survey) async {
    return await database.update(tableSurvey, survey.toMap(),
        where: '$columnSurveyId = ?', whereArgs: [survey.surveyId]);
  }

  Future close() async => database.close();
}
