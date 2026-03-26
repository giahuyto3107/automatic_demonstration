/// POI Infinite Scroll feature module.
///
/// Provides an infinite scroll list of Points of Interest with:
/// - Smart routing provider with request cancellation
/// - Dual-layer distance rendering (Haversine + Road routing)
/// - Location-based sorting with threshold-based refresh
/// - Shimmer loading effects
/// - Prefetch buffer for smooth scrolling

export 'data/models/models.dart';
export 'providers/providers.dart';
export 'utils/haversine.dart';
export 'views/views.dart';
export 'widgets/widgets.dart';
