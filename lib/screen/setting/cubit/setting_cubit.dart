import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:horeca/language_setting.dart';
import 'package:horeca/utils/call_api_utils.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca_service/contants/network.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/model/request/change_password_request.dart';
import 'package:horeca_service/network/apis.dart';
import 'package:horeca_service/sqflite_database/dto/change_password_dto.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:horeca_service/sqflite_database/dto/setting_dto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:unique_identifier/unique_identifier.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  final BuildContext context;
  SettingCubit(this.context) : super(SettingInitial());
  late SharedPreferences prefs;
  AccountProvider accountProvider = AccountProvider();
  LanguageProvider languageProvider = LanguageProvider();
  DatabaseProvider db = DatabaseProvider();
  late Database database;
  String message = "";
  Future<void> init() async {
    //emit(LoadingInit(lstDataSynchornize))
    prefs = await SharedPreferences.getInstance();

    String? userName = prefs.getString('username');
    String? serverName = Network.url;
    String? indApp = await UniqueIdentifier.serial;
    List<String> lstLayoutType = [AppLocalizations.of(context)!.defaultSetting];
    List<Language> lstLanguage = await languageProvider.select();
    String? languageCodeCurrent = lstLanguage
        .firstWhere((element) =>
            element.regionCode == LanguageSetting.locale.languageCode)
        .languageName;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    SettingDto result = SettingDto(
        userName: userName,
        versionName: version,
        serverName: serverName,
        indApp: indApp,
        lstLayoutType: lstLayoutType,
        lstlanguage: lstLanguage,
        languageCodeCurrent: languageCodeCurrent);

    emit(LoadingInitSuccess(result));
  }

  Future<void> changePassword(ChangePasswordDTO changePasswordDTO) async {
    emit(OnClickChangePassword());
    AppLocalizations multiLang = AppLocalizations.of(context)!;

    var connect = await Connectivity().checkConnectivity();
    try {
      if (connect == ConnectivityResult.none) {
        // throw "Vui lòng kết nối mạng để thực hiện thay đổi mật khẩu";
        message = multiLang.turnOnInternet(multiLang.changePassword);
        throw message;
      } else if (connect == ConnectivityResult.mobile ||
          connect == ConnectivityResult.wifi) {
        prefs = await SharedPreferences.getInstance();
        String? userName = prefs.getString('username');
        List<Account> lstAccount =
            await accountProvider.getAccountByUsername(userName!);
        if (lstAccount.isEmpty) {
          message = multiLang.notFound(multiLang.account);
          throw message;
        }

        Account currentAccount = lstAccount[0];
        validateChangePassword(changePasswordDTO, currentAccount.password!);

        database = await db.openSQFliteDatabase(DatabaseProvider.pathDb);
        await database.transaction((txn) async {
          CallApiUtils sendRequest = CallApiUtils();
          ChangePasswordRequest requestBody = ChangePasswordRequest(
              username: userName,
              currentPassword: changePasswordDTO.currentPassword,
              newPassword: changePasswordDTO.newPassword,
              confirmPassword: changePasswordDTO.confirmPassword);
          String requestBodyJson = jsonEncode(requestBody);
          await sendRequest.sendRequestAPI(
              APIs.changePassword, requestBodyJson);

          currentAccount.password =
              BCrypt.hashpw(changePasswordDTO.newPassword!, BCrypt.gensalt());
          currentAccount.updatedDate =
              DateFormat(Constant.dateTimeFormatter).format(DateTime.now());
          accountProvider.updatePassword(currentAccount, txn);
          message = [multiLang.changePassword, multiLang.success].join(" ");
          emit(ChangePasswordSuccessfully(message));
        });
      }
    } catch (error) {
      // print(error.runtimeType);
      emit(ChangePasswordFailed(error.toString()));
    }
  }

  void validateChangePassword(ChangePasswordDTO dto, String oldPassword) {
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    if (dto.currentPassword! == "") {
      message = multiLang.isNotBlank(multiLang.currentPassword);
      throw message;
    }
    if (dto.newPassword! == "") {
      message = multiLang.isNotBlank(multiLang.newPassword);
      throw message;
    }
    if (dto.confirmPassword! == "") {
      message = multiLang.isNotBlank(multiLang.confirmPassword);
      throw message;
    }
    if (!BCrypt.checkpw(dto.currentPassword!, oldPassword)) {
      message = multiLang.wrongCurrentPassword;
      throw message;
    }

    if (dto.confirmPassword! != dto.newPassword!) {
      message = multiLang.wrongConfirmPassword;
      throw message;
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    Locale newLocale;
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', languageCode);
    if (languageCode == 'vi') {
      newLocale = const Locale('vi', 'VN');
    } else {
      newLocale = const Locale('en', 'US');
    }
    message = multiLang.changeLanguageSuccess;
    emit(ChangeLanguageSuccessful(newLocale, message));
  }

  Future<void> exportDatabaseAndUpload() async {
    emit(ExportDatabaseLoading());
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    
    try {
      var connect = await Connectivity().checkConnectivity();
      if (connect == ConnectivityResult.none) {
        message = multiLang.turnOnInternet(multiLang.exportDatabase);
        throw message;
      }

      prefs = await SharedPreferences.getInstance();
      String? userName = prefs.getString('username');
      if (userName == null || userName.isEmpty) {
        throw 'User not logged in';
      }

      // Get database path
      var databasesPath = await getDatabasesPath();
      String dbPath = '$databasesPath/$userName/$userName.db';
      
      // Check if database exists
      File dbFile = File(dbPath);
      if (!await dbFile.exists()) {
        throw multiLang.notFound(multiLang.account);
      }

      // Create zip file
      String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      String zipFileName = '${userName}_database_$timestamp.zip';
      String zipPath = '$databasesPath/$userName/$zipFileName';
      
      // Create archive
      var encoder = ZipFileEncoder();
      encoder.create(zipPath);
      encoder.addFile(dbFile);
      encoder.close();

      // Upload via API
      CallApiUtils sendRequest = CallApiUtils();
      await sendRequest.uploadMultipartFile(
          APIs.uploadDatabase, zipPath, 'file');

      // Clean up zip file after upload
      File zipFile = File(zipPath);
      if (await zipFile.exists()) {
        await zipFile.delete();
      }

      message = multiLang.databaseExported;
      emit(ExportDatabaseSuccess(message));
    } catch (error) {
      print('Error exporting database: $error');
      emit(ExportDatabaseFailed(error.toString()));
    }
  }

  Future<void> exportDatabaseToDownloads() async {
    emit(ExportDatabaseLoading());
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    
    try {
      prefs = await SharedPreferences.getInstance();
      String? userName = prefs.getString('username');
      if (userName == null || userName.isEmpty) {
        throw 'User not logged in';
      }

      // Request storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      
      // For Android 11+ (API 30+), we need MANAGE_EXTERNAL_STORAGE permission
      if (Platform.isAndroid) {
        var manageStatus = await Permission.manageExternalStorage.status;
        if (!manageStatus.isGranted) {
          manageStatus = await Permission.manageExternalStorage.request();
          if (!manageStatus.isGranted) {
            throw 'Storage permission denied. Please grant storage permission in settings.';
          }
        }
      }

      // Get database path
      var databasesPath = await getDatabasesPath();
      String dbPath = '$databasesPath/$userName/$userName.db';
      
      // Check if database exists
      File dbFile = File(dbPath);
      if (!await dbFile.exists()) {
        throw 'Database file not found at: $dbPath';
      }

      // Get external storage directory (Download folder)
      Directory? downloadsDir;
      if (Platform.isAndroid) {
        // For Android, use the Downloads directory
        downloadsDir = Directory('/storage/emulated/0/Download');
        if (!await downloadsDir.exists()) {
          downloadsDir = Directory('/storage/emulated/0/Downloads');
        }
      } else {
        // For iOS, use the Documents directory
        downloadsDir = await getApplicationDocumentsDirectory();
      }
      
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      // Create timestamped filename
      String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      String exportFileName = '${userName}_database_$timestamp.db';
      String exportPath = '${downloadsDir.path}/$exportFileName';
      
      // Copy database file to Downloads folder
      await dbFile.copy(exportPath);
      
      print('Database exported successfully to: $exportPath');
      message = 'Database exported to Downloads: $exportFileName';
      emit(ExportDatabaseSuccess(message));
    } catch (error) {
      print('Export database to downloads failed: ${error.toString()}');
      emit(ExportDatabaseFailed(error.toString()));
    }
  }
}
