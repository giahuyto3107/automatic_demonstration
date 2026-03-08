import 'package:automatic_demonstration/core/constants/constants.dart';
import 'package:automatic_demonstration/core/services/vietmap_routing_service.dart';
import 'package:automatic_demonstration/core/theme/theme.dart';
import 'package:automatic_demonstration/core/theme/theme_getter.dart';
import 'package:automatic_demonstration/features/home_screen/data/models/food_stall_model.dart';
import 'package:automatic_demonstration/features/home_screen/data/repository/routing_repository.dart';
import 'package:automatic_demonstration/features/home_screen/providers/food_stall.dart';
import 'package:automatic_demonstration/features/home_screen/views/widgets/audio_popup_modal.dart';
import 'package:automatic_demonstration/features/home_screen/views/widgets/category_container.dart';
import 'package:automatic_demonstration/features/home_screen/views/widgets/inherited_widgets.dart';
import 'package:automatic_demonstration/features/home_screen/views/widgets/map_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

class FoodStallListSection extends ConsumerStatefulWidget {
  const FoodStallListSection({super.key});

  @override
  ConsumerState<FoodStallListSection> createState() => _FoodStallListSectionState();
}

class _FoodStallListSectionState extends ConsumerState<FoodStallListSection> {
  late PageController _pageController;
  List<bool> _allowFoodStallIndexes = [];
  List<FoodStallModel> _foodStallModels = [];
  int _currentPage = 0;
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
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

