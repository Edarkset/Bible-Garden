import 'dart:async';

import 'package:bible_garden/app/providers.dart';
import 'package:bible_garden/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Marca procurada no binário de `prod` pelo CI: se aparecer, o código da
/// versão mod vazou para a versão das lojas.
const String debugBuildMarker = 'BG_FERRAMENTAS_MOD_7f3a';

/// Ferramentas da versão mod: orvalho, relógio, volta, leitura simulada.
class DebugScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final offset = ref.watch(clockOffsetProvider);
    void done(String msg) =>
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
    return Scaffold(
      appBar: AppBar(title: Text(t.devToolsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            t.devToolsEmpty,
            semanticsLabel: '${t.devToolsEmpty} ($debugBuildMarker)',
          ),
          Text(t.devClockOffset(offset)),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () async {
              await ref
                  .read(gardenRepositoryProvider)
                  .credit(300, reason: 'ajuste_dev');
              done(t.devAddOrvalho);
            },
            child: Text(t.devAddOrvalho),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () {
              ref.read(clockOffsetProvider.notifier).advance(1);
              done(t.devAdvanceDay);
            },
            child: Text(t.devAdvanceDay),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () async {
              final repo = ref.read(gardenRepositoryProvider);
              final now = repo.now.subtract(const Duration(days: 4));
              final iso =
                  '${now.year}-${now.month.toString().padLeft(2, '0')}-'
                  '${now.day.toString().padLeft(2, '0')}';
              await repo.setSetting('visita.ultima', iso);
              done(t.devSimulateReturn);
            },
            child: Text(t.devSimulateReturn),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () async {
              final repo = ref.read(gardenRepositoryProvider);
              for (var c = 1; c <= 15; c++) {
                await repo.completeChapter(
                  book: 'GEN',
                  chapter: c,
                  chaptersInBook: 50,
                  minutes: 4,
                  method: 'app',
                );
              }
              done(t.devUnlockAll);
            },
            child: Text(t.devUnlockAll),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => unawaited(ref.read(databaseProvider).wipe()),
            child: Text(t.setErase),
          ),
        ],
      ),
    );
  }
}
