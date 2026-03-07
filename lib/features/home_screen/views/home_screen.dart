import 'package:automatic_demonstration/core/constants/app_constants.dart';
import 'package:automatic_demonstration/core/constants/app_strings.dart';
import 'package:automatic_demonstration/core/providers/app_theme.dart';
import 'package:automatic_demonstration/core/theme/app_colors.dart';
import 'package:automatic_demonstration/core/theme/theme_getter.dart';
import 'package:automatic_demonstration/features/home_screen/data/models/gps_enum.dart';
import 'package:automatic_demonstration/features/home_screen/views/widgets/food_stall_list_section.dart';
import 'package:automatic_demonstration/features/home_screen/views/widgets/map_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build (BuildContext context) {
    final backgroundGradients = context.backgroundGradients;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: backgroundGradients.topContainerGradient
          ),
          child: Column(
            children: [
              const _HeadingRow(),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: MapContainer(key: MapContainer.globalKey)
                    ),
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingXL.w,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: AppConstants.spacingL.h,),
                            Expanded(
                              child: FoodStallListSection()
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _HeadingRow extends StatelessWidget {
  const _HeadingRow();

  @override
  Widget build (BuildContext context) {
    final bgColors = context.surfaceColors;

    return Container(
      color: bgColors.headingSurface,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM.h,
          vertical: AppConstants.spacingL.h,
        ),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _DarkModeTogglerButton())
              ,
            ),
            Expanded(
              flex: 4,
              child: _LogoAndAppName()
            ),
            Expanded(
              flex: 3,
              child: Align(
                alignment: .centerRight,
                child: _GPSSection(
                  status: EGpsStatus.enable,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoAndAppName extends StatelessWidget {
  const _LogoAndAppName();

  @override
  Widget build (BuildContext context) {
    return Row(
      mainAxisAlignment: .center,
      children: [
        // ================  LOGO  ===================

        // Container(
        //   decoration: BoxDecoration(
        //     gradient: AppColors.logoColor,
        //     borderRadius: .circular(AppConstants.radiusM.r),
        //   ),
        //   padding: EdgeInsets.symmetric(
        //     horizontal: AppConstants.spacingS.w,
        //     vertical: AppConstants.spacingS.h,
        //   ),
        //   child: Icon(
        //     FontAwesomeIcons.spoon,
        //     color: Colors.white,
        //   ),
        // ),

        // SizedBox(width: AppConstants.spacingM.w,),

        Column(
          children: [
            Text(
              AppStrings.appPrimaryTitle,
              style: TextStyle(
                  fontSize: AppConstants.fontS.sp,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontWeight: .w700
              ),
            ),

            Text(
              AppStrings.appSecondaryTitle,
              style: TextStyle(
                  fontSize: AppConstants.fontXXS.sp,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontWeight: .w400
              ),
            )
          ],
        ),
      ],
    );
  }
}

class _GPSSection extends StatelessWidget {
    final EGpsStatus status;

  const _GPSSection({
    required this.status
  });

  @override
  Widget build (BuildContext context) {
    String gpsStatus = status == EGpsStatus.enable
        ? "Bật"
        : status == EGpsStatus.disable
        ? "Tắt"
        : "Đang kết nối";

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.enabledGpsBackground,
        borderRadius: .circular(AppConstants.radiusCircular.r),
        border: Border.all(
          color: AppColors.enabledGpsBorder,
          width: 1.0.w,
        )
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.spacingM.w,
        vertical: AppConstants.spacingXS.h,
      ),
      child: Row(
        mainAxisAlignment: .center,
        mainAxisSize: .min,
        children: [
          Tooltip(
            message: "GPS $gpsStatus",
            child: Icon(
              FontAwesomeIcons.locationDot,
              color: Color(0xff209851),
              size: AppConstants.fontM.r,
              weight: AppConstants.borderMedium,
            ),
          ),
          SizedBox(width: AppConstants.spacingXS.w,),
          Container(
            height: AppConstants.fontM.h,
            width: 1.0.w,
            color: AppColors.dividerColor,
          ),
          SizedBox(width: AppConstants.spacingS.w,),
          _RefreshButton()
        ],
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton();

  @override
  Widget build (BuildContext context) {
    return GestureDetector(
      onTap: () {
        MapContainer.globalKey.currentState?.startLiveTracking();
      },
      child: Icon(
        FontAwesomeIcons.rotate,
        size: AppConstants.fontS.r,
        color: Colors.white,
        weight: AppConstants.borderMedium,
      ),
    );
  }
}

class _DarkModeTogglerButton extends ConsumerWidget {
  const _DarkModeTogglerButton();

  @override
  Widget build (BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeProvider);
    final bool isLightMode = themeMode == ThemeMode.light;

    void toggleTheme() {
      ref.read(appThemeProvider.notifier).toggleTheme();
    }

    int slideSpacing = 27;
    double toggleSize = 25.r;
    int containerWidth = 70;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: toggleSize,
      width: containerWidth.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radiusCircular.r),
        border: Border.all(
          color: isLightMode ? Colors.black : Colors.white,
          width: 1.0.w,
        ),
        color: isLightMode ? Colors.white : Colors.black,
      ),
      child: InkWell(
        onTap: toggleTheme,
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeIn,
              top: 0,    // add this
              bottom: 0,
              left: isLightMode ? containerWidth.w - toggleSize : 0.w,
              right: isLightMode ? 0.w : containerWidth.w - toggleSize.w,
              child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 400),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return RotationTransition(
                      turns: animation,
                      child: child,
                    );
                  },

                  child: Container(
                    height: 25.h,
                    width: 25.h,
                    decoration: BoxDecoration(
                      color: isLightMode ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(AppConstants.radiusCircular.r),
                    ),
                    child: isLightMode
                      ? Icon(
                        Icons.light_mode,
                        color: Colors.white,
                        size: 15.r,
                        key: ValueKey(isLightMode),
                      )
                      : Icon(
                        Icons.dark_mode,
                        color: Colors.black,
                        size: 15.r,
                        key: ValueKey(isLightMode),
                      ),
                  )
                ),
            ),

            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeIn,
              left: isLightMode ? 0.w : slideSpacing.w,
              right: isLightMode ? slideSpacing.w : 0.w,
              top: 0,
              bottom: 0,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Center(
                  key: ValueKey(isLightMode),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: isLightMode ? AppConstants.spacingS.w : 0,   // padding away from border when on left
                      right: isLightMode ? 0 : AppConstants.spacingS.w,  // padding away from border when on right
                    ),
                    child: Text(
                      isLightMode ? 'Light' : 'Dark',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                        color: isLightMode ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}