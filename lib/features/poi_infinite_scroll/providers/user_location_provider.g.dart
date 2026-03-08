// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_location_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that watches GPS location with throttling.
///
/// Features:
/// - Threshold-based updates: Only signals "significant" movement (>100m)
/// - Permission handling
/// - Service availability check
/// - Stream-based continuous updates

@ProviderFor(UserLocation)
const userLocationProvider = UserLocationProvider._();

/// Provider that watches GPS location with throttling.
///
/// Features:
/// - Threshold-based updates: Only signals "significant" movement (>100m)
/// - Permission handling
/// - Service availability check
/// - Stream-based continuous updates
final class UserLocationProvider
    extends $NotifierProvider<UserLocation, UserLocationState> {
  /// Provider that watches GPS location with throttling.
  ///
  /// Features:
  /// - Threshold-based updates: Only signals "significant" movement (>100m)
  /// - Permission handling
  /// - Service availability check
  /// - Stream-based continuous updates
  const UserLocationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userLocationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userLocationHash();

  @$internal
  @override
  UserLocation create() => UserLocation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserLocationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserLocationState>(value),
    );
  }
}

String _$userLocationHash() => r'05e8e2a81108b3bbe2b29c6d3cf15672d896a52e';

/// Provider that watches GPS location with throttling.
///
/// Features:
/// - Threshold-based updates: Only signals "significant" movement (>100m)
/// - Permission handling
/// - Service availability check
/// - Stream-based continuous updates

abstract class _$UserLocation extends $Notifier<UserLocationState> {
  UserLocationState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<UserLocationState, UserLocationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserLocationState, UserLocationState>,
              UserLocationState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Simple provider for current location as LatLng.
/// Returns null if location is not available.

@ProviderFor(currentLocation)
const currentLocationProvider = CurrentLocationProvider._();

/// Simple provider for current location as LatLng.
/// Returns null if location is not available.

final class CurrentLocationProvider
    extends $FunctionalProvider<LatLng?, LatLng?, LatLng?>
    with $Provider<LatLng?> {
  /// Simple provider for current location as LatLng.
  /// Returns null if location is not available.
  const CurrentLocationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentLocationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentLocationHash();

  @$internal
  @override
  $ProviderElement<LatLng?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LatLng? create(Ref ref) {
    return currentLocation(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LatLng? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LatLng?>(value),
    );
  }
}

String _$currentLocationHash() => r'fbe4b0de7a0f296d7108af55b2e287cd4bb83f0e';

/// Provider that returns true when user has moved significantly.
/// Use this to trigger route recalculations.

@ProviderFor(shouldRefreshRouting)
const shouldRefreshRoutingProvider = ShouldRefreshRoutingProvider._();

/// Provider that returns true when user has moved significantly.
/// Use this to trigger route recalculations.

final class ShouldRefreshRoutingProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provider that returns true when user has moved significantly.
  /// Use this to trigger route recalculations.
  const ShouldRefreshRoutingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shouldRefreshRoutingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shouldRefreshRoutingHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return shouldRefreshRouting(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$shouldRefreshRoutingHash() =>
    r'4d4b98db2bc0dc45a724d2e17c9ecb60954886d5';
