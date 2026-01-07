import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:horeca/service/initial_data_service.dart';
import 'package:horeca/utils/call_api_utils.dart';
import 'package:horeca/utils/code_list_utils.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca/utils/message_utils.dart';
import 'package:horeca_service/contants/network.dart';
import 'package:horeca_service/model/request/update_latest_request.dart';
import 'package:horeca_service/model/response/api_response_entity.dart';
import 'package:horeca_service/model/response/api_response_header.dart';
import 'package:horeca_service/model/response/init_data_response.dart';
import 'package:horeca_service/network/apis.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:unique_identifier/unique_identifier.dart';

class CreateDataService {
  late SharedPreferences prefs;

  Future<String?> createData() async {
    try {
      CallApiUtils<InitDataResponse> callApiUtils = CallApiUtils();
      Map<String, dynamic> queryParams = {};
      prefs = await SharedPreferences.getInstance();
      queryParams['baPositionId'] =
          prefs.getInt(Session.baPositionId.toString()).toString();
      APIResponseEntity<InitDataResponse> getInitResponse = APIResponseEntity();
      getInitResponse = await callApiUtils.callApiGetMethod(
          APIs.getInitData, queryParams, InitDataResponse.fromJson);

      if (getInitResponse.data != null) {
        final InitDataResponse response = getInitResponse.data!;
        await downloadUnzip(response.masterUrlFile.toString(), 'masterdata')
            .then((value) =>
                downloadUnzip(response.baUrlFile.toString(), 'salesmandata')
                    .then((value) async {
                  try {
                    InitialDataService initialDataService =
                        InitialDataService();
                    bool isInitData = await initialDataService
                        .initData(response.dateCreateFile ?? '');

                    prefs = await SharedPreferences.getInstance();
                    String username =
                        prefs.getString(Session.username.toString()) ?? '';
                    //copy file
                    final Directory tempDir = await getTemporaryDirectory();
                    final String tempPathMaster = '${tempDir.path}/masterdata';
                    final String tempPathSalesman =
                        '${tempDir.path}/salesmandata';
                    var databasesPath = await getDatabasesPath();
                    await copyDirectory('$tempPathMaster/masterPhoto',
                        '$databasesPath/$username/masterPhoto');
                    await copyDirectory(
                        '$tempPathMaster/lib', '$databasesPath/$username/lib');
                    await copyDirectory('$tempPathSalesman/WebFolder',
                        '$databasesPath/$username/genHtml');
                    await copyDirectory('$tempPathSalesman/genHtml',
                        '$databasesPath/$username/genHtml');
                  } catch (err) {
                    String? imeiDevice = await UniqueIdentifier.serial;
                    MappingErrorObject errorLog = MappingErrorObject(
                        objectFail: 'initialData', log: err.toString());
                    UpdateLatestRequest requestLastest = UpdateLatestRequest(
                        positionId:
                            prefs.getInt(Session.baPositionId.toString()),
                        imei: imeiDevice,
                        updateDate: response.dateCreateFile,
                        updateStatus: '01',
                        mappingErrorObject: errorLog);
                    String requestBodyJson = jsonEncode(requestLastest);
                    CallApiUtils<dynamic> sendRequestAPI =
                        CallApiUtils<dynamic>();
                    APIResponseHeader responselatest = await sendRequestAPI
                        .sendRequestAPI(APIs.syncLogging, requestBodyJson);
                    throw err.toString();
                    // emit(FirstInitDataSuccess(false));
                  }
                }));

        await MessageUtils.loadMessagesIfNeeded();
        await CodeListUtils.loadCodeListIfNeeded();
      }
    } catch (error) {
      return error.toString();
    }

    return null;
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
}
