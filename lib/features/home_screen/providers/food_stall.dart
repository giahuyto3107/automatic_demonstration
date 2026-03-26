import 'dart:core';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'package:automatic_demonstration/core/services/location_service.dart';
import 'package:automatic_demonstration/core/offline/dto/stall.dart';
import 'package:automatic_demonstration/core/offline/dto/stall_mapper.dart';
import 'package:automatic_demonstration/core/services/database_service.dart';
import 'package:automatic_demonstration/features/home_screen/data/models/food_stall_model.dart';
import 'package:automatic_demonstration/features/home_screen/data/repository/food_stall_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:automatic_demonstration/core/providers/app_locale.dart';

part 'food_stall.g.dart';

@riverpod
class FoodStall extends _$FoodStall {
  @override
  Future<List<FoodStallModel>> build() async {
    final lang = ref.watch(appLocaleProvider).languageCode;
    return _fetchWithLocationFallback(lang: lang);
  }

  Future<List<FoodStallModel>> _fetchWithLocationFallback({double radius = 500, required String lang}) async {
    try {
      final hasPermission = await LocationService().requestPermission();
      
      if (!hasPermission) {
        print('[FoodStall] No location permission, falling back to all stalls.');
        return await _fetchFoodStalls(lang);
      }

      // We have permission, actively wait for GPS location. Dùng timeout để tránh kẹt mãi ở Loading state
      Position? position = await LocationService().getCurrentPosition().timeout(
        const Duration(seconds: 4),
        onTimeout: () => null,
      );

      if (position != null) {
        return await _fetchNearbyFoodStalls(
          lat: position.latitude,
          lng: position.longitude,
          radius: radius,
          lang: lang,
        );
      }
      
      // Fallback
      return await _fetchFoodStalls(lang);
    } catch (e) {
      // Fallback to all food stalls if nearby fetching fails
      print("Geolocation Error => Fallback Load All Stalls. Lá»—i: $e");
      return await _fetchFoodStalls(lang);
    }
  }

  Future<List<FoodStallModel>> _fetchFoodStalls(String lang) async {
    try {
      final repository = FoodStallRepository(DatabaseService.instance);
      return await repository.getFoodStalls(lang);
    } catch (e) {
      print("Fetch All Stalls Error: $e => Fallback to Local Mock Data");
      
      final localStalls = await _getLocalStalls(lang);

      // When offline, sort local mock data by nearest distance to user if location is available
      try {
        final position = await Geolocator.getLastKnownPosition();
        if (position != null) {
          final sortedLocal = List<FoodStallModel>.from(localStalls);
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
      
      return localStalls.take(5).toList(); // Return top 5 fallback if no location
    }
  }

  Future<List<FoodStallModel>> _getLocalStalls(String lang) async {
    try {
      final jsonString = await rootBundle.loadString('lib/core/offline/stall_json/$lang.json');
      final list = jsonDecode(jsonString) as List<dynamic>;
      
      final usedLanguage = switch (lang.toLowerCase()) {
        'vi' => StallLanguage.vi,
        'zh' => StallLanguage.zh,
        'ja' => StallLanguage.ja,
        'ko' => StallLanguage.ko,
        'en' => StallLanguage.en,
        _ => StallLanguage.en,
      };

      final parsedList = StallListResponse.fromJsonList(list, usedLanguage).sortedByPriority;
      return parsedList.map((dto) => dto.toModel()).toList();
    } catch (e) {
      print("Error loading local JSON for lang $lang: $e. Fallback to vi.");
      if (lang != 'vi') {
        return await _getLocalStalls('vi');
      }
      return [];
    }
  }

  Future<List<FoodStallModel>> _fetchNearbyFoodStalls({
    required double lat,
    required double lng,
    required double radius,
    required String lang,
  }) async {
    final repository = FoodStallRepository(DatabaseService.instance);
    return await repository.getNearbyFoodStalls(lat: lat, lng: lng, radius: radius, lang: lang);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final lang = ref.read(appLocaleProvider).languageCode;
    state = await AsyncValue.guard(() => _fetchWithLocationFallback(lang: lang));
  }

  Future<void> updateRadius(double newRadius) async {
    state = const AsyncLoading();
    final lang = ref.read(appLocaleProvider).languageCode;
    state = await AsyncValue.guard(() => _fetchWithLocationFallback(radius: newRadius, lang: lang));
  }
}
