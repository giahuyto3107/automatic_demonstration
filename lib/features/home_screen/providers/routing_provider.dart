import 'package:automatic_demonstration/core/services/vietmap_routing_service.dart';
import 'package:automatic_demonstration/features/home_screen/data/models/vietmap_route_model.dart';
import 'package:automatic_demonstration/features/home_screen/data/repository/routing_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routing_provider.g.dart';

/// Provider that fetches the route from user's current location
/// to a destination (food stall) using VietMap Route v3 API.
///
/// Usage: ref.watch(routingProvider((destLat: 10.76, destLng: 106.66)))
@riverpod
Future<RoutePath?> routing(
  Ref ref, {
  required double destLat,
  required double destLng,
}) async {
  final repository = RoutingRepository(VietMapRoutingService.instance);

  // Get user's current position
  final position = await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
    ),
  );

  return await repository.getRouteToStall(
    userLat: position.latitude,
    userLng: position.longitude,
    stallLat: destLat,
    stallLng: destLng,
  );
}
