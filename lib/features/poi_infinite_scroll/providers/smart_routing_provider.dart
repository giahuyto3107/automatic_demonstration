import 'dart:async';

import 'package:automatic_demonstration/core/services/vietmap_routing_service.dart';
import 'package:automatic_demonstration/features/poi_infinite_scroll/data/models/lat_lng.dart';
import 'package:automatic_demonstration/features/poi_infinite_scroll/data/models/routing_data.dart';
import 'package:automatic_demonstration/features/poi_infinite_scroll/providers/user_location_provider.dart';
import 'package:automatic_demonstration/core/utils/haversine.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'smart_routing_provider.g.dart';

/// Cache invalidation time: 5 minutes.
const Duration _cacheInvalidationTime = Duration(minutes: 5);

/// Fast scroll threshold: If disposed within this time, cancel the request.
const Duration _fastScrollThreshold = Duration(milliseconds: 250);

/// "Smart" Routing Provider with:
/// - Request cancellation on fast scroll (via CancelToken)
/// - Caching with keepAlive + Timer-based invalidation (5 minutes)
/// - Haversine fallback on error
///
/// Usage:
/// ```dart
/// final routing = ref.watch(smartRoutingProvider(
///   destination: LatLng(latitude: 10.76, longitude: 106.66),
/// ));
/// ```
@riverpod
Future<RoutingData> smartRouting(
  Ref ref, {
  required LatLng destination,
}) async {
  // Create a CancelToken for this request
  final cancelToken = CancelToken();

  // Track when this provider was created
  final createdAt = DateTime.now();

  // Handle disposal - cancel request if scrolled past quickly
  ref.onDispose(() {
    final lifetime = DateTime.now().difference(createdAt);
    if (lifetime < _fastScrollThreshold && !cancelToken.isCancelled) {
      debugPrint('[SmartRouting] Fast scroll detected, cancelling request');
      cancelToken.cancel('Fast scroll - request cancelled');
    }
  });

  // Get user's current location
  final locationState = ref.watch(userLocationProvider);
  final userLocation = locationState.location;

  // If no location available, return estimate only
  if (userLocation == null || !userLocation.isValid) {
    debugPrint('[SmartRouting] No user location, returning estimate');
    return RoutingData.error(
      message: 'Không xác định được vị trí',
      estimatedDistance: 0,
    );
  }

  // Calculate Haversine estimate immediately (will be used as fallback)
  final haversineDistance = calculateHaversineDistance(
    from: userLocation,
    to: destination,
  );

  // Keep alive for caching, but set a timer to invalidate after 5 minutes
  final link = ref.keepAlive();
  final invalidationTimer = Timer(_cacheInvalidationTime, () {
    debugPrint('[SmartRouting] Cache expired, invalidating');
    link.close();
  });

  // Clean up timer on dispose
  ref.onDispose(() {
    invalidationTimer.cancel();
  });

  try {
    // Check if destination is valid
    if (!destination.isValid) {
      return RoutingData.error(
        message: 'Tọa độ đích không hợp lệ',
        estimatedDistance: haversineDistance,
      );
    }

    // Fetch actual route from VietMap API
    final response = await VietMapRoutingService.instance.getRouteWithCancelToken(
      originLat: userLocation.latitude,
      originLng: userLocation.longitude,
      destLat: destination.latitude,
      destLng: destination.longitude,
      cancelToken: cancelToken,
    );

    // Check for cancellation
    if (cancelToken.isCancelled) {
      throw DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.cancel,
        message: 'Request cancelled',
      );
    }

    // Handle no route found
    if (response.code == 'ZERO_RESULTS' || response.bestRoute == null) {
      return RoutingData.error(
        message: 'Không tìm được đường đi',
        estimatedDistance: haversineDistance,
      );
    }

    // Success - return actual routing data
    final route = response.bestRoute!;
    return RoutingData.fromRoute(
      distanceMeters: route.distance,
      timeMillis: route.time,
    );
  } on DioException catch (e) {
    if (e.type == DioExceptionType.cancel) {
      // Cancelled due to fast scroll - return estimate
      debugPrint('[SmartRouting] Request cancelled');
      return RoutingData.estimate(distanceMeters: haversineDistance);
    }

    // Network error - return estimate with error message
    final message = _getErrorMessage(e);
    debugPrint('[SmartRouting] Error: $message');
    return RoutingData.error(
      message: message,
      estimatedDistance: haversineDistance,
    );
  } catch (e) {
    debugPrint('[SmartRouting] Unexpected error: $e');
    return RoutingData.error(
      message: 'Lỗi không xác định',
      estimatedDistance: haversineDistance,
    );
  }
}

/// Convert DioException to user-friendly message.
String _getErrorMessage(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      return 'Kết nối chậm';
    case DioExceptionType.connectionError:
      return 'Không có kết nối';
    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      if (statusCode == 429) return 'Quá tải, thử lại sau';
      if (statusCode == 423) return 'API hết quota';
      return 'Lỗi server';
    default:
      return 'Lỗi mạng';
  }
}

/// Combined routing state that holds both Haversine estimate and actual routing.
/// This enables the "Instant-First" pattern.
@immutable
class DualLayerRoutingState {
  /// Haversine (straight-line) estimate - always available immediately.
  final RoutingData estimate;

  /// Actual road routing - null while loading, populated when API responds.
  final RoutingData? actual;

  /// Whether the actual routing is still loading.
  final bool isLoading;

  const DualLayerRoutingState({
    required this.estimate,
    this.actual,
    this.isLoading = false,
  });

  /// Get the best available data (actual if available, otherwise estimate).
  RoutingData get best => actual ?? estimate;

  /// Whether we have actual routing data.
  bool get hasActualData => actual != null && !actual!.isEstimate;
}

/// Provider for dual-layer routing (instant estimate + async actual).
///
/// This provider immediately returns the Haversine estimate while
/// the actual routing is being fetched asynchronously.
@riverpod
class DualLayerRouting extends _$DualLayerRouting {
  @override
  DualLayerRoutingState build({required LatLng destination}) {
    // Get user location for immediate Haversine calculation
    final locationState = ref.watch(userLocationProvider);
    final userLocation = locationState.location;

    // Calculate immediate Haversine estimate
    final estimate = userLocation != null && userLocation.isValid
        ? RoutingData.estimate(
            distanceMeters: calculateHaversineDistance(
              from: userLocation,
              to: destination,
            ),
          )
        : RoutingData.estimate(distanceMeters: 0);

    // Watch the async routing provider
    final asyncRouting = ref.watch(smartRoutingProvider(destination: destination));

    return asyncRouting.when(
      data: (routingData) => DualLayerRoutingState(
        estimate: estimate,
        actual: routingData,
        isLoading: false,
      ),
      loading: () => DualLayerRoutingState(
        estimate: estimate,
        actual: null,
        isLoading: true,
      ),
      error: (error, stack) => DualLayerRoutingState(
        estimate: estimate,
        actual: RoutingData.error(
          message: error.toString(),
          estimatedDistance: estimate.distanceMeters,
        ),
        isLoading: false,
      ),
    );
  }
}
