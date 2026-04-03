import 'package:automatic_demonstration/core/constants/constants.dart';
import 'package:automatic_demonstration/core/services/vietmap_routing_service.dart';
import 'package:automatic_demonstration/core/theme/theme.dart';
import 'package:automatic_demonstration/core/theme/theme_getter.dart';
import 'package:automatic_demonstration/features/home_screen/data/models/food_stall_model.dart';
import 'package:automatic_demonstration/features/home_screen/data/repository/routing_repository.dart';
import 'package:automatic_demonstration/features/home_screen/providers/audio_notifier.dart';
import 'package:automatic_demonstration/features/home_screen/providers/audio_service_provider.dart';
import 'package:automatic_demonstration/features/home_screen/providers/food_stall_provider.dart';
import 'package:automatic_demonstration/features/home_screen/providers/geofence_service.dart';
import 'package:automatic_demonstration/features/home_screen/utils/duration_converter.dart';
import 'package:automatic_demonstration/features/home_screen/views/widgets/audio_popup_modal.dart';
import 'package:automatic_demonstration/features/home_screen/views/widgets/category_container.dart';
import 'package:automatic_demonstration/features/home_screen/views/widgets/inherited_widgets.dart';
import 'package:automatic_demonstration/features/home_screen/views/widgets/map_container.dart';
import 'package:automatic_demonstration/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:automatic_demonstration/core/services/location_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:automatic_demonstration/core/services/analytics_service.dart';


class FoodStallListSection extends ConsumerStatefulWidget {
  final List<FoodStallModel> foodStalls;

  const FoodStallListSection({super.key, required this.foodStalls});

  @override
  ConsumerState<FoodStallListSection> createState() => _FoodStallListSectionState();
}

class _FoodStallListSectionState extends ConsumerState<FoodStallListSection> {
  late PageController _pageController;
  List<bool> _allowFoodStallIndexes = [];
  List<FoodStallModel> _foodStallModels = [];
  int _currentPage = 0;
  int _selectedCategoryIndex = 0;
  bool _isModalShowing = false;
  int _currentModalId = 0;

  @override
  void initState() {
    super.initState();
    _foodStallModels = widget.foodStalls;
    _allowFoodStallIndexes = List.generate(widget.foodStalls.length, (_) => true);
    
    _pageController = PageController(viewportFraction: 0.9);

    _pageController.addListener(() {
      int next = _pageController.page?.round() ?? 0;

      if (_currentPage != next) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() => _currentPage = next);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPlay(int index, {bool isAuto = false}) {
    AnalyticsService().trackPlay(_foodStallModels[index].id, isAuto: isAuto);
    if (_isModalShowing) {
      Navigator.pop(context);
      _isModalShowing = false;
    }

    final url = _foodStallModels[index].audioUrl;
    final notifier = ref.read(audioProvider.notifier);
    final audioState = ref.read(audioProvider);
    final playerState = ref.read(audioPlayerStateProvider).value;

    if (audioState.value == url) {
      if (playerState?.processingState == ProcessingState.completed) {
        notifier.seek(Duration.zero);
        notifier.resume();
      } else if (playerState?.playing == true) {
        notifier.pause();
      } else {
        notifier.resume();
      }
    } else {
      notifier.load(url);
    }

    _isModalShowing = true;
    final int modalId = ++_currentModalId;
    
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return AudioPopupModal(
          foodStallModel: _foodStallModels[index],
          onSkip: () {
            setState(() {
              _allowFoodStallIndexes[index] = false;
            });
            notifier.stop();
            Navigator.pop(sheetContext);
          },
        );
      },
    ).then((_) {
      if (_currentModalId == modalId) {
        _isModalShowing = false;
      }
    });
  }

  void _onSkip(int index) {
    AnalyticsService().trackSkip(_foodStallModels[index].id);
    setState(() {
      _allowFoodStallIndexes[index] = false;
    });
    
    final notifier = ref.read(audioProvider.notifier);
    notifier.stop();
    
    if (_isModalShowing) {
      Navigator.pop(context);
      _isModalShowing = false;
    }
  }

  void _onRestore(int index) {
    setState(() {
      _allowFoodStallIndexes[index] = true;
    });
  }

  List<int> get visibleIndices {
    switch (_selectedCategoryIndex) {
      case 0:
        return List.generate(_foodStallModels.length, (index) => index)
            .where((i) => _allowFoodStallIndexes[i])
            .toList();
      case 1:
        return List.generate(_foodStallModels.length, (i) => i)
            .where((i) => !_allowFoodStallIndexes[i])
            .toList();
      default:
        return List.generate(_foodStallModels.length, (i) => i)
            .where((i) => _allowFoodStallIndexes[i])
            .toList();
    }
  }

