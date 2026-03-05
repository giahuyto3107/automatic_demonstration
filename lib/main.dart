import 'package:automatic_demonstration/core/config/config.dart';
import 'package:automatic_demonstration/core/providers/app_locale.dart';
import 'package:automatic_demonstration/core/providers/app_theme.dart';
import 'package:automatic_demonstration/core/router/app_router.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EnvService.init();

  runApp(
    ProviderScope(
      child: DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const MainApp()
      ),
    )
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final themeMode = ref.watch(appThemeProvider);
        final locale = ref.watch(appLocaleProvider);

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
          locale: locale,
          themeMode: themeMode,
          theme: ThemeData(
            // This sets the background color for every Scaffold in your app
            scaffoldBackgroundColor: Colors.transparent, // Change 'white' to any color you want

            // Optional: Customize your primary colors here too
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(brightness: Brightness.dark),
        );
      }
    );
  }
}