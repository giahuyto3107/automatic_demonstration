import 'package:automatic_demonstration/features/home_screen/views/home_screen.dart';
import 'package:automatic_demonstration/features/settings/views/settings_screen.dart';
import 'package:automatic_demonstration/features/shell/providers/main_navigation_controller.dart';
import 'package:automatic_demonstration/features/shell/views/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build (BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(mainNavigationControllerProvider);

    List<Widget> screens = [
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
              children: screens,
            ),
          ),

          Positioned(
            bottom: MediaQuery.of(context).padding.bottom,
            left: 0,
            right: 0,
            child: NavBar(
              onTap: ref.read(mainNavigationControllerProvider.notifier).setIndex,
              currentIndex: currentIndex,
            ),
          ),
        ]
      ),
    );
  }
}