import 'package:automatic_demonstration/core/utils/app_constants_all.dart';
import 'package:automatic_demonstration/features/home_screen/data/food_stall_model.dart';
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
            borderRadius: .circular(AppConstants.radiusXXL.r),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.spacingL.w,
            vertical: AppConstants.spacingM.h,
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

class _FoodStallList extends StatelessWidget {
  const _FoodStallList();

  @override
  Widget build (BuildContext context) {
    final dataProvider = FoodStallDataProvider.of(context);
    final foodStallModels = dataProvider?.foodStallModels ?? [];

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: foodStallModels.length,
      separatorBuilder: (context, index) => SizedBox(height: AppConstants.spacingL.h),
      itemBuilder: (context, index) {
        return _FoodStallContainer(foodStallModel: foodStallModels[index]);
      },
    );
  }
}

class _FoodStallContainer extends StatelessWidget {
  final FoodStallModel foodStallModel;

  const _FoodStallContainer({
    required this.foodStallModel
  });

  @override
  Widget build (BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.spacingM.w,
        vertical: AppConstants.spacingM.h,
      ),
      child: Column(
        children: [
          _FoodStallUpperContainer(
            foodStallModel: foodStallModel,
          ),
          _FoodStallLowerContainer(
            distanceMeter: foodStallModel.distanceMeter,
            distanceSecond: foodStallModel.distanceSecond,
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
                "${foodStallModel.distanceMeter.toStringAsFixed(1)}m",
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
  final double distanceMeter;
  final int distanceSecond;

  const _FoodStallLowerContainer({
    required this.foodStallName,
    required this.foodStallDescription,
    required this.distanceMeter,
    required this.distanceSecond
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
              distanceMeter: distanceMeter,
              distanceSecond: distanceSecond,
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
  final double distanceMeter;
  final int distanceSecond;

  const _TimeAndSpaceDistanceRow({
    required this.distanceMeter,
    required this.distanceSecond,
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
          "${distanceMeter.toStringAsFixed(1)}m",
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
          "${distanceSecond}s",
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
    return Row(
      children: [
        Container(
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

        SizedBox(width: AppConstants.spacingXS.w,),

        Container(
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
        )
      ],
    );
  }
}