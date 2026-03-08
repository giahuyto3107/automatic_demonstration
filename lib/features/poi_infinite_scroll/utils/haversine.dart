import 'dart:math' as math;

import 'package:automatic_demonstration/features/poi_infinite_scroll/data/models/lat_lng.dart';

/// Earth's radius in meters.
const double _earthRadiusMeters = 6371000.0;

/// Calculate the Haversine (great-circle) distance between two points.
///
/// This gives the straight-line distance "as the crow flies" between
/// two geographic coordinates. It's fast and provides an instant estimate
/// while waiting for actual road routing data.
///
/// Returns distance in meters.
///
/// Formula: https://en.wikipedia.org/wiki/Haversine_formula
double calculateHaversineDistance({
  required LatLng from,
  required LatLng to,
}) {
  return haversineDistanceMeters(
    lat1: from.latitude,
    lon1: from.longitude,
    lat2: to.latitude,
    lon2: to.longitude,
  );
}

/// Calculate Haversine distance using raw coordinates.
///
/// [lat1], [lon1] - Origin coordinates in degrees.
/// [lat2], [lon2] - Destination coordinates in degrees.
///
/// Returns distance in meters.
double haversineDistanceMeters({
  required double lat1,
  required double lon1,
  required double lat2,
  required double lon2,
}) {
  // Convert degrees to radians
  final phi1 = _toRadians(lat1);
  final phi2 = _toRadians(lat2);
  final deltaPhi = _toRadians(lat2 - lat1);
  final deltaLambda = _toRadians(lon2 - lon1);

  // Haversine formula
  final a = math.sin(deltaPhi / 2) * math.sin(deltaPhi / 2) +
      math.cos(phi1) *
          math.cos(phi2) *
          math.sin(deltaLambda / 2) *
          math.sin(deltaLambda / 2);

  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

  return _earthRadiusMeters * c;
}

/// Calculate Haversine distance and return in kilometers.
double haversineDistanceKm({
  required double lat1,
  required double lon1,
  required double lat2,
  required double lon2,
}) {
  return haversineDistanceMeters(
        lat1: lat1,
        lon1: lon1,
        lat2: lat2,
        lon2: lon2,
      ) /
      1000.0;
}

/// Format Haversine distance for display.
///
/// Returns a string like "~5.2 km" or "~350 m" with the tilde
/// indicating it's an estimate.
String formatHaversineDistance({
  required LatLng from,
  required LatLng to,
}) {
  final meters = calculateHaversineDistance(from: from, to: to);
  return formatDistanceWithEstimate(meters);
}

/// Format distance in meters to a human-readable string.
///
/// If [isEstimate] is true (default), adds a "~" prefix.
String formatDistanceWithEstimate(double meters, {bool isEstimate = true}) {
  final prefix = isEstimate ? '~' : '';
  if (meters >= 1000) {
    final km = meters / 1000.0;
    return '$prefix${km.toStringAsFixed(1)} km';
  }
  return '$prefix${meters.toStringAsFixed(0)} m';
}

/// Check if two points are within a given distance (in meters).
///
/// Useful for threshold checks like "user moved more than 100m".
bool isWithinDistance({
  required LatLng point1,
  required LatLng point2,
  required double thresholdMeters,
}) {
  final distance = calculateHaversineDistance(from: point1, to: point2);
  return distance <= thresholdMeters;
}

/// Convert degrees to radians.
double _toRadians(double degrees) => degrees * (math.pi / 180.0);
