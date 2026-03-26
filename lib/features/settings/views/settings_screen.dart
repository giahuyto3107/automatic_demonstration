import 'package:automatic_demonstration/core/constants/app_constants.dart';
import 'package:automatic_demonstration/core/providers/app_theme.dart';
import 'package:automatic_demonstration/core/theme/theme_getter.dart';
import 'package:automatic_demonstration/features/settings/views/language_screen.dart';
import 'package:automatic_demonstration/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final l10n = AppLocalizations.of(context)!;

    final options = [
      {'icon': FontAwesomeIcons.circleHalfStroke, 'label': l10n.theme},
      {'icon': Icons.notifications, 'label': l10n.notification},
      {'icon': FontAwesomeIcons.language, 'label': l10n.language},
    ];

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          l10n.appPreferences,
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
              return InkWell(
                onTap: () {
                  if (options[index]['label'] == l10n.language) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LanguageScreen()),
                    );
                  }
                },
                child: _OptionRow(
                  icon: options[index]['icon'] as IconData,
                  label: options[index]['label'] as String,
                  actionIcon: index == 0 ? const _ThemeButton() : null,
                ),
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
  final Widget? actionIcon;

  const _OptionRow({
    required this.icon,
    required this.label,
    this.actionIcon,
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

          actionIcon ?? Icon(
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

class _ThemeButton extends ConsumerWidget {
  const _ThemeButton();

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