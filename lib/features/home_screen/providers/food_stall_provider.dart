import 'dart:convert';
import 'package:automatic_demonstration/features/home_screen/data/models/food_stall_state.dart';
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
import 'package:automatic_demonstration/features/home_screen/providers/radius_provider.dart';

part 'food_stall_provider.g.dart';

@riverpod
class FoodStalls extends _$FoodStalls {
  static const int _prefetchBuffer = 5;

  @override
  Future<FoodStallState> build() async {
    final lang = ref.watch(appLocaleProvider).languageCode;
    final radius = ref.watch(radiusProvider);
    
    final items = await _fetchWithLocationFallback(radius: radius, lang: lang);
    
    return FoodStallState(
      items: items,
      currentPage: 0,
      hasMore: false, // API currently returns all items
      isLoading: false,
    );
  }

  int get prefetchTriggerIndex {
    final s = state.value;
    if (s == null) return 0;
    return s.items.length - _prefetchBuffer;
  }

  void onItemVisible(int index) {
    final s = state.value;
    if (s == null) return;
    if (index >= (s.items.length - _prefetchBuffer) && !s.isLoading && s.hasMore) {
      loadNextPage();
    }
  }

  Future<void> loadNextPage() async {
    final s = state.value;
    if (s == null || s.isLoading || !s.hasMore) return;
    
    state = AsyncValue.data(s.copyWith(isLoading: true));
    // Implementation for next page would go here if API supported it
    state = AsyncValue.data(s.copyWith(isLoading: false, hasMore: false));
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
      final localStalls = await _getLocalStalls(lang);
      try {
        final position = await LocationService().getCurrentPosition();
        if (position != null) {
          return _sortByDistance(localStalls, position.latitude, position.longitude);
        }
      } catch (_) {}
      return localStalls;
    }
  }

  List<FoodStallModel> _sortByDistance(List<FoodStallModel> stalls, double lat, double lng) {
    var stallsWithDistance = stalls.map((stall) {
      final dist = Geolocator.distanceBetween(lat, lng, stall.latitude, stall.longitude);
      return stall.copyWith(distance: dist);
    }).toList();

    stallsWithDistance.sort((a, b) {
      int distComparison = (a.distance ?? 0).compareTo(b.distance ?? 0);
      if (distComparison != 0) {
        return distComparison;
      }
      // If distance is the same, prioritize lower priority
      return (a.priority ?? 9999).compareTo(b.priority ?? 9999);
    });
    return stallsWithDistance;
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
           return _sortByDistance(localStalls, position.latitude, position.longitude);
        }
      } catch (_) {}
      
      return localStalls;
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
    final radius = ref.read(radiusProvider);
    state = await AsyncValue.guard(() async {
      final items = await _fetchWithLocationFallback(radius: radius, lang: lang);
      return FoodStallState(items: items);
    });
  }

  Future<void> updateRadius(double newRadius) async {
    // This now just updates the radiusProvider, which triggers a rebuild of the build() method
    ref.read(radiusProvider.notifier).state = newRadius;
  }
}
