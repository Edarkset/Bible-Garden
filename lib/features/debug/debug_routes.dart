import 'package:bible_garden/features/debug/debug_screen.dart';
import 'package:go_router/go_router.dart';

/// Rotas da versão mod. Só entram no roteador quando `isDev` é verdadeiro,
/// então o compilador as remove do build `prod`.
final List<RouteBase> debugRoutes = [
  GoRoute(path: '/dev', builder: (context, state) => const DebugScreen()),
];
