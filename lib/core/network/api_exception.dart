class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic errors;

  ApiException({
    this.statusCode,
    required this.message,
    this.errors,
  });

  @override
  String toString() {
    return 'ApiException(statusCode: $statusCode, message: $message, errors: $errors)';
  }
}

class NetworkException extends ApiException {
  NetworkException({String? message})
      : super(
          message: message ?? 'Network error occurred. Please check your connection.',
        );
}

class AuthException extends ApiException {
  AuthException({String? message, int? statusCode})
      : super(
          statusCode: statusCode ?? 401,
          message: message ?? 'Authentication required. Please log in again.',
        );
}

class ValidationException extends ApiException {
  final Map<String, dynamic>? fieldErrors;

  ValidationException({required String message, this.fieldErrors})
      : super(
          statusCode: 422,
          message: message,
          errors: fieldErrors,
        );
}

class ServerException extends ApiException {
  ServerException({String? message, int? statusCode})
      : super(
          statusCode: statusCode ?? 500,
          message: message ?? 'Server error. Please try again later.',
        );
}

class NotFoundException extends ApiException {
  NotFoundException({String? message})
      : super(
          statusCode: 404,
          message: message ?? 'Resource not found.',
        );
}

class ForbiddenException extends ApiException {
  ForbiddenException({String? message})
      : super(
          statusCode: 403,
          message: message ?? 'You do not have permission to perform this action.',
        );
}
