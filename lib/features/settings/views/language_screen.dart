import 'package:automatic_demonstration/core/constants/app_constants.dart';
import 'package:automatic_demonstration/core/providers/app_locale.dart';
import 'package:automatic_demonstration/core/theme/theme_getter.dart';
import 'package:automatic_demonstration/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key});

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {

  @override
  Widget build(BuildContext context) {
    final bgColors = context.backgroundGradients;
    final surfaceColors = context.surfaceColors;
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(appLocaleProvider);

    final languages = [
      {'flag': '🇻🇳', 'name': l10n.vietnamese, 'code': 'vi'},
      {'flag': '🇨🇳', 'name': l10n.chinese, 'code': 'zh'},
      {'flag': '🇺🇸', 'name': l10n.english, 'code': 'en'},
      {'flag': '🇯🇵', 'name': l10n.japanese, 'code': 'ja'},
      {'flag': '🇰🇷', 'name': l10n.korean, 'code': 'ko'},
    ];

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: bgColors.topContainerGradient,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.spacingXL.w,
              vertical: AppConstants.spacingL.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 24.r,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    SizedBox(width: AppConstants.spacingS.w),
                    Text(
                      l10n.language,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppConstants.spacingXL.h),
                Container(
                  decoration: BoxDecoration(
                    color: surfaceColors.primarySurface,
                    borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(13),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: languages.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1.h,
                      indent: AppConstants.spacingXL.w,
                      endIndent: AppConstants.spacingXL.w,
                      color: Colors.grey.withAlpha(50),
                    ),
                    itemBuilder: (context, index) {
                      final lang = languages[index];
                      final isSelected = currentLocale.languageCode == lang['code'];

                      return InkWell(
                        onTap: () {
                          ref.read(appLocaleProvider.notifier).setLocale(lang['code']!);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingM.w,
                            vertical: AppConstants.spacingM.h,
                          ),
                          child: Row(
                            children: [
                              Text(
                                lang['flag']!,
                                style: TextStyle(fontSize: 24.sp),
                              ),
                              SizedBox(width: AppConstants.spacingM.w),
                              Expanded(
                                child: Text(
                                  lang['name']!,
                                  style: TextStyle(
                                    fontSize: AppConstants.fontL.sp,
                                    color: Theme.of(context).textTheme.bodyMedium?.color,
                                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check,
                                  size: 24.r,
                                  color: Theme.of(context).textTheme.bodyMedium?.color,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
