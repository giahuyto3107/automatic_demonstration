// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routing_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that fetches the route from user's current location
/// to a destination (food stall) using VietMap Route v3 API.
///
/// Usage: ref.watch(routingProvider((destLat: 10.76, destLng: 106.66)))

@ProviderFor(routing)
const routingProvider = RoutingFamily._();

/// Provider that fetches the route from user's current location
/// to a destination (food stall) using VietMap Route v3 API.
///
/// Usage: ref.watch(routingProvider((destLat: 10.76, destLng: 106.66)))

final class RoutingProvider
    extends
        $FunctionalProvider<
          AsyncValue<RoutePath?>,
          RoutePath?,
          FutureOr<RoutePath?>
        >
    with $FutureModifier<RoutePath?>, $FutureProvider<RoutePath?> {
  /// Provider that fetches the route from user's current location
  /// to a destination (food stall) using VietMap Route v3 API.
  ///
  /// Usage: ref.watch(routingProvider((destLat: 10.76, destLng: 106.66)))
  const RoutingProvider._({
    required RoutingFamily super.from,
    required ({double destLat, double destLng}) super.argument,
  }) : super(
         retry: null,
         name: r'routingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$routingHash();

  @override
  String toString() {
    return r'routingProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<RoutePath?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<RoutePath?> create(Ref ref) {
    final argument = this.argument as ({double destLat, double destLng});
    return routing(ref, destLat: argument.destLat, destLng: argument.destLng);
  }

  @override
  bool operator ==(Object other) {
    return other is RoutingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$routingHash() => r'a7d9dc75b0aaa0a6573c52d6d22ceea9dd874c1f';

/// Provider that fetches the route from user's current location
/// to a destination (food stall) using VietMap Route v3 API.
///
/// Usage: ref.watch(routingProvider((destLat: 10.76, destLng: 106.66)))

final class RoutingFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<RoutePath?>,
          ({double destLat, double destLng})
        > {
  const RoutingFamily._()
    : super(
        retry: null,
        name: r'routingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider that fetches the route from user's current location
  /// to a destination (food stall) using VietMap Route v3 API.
  ///
  /// Usage: ref.watch(routingProvider((destLat: 10.76, destLng: 106.66)))

  RoutingProvider call({required double destLat, required double destLng}) =>
      RoutingProvider._(
        argument: (destLat: destLat, destLng: destLng),
        from: this,
      );

  @override
  String toString() => r'routingProvider';
}
