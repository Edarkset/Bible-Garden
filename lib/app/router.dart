import 'package:bible_garden/app/flavor.dart';
import 'package:bible_garden/features/debug/debug_routes.dart';
import 'package:bible_garden/features/garden/garden_screen.dart';
import 'package:go_router/go_router.dart';

/// Rotas do app. As rotas de teste só existem no flavor dev.
GoRouter buildRouter() => GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const GardenScreen()),
    if (isDev) ...debugRoutes,
  ],
);
