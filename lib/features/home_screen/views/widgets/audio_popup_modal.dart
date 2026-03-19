import 'package:automatic_demonstration/core/theme/theme_getter.dart';
import 'package:automatic_demonstration/features/home_screen/data/models/food_stall_model.dart';
import 'package:automatic_demonstration/features/home_screen/providers/audio_notifier.dart';
import 'package:automatic_demonstration/features/home_screen/providers/audio_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:automatic_demonstration/core/utils/time_converter.dart';
import 'package:automatic_demonstration/core/constants/constants.dart';
import 'package:automatic_demonstration/core/theme/theme.dart';
import 'package:just_audio/just_audio.dart';

class AudioPopupModal extends ConsumerStatefulWidget {
  final FoodStallModel foodStallModel;

  const AudioPopupModal({
    super.key,
    required this.foodStallModel
  });

  @override
  ConsumerState<AudioPopupModal> createState() => _AudioPopupModalState();
}

class _AudioPopupModalState extends ConsumerState<AudioPopupModal> {
  @override
  void initState() {
    super.initState();
    // Load the audio if it's not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audioProvider.notifier).load(widget.foodStallModel.audioUrl);
    });
  }

  @override
  Widget build (BuildContext context) {
    final surfaceColors = context.surfaceColors;

    final audioAsync = ref.watch(audioProvider);
    final playerStateAsync = ref.watch(audioPlayerStateProvider);

    final playerState = playerStateAsync.value;
    final isLoading = audioAsync.isLoading || 
        playerState?.processingState == ProcessingState.loading || 
        playerState?.processingState == ProcessingState.buffering;
    final isPlaying = playerState?.playing ?? false;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 36.w,
        vertical: AppConstants.spacingM.h,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColors.secondarySurface,
          borderRadius: BorderRadius.circular(AppConstants.radiusM.r)
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.spacingM.w,
            vertical: AppConstants.spacingM.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ModalHeading(
                foodStallModel: widget.foodStallModel
              ),
              SizedBox(height: AppConstants.spacingS.h,),
              _AudioSlider(
                foodStallModel: widget.foodStallModel,
              ),
              SizedBox(height: AppConstants.spacingXS.h,),
              _PlayStopToggleButton(
                isPlaying: isPlaying,
                isLoading: isLoading,
                onToggle: () {
                  final notifier = ref.read(audioProvider.notifier);
                  if (isPlaying) {
                    notifier.pause();
                  } else {
                    notifier.resume();
                  }
                },
              ),
              SizedBox(height: AppConstants.spacingL.h,),
              _TextContainer(
                foodStallModel: widget.foodStallModel
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
          color: Theme.of(context).textTheme.bodyMedium?.color,
          size: AppConstants.spacingXXXL.r,
        ),

        SizedBox(width: AppConstants.spacingM.w,),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              foodStallModel.name,
              style: TextStyle(
                fontSize: AppConstants.fontM.sp,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w700
              ),
            ),

            Row(
              children: [
                Icon(
                  FontAwesomeIcons.volumeHigh,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  size: AppConstants.fontXS.r,
                ),
                SizedBox(width: AppConstants.spacingS.w,),
                Text(
                  AppStrings.audioIsPlaying,
                  style: TextStyle(
                    fontSize: AppConstants.fontXS.sp,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontWeight: FontWeight.w400
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

class _AudioSlider extends ConsumerWidget {
  final FoodStallModel foodStallModel;

  const _AudioSlider({
    required this.foodStallModel,
  });

  @override
  Widget build (BuildContext context, WidgetRef ref) {
    final positionAsync = ref.watch(audioPositionProvider);
    final durationAsync = ref.watch(audioDurationProvider);

    final position = positionAsync.value ?? Duration.zero;
    final totalDuration = durationAsync.value ?? Duration.zero;

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackShape: CustomTrackShape(),
            overlayShape: SliderComponentShape.noOverlay,
          ),
          child: Slider(
            value: position.inSeconds.toDouble().clamp(0, totalDuration.inSeconds.toDouble()),
            max: totalDuration.inSeconds.toDouble() > 0 ? totalDuration.inSeconds.toDouble() : 1.0,
            onChanged: (val) {
              ref.read(audioProvider.notifier).seek(Duration(seconds: val.toInt()));
            },
            activeColor: AppColors.primaryColor,
            inactiveColor: AppColors.sliderInactiveColor,
            thumbColor: AppColors.sliderThumbColor,
          ),
        ),

        _AudioTimeIndicator(
          position: position,
          duration: totalDuration,
        )
      ],
    );
  }
}

class _AudioTimeIndicator extends StatelessWidget {
  final Duration position;
  final Duration duration;

  const _AudioTimeIndicator({
    required this.position,
    required this.duration
  });

  @override
  Widget build (BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          TimeConverter.secondToMinuteSecondString(position.inSeconds),
          style: TextStyle(
            fontSize: AppConstants.fontS.sp,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        Text(
          TimeConverter.secondToMinuteSecondString(duration.inSeconds),
          style: TextStyle(
            fontSize: AppConstants.fontS.sp,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        )
      ],
    );
  }
}

class _PlayStopToggleButton extends StatelessWidget {
  final bool isPlaying;
  final bool isLoading;
  final VoidCallback onToggle;

  const _PlayStopToggleButton({
    required this.isPlaying,
    required this.isLoading,
    required this.onToggle,
  });

  @override
  Widget build (BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onToggle,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(AppConstants.radiusCircular.r),
          ),
          padding: EdgeInsets.all(AppConstants.spacingS.w),
          child: isLoading
            ? SizedBox(
                width: AppConstants.fontXXXL.r,
                height: AppConstants.fontXXXL.r,
                child: const CircularProgressIndicator(
                  color: AppColors.textOnDark,
                  strokeWidth: 2,
                ),
              )
            : Icon(
                isPlaying
                  ? FontAwesomeIcons.pause
                  : FontAwesomeIcons.play,
                color: AppColors.textOnDark,
                size: AppConstants.fontXXXL.r,
              ),
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
    final surfaceColors = context.surfaceColors;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColors.lighterPrimarySurface,
        borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.spacingL.w,
        vertical: AppConstants.spacingM.h,
      ),
      child: Text(
        foodStallModel.description,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: AppConstants.fontS.sp,
          color: Theme.of(context).textTheme.bodyMedium?.color,
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
    final double trackWidth = parentBox.size.width;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
