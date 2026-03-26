import 'package:automatic_demonstration/core/config/config.dart';
import 'package:automatic_demonstration/core/providers/app_locale.dart';
import 'package:automatic_demonstration/core/providers/app_theme.dart';
import 'package:automatic_demonstration/core/router/app_router.dart';
import 'package:automatic_demonstration/core/theme/app_colors.dart';
import 'package:automatic_demonstration/core/theme/background_gradients_extension.dart';
import 'package:automatic_demonstration/core/theme/selection_colors_extension.dart';
import 'package:automatic_demonstration/core/theme/surface_colors_extension.dart';
import 'package:automatic_demonstration/l10n/app_localizations.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:automatic_demonstration/core/services/analytics_service.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EnvService.init();
  await AnalyticsService().init();

  AppLifecycleListener(
    onPause: () => AnalyticsService().flush(),
    onHide: () => AnalyticsService().flush(),
  );

  // We manually manage the container to pre-load the locale
  final container = ProviderContainer();

  // Initialize the locale from SharedPreferences
  await container.read(appLocaleProvider.notifier).init();

  runApp(
    UncontrolledProviderScope(
      container: container,
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

        final lightSelection = SelectionColors(
          selectedBg: AppColors.selectedBackgroundColorLightMode,
          selectedText: AppColors.textOnLight,
          unselectedBg: AppColors.unselectedBackgroundColorLightMode,
          unselectedText: AppColors.textOnLight,
        );

        final darkSelection = SelectionColors(
          selectedBg: AppColors.selectedBackgroundColorDarkMode,
          selectedText: AppColors.textOnDark,
          unselectedBg: AppColors.unselectedBackgroundColorDarkMode,
          unselectedText: AppColors.textOnLight,
        );

        final lightSurfaces = AppSurfaceColors(
          primarySurface: AppColors.textOnDark,         // Main background,
          headingSurface: AppColors.textOnDark,
          lighterPrimarySurface: Color(0xffeaeaea),
          secondarySurface: AppColors.textOnDark,
          skipButtonSurface: AppColors.skipButtonColorLightMode,
        );

// Dark Mode Version
        final darkSurfaces = AppSurfaceColors(
          headingSurface: Color(0xff1e1c30),
          primarySurface: Color(0xff1a242a),    // Deep dark background
          secondarySurface: Color(0xff26323a),
          lighterPrimarySurface: Color(0xff1e2a32),
          skipButtonSurface: AppColors.skipButtonColorDarkMode,
        );

        final lightBackgroundGradient = BackgroundGradients(
          topContainerGradient: AppColors.lightBackgroundGradient
        ); 
        final darkBackgroundGradient = BackgroundGradients(
          topContainerGradient: AppColors.darkBackgroundGradient
        );

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: const [
            Locale('vi'), // Vietnamese
            Locale('en'), // English
            Locale('zh'), // Chinese
            Locale('ja'), // Japanese
            Locale('ko'), // Korean
          ],
          themeMode: themeMode,
          theme: ThemeData(
            // This sets the background color for every Scaffold in your app
            scaffoldBackgroundColor: Colors.white, // Change 'white' to any color you want
            brightness: Brightness.light,
            primaryColor: AppColors.primaryColor,
            textTheme: const TextTheme(bodyMedium: TextStyle(color: AppColors.textOnLight)),
            extensions: [lightSelection, lightSurfaces, lightBackgroundGradient],
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFF121212),
            brightness: Brightness.dark,
            primaryColor: AppColors.primaryColor,
            textTheme: const TextTheme(bodyMedium: TextStyle(color: AppColors.textOnDark)),
            extensions: [darkSelection, darkSurfaces, darkBackgroundGradient],
          ),
        );
      }
    );
  }
}