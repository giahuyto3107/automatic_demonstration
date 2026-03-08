import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  EnvConfig._();

  static String get baseUrl {
    final envBaseUrl = dotenv.env['BASE_URL'] ??
      dotenv.env['DEV_BASE_URL'] ??
      'localhost:8080/api/v1';

    return envBaseUrl;
  }

  static String get devBaseUrl {
    return dotenv.env['DEV_BASE_URL'] ?? 'http://127.0.0.1:8080/api/v1';
  }

  /// Production base URL
  static String get prodBaseUrl {
    return dotenv.env['PROD_BASE_URL'] ?? 'https://your-production-server.com/api/v1';
  }

  /// Current environment flag
  static bool get isProduction {
    final env = dotenv.env['ENVIRONMENT'] ?? 'development';
    return env == 'production';
  }

  /// API Key for tile maps
  static String get apiKey {
    return dotenv.env['API_KEY'] ?? '';
  }

  /// API Key for routing
  static String get routingApiKey {
    return dotenv.env['ROUTING_API_KEY'] ?? '';
  }

  /// Environment name
  static String get environment {
    return dotenv.env['ENVIRONMENT'] ?? 'development';
  }

  /// App Configuration
  static String get appName {
    return dotenv.env['APP_NAME'] ?? 'FLUTTER';
  }

  static String get appVersion {
    return dotenv.env['APP_VERSION'] ?? '1.0.0';
  }
}