  @override
  void didUpdateWidget(FoodStallListSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.foodStalls != oldWidget.foodStalls) {
      _foodStallModels = widget.foodStalls;
      if (_allowFoodStallIndexes.length != widget.foodStalls.length) {
        _allowFoodStallIndexes = List.generate(widget.foodStalls.length, (_) => true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_foodStallModels.isEmpty && widget.foodStalls.isNotEmpty) {
      _foodStallModels = widget.foodStalls;
      _allowFoodStallIndexes =
          List.generate(widget.foodStalls.length, (_) => true);
    }

    ref.listen(geofenceServiceProvider, (previous, next) {
      if (previous == null) return;

      for (final stallId in next.keys) {
        final prevState = previous[stallId];
        final nextState = next[stallId];

        if (prevState != GeofenceState.triggered &&
            nextState == GeofenceState.triggered) {
          final index = _foodStallModels.indexWhere((s) => s.id == stallId);
          if (index != -1 && _allowFoodStallIndexes[index]) {
            // Check if audio is currently playing to prevent interrupting
            final playerState = ref.read(audioPlayerStateProvider).value;
            final isPlaying = (playerState?.playing ?? false) && 
                              playerState?.processingState != ProcessingState.completed;
            final isProcessing = playerState?.processingState == ProcessingState.loading || 
                                 playerState?.processingState == ProcessingState.buffering;
            
            // Only auto-play if no modal is showing, no audio is playing/loading
            if (!isPlaying && !isProcessing && !_isModalShowing) {
              _onPlay(index, isAuto: true);
              break; // Prevent multiple auto-plays in the same tick
            }
          }
        }
      }
    });

    return _BuildUI(
      foodStallModels: _foodStallModels,
      visibleIndices: visibleIndices,
      allowFoodStallIndexes: _allowFoodStallIndexes,
      pageController: _pageController,
      currentPage: _currentPage,
      selectedCategoryIndex: _selectedCategoryIndex,
      onPlay: _onPlay,
      onSkip: _onSkip,
      onRestore: _onRestore,
      onCategoryChanged: (int index) {
        setState(() {
          _selectedCategoryIndex = index;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients) {
            _pageController.jumpToPage(0);
          }
        });
      },
    );
  }
}

class _BuildUI extends StatelessWidget {
  final List<FoodStallModel> foodStallModels;
  final List<int> visibleIndices;
  final List<bool> allowFoodStallIndexes;
  final PageController pageController;
  final int currentPage;
  final int selectedCategoryIndex;
  final void Function(int, {bool isAuto}) onPlay;
  final Function(int) onSkip;
  final Function(int) onRestore;
  final Function(int) onCategoryChanged;

  const _BuildUI({
    required this.foodStallModels,
    required this.visibleIndices,
    required this.allowFoodStallIndexes,
    required this.pageController,
    required this.currentPage,
    required this.selectedCategoryIndex,
    required this.onPlay,
    required this.onSkip,
    required this.onRestore,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FoodStallListTitle(
          visibleIndices: visibleIndices,
          currentPage: currentPage,
        ),
        SizedBox(height: AppConstants.spacingS.h),
        AudioCategoryContainer(
          allCount: allowFoodStallIndexes.where((allowed) => allowed).length,
          listenedCount:
              allowFoodStallIndexes.where((allowed) => !allowed).length,
          onCategoryChanged: onCategoryChanged,
        ),
        SizedBox(height: AppConstants.spacingS.h),
        Expanded(
          child: _FoodStallList(
            models: foodStallModels,
            visibleIndices: visibleIndices,
            allowFoodStallIndexes: allowFoodStallIndexes,
            controller: pageController,
            onPlay: onPlay,
            onSkip: onSkip,
            onRestore: onRestore,
          ),
        ),

        SizedBox(height: AppConstants.spacingXXXL.h),
        // _AppNavigation(),
      ],
    );
  }
}

class _FoodStallListTitle extends StatelessWidget {
  final List<int> visibleIndices;
  final int currentPage;

  const _FoodStallListTitle({
    required this.visibleIndices,
    required this.currentPage,
  });

  @override
  Widget build (BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.foodStallSectionTitle,
          style: TextStyle(
            fontSize: AppConstants.fontM.sp,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            fontWeight: .w700
          ),
        ),

