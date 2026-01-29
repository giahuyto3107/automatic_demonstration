import 'package:automatic_demonstration/core/utils/app_constants_all.dart';
import 'package:automatic_demonstration/features/home_screen/data/gps_enum.dart';
import 'package:automatic_demonstration/features/home_screen/data/models/food_stall_model.dart';
import 'package:automatic_demonstration/features/home_screen/views/food_stall_list_section.dart';
import 'package:automatic_demonstration/features/home_screen/views/map_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build (BuildContext context) {
    List<FoodStallModel> foodStallModels = [
      FoodStallModel(
        foodStallName: "Green Garden Salads",
        foodStallDescription: "Fresh organic salads and cold-pressed juices.",
        distance: 450.5,
        audioLength: 300,
        foodStallImage: "assets/images/stalls/salad_stall.jpg",
      ),
      FoodStallModel(
        foodStallName: "The Burger Hub",
        foodStallDescription: "Juicy Wagyu burgers with homemade brioche buns.",
        distance: 1200.0,
        audioLength: 720,
        foodStallImage: "assets/images/stalls/burger_hub.jpg",
      ),
      FoodStallModel(
        foodStallName: "Sushi Zen",
        foodStallDescription: "Authentic hand-rolled sushi and sashimi platters.",
        distance: 850.0,
        audioLength: 510,
        foodStallImage: "assets/images/stalls/sushi_zen.jpg",
      ),
      FoodStallModel(
        foodStallName: "Pasta la Vista",
        foodStallDescription: "Freshly made Italian pasta with secret family sauces.",
        distance: 2100.0,
        audioLength: 1200,
        foodStallImage: "assets/images/stalls/pasta_stall.jpg",
      ),
      FoodStallModel(
        foodStallName: "Taco Fiesta",
        foodStallDescription: "Spicy Mexican street tacos with zesty lime crema.",
        distance: 300.0,
        audioLength: 180,
        foodStallImage: "assets/images/stalls/taco_fiesta.jpg",
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.backgroundColor
          ),
          child: Column(
            children: [
              _HeadingRow(),

              SizedBox(height: AppConstants.spacingM.h,),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingXL.w,
                  ),
                  child: Column(
                    children: [
                      MapContainer(),
                      SizedBox(height: AppConstants.spacingL.h,),
                      _GPSStatusContainer(),
                      SizedBox(height: AppConstants.spacingL.h,),
                      Expanded(
                        child: FoodStallListSection(
                          foodStallModels: foodStallModels)
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )
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
          horizontal: AppConstants.spacingL.h,
          vertical: AppConstants.spacingL.h,
        ),
        child: Row(
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
            )
          ],
        ),
      ),
    );
  }
}

class _GPSStatusContainer extends StatelessWidget {
  const _GPSStatusContainer();

  @override
  Widget build (BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff1B222D),
        borderRadius: .circular(AppConstants.radiusM.r),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.spacingM.w,
            vertical: AppConstants.spacingM.h,
          ),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.locationDot,
                    color: Color(0xff209851),
                    size: AppConstants.fontXXL.r,
                    weight: AppConstants.borderMedium,
                  ),
                  SizedBox(width: AppConstants.spacingL.w,),
                  _GPSStatus(
                    status: EGpsStatus.enable,
                  ),
                ],
              ),

              _RefreshButton()
            ]
          ),
        ),
      ),
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

    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Icon(
              FontAwesomeIcons.wifi,
              color: statusColor,
              size: AppConstants.fontL.r,
              weight: AppConstants.borderMedium,
            ),
            SizedBox(width: AppConstants.spacingM.w,),
            Text(
              "GPS $statusString",
              style: TextStyle(
                color: statusColor,
                fontSize: AppConstants.fontL.sp,
                fontWeight: .w700,
              ),
            )
          ],
        ),
        SizedBox(height: AppConstants.spacingXS.h,),
        Row(
          children: [
            Text(
              "Chính xác",
              style: TextStyle(
                fontWeight: .w400,
                fontSize: AppConstants.fontS.sp,
                color: Colors.white
              ),
            ),
            SizedBox(width: AppConstants.spacingS.w,),
            Container(
              width: 3.w,
              height: 3.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            SizedBox(width: AppConstants.spacingXXS.w,),
            Icon(
              FontAwesomeIcons.plusMinus,
              color: Colors.white,
              size: AppConstants.fontXXS.r,
              weight: AppConstants.borderThin,
            ),
            SizedBox(width: AppConstants.spacingXXS.w,),
            Text(
              "12ms",
              style: TextStyle(
                fontWeight: .w400,
                fontSize: AppConstants.fontS.sp,
                color: Colors.white
              ),
            )
          ],
        )
      ],
    );
  }
}


class _RefreshButton extends StatelessWidget {
  const _RefreshButton();

  @override
  Widget build (BuildContext context) {
    return Icon(
      FontAwesomeIcons.rotate,
      size: AppConstants.fontXXL.r,
      color: Colors.white,
      weight: AppConstants.borderMedium,
    );
  }
}