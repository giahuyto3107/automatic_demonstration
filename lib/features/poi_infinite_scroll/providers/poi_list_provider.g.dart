// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poi_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for infinite scroll POI list.
///
/// Features:
/// - Pagination with automatic prefetch buffer
/// - Sorted by distance from user location
/// - Append-only loading (no full list rebuilds)
/// - Error handling with retry support

@ProviderFor(POIList)
const pOIListProvider = POIListProvider._();

/// Provider for infinite scroll POI list.
///
/// Features:
/// - Pagination with automatic prefetch buffer
/// - Sorted by distance from user location
/// - Append-only loading (no full list rebuilds)
/// - Error handling with retry support
final class POIListProvider extends $NotifierProvider<POIList, POIListState> {
  /// Provider for infinite scroll POI list.
  ///
  /// Features:
  /// - Pagination with automatic prefetch buffer
  /// - Sorted by distance from user location
  /// - Append-only loading (no full list rebuilds)
  /// - Error handling with retry support
  const POIListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pOIListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pOIListHash();

  @$internal
  @override
  POIList create() => POIList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(POIListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<POIListState>(value),
    );
  }
}

String _$pOIListHash() => r'e5a01b79f564d60b926d50ae5a03be99a5fcf8f6';

/// Provider for infinite scroll POI list.
///
/// Features:
/// - Pagination with automatic prefetch buffer
/// - Sorted by distance from user location
/// - Append-only loading (no full list rebuilds)
/// - Error handling with retry support

abstract class _$POIList extends $Notifier<POIListState> {
  POIListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<POIListState, POIListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<POIListState, POIListState>,
              POIListState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for getting a single POI by ID.

@ProviderFor(poiById)
const poiByIdProvider = PoiByIdFamily._();

/// Provider for getting a single POI by ID.

final class PoiByIdProvider extends $FunctionalProvider<POI?, POI?, POI?>
    with $Provider<POI?> {
  /// Provider for getting a single POI by ID.
  const PoiByIdProvider._({
    required PoiByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'poiByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$poiByIdHash();

  @override
  String toString() {
    return r'poiByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<POI?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  POI? create(Ref ref) {
    final argument = this.argument as String;
    return poiById(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(POI? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<POI?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PoiByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$poiByIdHash() => r'a401747f54307e958e5def4349a2fddbba5dcdcb';

/// Provider for getting a single POI by ID.

final class PoiByIdFamily extends $Family
    with $FunctionalFamilyOverride<POI?, String> {
  const PoiByIdFamily._()
    : super(
        retry: null,
        name: r'poiByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for getting a single POI by ID.

  PoiByIdProvider call(String id) =>
      PoiByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'poiByIdProvider';
}

/// Provider for prefetch trigger check.

@ProviderFor(shouldPrefetch)
const shouldPrefetchProvider = ShouldPrefetchFamily._();

/// Provider for prefetch trigger check.

final class ShouldPrefetchProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provider for prefetch trigger check.
  const ShouldPrefetchProvider._({
    required ShouldPrefetchFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'shouldPrefetchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shouldPrefetchHash();

  @override
  String toString() {
    return r'shouldPrefetchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as int;
    return shouldPrefetch(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ShouldPrefetchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shouldPrefetchHash() => r'7f99ab2218922d14dad0c3f29e455d34fb6a7f76';

/// Provider for prefetch trigger check.

final class ShouldPrefetchFamily extends $Family
    with $FunctionalFamilyOverride<bool, int> {
  const ShouldPrefetchFamily._()
    : super(
        retry: null,
        name: r'shouldPrefetchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for prefetch trigger check.

  ShouldPrefetchProvider call(int currentIndex) =>
      ShouldPrefetchProvider._(argument: currentIndex, from: this);

  @override
  String toString() => r'shouldPrefetchProvider';
}