        _PageIndicator(
          currentPage: visibleIndices.isEmpty ? 0 : currentPage + 1,
          maxPage: visibleIndices.length,
        ),
      ],
    );
  }
}

class _FoodStallList extends ConsumerWidget {
  final List<FoodStallModel> models;
  final List<int> visibleIndices;
  final List<bool> allowFoodStallIndexes;
  final PageController controller;
  final Function(int, {bool isAuto}) onPlay;
  final Function(int) onSkip;
  final Function(int) onRestore;

  const _FoodStallList({
    required this.models,
    required this.visibleIndices,
    required this.allowFoodStallIndexes,
    required this.controller,
    required this.onPlay,
    required this.onSkip,
    required this.onRestore,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (visibleIndices.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.emptyStallList,
          style: TextStyle(
            fontSize: AppConstants.fontL.sp,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      );
    }

    final foodStallState = ref.watch(foodStallsProvider).value;
    final isLoadingMore = foodStallState?.isLoading ?? false;

    return PageView.builder(
      controller: controller,
      itemCount: visibleIndices.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= visibleIndices.length) {
          return const Center(child: CircularProgressIndicator());
        }

        // Trigger prefetch logic from poi_infinite_scroll pattern
          ref.read(foodStallsProvider.notifier).onItemVisible(index);

        int originalIndex = visibleIndices[index];
        bool isSkipped = !allowFoodStallIndexes[originalIndex];

        return Container(
          // Margin creates space outside the colored stall container
          margin: EdgeInsets.symmetric(horizontal: 12.0.w),
          child: FoodStallItemProvider(
            index: originalIndex,
            isSkipped: isSkipped,
            onPlayTap: () => onPlay(originalIndex),
            onSkipOrRestoreTap: () => isSkipped ? onRestore(originalIndex) : onSkip(originalIndex),
            child: _FoodStallContainer(foodStallModel: models[originalIndex]),
          ),
        );
      },
    );
  }
}

class _FoodStallContainer extends StatefulWidget {
  final FoodStallModel foodStallModel;

  const _FoodStallContainer({
    required this.foodStallModel,
  });

  @override
  State<_FoodStallContainer> createState() => _FoodStallContainerState();
}

class _FoodStallContainerState extends State<_FoodStallContainer> {
  String? _routeDistance;
  String? _routeTime;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRouteInfo();
  }

  @override
  void didUpdateWidget(_FoodStallContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.foodStallModel.id != oldWidget.foodStallModel.id) {
      _isLoading = true;
      _routeDistance = null;
      _routeTime = null;
      _fetchRouteInfo();
    }
  }

  Future<void> _fetchRouteInfo() async {
    final stallLat = widget.foodStallModel.latitude;
    final stallLng = widget.foodStallModel.longitude;

    try {
      final position = await LocationService().getCurrentPosition();
      if (position == null) {
        debugPrint('[RouteInfo] Skipping route fetch: No location permission or service disabled.');
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final repository = RoutingRepository(VietMapRoutingService.instance);
      final route = await repository.getRouteToStall(
        userLat: position.latitude,
        userLng: position.longitude,
        stallLat: stallLat,
        stallLng: stallLng,
      );

      if (mounted && route != null) {
        debugPrint('[RouteInfo] Success: ${route.formattedDistance}, ${route.formattedTime}');
        setState(() {
          _routeDistance = route.formattedDistance;
          _routeTime = route.formattedTime;
          _isLoading = false;
        });
      } else {
        debugPrint('[RouteInfo] Route is null');
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('[RouteInfo] Error: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build (BuildContext context) {
    final double fallbackDistance = widget.foodStallModel.distance ?? 0;
    final formattedFallback = fallbackDistance == 0
        ? "0 m"
        : (fallbackDistance >= 1000
        ? '${(fallbackDistance / 1000).toStringAsFixed(1)} km'
        : '${fallbackDistance.toStringAsFixed(1)} m');
    final distanceText = _routeDistance ?? formattedFallback;

    final duration = Duration(seconds: widget.foodStallModel.audioDuration);
    final timeText = _routeTime ?? formatDuration(duration);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppConstants.spacingS.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _FoodStallUpperContainer(
                    foodStallModel: widget.foodStallModel,
                    distanceText: distanceText,
                  ),
                  _FoodStallLowerContainer(
                    name: widget.foodStallModel.name,
                    address: widget.foodStallModel.address,
                    description: widget.foodStallModel.description,
                    distanceText: distanceText,
                    timeText: timeText,
                    isLoading: _isLoading,
                  ),
                ],
              ),
            ),
          ),
          _ActionButtonsRow(
            foodStallModel: widget.foodStallModel,
          ),
        ],
      ),
    );
  }
}

