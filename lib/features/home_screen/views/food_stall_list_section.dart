import 'package:automatic_demonstration/core/utils/app_constants_all.dart';
import 'package:automatic_demonstration/features/home_screen/data/models/food_stall_model.dart';
import 'package:automatic_demonstration/features/home_screen/views/audio_popup_modal.dart';
import 'package:automatic_demonstration/features/home_screen/views/widgets/inherited_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FoodStallListSection extends StatelessWidget {
  final List<FoodStallModel> foodStallModels;

  const FoodStallListSection({
    super.key,
    required this.foodStallModels
  });

  @override
  Widget build (BuildContext context) {
    return FoodStallDataProvider(
      foodStallModels: foodStallModels,
      child: Column(
        children: [
          const _FoodStallListTitle(),
          SizedBox(height: AppConstants.spacingM.h,),
          Expanded(child: const _FoodStallList())
        ],
      ),
    );
  }
}

class _FoodStallListTitle extends StatelessWidget {
  const _FoodStallListTitle();

  @override
  Widget build (BuildContext context) {
    final dataProvider = FoodStallDataProvider.of(context);
    final foodStallCount = dataProvider?.foodStallModels.length ?? 0;

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

        Container(
          decoration: BoxDecoration(
            color: Color(0xff1F2933),
            borderRadius: .circular(AppConstants.radiusXL.r),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.spacingL.w,
            vertical: AppConstants.spacingS.h,
          ),
          child: Text(
            "$foodStallCount dia diem",
            style: TextStyle(
              fontSize: AppConstants.fontS.sp,
              color: Colors.white,
              fontWeight: .w400
            ),
          ),
        )
      ],
    );
  }
}

class _FoodStallList extends StatefulWidget {
  const _FoodStallList();

  @override
  State<_FoodStallList> createState() => _FoodStallListState();
}

class _FoodStallListState extends State<_FoodStallList> {
  late List<bool> allowFoodStallIndexes;
  late List<FoodStallModel> foodStallModels;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final dataProvider = FoodStallDataProvider.of(context);
      foodStallModels = dataProvider?.foodStallModels ?? [];
      allowFoodStallIndexes = List.filled(foodStallModels.length, true);

      _isInitialized = true; // Mark as done
    }
  }

  void onSkipTap(int index) {
    setState(() {
      allowFoodStallIndexes[index] = false;
    });
  }

  void onPlayTap(int index) {
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
  }

  @override
  Widget build (BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: foodStallModels.length,
      separatorBuilder: (context, index) => SizedBox(height: AppConstants.spacingL.h),
      itemBuilder: (context, index) {
        if (!allowFoodStallIndexes[index]) return SizedBox.shrink();

        return FoodStallItemProvider(
          index: index,
          onPlayTap: onPlayTap,
          onSkipTap: onSkipTap,
          child: _FoodStallContainer(
            foodStallModel: foodStallModels[index],
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
        vertical: AppConstants.spacingM.h,
      ),
      child: Column(
        children: [
          _FoodStallUpperContainer(
            foodStallModel: foodStallModel,
          ),
          _FoodStallLowerContainer(
            distance: foodStallModel.distance,
            audioLength: foodStallModel.audioLength,
            foodStallDescription: foodStallModel.foodStallDescription,
            foodStallName: foodStallModel.foodStallName,
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
          height: 125.h,
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
          top: 15.h,
          left: 15.w,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xffe6b31f),
              borderRadius: .circular(AppConstants.radiusL.r)
            ),
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.spacingL.w,
              vertical: AppConstants.spacingS.h,
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
          horizontal: 15.w,
          vertical: AppConstants.spacingL.h,
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              foodStallName,
              style: TextStyle(
                fontSize: AppConstants.fontL.sp,
                color: AppColors.textOnDark,
                fontWeight: .w700
              ),
            ),

            SizedBox(height: AppConstants.spacingS.h,),

            Text(
              foodStallName,
              style: TextStyle(
                fontSize: AppConstants.fontM.sp,
                color: AppColors.textOnDark,
                fontWeight: .w300
              ),
            ),

            SizedBox(height: AppConstants.spacingL.h,),

            _TimeAndSpaceDistanceRow(
              distance: distance,
              audioLength: audioLength,
            ),

            SizedBox(height: AppConstants.spacingM.h,),

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
    final provider = FoodStallItemProvider.of(context);
    if (provider == null) return const SizedBox();
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => provider.onPlayTap(provider.index),
          child: Container(
            height: 40.h,
            decoration: BoxDecoration(
              color: AppColors.playButtonColor,
              borderRadius: .circular(AppConstants.radiusM.r),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.spacingL.w,
            ),
            child: Row(
              children: [
                Icon(
                  FontAwesomeIcons.play,
                  color: AppColors.textOnDark,
                  size: AppConstants.fontS.r,
                ),
                SizedBox(width: AppConstants.spacingS.w,),
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

        SizedBox(width: AppConstants.spacingM.w,),

        GestureDetector(
          onTap: () => provider.onSkipTap(provider.index),
          child: Container(
            height: 40.h,
            decoration: BoxDecoration(
              color: AppColors.skipButtonColor,
              borderRadius: .circular(AppConstants.radiusM.r),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.spacingL.w
            ),
            child: Icon(
              FontAwesomeIcons.forwardStep,
              color: AppColors.textOnDark,
              size: AppConstants.fontS.r,
            ),
          ),
        )
      ],
    );
  }
}