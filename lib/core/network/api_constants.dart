class ApiConstants {
  ApiConstants._();

  static const int connectionTimeout = 15000;
  static const int receiveTimeout = 15000;
  static const int maxRetryAttempts = 3;

  static const String contentTypeHeader = 'application/json';
  static const String acceptHeader = 'application/json';
  static const String authHeaderPrefix = 'Bearer ';

  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
}