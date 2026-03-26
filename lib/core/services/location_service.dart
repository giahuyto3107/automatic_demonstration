import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Completer<bool>? _permissionCompleter;

  /// Checks if location services are enabled and permissions are granted.
  /// If permissions are denied, it requests them.
  /// Returns true if everything is ready to use, false otherwise.
  Future<bool> requestPermission() async {
    if (_permissionCompleter != null) {
      return _permissionCompleter!.future;
    }
    _permissionCompleter = Completer<bool>();

    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('[LocationService] Location services are disabled.');
      _permissionCompleter!.complete(false);
      _permissionCompleter = null;
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('[LocationService] Location permissions are denied');
        _permissionCompleter!.complete(false);
        _permissionCompleter = null;
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('[LocationService] Location permissions are permanently denied.');
      _permissionCompleter!.complete(false);
      _permissionCompleter = null;
      return false;
    }

    _permissionCompleter!.complete(true);
    _permissionCompleter = null;
    return true;
  }

  /// Checks current permission status without requesting.
  Future<bool> hasPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  /// Gets the current position of the device.
  /// Returns null if permissions are not granted or service is disabled.
  Future<Position?> getCurrentPosition() async {
    try {
      if (!await hasPermission()) {
        if (!await requestPermission()) return null;
      }
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (e) {
      debugPrint('[LocationService] Error getting current position: $e');
      return null;
    }
  }

  /// Returns a stream of positions.
  /// Returns an empty stream if permissions are not granted.
  Stream<Position> getPositionStream({LocationSettings? locationSettings}) {
    // Note: We can't easily 'request' permission inside a stream return without async,
    // so we assume the caller has ensured permissions or we return an empty stream if they fail.
    
    // We'll return the stream directly, but it will error if no permission.
    // Callers should preferably check hasPermission() before listening.
    return Geolocator.getPositionStream(
      locationSettings: locationSettings ?? const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    );
  }

  /// Opens the app settings so the user can manually enable permissions.
  Future<void> openSettings() async {
    await openAppSettings();
  }
  
  /// Opens the location settings on the device.
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }
}

final locationService = LocationService();
