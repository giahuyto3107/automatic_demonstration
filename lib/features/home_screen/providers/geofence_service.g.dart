// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geofence_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GeofenceService)
const geofenceServiceProvider = GeofenceServiceProvider._();

final class GeofenceServiceProvider
    extends $NotifierProvider<GeofenceService, Map<int, GeofenceState>> {
  const GeofenceServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geofenceServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geofenceServiceHash();

  @$internal
  @override
  GeofenceService create() => GeofenceService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<int, GeofenceState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<int, GeofenceState>>(value),
    );
  }
}

String _$geofenceServiceHash() => r'08c3c8dd51fb33732477e092e1e1053e8e302d3c';

abstract class _$GeofenceService extends $Notifier<Map<int, GeofenceState>> {
  Map<int, GeofenceState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<Map<int, GeofenceState>, Map<int, GeofenceState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<int, GeofenceState>, Map<int, GeofenceState>>,
              Map<int, GeofenceState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
