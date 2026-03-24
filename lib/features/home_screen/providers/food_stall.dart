import 'dart:core';

import 'package:automatic_demonstration/core/services/database_service.dart';
import 'package:automatic_demonstration/features/home_screen/data/models/food_stall_model.dart';
import 'package:automatic_demonstration/features/home_screen/data/repository/food_stall_repository.dart';
import 'package:geolocator/geolocator.dart';
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

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Pauses the build (AsyncLoading) until the user answers the prompt
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return await _fetchFoodStalls();
      }

      if (permission == LocationPermission.deniedForever) return await _fetchFoodStalls();

      // We have permission, actively wait for GPS location.
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high)
      );

      return await _fetchNearbyFoodStalls(
        lat: position.latitude,
        lng: position.longitude,
        radius: radius,
      );
    } catch (e) {
      // Fallback to all food stalls if nearby fetching fails
      return await _fetchFoodStalls();
    }
  }

  Future<List<FoodStallModel>> _fetchFoodStalls() async {
    final repository = FoodStallRepository(DatabaseService.instance);
    return await repository.getFoodStalls();
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