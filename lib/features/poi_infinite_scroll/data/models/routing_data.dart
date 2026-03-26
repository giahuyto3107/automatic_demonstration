/// Routing data containing distance and time information.
/// Used for both Haversine estimates and actual road routing.
class RoutingData {
  /// Distance in meters.
  final double distanceMeters;

  /// Travel time in milliseconds (0 for Haversine estimates).
  final int timeMillis;

  /// Whether this is an estimated (Haversine) value or actual road routing.
  final bool isEstimate;

  /// Error message if routing failed.
  final String? errorMessage;

  /// Timestamp when this data was fetched/calculated.
  final DateTime timestamp;

  const RoutingData({
    required this.distanceMeters,
    required this.timeMillis,
    required this.isEstimate,
    this.errorMessage,
    required this.timestamp,
  });

  /// Create a Haversine estimate.
  factory RoutingData.estimate({
    required double distanceMeters,
  }) {
    return RoutingData(
      distanceMeters: distanceMeters,
      timeMillis: 0,
      isEstimate: true,
      timestamp: DateTime.now(),
    );
  }

  /// Create from road routing API response.
  factory RoutingData.fromRoute({
    required double distanceMeters,
    required int timeMillis,
  }) {
    return RoutingData(
      distanceMeters: distanceMeters,
      timeMillis: timeMillis,
      isEstimate: false,
      timestamp: DateTime.now(),
    );
  }

  /// Create an error state (keeps estimate visible).
  factory RoutingData.error({
    required String message,
    double? estimatedDistance,
  }) {
    return RoutingData(
      distanceMeters: estimatedDistance ?? 0,
      timeMillis: 0,
      isEstimate: true,
      errorMessage: message,
      timestamp: DateTime.now(),
    );
  }

  /// Distance in kilometers.
  double get distanceKm => distanceMeters / 1000.0;

  /// Travel time in minutes.
  int get timeMinutes => (timeMillis / 60000).ceil();

  /// Formatted distance string (e.g., "1.2 km" or "350 m").
  String get formattedDistance {
    if (distanceMeters >= 1000) {
      return '${distanceKm.toStringAsFixed(1)} km';
    }
    return '${distanceMeters.toStringAsFixed(0)} m';
  }

  /// Formatted distance with estimate indicator.
  String get formattedDistanceWithIndicator {
    final prefix = isEstimate ? '~' : '';
    return '$prefix$formattedDistance';
  }

  /// Formatted time string (e.g., "5 phút").
  String get formattedTime {
    if (timeMillis == 0) return '';
    final minutes = timeMinutes;
    if (minutes < 1) return '< 1 phút';
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      return mins > 0 ? '$hours giờ $mins phút' : '$hours giờ';
    }
    return '$minutes phút';
  }

  /// Check if the data is stale (older than given duration).
  bool isStale(Duration maxAge) {
    return DateTime.now().difference(timestamp) > maxAge;
  }

  /// Whether routing has an error.
  bool get hasError => errorMessage != null;

  @override
  String toString() =>
      'RoutingData($formattedDistanceWithIndicator, ${isEstimate ? "estimate" : formattedTime})';
}
