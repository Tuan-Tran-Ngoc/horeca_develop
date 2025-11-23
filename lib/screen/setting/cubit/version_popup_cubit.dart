import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:horeca/utils/call_api_utils.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/model/response/version_response.dart';
import 'package:horeca_service/network/apis.dart';
import 'package:meta/meta.dart';
import 'package:horeca_service/sqflite_database/dto/version_dto.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

part 'version_popup_state.dart';

class VersionPopupCubit extends Cubit<VersionPopupState> {
  VersionPopupCubit() : super(VersionPopupInitial());
  late SharedPreferences prefs;

  Future<void> init() async {
    String? versionCurrent;
    String? versionApp;
    String? urlDownload;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    versionCurrent = packageInfo.version;

    CallApiUtils<VersionResponse> callApiUtils = CallApiUtils();
    APIResponseEntity<VersionResponse> responseApk = await callApiUtils
        .callApiGetMethod(APIs.getApk, {}, VersionResponse.fromJson);

    if (responseApk.data != null) {
      final VersionResponse response = responseApk.data!;
      versionApp = response.version;
      urlDownload = response.masterUrlFile;
    }

    VersionDto versionInfo = VersionDto(
        versionCurrent: versionCurrent,
        versionApp: versionApp,
        urlDownload: urlDownload);

    emit(LoadingInitVersionSuccess(versionInfo));
  }

  Future<void> upgradeVersionApp(String? urlDownload) async {
    emit(EventUpradeVersionApp());
    String filePath = await downloadApk(urlDownload ?? '');

    // await AppInstaller.installApk(filePath, actionRequired: true);

    print('filePath apk: $filePath');

    emit(UpgradeVersionAppSuccess(filePath));
  }

  Future<String> downloadApk(String url) async {
    prefs = await SharedPreferences.getInstance();
    String filePath = '';
    final headers = <String, String>{
      'Authorization': 'Bearer ${prefs.getString('token')}',
    };
    final getDownloadResponse =
        await http.get(Uri.parse(url), headers: headers);
    if (getDownloadResponse.statusCode == 200) {
      // Get the app's temporary directory to store the downloaded file
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;

      // Replace 'downloaded_file.txt' with the desired filename
      String masterUrlFile = 'app-release.apk';
      filePath = '$tempPath/$masterUrlFile';

      // Write the content of the response to the file
      final File file =
          await File(filePath).writeAsBytes(getDownloadResponse.bodyBytes);

      print('File downloaded successfully at: $file');
      // await unzipFile(file.path, type);
    }
    return filePath;
  }
}
