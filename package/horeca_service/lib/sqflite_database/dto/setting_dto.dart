import 'package:chopper/chopper.dart';
import 'package:horeca_service/sqflite_database/model/m_language.dart';

class SettingDto {
  String? userName;
  String? versionName;
  String? serverName;
  String? indApp;
  List<String> lstLayoutType;
  List<Language> lstlanguage;
  String? languageCodeCurrent;

  SettingDto(
      {this.userName,
      this.versionName,
      this.serverName,
      this.indApp,
      required this.lstLayoutType,
      required this.lstlanguage,
      this.languageCodeCurrent});
}
