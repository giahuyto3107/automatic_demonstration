import 'dart:core';

import 'package:automatic_demonstration/core/constants/mock_food_stalls.dart';
import 'package:automatic_demonstration/core/services/database_service.dart';
import 'package:automatic_demonstration/features/home_screen/data/models/food_stall_model.dart';
import 'package:automatic_demonstration/features/home_screen/data/repository/food_stall_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'food_stall.g.dart';

@riverpod
class FoodStall extends _$FoodStall {
  @override
  Future<List<FoodStallModel>> build() async {
    return _fetchWithLocationFallback();
  }

  Future<List<FoodStallModel>> _fetchWithLocationFallback({double radius = 500}) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return await _fetchFoodStalls();
      
      // Sá»­ dá»¥ng permission_handler Ä‘á»ƒ xin quyá»n mÆ°á»£t mÃ  hÆ¡n trong Riverpod state 
      var status = await Permission.location.status;
      if (status.isDenied) {
        status = await Permission.location.request();
      }

      if (status.isGranted) {
        // We have permission, actively wait for GPS location. DÃ¹ng timeout Ä‘á»ƒ trÃ¡nh káº¹t mÃ£i á»Ÿ Loading state
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high)
        ).timeout(
          const Duration(seconds: 4),
          onTimeout: () => throw Exception('Location request timed out'),
        );

        return await _fetchNearbyFoodStalls(
          lat: position.latitude,
          lng: position.longitude,
          radius: radius,
        );
      }
      
      // Fallback
      return await _fetchFoodStalls();
    } catch (e) {
      // Fallback to all food stalls if nearby fetching fails
      print("Geolocation Error => Fallback Load All Stalls. Lá»—i: $e");
      return await _fetchFoodStalls();
    }
  }

  Future<List<FoodStallModel>> _fetchFoodStalls() async {
    try {
      final repository = FoodStallRepository(DatabaseService.instance);
      return await repository.getFoodStalls();
    } catch (e) {
      print("Fetch All Stalls Error: $e => Fallback to Local Mock Data");
      
      // When offline, sort local mock data by nearest distance to user if location is available
      try {
        final position = await Geolocator.getLastKnownPosition();
        if (position != null) {
          final sortedLocal = List<FoodStallModel>.from(mockFoodStalls);
          sortedLocal.sort((a, b) {
            final distA = Geolocator.distanceBetween(
                position.latitude, position.longitude, a.latitude, a.longitude);
            final distB = Geolocator.distanceBetween(
                position.latitude, position.longitude, b.latitude, b.longitude);
            return distA.compareTo(distB);
          });
          return sortedLocal.take(5).toList();
        }
      } catch (locErr) {
        print("Could not get location for offline sorting: $locErr");
      }
      
      return mockFoodStalls.take(5).toList(); // Return top 5 fallback if no location
    }
  }

  Future<List<FoodStallModel>> _fetchNearbyFoodStalls({
    required double lat,
    required double lng,
    required double radius,
  }) async {
    final repository = FoodStallRepository(DatabaseService.instance);
    return await repository.getNearbyFoodStalls(lat: lat, lng: lng, radius: radius);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchWithLocationFallback());
  }

  Future<void> updateRadius(double newRadius) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchWithLocationFallback(radius: newRadius));
  }
}
