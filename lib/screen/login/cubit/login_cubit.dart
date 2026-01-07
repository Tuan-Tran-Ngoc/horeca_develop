import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:horeca/service/create_data_service.dart';
import 'package:horeca/service/initial_data_service.dart';
import 'package:horeca/service/update_data_service.dart';
import 'package:horeca/utils/call_api_utils.dart';
import 'package:horeca/utils/code_list_utils.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca/utils/message_utils.dart';
import 'package:horeca_service/contants/network.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/network/apis.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:platform_device_id/platform_device_id.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final BuildContext context;
  LoginCubit(this.context) : super(LoginInitial());
  late SharedPreferences prefs;
  bool isExistDb = false;
  DatabaseProvider db = DatabaseProvider();
  CreateDataService createDataService = CreateDataService();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  String message = "";

  RouteAssignmentProvider routeAssignmentProvider = RouteAssignmentProvider();
  Future<void> initLogin() async {
    emit(ReloadForm());

    prefs = await SharedPreferences.getInstance();
    TargetPlatform platform = defaultTargetPlatform;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    String? username = await storage.read(key: 'username');
    String? password = await storage.read(key: 'password');

    print('username: $username');
    print('pass: $password');

    emit(LoginInitialSucess('', version, username ?? '', password ?? ''));
  }

  Future<void> tapSaveInfoLogin(bool isSaveInfoLogin) async {
    print('tap');

    emit(SaveInfoLoginSuccess(isSaveInfoLogin));
  }

  void tapObscure(bool isTapObscure) {
    print('tap');

    emit(TapObscureSuccess(isTapObscure));
  }

  Future<void> connectDatabase(String username) async {
    var path = await db.connectDatabase(username);
    DatabaseProvider.pathDb = path;
  }

  Future<void> firstInitData() async {
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    AccountProvider accountProvider = AccountProvider();
    print(
        'prefs.getString().toString(): ${prefs.getString(Session.username.toString()).toString()}');
    List<Account> accountLogin = await accountProvider.getAccountByUsername(
        prefs.getString(Session.username.toString()).toString());
    if (accountLogin.isEmpty) {
      emit(ReloadControl(multiLang.initializingData));

      String? errorStr = await createDataService.createData();

      emit(FirstInitDataSuccess(errorStr));
    }

    // update new data
    var connect = await Connectivity().checkConnectivity();
    if (connect == ConnectivityResult.wifi ||
        connect == ConnectivityResult.mobile) {
      UpdateDataService updateDataService = UpdateDataService();

      emit(ReloadControl(multiLang.updatingData));
      String message = await updateDataService.syncUpdateData(multiLang);
      emit(UpdateDataSuccess(message));
    }
    await MessageUtils.loadMessagesIfNeeded();
    await CodeListUtils.loadCodeListIfNeeded();
    emit(CheckInitialDataSuccess());
  }

  Future<void> downloadUnzip(String masterUrlFile, String type) async {
    final headers = <String, String>{
      'Authorization': 'Bearer ${prefs.getString(Session.token.toString())}',
      // Add other headers as needed
    };
    final getDownloadResponse = await http.get(
        Uri.parse(
            '${Network.url}/api/downloadFile?dataType=$type&fileName=$masterUrlFile'),
        headers: headers);
    // final responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    // print(getDownloadResponse.body);
    if (getDownloadResponse.statusCode == 200) {
      // Get the app's temporary directory to store the downloaded file
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;

      // Replace 'downloaded_file.txt' with the desired filename
      final String filePath = '$tempPath/$masterUrlFile';

      // Write the content of the response to the file
      final File file =
          await File(filePath).writeAsBytes(getDownloadResponse.bodyBytes);

      print('File downloaded successfully at: $file');
      await unzipFile(file.path, type);
    }
  }

  Future<void> submitEvent(String username, String password) async {
    //emit(ReloadControl());
    emit(StartSubmitEvent());
    AppLocalizations multiLang = AppLocalizations.of(context)!;
    var connect = await Connectivity().checkConnectivity();

    AccountProvider accountProvider = AccountProvider();

    prefs = await SharedPreferences.getInstance();

    if (connect == ConnectivityResult.none) {
      print('connect wifi: none');
      isExistDb = await db.isExistDatabase(username);

      if (!isExistDb) {
        emit(const LoginFailed(error: 'Vui lòng kết nối internet.'));
        return;
      }
      await connectDatabase(username);
      List<Account> lstAccLgn =
          await accountProvider.getAccountByUsername(username);
      if (lstAccLgn.isEmpty ||
          lstAccLgn[0].password == null ||
          lstAccLgn[0].password!.isEmpty) {
        message = [
          [multiLang.login, multiLang.failed].join(" "),
          multiLang.tryAgain
        ].join(".\n");
        emit(LoginFailed(error: message));
        return;
      }
      Account accLgn = lstAccLgn[0];

      String hashedPassword = accLgn.password ?? '';
      if (BCrypt.checkpw(password, hashedPassword)) {
        AccountPositionLinkProvider accountPositionLinkProvider =
            AccountPositionLinkProvider();
        List<AccountPositionLink> lstAccPos = await accountPositionLinkProvider
            .getInfoByAccountId(accLgn.accountId ?? 0);

        if (lstAccPos.isEmpty) {
          message = [
            [multiLang.login, multiLang.failed].join(" "),
            multiLang.tryAgain
          ].join(".\n");
          emit(LoginFailed(error: message));
          return;
        }
        AccountPositionLink accPos = lstAccPos[0];
        prefs.setInt(Session.baPositionId.toString(), accPos.positionId ?? 0);
        prefs.setString(Session.username.toString(), accLgn.username ?? '');
        message = [multiLang.login, multiLang.success].join(" ");
        await saveCredentials(username, password);
        emit(LoginSuccess(message));
      } else {
        message = [
          [multiLang.login, multiLang.failed].join(" "),
          multiLang.tryAgain
        ].join(".\n");
        emit(LoginFailed(error: message));
        return;
      }
    } else if (connect == ConnectivityResult.wifi ||
        connect == ConnectivityResult.mobile) {
      print('connect wifi: true');
      try {
        print(LoginRequest(username, password).password);
        String? imeiDevice = await UniqueIdentifier.serial;

        CallApiUtils callApiUtils = CallApiUtils();
        Map<String, String> params = {
          'username': username,
          'password': password,
          'grant_type': 'password',
          'imeiDevice': imeiDevice ?? ''
        };
        LoginResponse? credential = await callApiUtils
            .callApiPostMethodWithUrlencoded(APIs.oauth, params);

        if (credential != null && credential.accessToken != null) {
          print(credential.accessToken);

          prefs.setString(Session.token.toString(), credential.accessToken!);
          prefs.setString(
              Session.dateLogin.toString(),
              DateFormat(Constant.dateFormatterYYYYMMDD)
                  .format(DateTime.now()));

          if (prefs.get(Session.refreshToken.toString()) == null) {
            prefs.setString(
                Session.refreshToken.toString(), credential.refreshToken!);
          }
          if (credential.authenResponse?.baPositionId != null) {
            prefs.setInt(Session.baPositionId.toString(),
                credential.authenResponse!.baPositionId!);
            prefs.setString(Session.username.toString(),
                credential.authenResponse!.userName ?? '');
            NetworkService.addAuthorizationHeader(
                'Bearer ${credential.accessToken}');

            String username = (credential.authenResponse!.userName) ?? '';
            isExistDb = await db.isExistDatabase(username);
            InitialDataService initialDataService = InitialDataService();
            print(isExistDb);
            if (isExistDb) {
              await connectDatabase(username);
            } else {
              await initialDataService.createTable();
            }
          }

          message = [multiLang.login, multiLang.success].join(" ");

          await saveCredentials(username, password);
          emit(LoginSuccess(message));
        } else {
          emit(LoginFailed(error: multiLang.loginFail));
        }

        // message = [multiLang.login, multiLang.success].join(" ");

        // emit(LoginSuccess(message));
      } catch (e, trace) {
        print('ERROR : ${e.toString()}');
        print('TRACE : ${trace.toString()}');
        // emit(const LoginFailed());
        emit(LoginFailed(error: e.toString()));
      }
    }

    print('response');
  }

  Future<void> unzipFile(String zipFilePath, String type) async {
    // Read the Zip file from disk.
    final bytes = File(zipFilePath).readAsBytesSync();

    // Decode the Zip file
    final archive = ZipDecoder().decodeBytes(bytes);
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = '${tempDir.path}/$type';
    print('tempPath: $tempPath');
    // delete old folder
    final Directory oldDirectory = Directory(tempPath);
    if (await oldDirectory.exists()) {
      await oldDirectory.delete(recursive: true);
    }
    final Directory newDirectory = Directory(tempPath);
    await newDirectory.create(recursive: true);
    // Extract the contents of the Zip archive to disk.
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File('$tempPath/$filename')
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory('$tempPath/$filename').create(recursive: true);
      }
    }
  }

  Future<void> copyDirectory(String sourcePath, String destinationPath) async {
    try {
      // check sourcePath exist
      if (!await Directory(sourcePath).exists()) {
        print('tempPath: $sourcePath not exisit');
        return;
      }

      // Lấy danh sách tất cả các tệp và thư mục trong thư mục nguồn
      List<FileSystemEntity> entities =
          Directory(sourcePath).listSync(recursive: true);

      //override old directory
      await Directory(destinationPath).create(recursive: true);

      // Sao chép từng tệp và thư mục sang thư mục đích
      for (var entity in entities) {
        String newPath = entity.path.replaceFirst(sourcePath, destinationPath);
        if (entity is Directory) {
          await Directory(newPath).create(recursive: true);
        } else if (entity is File) {
          await entity.copy(newPath);
        }
      }
    } catch (e) {
      print(
          'Initial data: Copy Directory Fail $sourcePath -> $destinationPath: ${e.toString()}');
    }
  }

  Future<void> saveCredentials(String username, String password) async {
    await deleteCredentials();
    await storage.write(key: 'username', value: username);
    await storage.write(key: 'password', value: password);
  }

  Future<void> deleteCredentials() async {
    await storage.delete(key: 'username');
    await storage.delete(key: 'password');
  }
}
