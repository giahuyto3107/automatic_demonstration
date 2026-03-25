abstract class Endpoints {
  // Base Paths
  static const _admin = '/admin';
  static const _analytics = '/analytics';
  static const _stalls = '/stalls';


  // Admin
  static String adminStores(String id) =>
      '$_admin/stores/$id/geofence';

  static const String syncVietmap = '$_admin/sync-vietmap';

  static const String importJson = '$_admin/import-json';

  // Analytics
  static String track = '$_analytics/track';
  static String trackBatch = '$_analytics/track/batch';


  // Food Stalls
  static String getStallById(String id) =>
      '$_stalls/$id';

  static String deleteFoodStall(String id) =>
      getStallById(id);

  static String updateFoodStall(String id) =>
      getStallById(id);

  static String getFoodStall(String id) =>
      getStallById(id);

  static const String createFoodStall = _stalls;

  static String getAllStalls(String lang) => '$_stalls?lang=$lang';

  static const String syncStalls = '$_stalls/sync';

  static String getNearbyStalls({
    required double lat,
    required double lng,
    required String lang,
    double radius = 500,
  }) => '$_stalls/geofence?lat=$lat&lng=$lng&radius=$radius&lang=$lang';
}