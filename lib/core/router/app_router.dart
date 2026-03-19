import 'package:automatic_demonstration/core/router/app_routes.dart';
import 'package:automatic_demonstration/features/qr_scanner/views/qr_scanner_screen.dart';
import 'package:automatic_demonstration/features/shell/views/main_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
    routes: [
      GoRoute(
          path: '/',
          name: 'main_screen',
          builder: (context, state) => MainScreen()
      ),

      GoRoute(
        path: AppRoutes.qrScannerPath,
        name: 'qr_scanner_screen',
        builder: (context, state) => QrScannerScreen()
      )

      // GoRoute(
      //   path: '/',
      //   name: 'settings_screen',
      //   builder: (context, state) => SettingsScreen()
      // ),
    ]
);