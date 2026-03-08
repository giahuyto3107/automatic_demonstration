import 'dart:ui';

import 'package:automatic_demonstration/core/constants/app_constants.dart';
import 'package:automatic_demonstration/core/router/app_routes.dart';
import 'package:automatic_demonstration/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap; 
  
  const NavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.sp), // Matches your design
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // The "Frosted" effect
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(178),
            borderRadius: BorderRadius.circular(50.sp),
            border: Border.all(
              color: const Color(0xffE6E6E6).withAlpha(127), // Lighter border
              width: 1.w
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.spacingXS.w,
              vertical: AppConstants.spacingXS.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: .min,
              crossAxisAlignment: .center,
              children: [
                _NavBarItem(
                  icon: Icons.home,
                  label: "Home",
                  index: 0,
                  isSelected: currentIndex == 0,
                  onTap: onTap,
                ),
                const _SnapButton(),
                _NavBarItem(
                  icon: FontAwesomeIcons.gear,
                  label: "Settings",
                  index: 1,
                  isSelected: currentIndex == 1,
                  onTap: onTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool isSelected;
  final Function(int) onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.isSelected,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 55.w,
        child: Column(
          children: [
            Icon(
              icon,
              size: AppConstants.fontXL.sp,
              color: isSelected ? AppColors.textOnLight : AppColors.disable,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: AppConstants.fontXS.sp,
                color: isSelected ? AppColors.textOnLight : AppColors.disable,
                fontWeight: .w600
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SnapButton extends StatelessWidget {
  const _SnapButton();

  @override
  Widget build (BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.qrScannerPath),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 55.w,
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Icon(
              FontAwesomeIcons.plus,
              size: AppConstants.fontXL.sp,
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}