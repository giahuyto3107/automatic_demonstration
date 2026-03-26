import 'package:automatic_demonstration/core/services/vietmap_routing_service.dart';
import 'package:automatic_demonstration/features/home_screen/data/models/vietmap_route_model.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:automatic_demonstration/core/utils/polyline_encoder.dart';

/// Repository that wraps [VietMapRoutingService] for route calculation.
class RoutingRepository {
  final VietMapRoutingService _routingService;

  RoutingRepository(this._routingService);

  /// Calculate a route from user location to a food stall.
  ///
  /// Returns the best [RoutePath] or null if no route found.
  Future<RoutePath?> getRouteToStall({
    required double userLat,
    required double userLng,
    required double stallLat,
    required double stallLng,
    String vehicle = 'motorcycle',
  }) async {
    // Validate coordinates - reject 0,0 or obviously invalid values
    if (!_isValidCoordinate(stallLat, stallLng)) {
      debugPrint('[RoutingRepo] Invalid stall coords: $stallLat, $stallLng');
      throw Exception('Tọa độ quán ăn không hợp lệ');
    }
    if (!_isValidCoordinate(userLat, userLng)) {
      debugPrint('[RoutingRepo] Invalid user coords: $userLat, $userLng');
      throw Exception('Không thể xác định vị trí của bạn');
    }

    try {
      final response = await _routingService.getRoute(
        originLat: userLat,
        originLng: userLng,
        destLat: stallLat,
        destLng: stallLng,
        vehicle: vehicle,
      );

      // ZERO_RESULTS means no route found (e.g., too far, no road connection)
      // Return a straight-line fallback route instead of null
      if (response.code == 'ZERO_RESULTS' || !response.isSuccess || response.bestRoute == null) {
        if (response.code == 'ZERO_RESULTS') {
          debugPrint('[RoutingRepo] No route found (ZERO_RESULTS) - generating fallback line');
        }
        return _generateFallbackRoute(userLat, userLng, stallLat, stallLng);
      }

      return response.bestRoute;
    } catch (e) {
      // Re-throw with cleaner message, stripping nested "Exception:" prefixes
      final message = e.toString().replaceAll(RegExp(r'^Exception:\s*'), '');
      throw Exception(message);
    }
  }

  RoutePath _generateFallbackRoute(double originLat, double originLng, double destLat, double destLng) {
    final distanceMeters = Geolocator.distanceBetween(originLat, originLng, destLat, destLng);
    final timeMs = (distanceMeters / 11.111) * 60000; // rough estimation: 40km/h
    final encoded = encodePolyline([
      LatLng(originLat, originLng),
      LatLng(destLat, destLng)
    ]);
    return RoutePath(
      distance: distanceMeters,
      weight: distanceMeters,
      time: timeMs.toInt(),
      points: encoded,
    );
  }

  /// Check if coordinates are valid (not 0,0 and within reasonable bounds)
  bool _isValidCoordinate(double lat, double lng) {
    // Reject exact 0,0 (null island)
    if (lat == 0 && lng == 0) return false;
    // Vietnam bounds: lat 8.5-23.5, lng 102-110
    // Allow some margin for nearby countries
    if (lat < 5 || lat > 25) return false;
    if (lng < 100 || lng > 115) return false;
    return true;
  }
}
