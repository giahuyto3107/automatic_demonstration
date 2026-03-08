import 'dart:async';
import 'dart:collection';

import 'package:automatic_demonstration/core/config/env_config.dart';
import 'package:automatic_demonstration/features/home_screen/data/models/vietmap_route_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Standalone Dio-based service for VietMap external APIs.
///
/// Separate from [DatabaseService] which targets the backend server.
/// Uses VietMap Route v3 API:
/// https://maps.vietmap.vn/docs/map-api/route-version/route-v3/
class VietMapRoutingService {
  static VietMapRoutingService? _instance;
  late final Dio _dio;
  
  /// Serial queue for rate-limited API calls
  final _RequestQueue _queue = _RequestQueue(
    minInterval: const Duration(milliseconds: 2500),
  );

  VietMapRoutingService._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://maps.vietmap.vn/api',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
  }

  static VietMapRoutingService get instance {
    _instance ??= VietMapRoutingService._();
    return _instance!;
  }

  /// Get a route between two points.
  ///
  /// [originLat], [originLng] — user's current location.
  /// [destLat], [destLng] — destination (food stall) location.
  /// [vehicle] — vehicle type: 'motorcycle', 'car', 'truck', 'ferry'.
  Future<VietMapRouteResponse> getRoute({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    String vehicle = 'motorcycle',
  }) async {
    return _queue.add(() => _fetchRoute(
      originLat: originLat,
      originLng: originLng,
      destLat: destLat,
      destLng: destLng,
      vehicle: vehicle,
    ));
  }

  /// Get a route with CancelToken support for fast-scroll cancellation.
  ///
  /// Use this for infinite scroll lists where requests may need to be
  /// cancelled if the user scrolls past quickly.
  ///
  /// [cancelToken] — Dio CancelToken to cancel the request on fast scroll.
  Future<VietMapRouteResponse> getRouteWithCancelToken({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    String vehicle = 'motorcycle',
    CancelToken? cancelToken,
  }) async {
    // For cancellable requests, we bypass the queue to allow immediate cancellation
    return _fetchRouteWithCancelToken(
      originLat: originLat,
      originLng: originLng,
      destLat: destLat,
      destLng: destLng,
      vehicle: vehicle,
      cancelToken: cancelToken,
    );
  }

  Future<VietMapRouteResponse> _fetchRouteWithCancelToken({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    required String vehicle,
    CancelToken? cancelToken,
  }) async {
    final apiKey = EnvConfig.routingApiKey;
    final url = '/route/v3'
        '?apikey=$apiKey'
        '&point=$originLat,$originLng'
        '&point=$destLat,$destLng'
        '&vehicle=$vehicle'
        '&points_encoded=true';

    try {
      final response = await _dio.get(
        url,
        cancelToken: cancelToken,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode != null && response.statusCode! >= 400) {
        if (response.data is Map && response.data['code'] == 'ZERO_RESULTS') {
          return VietMapRouteResponse.fromJson(response.data as Map<String, dynamic>);
        }
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }

      if (response.data is Map<String, dynamic>) {
        return VietMapRouteResponse.fromJson(response.data as Map<String, dynamic>);
      }

      throw Exception('Invalid response format from VietMap API');
    } on DioException {
      rethrow;
    }
  }
  
  Future<VietMapRouteResponse> _fetchRoute({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    required String vehicle,
    int retryCount = 0,
  }) async {
    // Build URL manually with repeated 'point' params.
    // Dio's default list serialization (point[]=...) is rejected by VietMap.
    // VietMap expects: point=lat,lng&point=lat,lng
    final apiKey = EnvConfig.routingApiKey;
    debugPrint('[VietMapRouting] Using API key: ${apiKey.isNotEmpty ? "${apiKey.substring(0, 8)}..." : "EMPTY!"}');
    
    final url = '/route/v3'
        '?apikey=$apiKey'
        '&point=$originLat,$originLng'
        '&point=$destLat,$destLng'
        '&vehicle=$vehicle'
        '&points_encoded=true';

    debugPrint('[VietMapRouting] Calling: $url');

    try {
      final response = await _dio.get(
        url,
        options: Options(
          // Accept all status codes so we can handle them manually
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      debugPrint('[VietMapRouting] Status: ${response.statusCode}, Data: ${response.data}');

      // Handle client error status codes (4xx)
      if (response.statusCode != null && response.statusCode! >= 400) {
        final statusCode = response.statusCode;
        
        // Check for generic server-side failure (rate limit/processing error)
        if (response.data is Map && response.data['code'] == 'FAILED') {
          // Retry up to 2 times with increasing delay
          if (retryCount < 2) {
            final delay = Duration(seconds: 2 * (retryCount + 1));
            debugPrint('[VietMapRouting] Server FAILED, retrying in ${delay.inSeconds}s (attempt ${retryCount + 1}/2)');
            await Future.delayed(delay);
            return _fetchRoute(
              originLat: originLat,
              originLng: originLng,
              destLat: destLat,
              destLng: destLng,
              vehicle: vehicle,
              retryCount: retryCount + 1,
            );
          }
        }
        
        String errorMessage;
        switch (statusCode) {
          case 400:
            // Check if it's a ZERO_RESULTS in the body
            if (response.data is Map && response.data['code'] == 'ZERO_RESULTS') {
              return VietMapRouteResponse.fromJson(response.data as Map<String, dynamic>);
            }
            errorMessage = 'Tọa độ không hợp lệ hoặc không tìm được đường đi';
            break;
          case 401:
            errorMessage = 'API key không hợp lệ hoặc đã hết hạn';
            break;
          case 403:
            errorMessage = 'Không có quyền truy cập Routing API';
            break;
          case 423:
            errorMessage = 'Routing API tạm thời bị khóa hoặc đã hết quota';
            break;
          case 429:
            errorMessage = 'Quá nhiều yêu cầu, vui lòng thử lại sau';
            break;
          default:
            errorMessage = 'Lỗi từ server: $statusCode';
        }
        throw Exception(errorMessage);
      }

      if (response.data is Map<String, dynamic>) {
        return VietMapRouteResponse.fromJson(
            response.data as Map<String, dynamic>);
      }

      throw Exception('Invalid response format from VietMap API');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Kết nối tới VietMap bị timeout');
      }
      if (e.type == DioExceptionType.connectionError) {
        throw Exception('Không thể kết nối tới VietMap');
      }
      throw Exception(
          'VietMap routing failed: ${e.message ?? e.type.toString()}');
    }
  }
}

