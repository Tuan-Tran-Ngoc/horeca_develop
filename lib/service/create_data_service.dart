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
    print('========== START createData ==========');
    try {
      CallApiUtils<InitDataResponse> callApiUtils = CallApiUtils();
      Map<String, dynamic> queryParams = {};
      prefs = await SharedPreferences.getInstance();
      
      // Check token exists
      String? token = prefs.getString(Session.token.toString());
      int? baPositionId = prefs.getInt(Session.baPositionId.toString());
      String? username = prefs.getString(Session.username.toString());
      
      print('Token: ${token != null ? "EXISTS (${token.substring(0, 20)}...)" : "NULL"}');
      print('BA Position ID: $baPositionId');
      print('Username: $username');
      
      if (token == null || token.isEmpty) {
        print('ERROR: Token is null or empty');
        return 'Token not found. Please login again.';
      }
      
      if (baPositionId == null) {
        print('ERROR: BA Position ID is null');
        return 'BA Position ID not found. Please login again.';
      }
      
      queryParams['baPositionId'] = baPositionId.toString();
      print('Query params: $queryParams');
      
      print('Calling getInitData API...');
      APIResponseEntity<InitDataResponse> getInitResponse = APIResponseEntity();
      getInitResponse = await callApiUtils.callApiGetMethod(
          APIs.getInitData, queryParams, InitDataResponse.fromJson);
      print('GetInitData API response received');

      if (getInitResponse.data != null) {
        final InitDataResponse response = getInitResponse.data!;
        print('Master URL File: ${response.masterUrlFile}');
        print('BA URL File: ${response.baUrlFile}');
        print('Date Create File: ${response.dateCreateFile}');
        
        print('Downloading and unzipping masterdata...');
        await downloadUnzip(response.masterUrlFile.toString(), 'masterdata');
        print('Masterdata download complete');
        
        print('Downloading and unzipping salesmandata...');
        await downloadUnzip(response.baUrlFile.toString(), 'salesmandata');
        print('Salesmandata download complete');
        
        try {
          print('Initializing data...');
          InitialDataService initialDataService = InitialDataService();
          bool isInitData = await initialDataService
              .initData(response.dateCreateFile ?? '');
          print('InitData result: $isInitData');

          prefs = await SharedPreferences.getInstance();
          String username =
              prefs.getString(Session.username.toString()) ?? '';
          print('Username for file copy: $username');
          
          //copy file
          final Directory tempDir = await getTemporaryDirectory();
          final String tempPathMaster = '${tempDir.path}/masterdata';
          final String tempPathSalesman =
              '${tempDir.path}/salesmandata';
          var databasesPath = await getDatabasesPath();
          
          print('Copying masterPhoto...');
          await copyDirectory('$tempPathMaster/masterPhoto',
              '$databasesPath/$username/masterPhoto');
          
          print('Copying lib...');
          await copyDirectory(
              '$tempPathMaster/lib', '$databasesPath/$username/lib');
          
          print('Copying WebFolder...');
          await copyDirectory('$tempPathSalesman/WebFolder',
              '$databasesPath/$username/genHtml');
          
          print('Copying genHtml...');
          await copyDirectory('$tempPathSalesman/genHtml',
              '$databasesPath/$username/genHtml');
          
          print('All files copied successfully');
        } catch (err, stackTrace) {
          print('ERROR in initData/copyDirectory: $err');
          print('StackTrace: $stackTrace');
          
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
          
          print('Sending error log to server...');
          CallApiUtils<dynamic> sendRequestAPI =
              CallApiUtils<dynamic>();
          APIResponseHeader responselatest = await sendRequestAPI
              .sendRequestAPI(APIs.syncLogging, requestBodyJson);
          print('Error log sent: ${responselatest.toString()}');
          
          throw err.toString();
        }

        print('Loading messages...');
        await MessageUtils.loadMessagesIfNeeded();
        print('Loading code list...');
        await CodeListUtils.loadCodeListIfNeeded();
        print('Messages and code list loaded');
      } else {
        print('ERROR: getInitResponse.data is null');
        return 'Failed to get init data from server';
      }
      
      print('========== END createData SUCCESS ==========');
    } catch (error, stackTrace) {
      print('========== ERROR in createData ==========');
      print('Error: $error');
      print('StackTrace: $stackTrace');
      print('========== END createData ERROR ==========');
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
