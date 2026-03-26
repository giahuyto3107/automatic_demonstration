import 'dart:core';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
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
      bool isConnected = true;
      try {
        final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
        isConnected = !connectivityResult.contains(ConnectivityResult.none);
      } catch (_) {}

      if (!isConnected) {
        print('[FoodStall] Explicitly Offline -> Loading Local JSON.');
        final localStalls = await _getLocalStalls(lang);
        try {
          final position = await LocationService().getCurrentPosition();
          if (position != null) {
            return _sortByDistance(localStalls, position.latitude, position.longitude);
          }
        } catch (_) {}
        return localStalls;
      }

      final hasPermission = await LocationService().requestPermission();
      
      if (!hasPermission) {
        print('[FoodStall] No permission, fetching all stalls online.');
        return await _fetchFoodStalls(lang);
      }

      Position? position = await LocationService().getCurrentPosition().timeout(
        const Duration(seconds: 4),
        onTimeout: () => null,
      );

      if (position != null) {
        final nearbyStalls = await _fetchNearbyFoodStalls(
          lat: position.latitude,
          lng: position.longitude,
          radius: radius,
          lang: lang,
        );
        return _sortByDistance(nearbyStalls, position.latitude, position.longitude);
      }
      
      return await _fetchFoodStalls(lang);
    } catch (e) {
      print("Network/GPS Error => Fallback Local JSON. Lỗi: $e");
      return await _getLocalStalls(lang);
    }
  }

  List<FoodStallModel> _sortByDistance(List<FoodStallModel> stalls, double lat, double lng) {
    final sortedStalls = List<FoodStallModel>.from(stalls);
    sortedStalls.sort((a, b) {
      final distA = Geolocator.distanceBetween(lat, lng, a.latitude, a.longitude);
      final distB = Geolocator.distanceBetween(lat, lng, b.latitude, b.longitude);
      return distA.compareTo(distB);
    });
    return sortedStalls;
  }

  Future<List<FoodStallModel>> _fetchFoodStalls(String lang) async {
    try {
      final repository = FoodStallRepository(DatabaseService.instance);
      return await repository.getFoodStalls(lang);
    } catch (e) {
      print("Fetch All Stalls Error: $e => Fallback to Local Mock Data");
      
      final localStalls = await _getLocalStalls(lang);
      try {
        final position = await LocationService().getCurrentPosition();
        if (position != null) {
           return _sortByDistance(localStalls, position.latitude, position.longitude).take(5).toList();
        }
      } catch (_) {}
      
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
