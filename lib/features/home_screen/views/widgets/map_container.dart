import 'dart:async';

import 'package:automatic_demonstration/core/config/config.dart';
import 'package:automatic_demonstration/core/constants/app_constants.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
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

  @override
  Widget build (BuildContext context) {
    final apiKey = EnvConfig.apiKey;
    // final apiKey = '';

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