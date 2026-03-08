import 'package:automatic_demonstration/core/constants/app_constants.dart';
import 'package:automatic_demonstration/core/constants/app_strings.dart';
import 'package:automatic_demonstration/core/theme/app_colors.dart';
import 'package:automatic_demonstration/core/theme/theme_getter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build (BuildContext context) {
    final bgColors = context.backgroundGradients;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: bgColors.topContainerGradient
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.spacingXL.w,
              vertical: AppConstants.spacingL.h,
            ),
            child: Column(
              children: [
                const _AppPreferences()
              ],
            ),
          ),
        )
      )
    );
  }
}

class _AppPreferences extends StatelessWidget {
  const _AppPreferences();

  @override
  Widget build (BuildContext context) {
    final surfaceColors = context.surfaceColors;

    final options = [
      {'icon': Icons.notifications, 'label': AppStrings.notification},
      {'icon': FontAwesomeIcons.language, 'label': AppStrings.language},
    ];

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          AppStrings.appPreferences,
          style: TextStyle(
            fontSize: AppConstants.spacingL.sp,
            color: Theme.of(context).textTheme.bodyMedium?.color,
            fontWeight: .w600
          ),
        ),

        SizedBox(height: AppConstants.spacingS.h,),

        Container(
          decoration: BoxDecoration(
            color: surfaceColors.primarySurface,
            borderRadius: BorderRadius.circular(AppConstants.radiusL.r)
          ),
          child: ListView.separated(
            shrinkWrap: true, // Use this if inside a Column
            physics: const NeverScrollableScrollPhysics(), // Use this if inside a scrollable view
            itemCount: options.length,
            separatorBuilder: (context, index) => Divider(
              height: 1.h,
              indent: AppConstants.spacingXXL.w,
              endIndent: AppConstants.spacingXXL.w,
              color: Colors.grey.withAlpha(85),
            ),
            itemBuilder: (context, index) {
              return _OptionRow(
                icon: options[index]['icon'] as IconData,
                label: options[index]['label'] as String,
              );
            },
          ),
        )
      ],
    );
  }
}

class _OptionRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _OptionRow({
    required this.icon,
    required this.label
  });

  @override
  Widget build (BuildContext context) {
    final surfaceColors = context.surfaceColors;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColors.primarySurface,
          borderRadius: BorderRadius.circular(AppConstants.radiusL.r)
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.spacingS.w,
        vertical: AppConstants.spacingS.h,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).textTheme.bodyMedium?.color,
            size: AppConstants.fontL.r,
            weight: AppConstants.borderThin.r,
          ),
          SizedBox(width: AppConstants.spacingM.w),

          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppConstants.fontM.sp,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: .w400
              ),
            ),
          ),

          Icon(
            Icons.chevron_right,
            color: Theme.of(context).textTheme.bodyMedium?.color,
            size: AppConstants.fontXXL.r,
            weight: AppConstants.borderThick.r,
          )
        ],
      ),
    );
  }
}