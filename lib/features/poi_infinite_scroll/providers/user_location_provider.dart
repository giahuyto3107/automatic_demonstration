import 'dart:async';

import 'package:automatic_demonstration/features/poi_infinite_scroll/data/models/lat_lng.dart';
import 'package:automatic_demonstration/core/utils/haversine.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_location_provider.g.dart';

/// Threshold in meters: only trigger refresh if user moved more than this.
const double _locationThresholdMeters = 100.0;

/// User location state with throttling support.
@immutable
class UserLocationState {
  /// Current user location.
  final LatLng? location;

  /// Last location used for route calculations.
  /// Used for threshold-based refresh logic.
  final LatLng? lastCalculationPoint;

  /// Whether location permission is granted.
  final bool hasPermission;

  /// Whether location service is enabled.
  final bool isServiceEnabled;

  /// Error message if any.
  final String? errorMessage;

  /// Timestamp of last update.
  final DateTime lastUpdate;

  const UserLocationState({
    this.location,
    this.lastCalculationPoint,
    this.hasPermission = false,
    this.isServiceEnabled = false,
    this.errorMessage,
    required this.lastUpdate,
  });

  /// Check if user moved beyond threshold from last calculation point.
  bool get shouldRefreshRouting {
    if (location == null || lastCalculationPoint == null) return true;
    return !isWithinDistance(
      point1: location!,
      point2: lastCalculationPoint!,
      thresholdMeters: _locationThresholdMeters,
    );
  }

  /// Whether location is available and valid.
  bool get isAvailable => location != null && location!.isValid;

  UserLocationState copyWith({
    LatLng? location,
    LatLng? lastCalculationPoint,
    bool? hasPermission,
    bool? isServiceEnabled,
    String? errorMessage,
    DateTime? lastUpdate,
  }) {
    return UserLocationState(
      location: location ?? this.location,
      lastCalculationPoint: lastCalculationPoint ?? this.lastCalculationPoint,
      hasPermission: hasPermission ?? this.hasPermission,
      isServiceEnabled: isServiceEnabled ?? this.isServiceEnabled,
      errorMessage: errorMessage,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}

/// Provider that watches GPS location with throttling.
///
/// Features:
/// - Threshold-based updates: Only signals "significant" movement (>100m)
/// - Permission handling
/// - Service availability check
/// - Stream-based continuous updates
@riverpod
class UserLocation extends _$UserLocation {
  StreamSubscription<Position>? _positionSubscription;

  @override
  UserLocationState build() {
    // Initialize and start watching location
    _initializeLocation();

    // Clean up subscription on dispose
    ref.onDispose(() {
      _positionSubscription?.cancel();
    });

    return UserLocationState(
      lastUpdate: DateTime.now(),
    );
  }

  Future<void> _initializeLocation() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(
          isServiceEnabled: false,
          errorMessage: 'Dịch vụ định vị đang tắt',
          lastUpdate: DateTime.now(),
        );
        return;
      }

      // Check permission
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state = state.copyWith(
            hasPermission: false,
            isServiceEnabled: true,
            errorMessage: 'Quyền truy cập vị trí bị từ chối',
            lastUpdate: DateTime.now(),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        state = state.copyWith(
          hasPermission: false,
          isServiceEnabled: true,
          errorMessage: 'Quyền truy cập vị trí bị từ chối vĩnh viễn',
          lastUpdate: DateTime.now(),
        );
        return;
      }

      state = state.copyWith(
        hasPermission: true,
        isServiceEnabled: true,
        lastUpdate: DateTime.now(),
      );

      // Get initial position
      await _getCurrentPosition();

      // Start watching position stream
      _startPositionStream();
    } catch (e) {
      debugPrint('[UserLocation] Error initializing: $e');
      state = state.copyWith(
        errorMessage: 'Lỗi khởi tạo GPS: ${e.toString()}',
        lastUpdate: DateTime.now(),
      );
    }
  }

  Future<void> _getCurrentPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final newLocation = LatLng(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      state = state.copyWith(
        location: newLocation,
        lastCalculationPoint: state.lastCalculationPoint ?? newLocation,
        lastUpdate: DateTime.now(),
      );
    } catch (e) {
      debugPrint('[UserLocation] Error getting position: $e');
    }
  }

  void _startPositionStream() {
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Minimum distance (meters) before update
      ),
    ).listen(
      (Position position) {
        final newLocation = LatLng(
          latitude: position.latitude,
          longitude: position.longitude,
        );

        state = state.copyWith(
          location: newLocation,
          lastUpdate: DateTime.now(),
        );
      },
      onError: (error) {
        debugPrint('[UserLocation] Stream error: $error');
        state = state.copyWith(
          errorMessage: 'GPS error: ${error.toString()}',
          lastUpdate: DateTime.now(),
        );
      },
    );
  }

  /// Mark current location as the calculation point.
  /// Call this after fetching route data to enable threshold-based refresh.
  void markCalculationPoint() {
    if (state.location != null) {
      state = state.copyWith(
        lastCalculationPoint: state.location,
        lastUpdate: DateTime.now(),
      );
    }
  }

  /// Force refresh location.
  Future<void> refresh() async {
    await _getCurrentPosition();
  }

  /// Request location permission.
  Future<bool> requestPermission() async {
    final permission = await Geolocator.requestPermission();
    final granted = permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
    
    state = state.copyWith(
      hasPermission: granted,
      lastUpdate: DateTime.now(),
    );

    if (granted) {
      await _initializeLocation();
    }
    
    return granted;
  }
}

/// Simple provider for current location as LatLng.
/// Returns null if location is not available.
@riverpod
LatLng? currentLocation(Ref ref) {
  final state = ref.watch(userLocationProvider);
  return state.location;
}

/// Provider that returns true when user has moved significantly.
/// Use this to trigger route recalculations.
@riverpod
bool shouldRefreshRouting(Ref ref) {
  final state = ref.watch(userLocationProvider);
  return state.shouldRefreshRouting;
}
