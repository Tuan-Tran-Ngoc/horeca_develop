/// Custom exceptions for API error handling
/// Provides specific exception types for different network and server errors

/// Base class for all API-related exceptions
class ApiException implements Exception {
  final String message;
  final String? code;

  ApiException(this.message, {this.code});

  @override
  String toString() => message;
}

/// Thrown when there's no internet connection
class NoInternetException extends ApiException {
  NoInternetException(String message, {String? code})
      : super(message, code: code);
}

/// Thrown when the request times out
class TimeoutException extends ApiException {
  TimeoutException(String message, {String? code})
      : super(message, code: code);
}

/// Thrown for HTTP 400 Bad Request errors
class BadRequestException extends ApiException {
  BadRequestException(String message, {String? code})
      : super(message, code: code);
}

/// Thrown for HTTP 401 Unauthorized errors
class UnauthorizedException extends ApiException {
  UnauthorizedException(String message, {String? code})
      : super(message, code: code);
}

/// Thrown for HTTP 403 Forbidden errors
class ForbiddenException extends ApiException {
  ForbiddenException(String message, {String? code})
      : super(message, code: code);
}

/// Thrown for HTTP 404 Not Found errors
class NotFoundException extends ApiException {
  NotFoundException(String message, {String? code})
      : super(message, code: code);
}

/// Thrown for HTTP 500 Internal Server Error
class ServerException extends ApiException {
  ServerException(String message, {String? code})
      : super(message, code: code);
}

/// Thrown for HTTP 503 Service Unavailable
class ServiceUnavailableException extends ApiException {
  ServiceUnavailableException(String message, {String? code})
      : super(message, code: code);
}

/// Thrown when response cannot be parsed
class ParseException extends ApiException {
  ParseException(String message, {String? code})
      : super(message, code: code);
}

/// Thrown for unexpected errors
class UnknownException extends ApiException {
  UnknownException(String message, {String? code})
      : super(message, code: code);
}
