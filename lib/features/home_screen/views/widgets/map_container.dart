import 'dart:async';

import 'package:automatic_demonstration/core/config/config.dart';
import 'package:automatic_demonstration/core/constants/app_constants.dart';
import 'package:automatic_demonstration/core/utils/polyline_decoder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

class MapContainer extends StatefulWidget {
  const MapContainer({super.key});

  static final GlobalKey<MapContainerState> globalKey = GlobalKey<MapContainerState>();

  @override
  State<MapContainer> createState() => MapContainerState();
}

class MapContainerState extends State<MapContainer> {
  VietmapController? _mapController;
  LatLng? _userLocation;
  StreamSubscription<Position>? _positionStreamSubscription;
  Circle? _userLocationCircle;
  bool _hasRoute = false;

  /// Expose user location for routing providers.
  LatLng? get userLocation => _userLocation;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  void _showMapPopup(String apiKey) {
    VietmapController? popupController;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.all(20.w), // Space around the popup
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusM.r)),
        child: SizedBox(
          height: 500.h,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
            child: Stack(
              children: [
                VietmapGL(
                  styleString: 'https://maps.vietmap.vn/api/maps/light/styles.json?apikey=$apiKey',
                  initialCameraPosition: CameraPosition(
                    // Pass the current location so the popup starts where the user is
                    target: _userLocation ?? const LatLng(10.762, 106.660),
                    zoom: 16, // Higher zoom for the popup
                  ),
                  myLocationEnabled: false,
                  onStyleLoadedCallback: () async {
                    // Draw dot AFTER style is fully loaded
                    if (_userLocation != null && popupController != null) {
                      await popupController!.addCircle(
                        CircleOptions(
                          geometry: _userLocation!,
                          circleRadius: 10,
                          circleColor: const Color(0xffFF0000),
                          circleStrokeColor: const Color(0xffFFFFFF),
                          circleStrokeWidth: 3,
                        ),
                      );
                    }
                  },
                  onMapCreated: (controller) async {
                    popupController = controller;

                    if (_userLocation != null) {
                      await controller.addCircle(
                        CircleOptions(
                          geometry: _userLocation!,
                          circleRadius: 10,
                          circleColor: const Color(0xffFF0000), // Red
                          circleStrokeColor: const Color(0xffFFFFFF), // White border
                          circleStrokeWidth: 3,
                        ),
                      );
                    }
                  },
                ),
                // Close button for the modal
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),

                Positioned(
                  right: 10.w,
                  bottom: 10.h,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      if (_userLocation != null) {
                        _mapController?.animateCamera(
                            CameraUpdate.newLatLng(_userLocation!)
                        );
                      }
                    },
                    child: const Icon(Icons.my_location, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateUserLocationMarker(LatLng location) async {
    if (_mapController == null) return;

    // Remove existing circle if any
    if (_userLocationCircle != null) {
      await _mapController!.removeCircle(_userLocationCircle!);
    }

    // Add new circle at user's location
    _userLocationCircle = await _mapController!.addCircle(
      CircleOptions(
        geometry: location,
        circleRadius: 10,
        circleColor: Color(0xffFF0000),
        circleStrokeColor: Color(0xffFFFFFF),
        circleStrokeWidth: 3,
      ),
    );
  }

  Future<void> startLiveTracking() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    Position initialPosition = await Geolocator.getCurrentPosition();

    if (mounted) {
      setState(() {
        _userLocation = LatLng(initialPosition.latitude, initialPosition.longitude);
      });
      await _updateUserLocationMarker(_userLocation!);
    }

    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(initialPosition.latitude, initialPosition.longitude),
          zoom: 14,
          tilt: 0
        )
      )
    );

    final LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // Update every 5 meters moved
    );

    _positionStreamSubscription = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      if (mounted) {
        final newLocation = LatLng(position.latitude, position.longitude);
        setState(() {
          _userLocation = newLocation;
        });
        _updateUserLocationMarker(newLocation);
      }
    });
  }

  /// Draw a route polyline on the map from an encoded polyline string.
  ///
  /// [encodedPolyline] — Google Polyline 5 encoded string from VietMap API.
  Future<void> drawRoute(String encodedPolyline) async {
    if (_mapController == null) return;

    // Clear any existing route first
    await clearRoute();

    // Decode the polyline to LatLng points
    final List<LatLng> routePoints = decodePolyline(encodedPolyline);

    if (routePoints.isEmpty) return;

    // Draw the route line
    await _mapController!.addPolyline(
      PolylineOptions(
        geometry: routePoints,
        polylineColor: Color(0xff4A90D9),
        polylineWidth: 5.0,
        polylineOpacity: 0.85,
      ),
    );
    _hasRoute = true;

    // Fit the camera to show the entire route
    if (routePoints.length >= 2) {
      final bounds = LatLngBounds(
        southwest: LatLng(
          routePoints.map((p) => p.latitude).reduce((a, b) => a < b ? a : b),
          routePoints.map((p) => p.longitude).reduce((a, b) => a < b ? a : b),
        ),
        northeast: LatLng(
          routePoints.map((p) => p.latitude).reduce((a, b) => a > b ? a : b),
          routePoints.map((p) => p.longitude).reduce((a, b) => a > b ? a : b),
        ),
      );

      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, left: 50, top: 50, right: 50, bottom: 50),
      );
    }
  }

  /// Draw route given a list of LatLng points directly.
  Future<void> drawRouteFromPoints(List<LatLng> routePoints) async {
    if (_mapController == null || routePoints.isEmpty) return;

    await clearRoute();

    await _mapController!.addPolyline(
      PolylineOptions(
        geometry: routePoints,
        polylineColor: Color(0xff4A90D9),
        polylineWidth: 5.0,
        polylineOpacity: 0.85,
      ),
    );
    _hasRoute = true;
  }

  /// Clear the currently drawn route from the map.
  Future<void> clearRoute() async {
    if (_mapController == null || !_hasRoute) return;
    await _mapController!.clearPolylines();
    _hasRoute = false;
  }

  @override
  Widget build (BuildContext context) {
    final apiKey = EnvConfig.apiKey;

    return SizedBox(
      height: 160.h,
      width: double.infinity,
      // 2. ClipRRect adds rounded corners to match your UI theme
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
            child: VietmapGL(
              // -----------------------------------------------------------
              // INSERT YOUR API KEY HERE
              // -----------------------------------------------------------
              styleString: 'https://maps.vietmap.vn/api/maps/light/styles.json?apikey=$apiKey',

              initialCameraPosition: const CameraPosition(
                target: LatLng(10.762, 106.660), // Default to Ho Chi Minh City
                zoom: 13,
              ),

              onMapClick: (point, latLng) => _showMapPopup(apiKey),

              onMapCreated: (VietmapController controller) {
                setState(() {
                  _mapController = controller;
                });
                startLiveTracking();
              },

              myLocationEnabled: true,
              myLocationRenderMode: MyLocationRenderMode.compass,
            ),


          ),

          Positioned(
            right: 10.w,
            bottom: 10.h,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                if (_userLocation != null) {
                  _mapController?.animateCamera(
                      CameraUpdate.newLatLng(_userLocation!)
                  );
                }
              },
              child: const Icon(Icons.my_location, color: Colors.blue),
            ),
          ),
        ]
      ),
    );
  }
}