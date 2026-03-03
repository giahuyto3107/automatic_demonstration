class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;
  final dynamic originalError;

  ApiException({
    required this.message,
    this.statusCode,
    this.errorCode,
    this.originalError
  });

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode, Code: $errorCode)';
  }

  bool get isNetworkError =>
      errorCode == 'NETWORK_ERROR' || statusCode == null;

  bool get isAuthError => statusCode == 401 || statusCode == 403;

  bool get isValidationError => statusCode == 400 || statusCode == 422;

  bool get isServerError => statusCode != null && statusCode! >= 500;

  bool get isNotFoundError => statusCode == 404;

  factory ApiException.network([String? message]) {
    return ApiException(
      message: message ?? 'Network connection failed. Please check your internet.',
      errorCode: 'NETWORK_ERROR'
    );
  }

  factory ApiException.unauthorized([String? message]) {
    return ApiException(
      message: message ?? 'You are not authorized. Please auth again',
      statusCode: 401,
      errorCode: 'UNAUTHORIZED'
    );
  }
}