  void _onPlay(int index) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return AudioPopupModal(
          foodStallModel: _foodStallModels[index],
        );
      },
    );
  }

  void _onSkip(int index) {
    setState(() {
      _allowFoodStallIndexes[index] = false;
    });
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
  Widget build(BuildContext context) {
    final foodStallAsync = ref.watch(foodStallProvider);

    return foodStallAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Text(
          'Lỗi tải dữ liệu: $error',
          style: TextStyle(
            fontSize: AppConstants.fontM.sp,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ),
      data: (foodStalls) {
        // Sync state fields when data arrives or changes
        if (_foodStallModels.length != foodStalls.length) {
          _foodStallModels = foodStalls;
          _allowFoodStallIndexes =
              List.generate(foodStalls.length, (_) => true);
        }

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
  final Function(int) onPlay;
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
            allowedIndexes: allowFoodStallIndexes,
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
          AppStrings.foodStallSectionTitle,
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

class _FoodStallList extends StatelessWidget {
  final List<FoodStallModel> models;
  final List<int> visibleIndices;
  final List<bool> allowedIndexes;
  final PageController controller;
  final Function(int) onPlay;
  final Function(int) onSkip;
  final Function(int) onRestore;

  const _FoodStallList({
    required this.models,
    required this.visibleIndices,
    required this.allowedIndexes,
    required this.controller,
    required this.onPlay,
    required this.onSkip,
    required this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    if (visibleIndices.isEmpty) {
      return Center(
        child: Text(
          'Không có quán nào',
          style: TextStyle(
            fontSize: AppConstants.fontL.sp,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      );
    }

    return PageView.builder(
      controller: controller,
      itemCount: visibleIndices.length,
      itemBuilder: (context, index) {
        int originalIndex = visibleIndices[index];
        bool isSkipped = !allowedIndexes[originalIndex];

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

class _FoodStallContainer extends StatelessWidget {
  final FoodStallModel foodStallModel;

  const _FoodStallContainer({
    required this.foodStallModel,
  });

  @override
  Widget build (BuildContext context) {

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
                    foodStallModel: foodStallModel,
                  ),
                  _FoodStallLowerContainer(
                    distance: foodStallModel.distance ?? 0,
                    audioDuration: foodStallModel.audioDuration,
                    description: foodStallModel.description,
                    name: foodStallModel.name,
                    latitude: foodStallModel.latitude,
                    longitude: foodStallModel.longitude,
                  ),
                ],
              ),
            ),
          ),
          _ActionButtonsRow(
            latitude: foodStallModel.latitude,
            longitude: foodStallModel.longitude,
          ),
        ],
      ),
    );
  }
}

class _FoodStallUpperContainer extends StatelessWidget {
  final FoodStallModel foodStallModel;

  const _FoodStallUpperContainer({
    required this.foodStallModel
  });

  @override
  Widget build (BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 90.h,
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
                // "${foodStallModel.distance!.toStringAsFixed(1)}m",
                "${foodStallModel.distance ?? 0}m",
                style: TextStyle(
                  fontWeight: .w500,
                  fontSize: AppConstants.fontXS.sp,
                  color: AppColors.textOnLight
                ),
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
  final String description;
  final double distance;
  final int audioDuration;
  final double? latitude;
  final double? longitude;

  const _FoodStallLowerContainer({
    required this.name,
    required this.description,
    required this.distance,
    required this.audioDuration,
    this.latitude,
    this.longitude,
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
              Text(
                name,
                style: TextStyle(
                  fontSize: AppConstants.fontM.sp,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontWeight: .w700
                ),
              ),
              SizedBox(height: AppConstants.spacingXXS.h,),
              Text(
                description,
                style: TextStyle(
                  fontSize: AppConstants.fontS.sp,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontWeight: .w300
                ),
              ),

              SizedBox(height: AppConstants.spacingS.h,),

              _RouteInfoRow(
                stallLat: latitude,
                stallLng: longitude,
                fallbackDistance: distance,
                audioDuration: audioDuration,
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
class _RouteInfoRow extends StatefulWidget {
  final double? stallLat;
  final double? stallLng;
  final double fallbackDistance;
  final int audioDuration;

  const _RouteInfoRow({
    required this.stallLat,
    required this.stallLng,
    required this.fallbackDistance,
    required this.audioDuration,
  });

  @override
  State<_RouteInfoRow> createState() => _RouteInfoRowState();
}

class _RouteInfoRowState extends State<_RouteInfoRow> {
  String? _routeDistance;
  String? _routeTime;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRouteInfo();
  }

  Future<void> _fetchRouteInfo() async {
    if (widget.stallLat == null || widget.stallLng == null) {
      debugPrint('[RouteInfo] Stall coordinates are null');
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      debugPrint('[RouteInfo] User: ${position.latitude}, ${position.longitude} -> Stall: ${widget.stallLat}, ${widget.stallLng}');

      final repository = RoutingRepository(VietMapRoutingService.instance);
      final route = await repository.getRouteToStall(
        userLat: position.latitude,
        userLng: position.longitude,
        stallLat: widget.stallLat!,
        stallLng: widget.stallLng!,
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
  Widget build(BuildContext context) {
    final distanceText = _routeDistance ?? '${widget.fallbackDistance.toStringAsFixed(1)}m';
    final timeText = _routeTime ?? '${widget.audioDuration}s';

    return Row(
      children: [
        Icon(
          FontAwesomeIcons.route,
          size: AppConstants.fontS.r,
          color: Color(0xffcaa01a),
        ),
        SizedBox(width: AppConstants.spacingXS.w),
        _isLoading
            ? SizedBox(
                width: AppConstants.fontM.r,
                height: AppConstants.fontM.r,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: Color(0xffcaa01a),
                ),
              )
            : Flexible(
              child: Text(
                distanceText,
                style: TextStyle(
                  fontSize: AppConstants.fontS.sp,
                  color: Color(0xffcaa01a),
                  fontWeight: FontWeight.w300,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        SizedBox(width: AppConstants.spacingL.w),
        Icon(
          FontAwesomeIcons.clock,
          size: AppConstants.fontS.r,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
        SizedBox(width: AppConstants.spacingXS.w),
        _isLoading
            ? SizedBox(
                width: AppConstants.fontS.r,
                height: AppConstants.fontS.r,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                ),
              )
            : Flexible(
              child: Text(
                timeText,
                style: TextStyle(
                  fontSize: AppConstants.fontS.sp,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontWeight: FontWeight.w300,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
      ],
    );
  }
}

class _ActionButtonsRow extends StatelessWidget {
  final double? latitude;
  final double? longitude;

  const _ActionButtonsRow({
    this.latitude,
    this.longitude,
  });

  Future<void> _showRouteOnMap(BuildContext context) async {
    if (latitude == null || longitude == null) return;

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final repository = RoutingRepository(VietMapRoutingService.instance);
      final route = await repository.getRouteToStall(
        userLat: position.latitude,
        userLng: position.longitude,
        stallLat: latitude!,
        stallLng: longitude!,
      );

      if (route != null && route.points.isNotEmpty) {
        MapContainer.globalKey.currentState?.drawRoute(route.points);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể tải chỉ đường: $e')),
        );
      }
    }
  }

  @override
  Widget build (BuildContext context) {
    final surfaceColors = context.surfaceColors;

    final provider = FoodStallItemProvider.of(context);
    if (provider == null) return const SizedBox();
    
    return Container(
      decoration: BoxDecoration(
        color: surfaceColors.primarySurface,
        borderRadius: .vertical(bottom: Radius.circular(AppConstants.radiusM.r)),
      ),
      padding: EdgeInsets.only(
        left: AppConstants.spacingS.w,
        right: AppConstants.spacingS.w,
        top: AppConstants.spacingS.w,
        bottom: AppConstants.spacingS.h
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 3,
            child: _ActionButtonContainer(
              latitude: latitude,
              longitude: longitude,
              icon: FontAwesomeIcons.play,
              name: AppStrings.playAudio,
              bgColor: AppColors.playButtonColor,
              onClick: provider.onPlayTap
            )
          ),
          SizedBox(width: AppConstants.spacingXS.w,),
          Expanded(
            flex: 4,
            child: _ActionButtonContainer(
              latitude: latitude,
              longitude: longitude,
              icon: FontAwesomeIcons.route,
              name: 'Chỉ đường',
              bgColor: Color(0xff4A90D9),
              onClick: () => _showRouteOnMap(context),
            )
          ),
          SizedBox(width: AppConstants.spacingXS.w,),
          Expanded(
            flex: 3,
            child: _ActionButtonContainer(
              latitude: latitude,
              longitude: longitude,
              icon: provider.isSkipped
                  ? FontAwesomeIcons.rotateLeft
                  : FontAwesomeIcons.forwardStep,
              name: provider.isSkipped
                  ? AppStrings.restoreAudio
                  : AppStrings.skipAudio,
              bgColor: provider.isSkipped
                  ? AppColors.playButtonColor
                  : surfaceColors.skipButtonSurface,
              onClick: provider.onSkipOrRestoreTap
            )
          )
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
              color: AppColors.textOnDark,
              size: AppConstants.fontXS.r,
            ),
            SizedBox(width: AppConstants.spacingXS.w,),
            Text(
              name,
              style: TextStyle(
                fontSize: AppConstants.fontXS.sp,
                color: AppColors.textOnDark,
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