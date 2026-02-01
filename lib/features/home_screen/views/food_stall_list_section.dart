import 'package:automatic_demonstration/core/utils/app_constants_all.dart';
import 'package:automatic_demonstration/features/home_screen/data/models/food_stall_model.dart';
import 'package:automatic_demonstration/features/home_screen/views/audio_popup_modal.dart';
import 'package:automatic_demonstration/features/home_screen/views/widgets/inherited_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FoodStallListSection extends StatefulWidget {
  final List<FoodStallModel> foodStallModels;
  const FoodStallListSection({super.key, required this.foodStallModels});

  @override
  State<FoodStallListSection> createState() => _FoodStallListSectionState();
}

class _FoodStallListSectionState extends State<FoodStallListSection> {
  late PageController _pageController;
  late List<bool> _allowFoodStallIndexes;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    _allowFoodStallIndexes = List.filled(widget.foodStallModels.length, true);

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
              foodStallModel: widget.foodStallModels[index],
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _FoodStallList(
            models: widget.foodStallModels,
            allowed: _allowFoodStallIndexes,
            controller: _pageController,
            onPlay: _onPlay,
            onSkip: _onSkip,
          ),
        ),
        _PageIndicator(
          currentPage: _currentPage + 1,
          maxPage: widget.foodStallModels.length,
        ),
        SizedBox(height: AppConstants.spacingXS.h,)
      ],
    );
  }
}

class _FoodStallList extends StatelessWidget {
  final List<FoodStallModel> models;
  final List<bool> allowed;
  final PageController controller;
  final Function(int) onPlay;
  final Function(int) onSkip;

  const _FoodStallList({
    required this.models,
    required this.allowed,
    required this.controller,
    required this.onPlay,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      itemCount: models.length,
      itemBuilder: (context, index) {
        if (!allowed[index]) return const SizedBox.shrink();

        return Container(
          // Margin creates space outside the colored stall container
          margin: EdgeInsets.symmetric(horizontal: 12.0.w),
          child: FoodStallItemProvider(
            index: index,
            onPlayTap: () => onPlay(index),
            onSkipTap: () => onSkip(index),
            child: _FoodStallContainer(foodStallModel: models[index]),
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
              distance: foodStallModel.distance,
              audioLength: foodStallModel.audioLength,
              foodStallDescription: foodStallModel.foodStallDescription,
              foodStallName: foodStallModel.foodStallName,
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
                "${foodStallModel.distance.toStringAsFixed(1)}m",
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
  final String foodStallName;
  final String foodStallDescription;
  final double distance;
  final int audioLength;

  const _FoodStallLowerContainer({
    required this.foodStallName,
    required this.foodStallDescription,
    required this.distance,
    required this.audioLength,
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
              foodStallName,
              style: TextStyle(
                fontSize: AppConstants.fontL.sp,
                color: AppColors.textOnDark,
                fontWeight: .w700
              ),
            ),
            SizedBox(height: AppConstants.spacingXXS.h,),
            Text(
              foodStallName,
              style: TextStyle(
                fontSize: AppConstants.fontM.sp,
                color: AppColors.textOnDark,
                fontWeight: .w300
              ),
            ),

            SizedBox(height: AppConstants.spacingS.h,),

            _TimeAndSpaceDistanceRow(
              distance: distance,
              audioLength: audioLength,
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
  final int audioLength;

  const _TimeAndSpaceDistanceRow({
    required this.distance,
    required this.audioLength,
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
          "${audioLength}s",
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
                horizontal: AppConstants.spacingL.w,
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

        Expanded(
          flex: 5,
          child: GestureDetector(
            onTap: provider.onSkipTap,
            child: Container(
              height: height.h,
              decoration: BoxDecoration(
                color: AppColors.skipButtonColor,
                borderRadius: .circular(AppConstants.radiusM.r),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.spacingL.w
              ),
              child: Row(
                mainAxisAlignment: .center,
                children: [
                  Icon(
                    FontAwesomeIcons.forwardStep,
                    color: AppColors.textOnDark,
                    size: AppConstants.fontS.r,
                  ),
                  SizedBox(width: AppConstants.spacingXS.w,),
                  Text(
                    AppStrings.skipAudio,
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