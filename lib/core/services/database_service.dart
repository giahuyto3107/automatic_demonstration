import 'package:automatic_demonstration/core/config/env_config.dart';
import 'package:automatic_demonstration/core/network/api_constants.dart';
import 'package:automatic_demonstration/core/network/api_response.dart';
import 'package:dio/dio.dart';

class DatabaseService {
  static DatabaseService? _instance;
  late final Dio _dio;
  // late final Dio _refreshDio; // Separate Dio for token refresh (no interceptors)
  // bool _isRefreshing = false;

  DatabaseService._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.baseUrl,
        connectTimeout: Duration(milliseconds: ApiConstants.connectionTimeout),
        receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
        headers: {
          'Content-Type': ApiConstants.contentTypeHeader,
          'Accept': ApiConstants.acceptHeader
        },
      ),
    );


  }

  static DatabaseService get instance {
    _instance ??= DatabaseService._();
    return _instance!;
  }

  // Future<void> _retry(RequestOptions requestOptions) async {
  //
  // }

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    }) async {
      try {
        final response = await _dio.get(
          endpoint,
          queryParameters: queryParameters
        );

        return ApiResponse.success(
          data: fromJson != null ? fromJson(response.data) : response.data,
          statusCode: response.statusCode,
        );
      } on DioException catch (e) {
        return ApiResponse.error(
          message: _getErrorMessage(e),
          statusCode: e.response?.statusCode
        );
      }
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    T Function(dynamic)? fromJson
    }) async {
      try {
        final response = await _dio.post(
          endpoint,
          data: data
        );

        return ApiResponse.success(
          data: fromJson != null ? fromJson(response.data) : response.data,
          statusCode: response.statusCode
        );
      } on DioException catch (e) {
        return ApiResponse.error(
          message: _getErrorMessage(e),
          statusCode: e.response?.statusCode
        );
      }
    }

    Future<ApiResponse<T>> put<T>(
      String endpoint, {
      dynamic data,
      T Function(dynamic)? fromJson
    }) async {
      try {
        final response = await _dio.put(
          endpoint,
          data: data
        );

        return ApiResponse.success(
          data: fromJson != null ? fromJson(response.data) : response.data,
          statusCode: response.statusCode
        );
      } on DioException catch (e) {
        return ApiResponse.error(
          message: _getErrorMessage(e),
          statusCode: e.response?.statusCode
        );
      }
    }

  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    dynamic data,
    T Function(dynamic)? fromJson
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data
      );

      return ApiResponse.success(
        data: fromJson != null ? fromJson(response.data) : response.data,
        statusCode: response.statusCode
      );
    } on DioException catch (e) {
      return ApiResponse.error(
        message: _getErrorMessage(e),
        statusCode: e.response?.statusCode
      );
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    dynamic data,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(endpoint, data: data);
      return ApiResponse.success(
        data: fromJson != null ? fromJson(response.data) : response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse.error(
        message: _getErrorMessage(e),
        statusCode: e.response?.statusCode,
      );
    }
  }


  String _getErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Send timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server is taking too long to respond. Please try again.';
      case DioExceptionType.badResponse:
        return _parseServerError(error.response);
      case DioExceptionType.cancel:
        return 'Request was cancelled';
      case DioExceptionType.connectionError:
        return 'Connection error. Please check your internet connection.';
      default:
        return 'An unexpected error occurred. Please try again';
    }
  }

  String _parseServerError(Response? response) {
    if (response?.data != null && response!.data is Map) {
      return response.data['message'] ?? 'Server error occurred.';
    }
    return 'Server error occurred. Status: ${response?.statusCode}';
  }
}