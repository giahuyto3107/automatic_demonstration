import 'package:automatic_demonstration/core/utils/app_constants_all.dart';
import 'package:automatic_demonstration/features/home_screen/data/gps_enum.dart';
import 'package:automatic_demonstration/features/home_screen/views/food_stall_list_section.dart';
import 'package:automatic_demonstration/features/home_screen/views/map_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.backgroundColor
          ),
          child: Column(
            children: [
              const _HeadingRow(),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: const MapContainer()
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
    return Container(
      color: Color(0xff252238),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM.h,
          vertical: AppConstants.spacingL.h,
        ),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            _LogoAndAppName(),
            _GPSSection(),
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
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: AppColors.logoColor,
            borderRadius: .circular(AppConstants.radiusM.r),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.spacingS.w,
            vertical: AppConstants.spacingS.h,
          ),
          child: Icon(
            FontAwesomeIcons.spoon,
            color: Colors.white,
          ),
        ),

        SizedBox(width: AppConstants.spacingM.w,),

        Column(
          children: [
            Text(
              AppStrings.appPrimaryTitle,
              style: TextStyle(
                  fontSize: AppConstants.fontL.sp,
                  color: Colors.white,
                  fontWeight: .w700
              ),
            ),

            Text(
              AppStrings.appSecondaryTitle,
              style: TextStyle(
                  fontSize: AppConstants.fontXS.sp,
                  color: Colors.white,
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
  const _GPSSection();

  @override
  Widget build (BuildContext context) {
    return Row(
      children: [
        Icon(
          FontAwesomeIcons.locationDot,
          color: Color(0xff209851),
          size: AppConstants.fontXL.r,
          weight: AppConstants.borderMedium,
        ),
        SizedBox(width: AppConstants.spacingXS.w,),
        _GPSStatus(
          status: EGpsStatus.enable,
        ),
        SizedBox(width: AppConstants.spacingS.w,),
        _RefreshButton()
      ],
    );
  }
}

class _GPSStatus extends StatelessWidget {
  final EGpsStatus status;
  const _GPSStatus({
    required this.status
  });

  @override
  Widget build (BuildContext context) {
    String statusString = status == EGpsStatus.enable
        ? "Bật"
        : status == EGpsStatus.disable
          ? "Tắt"
          : "Đang kết nối";

    Color statusColor = status == EGpsStatus.enable
        ? AppColors.enable
        : status == EGpsStatus.disable
        ? AppColors.disable
        : AppColors.connecting;

    return Text(
      "GPS $statusString",
      style: TextStyle(
        color: statusColor,
        fontSize: AppConstants.fontM.sp,
        fontWeight: .w700,
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton();

  @override
  Widget build (BuildContext context) {
    return Icon(
      FontAwesomeIcons.rotate,
      size: AppConstants.fontXL.r,
      color: Colors.white,
      weight: AppConstants.borderMedium,
    );
  }
}