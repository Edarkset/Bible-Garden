import 'package:bible_garden/app/flavor.dart';
import 'package:bible_garden/features/debug/debug_routes.dart';
import 'package:bible_garden/features/garden/garden_screen.dart';
import 'package:bible_garden/features/reading/book_screen.dart';
import 'package:bible_garden/features/reading/reader_screen.dart';
import 'package:bible_garden/features/reading/reading_list_screen.dart';
import 'package:bible_garden/features/reading/validation_screen.dart';
import 'package:bible_garden/l10n/gen/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>();

/// Rotas do app. As rotas de teste só existem no flavor dev.
GoRouter buildRouter({String initialLocation = '/'}) => GoRouter(
  navigatorKey: _rootKey,
  initialLocation: initialLocation,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => _Shell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: '/', builder: (c, s) => const GardenScreen())],
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
                      parentNavigatorKey: _rootKey,
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
      ],
    ),
    GoRoute(
      path: '/validacao',
      parentNavigatorKey: _rootKey,
      builder: (c, s) => const ValidationScreen(),
    ),
    if (isDev) ...debugRoutes,
  ],
);

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
        ],
      ),
    );
  }
}