class _FoodStallUpperContainer extends StatelessWidget {
  final FoodStallModel foodStallModel;
  final String distanceText;

  const _FoodStallUpperContainer({
    required this.foodStallModel,
    required this.distanceText,
  });

  @override
  Widget build (BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 80.h,
          decoration: BoxDecoration(
            gradient: AppColors.foodStallUpperContainerBackgroundColor,
            borderRadius: .vertical(
              top: Radius.circular(AppConstants.radiusM.r)
            ),
          ),
          child: Center(
            child: Icon(Icons.coffee)
          )
        ),

        Positioned(
          top: 10.h,
          left: 15.w,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xffe6b31f),
              borderRadius: .circular(AppConstants.radiusL.r)
            ),
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.spacingL.w,
              vertical: AppConstants.spacingXS.h,
            ),
            child: Center(
              child: Text(
                distanceText,
                style: TextStyle(
                  fontSize: AppConstants.fontS.sp,
                  color: AppColors.textOnLight,
                  fontWeight: FontWeight.w300,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        )
      ]
    );
  }
}

class _FoodStallLowerContainer extends StatelessWidget {
  final String name;
  final String address;
  final String description;
  final String distanceText;
  final String timeText;
  final bool isLoading;

  const _FoodStallLowerContainer({
    required this.name,
    required this.address,
    required this.description,
    required this.distanceText,
    required this.timeText,
    required this.isLoading,
  });

