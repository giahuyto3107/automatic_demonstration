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

  static const String getAllStalls = _stalls;

  static const String syncStalls = '$_stalls/sync';

  static const String getNearbyStalls = '$_stalls/nearby';
}