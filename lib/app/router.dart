import 'package:bible_garden/app/flavor.dart';
import 'package:bible_garden/features/customize/customize_screen.dart';
import 'package:bible_garden/features/debug/debug_routes.dart';
import 'package:bible_garden/features/devotional/devotional_screen.dart';
import 'package:bible_garden/features/forest/forest_screen.dart';
import 'package:bible_garden/features/garden/garden_screen.dart';
import 'package:bible_garden/features/herbarium/herbarium_screen.dart';
import 'package:bible_garden/features/onboarding/onboarding_screen.dart';
import 'package:bible_garden/features/prayer/prayer_screen.dart';
import 'package:bible_garden/features/reading/book_screen.dart';
import 'package:bible_garden/features/reading/reader_screen.dart';
import 'package:bible_garden/features/reading/reading_list_screen.dart';
import 'package:bible_garden/features/reading/validation_screen.dart';
import 'package:bible_garden/features/settings/settings_screen.dart';
import 'package:bible_garden/features/shop/shop_screen.dart';
import 'package:bible_garden/l10n/gen/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Rotas do app. As rotas de teste só existem no flavor dev.
GoRouter buildRouter({String initialLocation = '/'}) {
  final rootKey = GlobalKey<NavigatorState>();
  GoRoute full(String path, Widget Function(GoRouterState s) b) =>
      GoRoute(path: path, parentNavigatorKey: rootKey, builder: (c, s) => b(s));
  return GoRouter(
    navigatorKey: rootKey,
    initialLocation: initialLocation,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => _Shell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/', builder: (c, s) => const GardenScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/ler',
                builder: (c, s) => const ReadingListScreen(),
                routes: [
                  GoRoute(
                    path: ':book',
                    builder: (c, s) =>
                        BookScreen(bookId: s.pathParameters['book']!),
                    routes: [
                      GoRoute(
                        path: ':chapter',
                        parentNavigatorKey: rootKey,
                        builder: (c, s) => ReaderScreen(
                          bookId: s.pathParameters['book']!,
                          chapter: int.parse(s.pathParameters['chapter']!),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/orar', builder: (c, s) => const PrayerScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/floresta',
                builder: (c, s) => const ForestScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/cuidar', builder: (c, s) => const ShopScreen()),
            ],
          ),
        ],
      ),
      full('/bem-vindo', (s) => const OnboardingScreen()),
      full('/validacao', (s) => const ValidationScreen()),
      full('/devocional', (s) => const DevotionalScreen()),
      full('/herbario', (s) => const HerbariumScreen()),
      full('/personalizar', (s) => const CustomizeScreen()),
      full('/ajustes', (s) => const SettingsScreen()),
      if (isDev) ...debugRoutes,
    ],
  );
}

class _Shell extends StatelessWidget {
  const new({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) =>
            shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.park_outlined),
            selectedIcon: const Icon(Icons.park),
            label: t.navGarden,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: t.navRead,
          ),
          NavigationDestination(
            icon: const Icon(Icons.spa_outlined),
            selectedIcon: const Icon(Icons.spa),
            label: t.navPray,
          ),
          NavigationDestination(
            icon: const Icon(Icons.forest_outlined),
            selectedIcon: const Icon(Icons.forest),
            label: t.navForest,
          ),
          NavigationDestination(
            icon: const Icon(Icons.local_florist_outlined),
            selectedIcon: const Icon(Icons.local_florist),
            label: t.navShop,
          ),
        ],
      ),
    );
  }
}
