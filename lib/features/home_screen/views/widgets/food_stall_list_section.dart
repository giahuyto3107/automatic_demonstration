import 'package:automatic_demonstration/core/constants/constants.dart';
import 'package:automatic_demonstration/core/theme/theme.dart';
import 'package:automatic_demonstration/features/home_screen/data/models/food_stall_model.dart';
import 'package:automatic_demonstration/features/home_screen/views/widgets/audio_popup_modal.dart';
import 'package:automatic_demonstration/features/home_screen/views/widgets/category_container.dart';
import 'package:automatic_demonstration/features/home_screen/views/widgets/inherited_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FoodStallListSection extends StatefulWidget {
  const FoodStallListSection({super.key});

  @override
  State<FoodStallListSection> createState() => _FoodStallListSectionState();
}

class _FoodStallListSectionState extends State<FoodStallListSection> {
  late PageController _pageController;
  late List<bool> _allowFoodStallIndexes;
  int _currentPage = 0;
  int _selectedCategoryIndex = 0;

  // Tính distance cho các quán ăn trong initState

  List<FoodStallModel> foodStallModels = [
    FoodStallModel(
      name: "Green Garden Salads",
      description: "Fresh organic salads and cold-pressed juices.",
      distance: 450.5,
      audioDuration: 300,
      imageUrl: "assets/images/stalls/salad_stall.jpg",
    ),
    FoodStallModel(
      name: "The Burger Hub",
      description: "Juicy Wagyu burgers with homemade brioche buns.",
      distance: 1200.0,
      audioDuration: 720,
      imageUrl: "assets/images/stalls/burger_hub.jpg",
    ),
    FoodStallModel(
      name: "Sushi Zen",
      description: "Authentic hand-rolled sushi and sashimi platters.",
      distance: 850.0,
      audioDuration: 510,
      imageUrl: "assets/images/stalls/sushi_zen.jpg",
    ),
    FoodStallModel(
      name: "Pasta la Vista",
      description: "Freshly made Italian pasta with secret family sauces.",
      distance: 2100.0,
      audioDuration: 1200,
      imageUrl: "assets/images/stalls/pasta_stall.jpg",
    ),
    FoodStallModel(
      name: "Taco Fiesta",
      description: "Spicy Mexican street tacos with zesty lime crema.",
      distance: 300.0,
      audioDuration: 180,
      imageUrl: "assets/images/stalls/taco_fiesta.jpg",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    _allowFoodStallIndexes = List.filled(foodStallModels.length, true);

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
    _pageController.dispose(); // Clean up memory
    super.dispose();
  }

  void _onPlay(int index) {
    setState(() {
      showModalBottomSheet(
          context: context,
          isDismissible: true,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext sheetContext) {
            return AudioPopupModal(
              foodStallModel: foodStallModels[index],
            );
          }
      );
    });
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
    switch(_selectedCategoryIndex) {
      case 0:
        return List.generate(foodStallModels.length, (index) => index)
          .where((i) => _allowFoodStallIndexes[i])
          .toList();
      case 1:
        return List.generate(foodStallModels.length, (i) => i)
          .where((i) => !_allowFoodStallIndexes[i])
          .toList();
      default:
        return List.generate(foodStallModels.length, (i) => i)
          .where((i) => _allowFoodStallIndexes[i])
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _FoodStallListTitle(),
        SizedBox(height: AppConstants.spacingM.h,),
        AudioCategoryContainer(
          allCount: _allowFoodStallIndexes.where((allowed) => allowed).length,
          listenedCount: _allowFoodStallIndexes.where((allowed) => !allowed).length,
          onCategoryChanged: (int index) {
            setState(() {
              _selectedCategoryIndex = index;
            });
            // Only jump to page if PageController is attached (list not empty)
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_pageController.hasClients) {
                _pageController.jumpToPage(0);
              }
            });
          }
        ),
        SizedBox(height: AppConstants.spacingM.h,),
        Expanded(
          child: _FoodStallList(
            models: foodStallModels,
            visibleIndices: visibleIndices,
            allowedIndexes: _allowFoodStallIndexes,
            controller: _pageController,
            onPlay: _onPlay,
            onSkip: _onSkip,
            onRestore: _onRestore,
          ),
        ),
        _PageIndicator(
          currentPage: visibleIndices.isEmpty
            ? 0
            : _currentPage + 1,
          maxPage: visibleIndices.length,
        ),
        SizedBox(height: AppConstants.spacingXS.h,)
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
            flex: 4,
            child: _FoodStallUpperContainer(
              foodStallModel: foodStallModel,
            ),
          ),
          Expanded(
            flex: 6,
            child: _FoodStallLowerContainer(
              distance: foodStallModel.distance!,
              audioDuration: foodStallModel.audioDuration,
              description: foodStallModel.description,
              name: foodStallModel.name,
            ),
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
                "${foodStallModel.distance!.toStringAsFixed(1)}m",
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
          borderRadius: .vertical(bottom: Radius.circular(AppConstants.radiusM.r)),
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
              name,
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
            SizedBox(height: AppConstants.spacingS.h,),
            _ActionButtonsRow()
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
          color: AppColors.textOnDark,
        ),
        SizedBox(width: AppConstants.spacingXS.w,),
        Text(
          "${distance.toStringAsFixed(1)}m",
          style: TextStyle(
            fontSize: AppConstants.fontM.sp,
            color: AppColors.textOnDark,
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
    
    return Row(
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