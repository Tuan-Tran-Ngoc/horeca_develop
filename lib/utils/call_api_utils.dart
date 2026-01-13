import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:horeca/l10n/app_localizations.dart';
import 'package:horeca/service/navigation_service.dart';
import 'package:horeca/utils/api_exceptions.dart';
import 'package:horeca/utils/constants.dart';
import 'package:horeca/utils/message_utils.dart';
import 'package:horeca_service/contants/network.dart';
import 'package:horeca_service/horeca_service.dart';
import 'package:horeca_service/model/response/api_response_entity.dart';
import 'package:horeca_service/model/response/api_response_header.dart';
import 'package:horeca_service/sqflite_database/dto/error_info_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// API utility class that handles all HTTP requests with comprehensive error handling
/// Uses Flutter localization for user-friendly error messages

class CallApiUtils<T> {
  /// Get localized error message
  /// If apiMessage is provided, it takes priority over localized messages
  String _getLocalizedMessage(String key, {String? apiMessage}) {
    // If API message is provided and not empty, use it first
    if (apiMessage != null && apiMessage.isNotEmpty) {
      return apiMessage;
    }

    BuildContext? context = NavigationService.navigatorKey.currentContext;
    if (context != null) {
      final localizations = AppLocalizations.of(context);
      if (localizations != null) {
        switch (key) {
          case 'errorNoInternet':
            return localizations.errorNoInternet;
          case 'errorTimeout':
            return localizations.errorTimeout;
          case 'errorBadRequest':
            return localizations.errorBadRequest;
          case 'errorUnauthorized':
            return localizations.errorUnauthorized;
          case 'errorForbidden':
            return localizations.errorForbidden;
          case 'errorNotFound':
            return localizations.errorNotFound;
          case 'errorServer':
            return localizations.errorServer;
          case 'errorServiceUnavailable':
            return localizations.errorServiceUnavailable;
          case 'errorParse':
            return localizations.errorParse;
          case 'errorUnknown':
            return localizations.errorUnknown;
          case 'errorSlowResponse':
            return localizations.errorSlowResponse;
          default:
            return localizations.errorUnknown;
        }
      }
    }
    // Fallback to English if context is not available
    return _getFallbackMessage(key);
  }

  /// Fallback messages in Vietnamese when context is not available
  String _getFallbackMessage(String key) {
    switch (key) {
      case 'errorNoInternet':
        return 'Không có kết nối Internet. Vui lòng kiểm tra cài đặt mạng.';
      case 'errorTimeout':
        return 'Yêu cầu hết thời gian chờ. Vui lòng thử lại.';
      case 'errorBadRequest':
        return 'Yêu cầu không hợp lệ. Vui lòng kiểm tra dữ liệu đầu vào.';
      case 'errorUnauthorized':
        return 'Chưa được ủy quyền. Vui lòng đăng nhập lại.';
      case 'errorForbidden':
        return 'Truy cập bị cấm. Bạn không có quyền.';
      case 'errorNotFound':
        return 'Không tìm thấy tài nguyên. Vui lòng kiểm tra URL.';
      case 'errorServer':
        return 'Lỗi máy chủ nội bộ. Vui lòng thử lại sau.';
      case 'errorServiceUnavailable':
        return 'Dịch vụ tạm thời không khả dụng. Vui lòng thử lại sau.';
      case 'errorParse':
        return 'Không thể phân tích phản hồi. Vui lòng liên hệ hỗ trợ.';
      case 'errorUnknown':
        return 'Đã xảy ra lỗi không mong muốn. Vui lòng thử lại.';
      case 'errorSlowResponse':
        return 'Phản hồi từ máy chủ quá chậm. Vui lòng kiểm tra kết nối.';
      default:
        return 'Đã xảy ra lỗi không mong muốn. Vui lòng thử lại.';
    }
  }

