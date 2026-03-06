import 'package:automatic_demonstration/core/constants/constants.dart';
import 'package:automatic_demonstration/core/theme/theme.dart';
import 'package:automatic_demonstration/features/home_screen/data/models/food_stall_model.dart';
import 'package:automatic_demonstration/features/home_screen/providers/food_stall.dart';
import 'package:automatic_demonstration/features/home_screen/views/widgets/audio_popup_modal.dart';
import 'package:automatic_demonstration/features/home_screen/views/widgets/category_container.dart';
import 'package:automatic_demonstration/features/home_screen/views/widgets/inherited_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            color: Colors.white70,
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
        const _FoodStallListTitle(),
        SizedBox(height: AppConstants.spacingM.h),
        AudioCategoryContainer(
          allCount: allowFoodStallIndexes.where((allowed) => allowed).length,
          listenedCount:
              allowFoodStallIndexes.where((allowed) => !allowed).length,
          onCategoryChanged: onCategoryChanged,
        ),
        SizedBox(height: AppConstants.spacingM.h),
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
        _PageIndicator(
          currentPage: visibleIndices.isEmpty ? 0 : currentPage + 1,
          maxPage: visibleIndices.length,
        ),
        SizedBox(height: AppConstants.spacingXS.h),
      ],
    );
  }
}

class _FoodStallListTitle extends StatelessWidget {
  const _FoodStallListTitle();

  @override
  Widget build (BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(
          AppStrings.foodStallSectionTitle,
          style: TextStyle(
            fontSize: AppConstants.fontL.sp,
            color: Colors.white,
            fontWeight: .w700
          ),
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
            color: Colors.white70,
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
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _FoodStallUpperContainer(
                    foodStallModel: foodStallModel,
                  ),
                  _FoodStallLowerContainer(
                    distance: foodStallModel.distance ?? 0,
                    audioDuration: foodStallModel.audioDuration,
                    description: foodStallModel.description,
                    name: foodStallModel.name,
                  ),
                ],
              ),
            ),
          ),

          _ActionButtonsRow(),
        ]
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

  const _FoodStallLowerContainer({
    required this.name,
    required this.description,
    required this.distance,
    required this.audioDuration,
  });

  @override
  Widget build (BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.foodStallLowerContainerBackgroundColor,
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
                  fontSize: AppConstants.fontL.sp,
                  color: AppColors.textOnDark,
                  fontWeight: .w700
                ),
              ),
              SizedBox(height: AppConstants.spacingXXS.h,),
              Text(
                description,
                style: TextStyle(
                  fontSize: AppConstants.fontM.sp,
                  color: AppColors.textOnDark,
                  fontWeight: .w300
                ),
              ),

              SizedBox(height: AppConstants.spacingS.h,),

              _TimeAndSpaceDistanceRow(
                distance: distance,
                audioDuration: audioDuration,
              ),
            ],
          ),
      ),
    );
  }
}

class _TimeAndSpaceDistanceRow extends StatelessWidget {
  final double distance;
  final int audioDuration;

  const _TimeAndSpaceDistanceRow({
    required this.distance,
    required this.audioDuration,
  });

  @override
  Widget build (BuildContext context) {
    return Row(
      children: [
        Icon(
          FontAwesomeIcons.locationDot,
          size: AppConstants.fontM.r,
          color: Color(0xffcaa01a),
        ),
        SizedBox(width: AppConstants.spacingXS.w,),
        Text(
          "${distance.toStringAsFixed(1)}m",
          style: TextStyle(
            fontSize: AppConstants.fontM.sp,
            color: Color(0xffcaa01a),
            fontWeight: .w300
          ),
        ),

        SizedBox(width: AppConstants.spacingL.w,),

        Icon(
          FontAwesomeIcons.clock,
          size: AppConstants.fontM.r,
          color: AppColors.textOnDark,
        ),
        SizedBox(width: AppConstants.spacingXS.w,),
        Text(
          "${audioDuration}s",
          style: TextStyle(
            fontSize: AppConstants.fontM.sp,
            color: AppColors.textOnDark,
            fontWeight: .w300
          ),
        ),
      ],
    );
  }
}

class _ActionButtonsRow extends StatelessWidget {
  const _ActionButtonsRow();

  @override
  Widget build (BuildContext context) {
    final int height = 28;
    final provider = FoodStallItemProvider.of(context);
    if (provider == null) return const SizedBox();
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.foodStallLowerContainerBackgroundColor,
        borderRadius: .vertical(bottom: Radius.circular(AppConstants.radiusM.r)),
      ),
      padding: EdgeInsets.only(
        left: AppConstants.spacingM.w,
        right: AppConstants.spacingM.w,
        top: AppConstants.spacingXS.w,
        bottom: AppConstants.spacingS.h
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 5,
            child: GestureDetector(
              onTap: provider.onPlayTap,
              child: Container(
                height: height.h,
                decoration: BoxDecoration(
                  color: AppColors.playButtonColor,
                  borderRadius: .circular(AppConstants.radiusM.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingM.w
                ),
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    Icon(
                      FontAwesomeIcons.play,
                      color: AppColors.textOnDark,
                      size: AppConstants.fontS.r,
                    ),
                    SizedBox(width: AppConstants.spacingXS.w,),
                    Text(
                      AppStrings.playAudio,
                      style: TextStyle(
                        fontSize: AppConstants.fontM.sp,
                        color: AppColors.textOnDark,
                        fontWeight: .w400
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: AppConstants.spacingS.w,),
          Expanded(
            flex: 5,
            child: GestureDetector(
              onTap: provider.onSkipOrRestoreTap,
              child: Container(
                height: height.h,
                decoration: BoxDecoration(
                  color: provider.isSkipped
                      ? AppColors.playButtonColor
                      : AppColors.skipButtonColor,
                  borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingM.w
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      provider.isSkipped
                        ? FontAwesomeIcons.rotateLeft
                        : FontAwesomeIcons.forwardStep,
                      color: AppColors.textOnDark,
                      size: AppConstants.fontS.r,
                    ),
                    SizedBox(width: AppConstants.spacingXS.w,),
                    Text(
                      provider.isSkipped
                        ? AppStrings.restoreAudio
                        : AppStrings.skipAudio,
                      style: TextStyle(
                          fontSize: AppConstants.fontM.sp,
                          color: AppColors.textOnDark,
                          fontWeight: FontWeight.w400
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
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
       fontSize: AppConstants.fontL.sp,
       color: Colors.white,
       fontWeight: .w700
     ),
    );
  }
}