/// Serial request queue with rate limiting
class _RequestQueue {
  final Duration minInterval;
  final Queue<_QueuedRequest> _queue = Queue();
  bool _isProcessing = false;
  int _consecutiveFailures = 0;
  
  _RequestQueue({required this.minInterval});
  
  Future<T> add<T>(Future<T> Function() task) {
    final completer = Completer<T>();
    _queue.add(_QueuedRequest(
      task: () async => completer.complete(await task()),
      onError: completer.completeError,
    ));
    _processQueue();
    return completer.future;
  }
  
  void _processQueue() async {
    if (_isProcessing) return;
    _isProcessing = true;
    
    while (_queue.isNotEmpty) {
      final request = _queue.removeFirst();
      try {
        await request.task();
        _consecutiveFailures = 0; // Reset on success
      } catch (e) {
        request.onError(e);
        // Track consecutive failures for backoff
        if (e.toString().contains('FAILED') || e.toString().contains('400')) {
          _consecutiveFailures++;
        }
      }
      
      // Wait before processing next request
      // Use exponential backoff if we're getting failures
      if (_queue.isNotEmpty) {
        final backoffMultiplier = _consecutiveFailures > 0 
            ? (_consecutiveFailures * 2).clamp(1, 8) 
            : 1;
        final waitTime = minInterval * backoffMultiplier;
        debugPrint('[VietMapRouting] Queue: ${_queue.length} remaining, waiting ${waitTime.inMilliseconds}ms (backoff: ${backoffMultiplier}x)');
        await Future.delayed(waitTime);
      }
    }
    
    _isProcessing = false;
  }
}

class _QueuedRequest {
  final Future<void> Function() task;
  final void Function(Object error) onError;
  
  _QueuedRequest({required this.task, required this.onError});
}
