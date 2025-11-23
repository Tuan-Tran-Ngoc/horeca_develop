import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static late Database database;
  static String pathDb = '';

  static Future<bool> doesFileExist(String filePath) async {
    File file = File(filePath);
    return await file.exists();
  }

  Future<bool> isExistDatabase(String username) async {
    var databasesPath = await getDatabasesPath();
    print('$databasesPath/$username');
    String path = join('$databasesPath/$username/', '$username.db');

    bool fileExists = await doesFileExist(path);
    if (fileExists) {
      print('File exists at $path');
    } else {
      print('File does not exist at $path');
    }
    return fileExists;
  }

  Future<String> createDatabase(String username) async {
    var databasesPath = await getDatabasesPath();
    print(databasesPath);
    String path = join('$databasesPath/$username/', '$username.db');

    if (await databaseExists(path)) {
      // Delete root folder
      await deleteDatabase(path);
      String rootFolder = '$databasesPath/$username';
      final directory = Directory(rootFolder);
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
    }

    // await deleteDatabase(path);
    await createSQFliteDatabase(path);
    // open the database
    return path;
  }

  Future<String> connectDatabase(String username) async {
    var databasesPath = await getDatabasesPath();
    String path = join('$databasesPath/$username', '$username.db');
    openSQFliteDatabase(path);
    // open the database
    return path;
  }

  Future<Database> openSQFliteDatabase(String path) async {
    return await openDatabase(path);
  }

  Future<Database> createSQFliteDatabase(String path) async {
    return await openDatabase(path,
        version: 1, onCreate: (Database db, int version) async {});
  }
}
