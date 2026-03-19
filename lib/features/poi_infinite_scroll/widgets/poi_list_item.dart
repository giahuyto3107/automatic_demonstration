import 'package:automatic_demonstration/features/poi_infinite_scroll/data/models/poi_model.dart';
import 'package:automatic_demonstration/features/poi_infinite_scroll/providers/smart_routing_provider.dart';
import 'package:automatic_demonstration/features/poi_infinite_scroll/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// POI list item widget with dual-layer distance rendering.
///
/// Features:
/// - Layer 1 (Sync): Immediate Haversine estimate (~5.2 km)
/// - Layer 2 (Async): Animated transition to actual road distance/time
/// - Shimmer effect while loading
/// - Error fallback with offline indicator
class POIListItem extends ConsumerWidget {
  final POI poi;
  final VoidCallback? onTap;
  final int index;

  const POIListItem({
    super.key,
    required this.poi,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the dual-layer routing state
    final routingState = ref.watch(
      dualLayerRoutingProvider(destination: poi.location),
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              _buildThumbnail(),
              const SizedBox(width: 12),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and status
                    _buildHeader(context),
                    const SizedBox(height: 4),
                    
                    // Address
                    _buildAddress(context),
                    const SizedBox(height: 8),
                    
                    // Distance and time row
                    _buildDistanceRow(context, routingState),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 80,
        height: 80,
        color: Colors.grey[200],
        child: poi.imageUrl != null
            ? Image.network(
                poi.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholderIcon(),
              )
            : _buildPlaceholderIcon(),
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Icon(
      _getCategoryIcon(poi.category),
      size: 32,
      color: Colors.grey[400],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            poi.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (poi.isOpen != null) ...[
          const SizedBox(width: 8),
          _buildOpenStatus(context, poi.isOpen!),
        ],
      ],
    );
  }

  Widget _buildOpenStatus(BuildContext context, bool isOpen) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isOpen ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isOpen ? 'Đang mở' : 'Đã đóng',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: isOpen ? Colors.green[700] : Colors.red[700],
        ),
      ),
    );
  }

  Widget _buildAddress(BuildContext context) {
    return Text(
      poi.address,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Build the distance/time row with dual-layer rendering.
  Widget _buildDistanceRow(BuildContext context, DualLayerRoutingState routingState) {
    return Row(
      children: [
        // Distance display with animated transition
        _buildDistanceDisplay(context, routingState),
        
        const SizedBox(width: 12),
        
        // Time display (shimmer while loading)
        _buildTimeDisplay(context, routingState),
        
        const Spacer(),
        
        // Rating
        _buildRating(context),
      ],
    );
  }

  /// Distance display: shows estimate first, then animates to actual.
  Widget _buildDistanceDisplay(BuildContext context, DualLayerRoutingState routingState) {
    final best = routingState.best;
    final isEstimate = best.isEstimate;
    
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.2),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: Row(
        key: ValueKey(isEstimate ? 'estimate' : 'actual'),
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.directions_walk,
            size: 16,
            color: isEstimate ? Colors.grey[400] : Colors.blue[600],
          ),
          const SizedBox(width: 4),
          Text(
            best.formattedDistanceWithIndicator,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              // Dimmed for estimate, normal for actual
              color: isEstimate ? Colors.grey[500] : Colors.grey[800],
            ),
          ),
          // Offline/error indicator
          if (best.hasError) ...[
            const SizedBox(width: 4),
            Tooltip(
              message: 'Dữ liệu bản đồ offline',
              child: Icon(
                Icons.cloud_off,
                size: 14,
                color: Colors.orange[400],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Time display: shimmer while loading, actual value when ready.
  Widget _buildTimeDisplay(BuildContext context, DualLayerRoutingState routingState) {
    if (routingState.isLoading) {
      // Shimmer effect while loading
      return const ShimmerWidget(
        width: 60,
        height: 16,
        borderRadius: 4,
      );
    }

    final actual = routingState.actual;
    if (actual == null || actual.isEstimate || actual.timeMillis == 0) {
      // No time data available
      return const SizedBox.shrink();
    }

    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 300),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule,
            size: 16,
            color: Colors.blue[600],
          ),
          const SizedBox(width: 4),
          Text(
            actual.formattedTime,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRating(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star,
          size: 16,
          color: Colors.amber[600],
        ),
        const SizedBox(width: 2),
        Text(
          poi.rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        Text(
          ' (${poi.reviewCount})',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'restaurant':
        return Icons.restaurant;
      case 'cafe':
        return Icons.local_cafe;
      case 'shop':
        return Icons.store;
      case 'hotel':
        return Icons.hotel;
      case 'attraction':
        return Icons.attractions;
      case 'bank':
        return Icons.account_balance;
      case 'pharmacy':
        return Icons.local_pharmacy;
      case 'gas_station':
        return Icons.local_gas_station;
      default:
        return Icons.place;
    }
  }
}
