import 'dart:async';

import 'package:automatic_demonstration/features/poi_infinite_scroll/data/models/lat_lng.dart';
import 'package:automatic_demonstration/features/poi_infinite_scroll/data/models/poi_model.dart';
import 'package:automatic_demonstration/features/poi_infinite_scroll/providers/user_location_provider.dart';
import 'package:automatic_demonstration/core/utils/haversine.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'poi_list_provider.g.dart';

/// Number of items per page.
const int _pageSize = 20;

/// Prefetch buffer: load next page when reaching this many items from end.
const int _prefetchBuffer = 5;

/// State for the infinite scroll POI list.
@immutable
class POIListState {
  /// List of loaded POIs.
  final List<POI> items;

  /// Current page number (0-indexed).
  final int currentPage;

  /// Whether more pages are available.
  final bool hasMore;

  /// Whether currently loading a page.
  final bool isLoading;

  /// Error message if last load failed.
  final String? errorMessage;

  /// Last successful load time.
  final DateTime? lastLoadTime;

  const POIListState({
    this.items = const [],
    this.currentPage = 0,
    this.hasMore = true,
    this.isLoading = false,
    this.errorMessage,
    this.lastLoadTime,
  });

  /// Total number of loaded items.
  int get itemCount => items.length;

  /// Index at which we should trigger prefetch.
  int get prefetchTriggerIndex => itemCount - _prefetchBuffer;

  /// Whether the list is empty and loading.
  bool get isInitialLoad => items.isEmpty && isLoading;

  /// Whether there's content to show.
  bool get hasContent => items.isNotEmpty;

  POIListState copyWith({
    List<POI>? items,
    int? currentPage,
    bool? hasMore,
    bool? isLoading,
    String? errorMessage,
    DateTime? lastLoadTime,
  }) {
    return POIListState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      lastLoadTime: lastLoadTime ?? this.lastLoadTime,
    );
  }
}

/// Provider for infinite scroll POI list.
///
/// Features:
/// - Pagination with automatic prefetch buffer
/// - Sorted by distance from user location
/// - Append-only loading (no full list rebuilds)
/// - Error handling with retry support
@riverpod
class POIList extends _$POIList {
  @override
  POIListState build() {
    // Initial load
    Future.microtask(() => loadInitial());
    return const POIListState(isLoading: true);
  }

  /// Load initial page.
  Future<void> loadInitial() async {
    if (state.isLoading && state.hasContent) return;

    state = state.copyWith(
      isLoading: true,
      currentPage: 0,
      items: [],
      hasMore: true,
    );

    await _loadPage(0);
  }

  /// Load next page if available.
  Future<void> loadNextPage() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);
    await _loadPage(state.currentPage + 1);
  }

  /// Called when user scrolls to an index - triggers prefetch if needed.
  void onItemVisible(int index) {
    if (index >= state.prefetchTriggerIndex && !state.isLoading && state.hasMore) {
      debugPrint('[POIList] Prefetch triggered at index $index');
      loadNextPage();
    }
  }

  /// Refresh the entire list.
  Future<void> refresh() async {
    await loadInitial();
  }

  Future<void> _loadPage(int page) async {
    try {
      // Get user location for distance sorting
      final locationState = ref.read(userLocationProvider);
      final userLocation = locationState.location;

      // Simulate API call - replace with actual POI API
      final newItems = await _fetchPOIsFromAPI(
        page: page,
        pageSize: _pageSize,
        userLocation: userLocation,
      );

      // Sort by distance if we have user location
      List<POI> sortedItems = newItems;
      if (userLocation != null && userLocation.isValid) {
        sortedItems = _sortByDistance(newItems, userLocation);
      }

      // Append new items
      final updatedItems = page == 0 
          ? sortedItems 
          : [...state.items, ...sortedItems];

      state = state.copyWith(
        items: updatedItems,
        currentPage: page,
        hasMore: newItems.length >= _pageSize,
        isLoading: false,
        lastLoadTime: DateTime.now(),
      );
    } catch (e) {
      debugPrint('[POIList] Error loading page $page: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Sort POIs by distance from user location.
  List<POI> _sortByDistance(List<POI> pois, LatLng userLocation) {
    final sorted = List<POI>.from(pois);
    sorted.sort((a, b) {
      final distA = calculateHaversineDistance(
        from: userLocation,
        to: a.location,
      );
      final distB = calculateHaversineDistance(
        from: userLocation,
        to: b.location,
      );
      return distA.compareTo(distB);
    });
    return sorted;
  }

  /// Fetch POIs from API - replace with actual implementation.
  Future<List<POI>> _fetchPOIsFromAPI({
    required int page,
    required int pageSize,
    LatLng? userLocation,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Generate mock POIs for demonstration
    // Replace this with actual API call to your backend
    final startIndex = page * pageSize;
    return List.generate(
      pageSize,
      (index) {
        final poiIndex = startIndex + index;
        // Generate POIs in a grid around Ho Chi Minh City
        final lat = 10.75 + (poiIndex % 10) * 0.01;
        final lng = 106.65 + (poiIndex ~/ 10) * 0.01;
        
        return POI(
          id: 'poi_$poiIndex',
          name: 'Địa điểm ${poiIndex + 1}',
          address: 'Số ${poiIndex + 1}, Đường ABC, Quận ${(poiIndex % 12) + 1}',
          category: _mockCategories[poiIndex % _mockCategories.length],
          location: LatLng(latitude: lat, longitude: lng),
          imageUrl: 'https://picsum.photos/seed/$poiIndex/200/200',
          rating: 3.5 + (poiIndex % 15) * 0.1,
          reviewCount: 10 + poiIndex * 3,
          isOpen: poiIndex % 3 != 0,
        );
      },
    );
  }
}

/// Mock categories for demonstration.
const _mockCategories = [
  'restaurant',
  'cafe',
  'shop',
  'hotel',
  'attraction',
  'bank',
  'pharmacy',
  'gas_station',
];

/// Provider for getting a single POI by ID.
@riverpod
POI? poiById(Ref ref, String id) {
  final state = ref.watch(pOIListProvider);
  try {
    return state.items.firstWhere((poi) => poi.id == id);
  } catch (_) {
    return null;
  }
}

/// Provider for prefetch trigger check.
@riverpod
bool shouldPrefetch(Ref ref, int currentIndex) {
  final state = ref.watch(pOIListProvider);
  return currentIndex >= state.prefetchTriggerIndex && 
         !state.isLoading && 
         state.hasMore;
}
