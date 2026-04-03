// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radius_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider to store the user-selected search radius for food stalls.
/// Resides in a separate provider to persist even when the food stall list
/// is in a loading state.

@ProviderFor(Radius)
const radiusProvider = RadiusProvider._();

/// Provider to store the user-selected search radius for food stalls.
/// Resides in a separate provider to persist even when the food stall list
/// is in a loading state.
final class RadiusProvider extends $NotifierProvider<Radius, double> {
  /// Provider to store the user-selected search radius for food stalls.
  /// Resides in a separate provider to persist even when the food stall list
  /// is in a loading state.
  const RadiusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'radiusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$radiusHash();

  @$internal
  @override
  Radius create() => Radius();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$radiusHash() => r'9d26eb67c165d21f295018cd9088a555a5dec606';

/// Provider to store the user-selected search radius for food stalls.
/// Resides in a separate provider to persist even when the food stall list
/// is in a loading state.

abstract class _$Radius extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<double, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double, double>,
              double,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
