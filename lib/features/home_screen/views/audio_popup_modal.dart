import 'dart:async';

import 'package:automatic_demonstration/core/utils/app_constants_all.dart';
import 'package:automatic_demonstration/features/home_screen/data/food_stall_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:automatic_demonstration/core/utils/time_converter.dart';

class AudioPopupModal extends StatelessWidget {
  final FoodStallModel foodStallModel;

  const AudioPopupModal({
    super.key,
    required this.foodStallModel
  });

  @override
  Widget build (BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 36.w,
        vertical: AppConstants.spacingM.h,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff2E3A44)
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.spacingM.w,
            vertical: AppConstants.spacingM.h,
          ),
          child: Column(
            mainAxisSize: .min,
            children: [
              _ModalHeading(
                foodStallModel: foodStallModel
              ),
              SizedBox(height: AppConstants.spacingS.h,),
              _AudioSlider(
                foodStallModel: foodStallModel,
                maximumTimelineSec: 59,
              ),
              SizedBox(height: AppConstants.spacingXS.h,),
              _PlayStopToggleButton(),
              SizedBox(height: AppConstants.spacingL.h,),
              _TextContainer(
                foodStallModel: foodStallModel
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ModalHeading extends StatelessWidget {
  final FoodStallModel foodStallModel;

  const _ModalHeading({
    required this.foodStallModel,
  });

  @override
  Widget build (BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.coffee,
          color: AppColors.textOnDark,
          size: AppConstants.spacingXXXL.r,
        ),

        SizedBox(width: AppConstants.spacingM.w,),

        Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              foodStallModel.foodStallName,
              style: TextStyle(
                fontSize: AppConstants.fontM.sp,
                color: AppColors.textOnDark,
                fontWeight: .w700
              ),
            ),

            Row(
              children: [
                Icon(
                  FontAwesomeIcons.volumeHigh,
                  color: AppColors.textOnDark,
                  size: AppConstants.fontXS.r,
                ),
                SizedBox(width: AppConstants.spacingS.w,),
                Text(
                  AppStrings.audioIsPlaying,
                  style: TextStyle(
                    fontSize: AppConstants.fontXS.sp,
                    color: AppColors.textOnDark,
                    fontWeight: .w400
                  ),
                )
              ],
            )

          ],
        )
      ],
    );
  }
}

class _AudioSlider extends StatefulWidget {
  final int maximumTimelineSec;
  final FoodStallModel foodStallModel;

  const _AudioSlider({
    required this.foodStallModel,
    required this.maximumTimelineSec,
  });

  @override
  State<_AudioSlider> createState() => _AudioSliderState();
}

class _AudioSliderState extends State<_AudioSlider> {
  Timer? _timer;
  late int totalDurationSeconds;
  int currentAudioSecond = 0;
  double currentAudioPercentage = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalDurationSeconds = widget.maximumTimelineSec;
    startProgress();
  }

  void startProgress() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // Calculate the increment for 1 second (100% / total seconds)
        double step = 1.0 / totalDurationSeconds;

        if (currentAudioPercentage + step >= 1.0) {
          currentAudioPercentage = 1.0;
          currentAudioSecond = totalDurationSeconds;
          timer.cancel(); // Stop when finished
        } else {
          currentAudioPercentage += step;
          currentAudioSecond++;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Always cancel timers to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build (BuildContext context) {
    return Column(
      children: [
        IgnorePointer(
          ignoring: true,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackShape: CustomTrackShape(),
              overlayShape: SliderComponentShape.noOverlay,
            ),
            child: Slider(
              value: currentAudioPercentage,
              onChanged: (val) {}, // Changed to non-null so it looks "active"
              activeColor: AppColors.primaryColor,
              inactiveColor: AppColors.sliderInactiveColor,
              thumbColor: AppColors.sliderThumbColor,
            ),
          ),
        ),

        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              "${TimeConverter.secondToMinuteString(
                currentAudioSecond
              )}:${TimeConverter.secondToSecondString(
                currentAudioSecond
              )}",
              style: TextStyle(
                fontSize: AppConstants.fontS.sp,
                fontWeight: .w500,
                color: AppColors.textOnDark
              ),
            ),
            Text(
              TimeConverter.secondToMinuteSecondString(totalDurationSeconds),
              style: TextStyle(
                fontSize: AppConstants.fontS.sp,
                fontWeight: .w500,
                color: AppColors.textOnDark
              ),
            )
          ],
        )
      ],
    );
  }
}

class _PlayStopToggleButton extends StatelessWidget {
  const _PlayStopToggleButton();

  @override
  Widget build (BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: .circular(AppConstants.radiusCircular.r),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.spacingS.w,
          vertical: AppConstants.spacingS.w,
        ),
        child: Icon(
          FontAwesomeIcons.play,
          color: AppColors.textOnDark,
          size: AppConstants.fontXXXL.r,
        ),
      ),
    );
  }
}

class _TextContainer extends StatelessWidget {
  final FoodStallModel foodStallModel;

  const _TextContainer({
    required this.foodStallModel,
  });

  @override
  Widget build (BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff25303B),
        borderRadius: .circular(AppConstants.radiusM.r),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.spacingL.w,
        vertical: AppConstants.spacingM.h,
      ),
      child: Text(
        foodStallModel.foodStallDescription,
        style: TextStyle(
          fontWeight: .w400,
          fontSize: AppConstants.spacingM.sp,
          color: AppColors.textOnDark
        )
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 2;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    // This dictates the width. We use the full parent width without subtracting thumb radius.
    final double trackWidth = parentBox.size.width;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}