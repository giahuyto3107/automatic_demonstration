import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvService {
  static bool _isInitialized = false;

  static Future<void> init() async {
    if (!_isInitialized) {
      await dotenv.load(fileName: '.env');
      _isInitialized = true;
    }
  }

  static bool get isInitialized => _isInitialized;

  static Future<void> initTest() async {
    if (!_isInitialized) {
      await dotenv.load(fileName: '.env.test');
      _isInitialized = true;
    }
  }

  static String get serverClientId => dotenv.env['SERVER_CLIENT_ID'] ?? '';
}