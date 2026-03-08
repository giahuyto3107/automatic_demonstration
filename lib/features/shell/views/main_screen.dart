import 'package:automatic_demonstration/core/constants/app_constants.dart';
import 'package:automatic_demonstration/features/home_screen/views/home_screen.dart';
import 'package:automatic_demonstration/features/settings/views/settings_screen.dart';
import 'package:automatic_demonstration/features/shell/providers/main_navigation_controller.dart';
import 'package:automatic_demonstration/features/shell/views/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build (BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(mainNavigationControllerProvider);

    List<Widget> _screens = [
      const HomeScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: IndexedStack(
              index: currentIndex,
              children: _screens,
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: AppConstants.spacingS.h,
                ),
                child: IntrinsicHeight(
                  child: NavBar(
                    onTap: ref.read(mainNavigationControllerProvider.notifier).setIndex,
                    currentIndex: currentIndex,
                  ),
                ),
              )
            ),
          )
        ]
      ),
    );
  }
}