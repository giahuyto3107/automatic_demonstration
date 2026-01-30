import 'package:automatic_demonstration/core/utils/app_colors.dart';
import 'package:automatic_demonstration/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AudioCategoryContainer extends StatefulWidget {
  const AudioCategoryContainer({super.key});

  @override
  State<AudioCategoryContainer> createState() => _AudioCategoryContainerState();
}

class _AudioCategoryContainerState extends State<AudioCategoryContainer> {
  int selectedIndex = 0;

  @override
  Widget build (BuildContext context) {
    List<String> audioCategoryItems = [
      'Tất cả',
      'Đã nghe',
      'Lọc'
    ];
    int lastCategoryItemIndex = audioCategoryItems.length - 1;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.unselectedBackgroundColor,
        borderRadius: .circular(AppConstants.radiusM.r),
      ),
      child: Row(
        mainAxisAlignment: .spaceAround,
        children: audioCategoryItems.asMap().entries.map((entry) {
          int index = entry.key;
          String item = entry.value;

          bool isSelected = selectedIndex == index;
          bool isLastCategoryItem = index == lastCategoryItemIndex;

          Widget itemContent = Text(
            item,
            style: TextStyle(
              fontSize: AppConstants.fontM.sp,
              color: isSelected ? Colors.white : const Color(0xff000000),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
            ),
            textAlign: .center,
          );

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: AppConstants.spacingXS.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.selectedBackgroundColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
                ),
                child: isLastCategoryItem ? Row(
                  mainAxisAlignment: .center,
                  children: [
                    itemContent,
                    SizedBox(width: AppConstants.spacingXXS.w,),
                    Icon(
                      FontAwesomeIcons.caretDown,
                      size: AppConstants.fontL.r,
                      color: isSelected ? AppColors.selectedTextColor : AppColors.unSelectedTextColor,
                    )
                  ],
                ) : itemContent
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}