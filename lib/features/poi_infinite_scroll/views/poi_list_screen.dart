import 'package:automatic_demonstration/features/poi_infinite_scroll/providers/poi_list_provider.dart';
import 'package:automatic_demonstration/features/poi_infinite_scroll/providers/user_location_provider.dart';
import 'package:automatic_demonstration/features/poi_infinite_scroll/widgets/poi_list_item.dart';
import 'package:automatic_demonstration/features/poi_infinite_scroll/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// POI Infinite Scroll List screen.
///
/// Features:
/// - ListView.builder with efficient item rendering
/// - Prefetch buffer: loads next page when 5 items from end
/// - Pull-to-refresh support
/// - Location permission handling
/// - Error states with retry
class POIListScreen extends ConsumerStatefulWidget {
  const POIListScreen({super.key});

  @override
  ConsumerState<POIListScreen> createState() => _POIListScreenState();
}

class _POIListScreenState extends ConsumerState<POIListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Get current visible items and notify for prefetch
    // This is handled more precisely in itemBuilder via onItemVisible
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(userLocationProvider);
    final poiState = ref.watch(pOIListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Địa điểm gần bạn'),
        actions: [
          // Location status indicator
          _buildLocationIndicator(locationState),
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(pOIListProvider.notifier).refresh(),
          ),
        ],
      ),
      body: _buildBody(poiState, locationState),
    );
  }

  Widget _buildLocationIndicator(UserLocationState locationState) {
    IconData icon;
    Color color;
    String tooltip;

    if (!locationState.isServiceEnabled) {
      icon = Icons.location_off;
      color = Colors.red;
      tooltip = 'Dịch vụ định vị đang tắt';
    } else if (!locationState.hasPermission) {
      icon = Icons.location_disabled;
      color = Colors.orange;
      tooltip = 'Chưa cấp quyền vị trí';
    } else if (locationState.isAvailable) {
      icon = Icons.my_location;
      color = Colors.green;
      tooltip = 'Đã xác định vị trí';
    } else {
      icon = Icons.location_searching;
      color = Colors.grey;
      tooltip = 'Đang tìm vị trí...';
    }

    return IconButton(
      icon: Icon(icon, color: color),
      tooltip: tooltip,
      onPressed: () => _showLocationDialog(locationState),
    );
  }

  void _showLocationDialog(UserLocationState locationState) {
    if (!locationState.hasPermission) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Quyền vị trí'),
          content: Text(locationState.errorMessage ?? 
              'Ứng dụng cần quyền truy cập vị trí để tính khoảng cách.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ref.read(userLocationProvider.notifier).requestPermission();
              },
              child: const Text('Cấp quyền'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildBody(POIListState poiState, UserLocationState locationState) {
    // Show location permission request if needed
    if (!locationState.hasPermission && !locationState.isServiceEnabled) {
      return _buildLocationPermissionView(locationState);
    }

    // Initial loading state
    if (poiState.isInitialLoad) {
      return _buildLoadingView();
    }

    // Error state with no content
    if (!poiState.hasContent && poiState.errorMessage != null) {
      return _buildErrorView(poiState.errorMessage!);
    }

    // Content available
    return RefreshIndicator(
      onRefresh: () => ref.read(pOIListProvider.notifier).refresh(),
      child: _buildList(poiState),
    );
  }

  Widget _buildLocationPermissionView(UserLocationState locationState) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              locationState.errorMessage ?? 
                  'Cần quyền truy cập vị trí để hiển thị địa điểm gần bạn',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => 
                  ref.read(userLocationProvider.notifier).requestPermission(),
              icon: const Icon(Icons.location_on),
              label: const Text('Cấp quyền vị trí'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => const POIListItemShimmer(),
    );
  }

  Widget _buildErrorView(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.read(pOIListProvider.notifier).refresh(),
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(POIListState poiState) {
    return ListView.builder(
      controller: _scrollController,
      // Add 1 for loading indicator at the bottom
      itemCount: poiState.itemCount + (poiState.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        // Loading indicator at the bottom
        if (index >= poiState.itemCount) {
          return _buildLoadingIndicator();
        }

        // Notify for prefetch when reaching trigger index
        if (index >= poiState.prefetchTriggerIndex) {
          // Schedule prefetch notification for next frame
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(pOIListProvider.notifier).onItemVisible(index);
          });
        }

        final poi = poiState.items[index];
        return POIListItem(
          poi: poi,
          index: index,
          onTap: () => _onPOITap(poi),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  void _onPOITap(poi) {
    // Navigate to POI detail or perform action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã chọn: ${poi.name}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