  /// Handle HTTP errors based on status code
  /// Accepts optional API error message and response body to extract error details
  void _handleHttpError(int statusCode,
      {String? apiMessage, Map<String, dynamic>? responseBody}) {
    // Try to extract error message from response body if available
    String? errorMessage = apiMessage;

    if (errorMessage == null && responseBody != null) {
      try {
        if (responseBody['error'] != null) {
          if (responseBody['error'] is Map) {
            ErrorInfoDTO? errorInfo = ErrorInfoDTO.fromJson(
                responseBody['error'] as Map<String, dynamic>);
            errorMessage = MessageUtils.getMessages(
                code: errorInfo.code, args: errorInfo.parameter);
          } else if (responseBody['error'] is String) {
            errorMessage = responseBody['error'];
          }
        } else if (responseBody['message'] != null) {
          errorMessage = responseBody['message'].toString();
        }
      } catch (e) {
        // If parsing fails, continue with localized message
      }
    }

    switch (statusCode) {
      case 400:
        throw BadRequestException(
            _getLocalizedMessage('errorBadRequest', apiMessage: errorMessage),
            code: Constant.ERROR_BAD_REQUEST);
      case 401:
        throw UnauthorizedException(
            _getLocalizedMessage('errorUnauthorized', apiMessage: errorMessage),
            code: Constant.ERROR_UNAUTHORIZED);
      case 403:
        throw ForbiddenException(
            _getLocalizedMessage('errorForbidden', apiMessage: errorMessage),
            code: Constant.ERROR_FORBIDDEN);
      case 404:
        throw NotFoundException(
            _getLocalizedMessage('errorNotFound', apiMessage: errorMessage),
            code: Constant.ERROR_NOT_FOUND);
      case 500:
        throw ServerException(
            _getLocalizedMessage('errorServer', apiMessage: errorMessage),
            code: Constant.ERROR_SERVER);
      case 503:
        throw ServiceUnavailableException(
            _getLocalizedMessage('errorServiceUnavailable',
                apiMessage: errorMessage),
            code: Constant.ERROR_SERVICE_UNAVAILABLE);
      default:
        throw UnknownException(
            _getLocalizedMessage('errorUnknown', apiMessage: errorMessage),
            code: Constant.ERROR_UNKNOWN);
    }
  }

  /// Handle various exceptions and convert to user-friendly messages
  void _handleException(dynamic error) {
    if (error is SocketException) {
      throw NoInternetException(_getLocalizedMessage('errorNoInternet'),
          code: Constant.ERROR_NO_INTERNET);
    } else if (error is TimeoutException) {
      throw TimeoutException(_getLocalizedMessage('errorTimeout'),
          code: Constant.ERROR_TIMEOUT);
    } else if (error is FormatException) {
      throw ParseException(_getLocalizedMessage('errorParse'),
          code: Constant.ERROR_PARSE);
    } else if (error is ApiException) {
      throw error;
    } else if (error is String) {
      throw ApiException(error);
    } else {
      // For unexpected errors, include the error details in the message
      String errorMessage =
          '${_getLocalizedMessage('errorUnknown')}\n\nChi tiết: $error';
      throw UnknownException(errorMessage, code: Constant.ERROR_UNKNOWN);
    }
  }

  Future<APIResponseEntity<T>> callApiPostMethod(String pathApi,
      String jsonRequest, T Function(Map<String, dynamic>)? fromJson) async {
    APIResponseEntity<T> result = APIResponseEntity();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(Session.token.toString());
      String uri = Network.url + pathApi;

      final response = await http
          .post(Uri.parse(uri),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json'
              },
              body: jsonRequest)
          .timeout(const Duration(seconds: Constant.REQUEST_TIMMEOUT),
              onTimeout: () {
        throw TimeoutException(_getLocalizedMessage('errorTimeout'),
            code: Constant.ERROR_TIMEOUT);
      });

      // Parse response body first to extract potential error messages
      Map<String, dynamic> responseBody = jsonDecode(response.body);

      // Check HTTP status code and pass response body for error extraction
      if (response.statusCode != 200 && response.statusCode != 201) {
        _handleHttpError(response.statusCode, responseBody: responseBody);
      }

