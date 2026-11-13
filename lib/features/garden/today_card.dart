import 'package:bible_garden/app/providers.dart';
import 'package:bible_garden/core/calendar.dart';
import 'package:bible_garden/core/economy.dart';
import 'package:bible_garden/core/rules.dart';
import 'package:bible_garden/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

final class TodayState {
  const new({
    required this.day,
    required this.week,
    required this.porcao,
    required this.goal,
  });

  final DayActivity day;
  final List<bool> week;
  final int porcao;
  final NextGoal? goal;
}

final FutureProvider<TodayState> todayProvider = FutureProvider<TodayState>((
  ref,
) async {
  final balance = ref.watch(balanceProvider).value ?? 0;
  final repo = ref.watch(gardenRepositoryProvider);
  final content = ref.watch(contentProvider);
  final day = await repo.dayActivity();
  final owned = await repo.ownedItems();
  final items = [
    for (final d in content.decoracao)
      ShopItem(
        id: d.id,
        nome: d.nome,
        preco: d.preco,
        tem: owned.contains(d.id),
      ),
    for (final a in content.animais.where((a) => a.preco != null))
      ShopItem(
        id: 'animal:${a.id}',
        nome: a.nome,
        preco: a.preco!,
        tem: owned.contains('animal:${a.id}'),
      ),
  ];
  return TodayState(
    day: day,
    week: weekRhythm(await repo.activeDays(), repo.now),
    porcao: porcaoDoDia(day),
    goal: proximaConquista(balance, items),
  );
});

/// "Hoje no jardim": ler, orar, devocional, porção, ritmo da semana e a
/// próxima conquista. Sem sequência que zera: a semana só mostra os dias.
class TodayCard extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final s = ref.watch(todayProvider).value;
    if (s == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    Widget act(String label, bool done, VoidCallback onTap) => Expanded(
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(done ? Icons.check_circle : Icons.circle_outlined),
        label: Text(label),
      ),
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(t.todayTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                act(
                  t.todayRead,
                  s.day.readMin >= Rules.readMinForPresence,
                  () => context.go('/ler'),
                ),
                const SizedBox(width: 6),
                act(
                  t.todayPray,
                  s.day.prayMin >= Rules.prayerMinMinutes,
                  () => context.go('/orar'),
                ),
                const SizedBox(width: 6),
                act(
                  t.todayDevotional,
                  s.day.devocional,
                  () => context.push('/devocional'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(t.todayPortion(s.porcao, Rules.porcao.teto)),
            LinearProgressIndicator(value: s.porcao / Rules.porcao.teto),
            const SizedBox(height: 12),
            Text(t.todayWeek),
            const SizedBox(height: 4),
            Row(
              children: [
                for (final d in s.week)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Icon(
                      d ? Icons.eco : Icons.circle_outlined,
                      size: 18,
                      color: d
                          ? theme.colorScheme.secondary
                          : theme.colorScheme.outline,
                    ),
                  ),
              ],
            ),
            if (s.goal != null) ...[
              const SizedBox(height: 12),
              Text(t.todayNextGoal(s.goal!.nome)),
              LinearProgressIndicator(value: s.goal!.pct),
              Text(
                s.goal!.falta == 0
                    ? t.todayNextGoalReady
                    : t.todayNextGoalLeft(s.goal!.falta),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
