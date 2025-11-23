import 'dart:convert';

import 'package:horeca/utils/constants.dart';
import 'package:horeca/utils/message_utils.dart';
import 'package:horeca_service/contants/network.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/model/response/api_response_entity.dart';
import 'package:horeca_service/model/response/api_response_header.dart';
import 'package:horeca_service/sqflite_database/dto/error_info_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CallApiUtils<T> {
  Future<APIResponseEntity<T>> callApiPostMethod(String pathApi,
      String jsonRequest, T Function(Map<String, dynamic>)? fromJson) async {
    APIResponseEntity<T> result = APIResponseEntity();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String uri = Network.url + pathApi;

      final response = await http
          .post(Uri.parse(uri),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json'
              },
              body: jsonRequest)
          .timeout(const Duration(seconds: Constant.REQUEST_TIMMEOUT),
              onTimeout: () => throw 'Error: Request timeout');

      Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (responseBody['error'] != null) {
        if (responseBody['error'] is Map) {
          ErrorInfoDTO? errorInfo = ErrorInfoDTO.fromJson(
              responseBody['error'] as Map<String, dynamic>);
          String? mess = MessageUtils.getMessages(
              code: errorInfo.code, args: errorInfo.parameter);
          print('mess in call api $mess');
          // throw result.error!;
          throw mess;
        } else {
          throw MessageUtils.getMessages(code: 'err.sys.0205');
        }
      }

      result = APIResponseEntity<T>.fromJson(responseBody, fromJson);
    } catch (error) {
      print('Error: callAPI [$pathApi] request [$jsonRequest]');
      print(error);
      rethrow;
    }
    return result;
  }

  Future<APIResponseHeader> sendRequestAPI(
      String path, String jsonBodyRequest) async {
    APIResponseHeader result = APIResponseHeader();

    try {
      print('jsonBodyRequest $jsonBodyRequest');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String url = Network.url + path;
      final response = await http
          .post(Uri.parse(url),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-type': 'application/json'
              },
              body: jsonBodyRequest)
          .timeout(const Duration(seconds: Constant.REQUEST_TIMMEOUT),
              onTimeout: () => throw 'Error: Request timeout');
      // print(jsonDecode(response.body)['error']);
      Map<String, dynamic> body = jsonDecode(response.body);

      if (body['error'] != null) {
        if (body['error'] is Map) {
          ErrorInfoDTO? errorInfo =
              ErrorInfoDTO.fromJson(body['error'] as Map<String, dynamic>);

          String? mess = MessageUtils.getMessages(
              code: errorInfo?.code, args: errorInfo?.parameter);
          print('mess in call api $mess');
          // throw result.error!;
          throw mess;
        } else {
          // String new_access_token =
          //     await refreshAccessToken(prefs.get('refresh_token'));
          // prefs.setString('token', new_access_token);
          // return await sendRequestAPI(path, jsonBodyRequest);
          throw MessageUtils.getMessages(code: Constant.SESSION_LOGIN_EXPIRED);
        }
      }
      result = APIResponseHeader.fromJson(body);
    } catch (error) {
      rethrow;
    }
    return result;
  }

  Future<String> refreshAccessToken(dynamic refreshToken) async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    if (prefs.get('refresh_token') == null) {
      throw MessageUtils.getMessages(code: Constant.SESSION_LOGIN_EXPIRED);
    }
    String url =
        '${Network.url}/oauth/token?grant_type=refresh_token&refresh_token=$refreshToken';
    http.Response response = await http.post(Uri.parse(url), headers: {
      'Authorization': 'Basic Y2xpZW50X2lkOmNsaWVudF9zZWNyZXQ=',
      'Content-Type': 'application/x-www-form-urlencoded'
    });
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    if (responseBody['access_token'] == null) {
      throw MessageUtils.getMessages(code: Constant.SESSION_LOGIN_EXPIRED);
    }
    return responseBody['access_token'];
  }

  Future<LoginResponse?> callApiPostMethodWithUrlencoded(
      String pathApi, Map<String, String> params) async {
    LoginResponse? result;
    try {
      String uri = Network.url + pathApi;
      String auth = 'Basic Y2xpZW50X2lkOmNsaWVudF9zZWNyZXQ=';

      final response = await http
          .post(Uri.parse(uri),
              headers: {
                'Authorization': auth,
                'Content-Type': 'application/x-www-form-urlencoded'
              },
              body: params)
          .timeout(const Duration(seconds: Constant.REQUEST_TIMMEOUT),
              onTimeout: () => throw Exception('Error: Request timeout'));

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody['errorInfo'] != null) {
        throw responseBody['errorInfo']['errorMessage'];
      }
      result = LoginResponse.fromJson(responseBody);
    } catch (error) {
      print(error);
      rethrow;
    }
    return result;
  }

  Future<APIResponseEntity<T>> callApiGetMethod(
    String pathApi,
    Map<String, dynamic>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
  ) async {
    APIResponseEntity<T> result = APIResponseEntity();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String uri = Network.url + pathApi;

      // Append query parameters to the URL
      if (queryParams != null) {
        uri +=
            '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}';
      }

      final response = await http.get(
        Uri.parse(uri),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: Constant.REQUEST_TIMMEOUT),
        onTimeout: () => throw 'Error: Request timeout',
      );

      Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (responseBody['error'] != null) {
        if (responseBody['error'] is Map) {
          ErrorInfoDTO? errorInfo = ErrorInfoDTO.fromJson(
              responseBody['error'] as Map<String, dynamic>);
          String? mess = MessageUtils.getMessages(
              code: errorInfo.code, args: errorInfo.parameter);
          print('mess in call api $mess');
          throw mess;
        } else {
          throw MessageUtils.getMessages(code: 'err.sys.0205');
        }
      }

      result = APIResponseEntity<T>.fromJson(responseBody, fromJson);
    } catch (error) {
      print('Error: callAPI [$pathApi]');
      print(error);
      rethrow;
    }
    return result;
  }
}