      if (responseBody['error'] != null) {
        if (responseBody['error'] is Map) {
          ErrorInfoDTO? errorInfo = ErrorInfoDTO.fromJson(
              responseBody['error'] as Map<String, dynamic>);
          String? mess = MessageUtils.getMessages(
              code: errorInfo.code, args: errorInfo.parameter);
          print('mess in call api $mess');
          throw ApiException(mess, code: errorInfo.code);
        } else {
          throw UnauthorizedException(_getLocalizedMessage('errorUnauthorized'),
              code: Constant.SESSION_LOGIN_EXPIRED);
        }
      }

      result = APIResponseEntity<T>.fromJson(responseBody, fromJson);
    } on SocketException {
      print('Error: callAPI [$pathApi] - No Internet Connection');
      throw NoInternetException(_getLocalizedMessage('errorNoInternet'),
          code: Constant.ERROR_NO_INTERNET);
    } on TimeoutException {
      print('Error: callAPI [$pathApi] - Request Timeout');
      rethrow;
    } on FormatException catch (e) {
      print('Error: callAPI [$pathApi] - Parse Error: $e');
      throw ParseException(_getLocalizedMessage('errorParse'),
          code: Constant.ERROR_PARSE);
    } on ApiException {
      rethrow;
    } catch (error) {
      print('Error: callAPI [$pathApi] request [$jsonRequest]');
      print(error);
      _handleException(error);
    }
    return result;
  }

  Future<APIResponseHeader> sendRequestAPI(
      String path, String jsonBodyRequest) async {
    APIResponseHeader result = APIResponseHeader();

    try {
      print('jsonBodyRequest $jsonBodyRequest');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(Session.token.toString());
      String url = Network.url + path;
      final response = await http
          .post(Uri.parse(url),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-type': 'application/json'
              },
              body: jsonBodyRequest)
          .timeout(const Duration(seconds: Constant.REQUEST_TIMMEOUT),
              onTimeout: () {
        throw TimeoutException(_getLocalizedMessage('errorTimeout'),
            code: Constant.ERROR_TIMEOUT);
      });

      // Parse response body first to extract potential error messages
      Map<String, dynamic> body = jsonDecode(response.body);

      // Check HTTP status code and pass response body for error extraction
      if (response.statusCode != 200 && response.statusCode != 201) {
        _handleHttpError(response.statusCode, responseBody: body);
      }

      if (body['error'] != null) {
        if (body['error'] is Map) {
          ErrorInfoDTO? errorInfo =
              ErrorInfoDTO.fromJson(body['error'] as Map<String, dynamic>);

          String? mess = MessageUtils.getMessages(
              code: errorInfo.code, args: errorInfo.parameter);
          print('mess in call api $mess');
          throw ApiException(mess, code: errorInfo.code);
        } else {
          throw UnauthorizedException(_getLocalizedMessage('errorUnauthorized'),
              code: Constant.SESSION_LOGIN_EXPIRED);
        }
      }
      result = APIResponseHeader.fromJson(body);
    } on SocketException {
      print('Error: sendRequestAPI [$path] - No Internet Connection');
      throw NoInternetException(_getLocalizedMessage('errorNoInternet'),
          code: Constant.ERROR_NO_INTERNET);
    } on TimeoutException {
      print('Error: sendRequestAPI [$path] - Request Timeout');
      rethrow;
    } on FormatException catch (e) {
      print('Error: sendRequestAPI [$path] - Parse Error: $e');
      throw ParseException(_getLocalizedMessage('errorParse'),
          code: Constant.ERROR_PARSE);
    } on ApiException {
      rethrow;
    } catch (error) {
      print('Error: sendRequestAPI [$path]');
      print(error);
      _handleException(error);
    }
    return result;
  }

  Future<String> refreshAccessToken(dynamic refreshToken) async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    if (prefs.get('refresh_token') == null) {
      throw _getLocalizedMessage('errorUnauthorized');
    }
    String url =
        '${Network.url}/oauth/token?grant_type=refresh_token&refresh_token=$refreshToken';
    http.Response response = await http.post(Uri.parse(url), headers: {
      'Authorization': 'Basic Y2xpZW50X2lkOmNsaWVudF9zZWNyZXQ=',
      'Content-Type': 'application/x-www-form-urlencoded'
    });
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    if (responseBody['access_token'] == null) {
      throw _getLocalizedMessage('errorUnauthorized');
    }
    return responseBody['access_token'];
  }

  Future<LoginResponse?> callApiPostMethodWithUrlencoded(
      String pathApi, Map<String, String> params) async {
    LoginResponse? result;
    try {
      String uri = Network.url + pathApi;
      String auth = 'Basic Y2xpZW50X2lkOmNsaWVudF9zZWNyZXQ=';

      print('========== OAuth Token Request ==========');
      print('URL: $uri');
      print('Params: ${params.keys.join(", ")}');
      print('Timeout: ${Constant.REQUEST_TIMMEOUT} seconds');
      print('Starting request at: ${DateTime.now()}');
      
      // Test DNS resolution first
      try {
        final testUri = Uri.parse(Network.url);
        print('Testing connection to host: ${testUri.host}');
        await InternetAddress.lookup(testUri.host).timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            print('DNS lookup timeout for ${testUri.host}');
            throw TimeoutException('DNS lookup timeout');
          },
        );
        print('DNS lookup successful');
      } catch (e) {
        print('DNS lookup failed: $e');
        print('This might indicate network connectivity issues');
      }

      final response = await http
          .post(Uri.parse(uri),
              headers: {
                'Authorization': auth,
                'Content-Type': 'application/x-www-form-urlencoded'
              },
              body: params)
          .timeout(const Duration(seconds: Constant.REQUEST_TIMMEOUT),
              onTimeout: () {
        print('Request timed out after ${Constant.REQUEST_TIMMEOUT} seconds');
        throw TimeoutException(_getLocalizedMessage('errorTimeout'),
            code: Constant.ERROR_TIMEOUT);
      });

      print('Response received at: ${DateTime.now()}');
      print('Response status: ${response.statusCode}');

      // Parse response body first to extract potential error messages
      Map<String, dynamic> responseBody = jsonDecode(response.body);

      // Check for error or error_description in OAuth response
      if (responseBody['error'] != null) {
        String errorMsg = responseBody['error'].toString();
        if (responseBody['error_description'] != null) {
          errorMsg = responseBody['error_description'].toString();
        }
        throw ApiException(errorMsg);
      }

      // Check for errorInfo in response
      if (responseBody['errorInfo'] != null) {
        throw ApiException(responseBody['errorInfo']['errorMessage']);
      }

      // Check HTTP status code and pass response body for error extraction
      if (response.statusCode != 200 && response.statusCode != 201) {
        _handleHttpError(response.statusCode, responseBody: responseBody);
      }
      result = LoginResponse.fromJson(responseBody);
      print('Login response parsed successfully');
    } on SocketException catch (e) {
      print(
          'Error: callApiPostMethodWithUrlencoded [$pathApi] - No Internet Connection');
      print('SocketException details: $e');
      throw NoInternetException(_getLocalizedMessage('errorNoInternet'),
          code: Constant.ERROR_NO_INTERNET);
    } on TimeoutException catch (e) {
      print(
          'Error: callApiPostMethodWithUrlencoded [$pathApi] - Request Timeout');
      print('TimeoutException details: $e');
      print('URL was: ${Network.url}$pathApi');
      print('Please check:');
      print('  1. Network connection stability');
      print('  2. Server availability at ${Network.url}');
      print('  3. Firewall or proxy settings');
      rethrow;
    } on FormatException catch (e) {
      print(
          'Error: callApiPostMethodWithUrlencoded [$pathApi] - Parse Error: $e');
      throw ParseException(_getLocalizedMessage('errorParse'),
          code: Constant.ERROR_PARSE);
    } on ApiException {
      rethrow;
    } catch (error) {
      print('Error: callApiPostMethodWithUrlencoded [$pathApi]');
      print(error);
      _handleException(error);
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
      String? token = prefs.getString(Session.token.toString());
      print('callApiGetMethod - Token: ${token != null ? "EXISTS (${token.substring(0, 20)}...)" : "NULL"}');
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
        onTimeout: () {
          throw TimeoutException(_getLocalizedMessage('errorTimeout'),
              code: Constant.ERROR_TIMEOUT);
        },
      );

      // Parse response body first to extract potential error messages
      Map<String, dynamic> responseBody = jsonDecode(response.body);

      // Check HTTP status code and pass response body for error extraction
      if (response.statusCode != 200 && response.statusCode != 201) {
        _handleHttpError(response.statusCode, responseBody: responseBody);
      }

      if (responseBody['error'] != null) {
        if (responseBody['error'] is Map) {
          ErrorInfoDTO? errorInfo = ErrorInfoDTO.fromJson(
              responseBody['error'] as Map<String, dynamic>);
          String? mess = MessageUtils.getMessages(
              code: errorInfo.code, args: errorInfo.parameter);
          print('mess in call api $mess');
          throw ApiException(mess, code: errorInfo.code);
        } else {
          throw UnauthorizedException(_getLocalizedMessage('errorUnauthorized'),
              code: Constant.SESSION_LOGIN_EXPIRED);
        }
      }

      result = APIResponseEntity<T>.fromJson(responseBody, fromJson);
    } on SocketException {
      print('Error: callAPI [$pathApi] - No Internet Connection');
      throw NoInternetException(_getLocalizedMessage('errorNoInternet'),
          code: Constant.ERROR_NO_INTERNET);
    } on TimeoutException {
      print('Error: callAPI [$pathApi] - Request Timeout');
      rethrow;
    } on FormatException catch (e) {
      print('Error: callAPI [$pathApi] - Parse Error: $e');
      throw ParseException(_getLocalizedMessage('errorParse'),
          code: Constant.ERROR_PARSE);
    } on ApiException {
      rethrow;
    } catch (error) {
      print('Error: callAPI [$pathApi]');
      print(error);
      _handleException(error);
    }
    return result;
  }

  Future<APIResponseHeader> uploadMultipartFile(
      String pathApi, String filePath, String fieldName) async {
    APIResponseHeader result = APIResponseHeader();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(Session.token.toString());
      String uri = Network.url + pathApi;

      var request = http.MultipartRequest('POST', Uri.parse(uri));
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: Constant.REQUEST_TIMMEOUT * 3),
        onTimeout: () {
          throw TimeoutException(_getLocalizedMessage('errorTimeout'),
              code: Constant.ERROR_TIMEOUT);
        },
      );

      final response = await http.Response.fromStream(streamedResponse);

      // Parse response body first to extract potential error messages
      Map<String, dynamic> body = jsonDecode(response.body);

      // Check HTTP status code and pass response body for error extraction
      if (response.statusCode != 200 && response.statusCode != 201) {
        _handleHttpError(response.statusCode, responseBody: body);
      }

      if (body['error'] != null) {
        if (body['error'] is Map) {
          ErrorInfoDTO? errorInfo =
              ErrorInfoDTO.fromJson(body['error'] as Map<String, dynamic>);
          String? mess = MessageUtils.getMessages(
              code: errorInfo.code, args: errorInfo.parameter);
          throw ApiException(mess, code: errorInfo.code);
        } else {
          throw UnauthorizedException(_getLocalizedMessage('errorUnauthorized'),
              code: Constant.SESSION_LOGIN_EXPIRED);
        }
      }
      result = APIResponseHeader.fromJson(body);
    } on SocketException {
      print('Error: uploadMultipartFile [$pathApi] - No Internet Connection');
      throw NoInternetException(_getLocalizedMessage('errorNoInternet'),
          code: Constant.ERROR_NO_INTERNET);
    } on TimeoutException {
      print('Error: uploadMultipartFile [$pathApi] - Request Timeout');
      rethrow;
    } on FormatException catch (e) {
      print('Error: uploadMultipartFile [$pathApi] - Parse Error: $e');
      throw ParseException(_getLocalizedMessage('errorParse'),
          code: Constant.ERROR_PARSE);
    } on ApiException {
      rethrow;
    } catch (error) {
      print('Error: uploadMultipartFile [$pathApi]');
      print(error);
      _handleException(error);
    }
    return result;
  }
}
