import 'package:automatic_demonstration/core/router/app_routes.dart';
import 'package:automatic_demonstration/features/home_screen/views/home_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
          path: '/',
          name: 'homeScreen',
          builder: (context, state) => HomeScreen()
      ),
    ]
);