import 'package:horeca/utils/api_exceptions.dart';
import 'package:horeca/utils/call_api_utils.dart';

/// Example of how to handle API errors in your application
/// 
/// This file demonstrates best practices for catching and handling
/// different types of API exceptions returned by CallApiUtils

class ApiUsageExample {
  /// Example 1: Basic error handling with user-friendly messages
  Future<void> exampleBasicErrorHandling() async {
    try {
      CallApiUtils callApi = CallApiUtils();
      // Your API call here
      // await callApi.callApiPostMethod(...);
      
    } on NoInternetException catch (e) {
      // Handle no internet connection
      print('No Internet: ${e.message}');
      // Show a dialog or snackbar to user
      _showErrorToUser(e.message);
      
    } on TimeoutException catch (e) {
      // Handle timeout - maybe offer retry
      print('Timeout: ${e.message}');
      _showErrorToUser(e.message);
      
    } on NotFoundException catch (e) {
      // Handle 404 - resource not found
      print('Not Found: ${e.message}');
      _showErrorToUser(e.message);
      
    } on UnauthorizedException catch (e) {
      // Handle 401 - redirect to login
      print('Unauthorized: ${e.message}');
      _redirectToLogin();
      
    } on ServerException catch (e) {
      // Handle 500 - server error
      print('Server Error: ${e.message}');
      _showErrorToUser(e.message);
      
    } on ApiException catch (e) {
      // Handle any other API exceptions
      print('API Error: ${e.message}');
      _showErrorToUser(e.message);
      
    } catch (e) {
      // Handle unexpected errors
      print('Unexpected Error: $e');
      _showErrorToUser('An unexpected error occurred');
    }
  }

  /// Example 2: Error handling with retry logic
  Future<void> exampleWithRetry() async {
    int retryCount = 0;
    const maxRetries = 3;
    
    while (retryCount < maxRetries) {
      try {
        CallApiUtils callApi = CallApiUtils();
        // Your API call here
        // await callApi.callApiGetMethod(...);
        break; // Success, exit loop
        
      } on TimeoutException catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          _showErrorToUser('${e.message}. Max retries reached.');
          rethrow;
        }
        print('Timeout, retrying... ($retryCount/$maxRetries)');
        await Future.delayed(Duration(seconds: 2));
        
      } on NoInternetException catch (e) {
        // Don't retry if no internet
        _showErrorToUser(e.message);
        rethrow;
        
      } on ApiException catch (e) {
        // Don't retry for other API errors
        _showErrorToUser(e.message);
        rethrow;
      }
    }
  }

  /// Example 3: Handling specific HTTP status codes
  Future<void> exampleStatusCodeHandling() async {
    try {
      CallApiUtils callApi = CallApiUtils();
      // Your API call here
      
    } on BadRequestException catch (e) {
      // 400 - Invalid input from user
      print('Bad Request: ${e.message}');
      _showErrorToUser('Please check your input and try again');
      
    } on UnauthorizedException catch (e) {
      // 401 - User needs to login
      print('Unauthorized: ${e.message}');
      _redirectToLogin();
      
    } on ForbiddenException catch (e) {
      // 403 - User doesn't have permission
      print('Forbidden: ${e.message}');
      _showErrorToUser('You do not have permission for this action');
      
    } on NotFoundException catch (e) {
      // 404 - Resource doesn't exist
      print('Not Found: ${e.message}');
      _showErrorToUser('The requested resource was not found');
      
    } on ServiceUnavailableException catch (e) {
      // 503 - Service down
      print('Service Unavailable: ${e.message}');
      _showErrorToUser('Service is temporarily unavailable. Please try again later.');
    }
  }

  /// Example 4: Centralized error handler
  Future<T?> executeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
      
    } on NoInternetException catch (e) {
      _handleNetworkError(e);
      
    } on TimeoutException catch (e) {
      _handleTimeoutError(e);
      
    } on UnauthorizedException catch (e) {
      _handleAuthError(e);
      
    } on ServerException catch (e) {
      _handleServerError(e);
      
    } on ApiException catch (e) {
      _handleGenericApiError(e);
      
    } catch (e) {
      _handleUnknownError(e);
    }
    return null;
  }

  // Helper methods for error handling
  void _showErrorToUser(String message) {
    // Implement your UI error display logic
    // e.g., show SnackBar, Dialog, Toast, etc.
    print('Show to user: $message');
  }

  void _redirectToLogin() {
    // Navigate to login screen
    print('Redirecting to login...');
  }

  void _handleNetworkError(NoInternetException e) {
    print('Network Error: ${e.message}');
    _showErrorToUser(e.message);
  }

  void _handleTimeoutError(TimeoutException e) {
    print('Timeout Error: ${e.message}');
    _showErrorToUser(e.message);
  }

  void _handleAuthError(UnauthorizedException e) {
    print('Auth Error: ${e.message}');
    _redirectToLogin();
  }

  void _handleServerError(ServerException e) {
    print('Server Error: ${e.message}');
    _showErrorToUser('Server error occurred. Please try again later.');
  }

  void _handleGenericApiError(ApiException e) {
    print('API Error: ${e.message}');
    _showErrorToUser(e.message);
  }

  void _handleUnknownError(dynamic e) {
    print('Unknown Error: $e');
    _showErrorToUser('An unexpected error occurred');
  }
}

/// Usage in a real service or screen:
/// 
/// ```dart
/// Future<void> loadData() async {
///   try {
///     CallApiUtils<MyResponseType> callApi = CallApiUtils();
///     var response = await callApi.callApiGetMethod(
///       '/api/endpoint',
///       {'param': 'value'},
///       (json) => MyResponseType.fromJson(json),
///     );
///     // Handle success
///   } on NoInternetException catch (e) {
///     showSnackBar(e.message);
///   } on TimeoutException catch (e) {
///     showSnackBar(e.message);
///   } on ApiException catch (e) {
///     showSnackBar(e.message);
///   }
/// }
/// ```
