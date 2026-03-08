import 'dart:math' as math;

/// Lightweight latitude/longitude model.
class LatLng {
  final double latitude;
  final double longitude;

  const LatLng({
    required this.latitude,
    required this.longitude,
  });

  /// Create from a map (e.g., JSON).
  factory LatLng.fromJson(Map<String, dynamic> json) {
    return LatLng(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };

  /// Check if coordinates are valid (not null island, within Vietnam bounds).
  bool get isValid {
    if (latitude == 0 && longitude == 0) return false;
    // Vietnam approximate bounds
    if (latitude < 5 || latitude > 25) return false;
    if (longitude < 100 || longitude > 115) return false;
    return true;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LatLng &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() => 'LatLng($latitude, $longitude)';
}
