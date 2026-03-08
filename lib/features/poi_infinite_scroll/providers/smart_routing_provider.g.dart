// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_routing_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// "Smart" Routing Provider with:
/// - Request cancellation on fast scroll (via CancelToken)
/// - Caching with keepAlive + Timer-based invalidation (5 minutes)
/// - Haversine fallback on error
///
/// Usage:
/// ```dart
/// final routing = ref.watch(smartRoutingProvider(
///   destination: LatLng(latitude: 10.76, longitude: 106.66),
/// ));
/// ```

@ProviderFor(smartRouting)
const smartRoutingProvider = SmartRoutingFamily._();

/// "Smart" Routing Provider with:
/// - Request cancellation on fast scroll (via CancelToken)
/// - Caching with keepAlive + Timer-based invalidation (5 minutes)
/// - Haversine fallback on error
///
/// Usage:
/// ```dart
/// final routing = ref.watch(smartRoutingProvider(
///   destination: LatLng(latitude: 10.76, longitude: 106.66),
/// ));
/// ```

final class SmartRoutingProvider
    extends
        $FunctionalProvider<
          AsyncValue<RoutingData>,
          RoutingData,
          FutureOr<RoutingData>
        >
    with $FutureModifier<RoutingData>, $FutureProvider<RoutingData> {
  /// "Smart" Routing Provider with:
  /// - Request cancellation on fast scroll (via CancelToken)
  /// - Caching with keepAlive + Timer-based invalidation (5 minutes)
  /// - Haversine fallback on error
  ///
  /// Usage:
  /// ```dart
  /// final routing = ref.watch(smartRoutingProvider(
  ///   destination: LatLng(latitude: 10.76, longitude: 106.66),
  /// ));
  /// ```
  const SmartRoutingProvider._({
    required SmartRoutingFamily super.from,
    required LatLng super.argument,
  }) : super(
         retry: null,
         name: r'smartRoutingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$smartRoutingHash();

  @override
  String toString() {
    return r'smartRoutingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<RoutingData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RoutingData> create(Ref ref) {
    final argument = this.argument as LatLng;
    return smartRouting(ref, destination: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SmartRoutingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$smartRoutingHash() => r'984b447bfc798f02cf4cfc59fa2addd96dcb4376';

/// "Smart" Routing Provider with:
/// - Request cancellation on fast scroll (via CancelToken)
/// - Caching with keepAlive + Timer-based invalidation (5 minutes)
/// - Haversine fallback on error
///
/// Usage:
/// ```dart
/// final routing = ref.watch(smartRoutingProvider(
///   destination: LatLng(latitude: 10.76, longitude: 106.66),
/// ));
/// ```

final class SmartRoutingFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<RoutingData>, LatLng> {
  const SmartRoutingFamily._()
    : super(
        retry: null,
        name: r'smartRoutingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// "Smart" Routing Provider with:
  /// - Request cancellation on fast scroll (via CancelToken)
  /// - Caching with keepAlive + Timer-based invalidation (5 minutes)
  /// - Haversine fallback on error
  ///
  /// Usage:
  /// ```dart
  /// final routing = ref.watch(smartRoutingProvider(
  ///   destination: LatLng(latitude: 10.76, longitude: 106.66),
  /// ));
  /// ```

  SmartRoutingProvider call({required LatLng destination}) =>
      SmartRoutingProvider._(argument: destination, from: this);

  @override
  String toString() => r'smartRoutingProvider';
}

/// Provider for dual-layer routing (instant estimate + async actual).
///
/// This provider immediately returns the Haversine estimate while
/// the actual routing is being fetched asynchronously.

@ProviderFor(DualLayerRouting)
const dualLayerRoutingProvider = DualLayerRoutingFamily._();

/// Provider for dual-layer routing (instant estimate + async actual).
///
/// This provider immediately returns the Haversine estimate while
/// the actual routing is being fetched asynchronously.
final class DualLayerRoutingProvider
    extends $NotifierProvider<DualLayerRouting, DualLayerRoutingState> {
  /// Provider for dual-layer routing (instant estimate + async actual).
  ///
  /// This provider immediately returns the Haversine estimate while
  /// the actual routing is being fetched asynchronously.
  const DualLayerRoutingProvider._({
    required DualLayerRoutingFamily super.from,
    required LatLng super.argument,
  }) : super(
         retry: null,
         name: r'dualLayerRoutingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dualLayerRoutingHash();

  @override
  String toString() {
    return r'dualLayerRoutingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DualLayerRouting create() => DualLayerRouting();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DualLayerRoutingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DualLayerRoutingState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DualLayerRoutingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dualLayerRoutingHash() => r'9ee62a98aee8cb35891ff741ed269410d86d7f3a';

/// Provider for dual-layer routing (instant estimate + async actual).
///
/// This provider immediately returns the Haversine estimate while
/// the actual routing is being fetched asynchronously.

final class DualLayerRoutingFamily extends $Family
    with
        $ClassFamilyOverride<
          DualLayerRouting,
          DualLayerRoutingState,
          DualLayerRoutingState,
          DualLayerRoutingState,
          LatLng
        > {
  const DualLayerRoutingFamily._()
    : super(
        retry: null,
        name: r'dualLayerRoutingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for dual-layer routing (instant estimate + async actual).
  ///
  /// This provider immediately returns the Haversine estimate while
  /// the actual routing is being fetched asynchronously.

  DualLayerRoutingProvider call({required LatLng destination}) =>
      DualLayerRoutingProvider._(argument: destination, from: this);

  @override
  String toString() => r'dualLayerRoutingProvider';
}

/// Provider for dual-layer routing (instant estimate + async actual).
///
/// This provider immediately returns the Haversine estimate while
/// the actual routing is being fetched asynchronously.

abstract class _$DualLayerRouting extends $Notifier<DualLayerRoutingState> {
  late final _$args = ref.$arg as LatLng;
  LatLng get destination => _$args;

  DualLayerRoutingState build({required LatLng destination});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(destination: _$args);
    final ref = this.ref as $Ref<DualLayerRoutingState, DualLayerRoutingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DualLayerRoutingState, DualLayerRoutingState>,
              DualLayerRoutingState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