  @override
  Widget build (BuildContext context) {
    final surfaceColors = context.surfaceColors;

    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColors.primarySurface,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM.w,
          vertical: AppConstants.spacingXS.h
        ),
        child: Column(
          crossAxisAlignment: .start,
          mainAxisAlignment: .center,
          children: [
            SizedBox(height: AppConstants.spacingXS.h,),
            Text(
              name,
              style: TextStyle(
                fontSize: AppConstants.fontM.sp,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: .w700
              ),
            ),
            SizedBox(height: AppConstants.spacingS.h,),
            Text(
              address,
              style: TextStyle(
                fontSize: AppConstants.fontS.sp,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: .w400
              ),
            ),

            SizedBox(height: AppConstants.spacingS.h,),

            _RouteInfoRow(
              distanceText: distanceText,
              timeText: timeText,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays route-based distance and travel time from VietMap API.
///
/// Falls back to straight-line distance when route data is unavailable.
class _RouteInfoRow extends StatelessWidget {
  final String distanceText;
  final String timeText;
  final bool isLoading;

  const _RouteInfoRow({
    required this.distanceText,
    required this.timeText,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildInfoItem(
          icon: FontAwesomeIcons.route,
          text: distanceText,
          color: Color(0xffcaa01a),
          isLoading: isLoading,
        ),

        SizedBox(width: AppConstants.spacingL.w),

        // --- Time Section ---
        _buildInfoItem(
          icon: FontAwesomeIcons.clock,
          text: timeText,
          color: Theme.of(context).textTheme.bodyMedium?.color,
          isLoading: isLoading,
        ),
      ],
    );
  }

  // Extracted helper widget to reduce code duplication
  Widget _buildInfoItem({
    required IconData icon,
    required String text,
    required Color? color,
    required bool isLoading,
  }) {
    return Expanded( // Changed to Expanded/Flexible to prevent overflow
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppConstants.fontS.r, color: color),
          SizedBox(width: AppConstants.spacingXS.w),
          isLoading
              ? SizedBox(
            width: AppConstants.fontS.r,
            height: AppConstants.fontS.r,
            child: CircularProgressIndicator(strokeWidth: 1.2, color: color),
          )
              : Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: AppConstants.fontS.sp,
                color: color,
                fontWeight: FontWeight.w300,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtonsRow extends ConsumerWidget {
  final FoodStallModel foodStallModel;

  const _ActionButtonsRow({
    required this.foodStallModel,
  });

  Future<void> _showRouteOnMap(BuildContext context) async {
    final latitude = foodStallModel.latitude;
    final longitude = foodStallModel.longitude;

    try {
      final position = await LocationService().getCurrentPosition();
      if (position == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vui lòng cấp quyền truy cập vị trí để xem đường đi.')),
          );
        }
        return;
      }

      final repository = RoutingRepository(VietMapRoutingService.instance);
      final route = await repository.getRouteToStall(
        userLat: position.latitude,
        userLng: position.longitude,
        stallLat: latitude,
        stallLng: longitude,
      );

      if (route != null && route.points.isNotEmpty) {
        MapContainer.globalKey.currentState?.drawRoute(route.points);
      }
    } catch (e) {
      if (context.mounted) {
        final errorMsg = AppLocalizations.of(context)!.routingError;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$errorMsg: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surfaceColors = context.surfaceColors;
    final selectionColors = context.selectionColors;

    final provider = FoodStallItemProvider.of(context);
    if (provider == null) return const SizedBox();

    final audioAsync = ref.watch(audioProvider);
    final playerStateAsync = ref.watch(audioPlayerStateProvider);

    final currentAudioUrl = audioAsync.value;
    final isPlaying = playerStateAsync.value?.playing ?? false;
    final isCompleted = playerStateAsync.value?.processingState == ProcessingState.completed;
    final isCurrentStallPlaying = isPlaying && !isCompleted && currentAudioUrl == foodStallModel.audioUrl;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColors.primarySurface,
        borderRadius: .vertical(bottom: Radius.circular(AppConstants.radiusM.r)),
      ),
      padding: EdgeInsets.only(
          left: AppConstants.spacingS.w,
          right: AppConstants.spacingS.w,
          top: AppConstants.spacingS.w,
          bottom: AppConstants.spacingS.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
              flex: 3,
              child: _ActionButtonContainer(
                  latitude: foodStallModel.latitude,
                  longitude: foodStallModel.longitude,
                  icon: isCurrentStallPlaying
                      ? FontAwesomeIcons.pause
                      : FontAwesomeIcons.play,
                  name: isCurrentStallPlaying
                      ? AppLocalizations.of(context)!.audioIsStoppedButton
                      : AppLocalizations.of(context)!.playAudio,
                  bgColor: isCurrentStallPlaying
                      ? AppColors.enable
                      : AppColors.playButtonColor,
                  onClick: provider.onPlayTap)),
          SizedBox(
            width: AppConstants.spacingXS.w,
          ),
          Expanded(
              flex: 4,
              child: _ActionButtonContainer(
                latitude: foodStallModel.latitude,
                longitude: foodStallModel.longitude,
                icon: FontAwesomeIcons.route,
                name: AppLocalizations.of(context)!.routing,
                bgColor: Color(0xff4A90D9),
                onClick: () => _showRouteOnMap(context),
              )),
          SizedBox(
            width: AppConstants.spacingXS.w,
          ),
          Expanded(
              flex: 3,
              child: _ActionButtonContainer(
                  latitude: foodStallModel.latitude,
                  longitude: foodStallModel.longitude,
                  icon: provider.isSkipped
                      ? FontAwesomeIcons.rotateLeft
                      : FontAwesomeIcons.forwardStep,
                  name: provider.isSkipped
                      ? AppLocalizations.of(context)!.restoreAudio
                      : AppLocalizations.of(context)!.skipAudio,
                  bgColor: provider.isSkipped
                      ? AppColors.playButtonColor
                      : selectionColors.selectedText,
                  onClick: provider.onSkipOrRestoreTap))
        ],
      ),
    );
  }
}

class _ActionButtonContainer extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final IconData icon;
  final String name;
  final Color bgColor;
  final Function() onClick;

  const _ActionButtonContainer({
    required this.latitude,
    required this.longitude,
    required this.icon,
    required this.name,
    required this.bgColor,
    required this.onClick,
  });

  @override
  Widget build (BuildContext context) {
    final surfaceColors = context.surfaceColors;

    final int height = 25;

    return GestureDetector(
      onTap: () => onClick(),
      child: Container(
        height: height.h,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.spacingXXS.w
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: surfaceColors.primarySurface,
              size: AppConstants.fontXS.r,
            ),
            SizedBox(width: AppConstants.spacingXS.w,),
            Text(
              name,
              style: TextStyle(
                fontSize: AppConstants.fontXS.sp,
                color: surfaceColors.primarySurface,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int currentPage;
  final int maxPage;

  const _PageIndicator({
    required this.currentPage,
    required this.maxPage
  });

  @override
  Widget build (BuildContext context) {
    return Text(
     "$currentPage/$maxPage",
     style: TextStyle(
       fontSize: AppConstants.fontM.sp,
         color: Theme.of(context).textTheme.bodyMedium?.color,
       fontWeight: .w700
     ),
    );
  }
}

// class _AppNavigation extends StatelessWidget {
//   const _AppNavigation();
//
//   @override
//   Widget build(BuildContext context) {
//
//   }
// }