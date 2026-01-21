import 'package:automatic_demonstration/core/utils/app_constants_all.dart';
import 'package:automatic_demonstration/features/home_screen/data/food_stall_model.dart';
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
