/// Models for VietMap Route v3 API response.
///
/// API: GET https://maps.vietmap.vn/api/route/v3
/// Docs: https://maps.vietmap.vn/docs/map-api/route-version/route-v3/

class VietMapRouteResponse {
  final String code;
  final List<RoutePath> paths;

  VietMapRouteResponse({
    required this.code,
    required this.paths,
  });

  bool get isSuccess => code == 'OK';

  /// Returns the best (first) route path, or null if none.
  RoutePath? get bestRoute => paths.isNotEmpty ? paths.first : null;

  factory VietMapRouteResponse.fromJson(Map<String, dynamic> json) {
    return VietMapRouteResponse(
      code: json['code'] as String? ?? '',
      paths: (json['paths'] as List<dynamic>?)
              ?.map((p) => RoutePath.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class RoutePath {
  /// Distance in meters.
  final double distance;

  /// Weight (routing cost).
  final double weight;

  /// Travel time in milliseconds.
  final int time;

  /// Encoded polyline string (Google Polyline 5).
  final String points;

  /// Whether points are encoded.
  final bool pointsEncoded;

  /// Bounding box [minLon, minLat, maxLon, maxLat].
  final List<double> bbox;

  /// Turn-by-turn navigation instructions.
  final List<RouteInstruction> instructions;

  /// Snapped waypoints encoded polyline.
  final String snappedWaypoints;

  RoutePath({
    required this.distance,
    required this.weight,
    required this.time,
    required this.points,
    this.pointsEncoded = true,
    this.bbox = const [],
    this.instructions = const [],
    this.snappedWaypoints = '',
  });

  /// Distance in kilometers, rounded to 1 decimal.
  double get distanceInKm => distance / 1000.0;

  /// Travel time in minutes, rounded up.
  int get timeInMinutes => (time / 60000).ceil();

  /// Formatted distance string (e.g. "1.2 km" or "350 m").
  String get formattedDistance {
    if (distance >= 1000) {
      return '${distanceInKm.toStringAsFixed(1)} km';
    }
    return '${distance.toStringAsFixed(0)} m';
  }

  /// Formatted time string (e.g. "5 phút").
  String get formattedTime {
    final minutes = timeInMinutes;
    if (minutes < 1) return '< 1 phút';
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      return mins > 0 ? '$hours giờ $mins phút' : '$hours giờ';
    }
    return '$minutes phút';
  }

  factory RoutePath.fromJson(Map<String, dynamic> json) {
    return RoutePath(
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      time: (json['time'] as num?)?.toInt() ?? 0,
      points: json['points'] as String? ?? '',
      pointsEncoded: json['points_encoded'] as bool? ?? true,
      bbox: (json['bbox'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      instructions: (json['instructions'] as List<dynamic>?)
              ?.map(
                  (i) => RouteInstruction.fromJson(i as Map<String, dynamic>))
              .toList() ??
          [],
      snappedWaypoints: json['snapped_waypoints'] as String? ?? '',
    );
  }
}

class RouteInstruction {
  /// Distance of this segment in meters.
  final double distance;

  /// Heading angle.
  final double heading;

  /// Sign code (turn type): 0=straight, -2=left, 2=right, 4=arrive, etc.
  final int sign;

  /// Point index interval [start, end].
  final List<int> interval;

  /// Human-readable instruction text (Vietnamese).
  final String text;

  /// Time for this segment in milliseconds.
  final int time;

  /// Street name for this segment.
  final String streetName;

  RouteInstruction({
    required this.distance,
    required this.heading,
    required this.sign,
    required this.interval,
    required this.text,
    required this.time,
    required this.streetName,
  });

  factory RouteInstruction.fromJson(Map<String, dynamic> json) {
    return RouteInstruction(
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      heading: (json['heading'] as num?)?.toDouble() ?? 0.0,
      sign: (json['sign'] as num?)?.toInt() ?? 0,
      interval: (json['interval'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      text: json['text'] as String? ?? '',
      time: (json['time'] as num?)?.toInt() ?? 0,
      streetName: json['street_name'] as String? ?? '',
    );
  }
}
