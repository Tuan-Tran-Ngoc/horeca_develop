import 'package:horeca_service/sqflite_database/model/common_column.dart';
import 'package:horeca_service/sqflite_database/model/m_membership.dart';
import 'package:sqflite/sqflite.dart';

import 'package:horeca_service/sqflite_database/provider/database_provider.dart';

class MembershipProvider {
  late Database database;
  DatabaseProvider db = DatabaseProvider();

  Future createTableMembership() async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.execute('''
        create table $tableMembership ( 
          $columnMembershipRecordId integer primary key, 
          $columnMembershipId integer,
          $columnMembershipCode text,
          $columnMembershipName text,
          $columnCustomerVisitId text,
          $columnStatus text,
          $columnTelNo text,
          $columnBirthdate text,
          $columnProvinceId integer,
          $columnDistrictId integer,
          $columnWardId integer,
          $columnStreetName text,
          $columnAddressDetail text,
          $columnTotalPoint double,
          $columnUsedPoint double,
          $columnCurrentPoint double,
          $columnRemark text,
          $columnBaPositionId integer,
          $columnCreatedBy integer,
          $columnCreatedDate text,
          $columnUpdatedBy integer,
          $columnUpdatedDate text,
          $columnVersion integer)
        ''');
    // db.close();
  }

  Future<Membership> insert(Membership record) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    await database.transaction((txn) async {
      record.membershipRecordId =
          await txn.insert(tableMembership, record.toMap());
    });

    return record;
  }

  Future insertMultipleRow(List<Membership> records, Batch batch) async {
    database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
    var recordsMap = records.map((data) => data.toMap()).toList();

    //var batch = database.batch();

    for (var record in recordsMap) {
      batch.insert(tableMembership, record);
    }

    //await batch.commit(noResult: true);
  }

  Future close() async => database.close();
}
