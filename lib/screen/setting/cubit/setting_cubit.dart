import 'dart:convert';
import 'dart:io';
import 'package:bcrypt/bcrypt.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
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

    String? userName = prefs.getString(Session.username.toString());
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
        String? userName = prefs.getString(Session.username.toString());
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
    prefs.setString(Session.languageCode.toString(), languageCode);
    if (languageCode == 'vi') {
      newLocale = const Locale('vi', 'VN');
    } else {
      newLocale = const Locale('en', 'US');
    }
    message = multiLang.changeLanguageSuccess;
    emit(ChangeLanguageSuccessful(newLocale, message));
  }
}
