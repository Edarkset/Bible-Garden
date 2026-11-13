import 'package:bible_garden/app/providers.dart';
import 'package:bible_garden/core/growth.dart';
import 'package:bible_garden/features/forest/forest_screen.dart';
import 'package:bible_garden/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// O que a pessoa já encontrou: árvores dos livros que viraram árvore,
/// plantas compradas, animais que chegaram.
final FutureProvider<Set<String>> discoveredProvider =
    FutureProvider<Set<String>>((ref) async {
      final repo = ref.watch(gardenRepositoryProvider);
      final content = ref.watch(contentProvider);
      final index = ref.watch(bibleIndexProvider);
      final counts = await ref.watch(readCountsProvider.future);
      final owned = await repo.ownedItems();
      final db = ref.watch(databaseProvider);
      final animals = await db.select(db.animals).get();
      return {
        for (final b in content.livros)
          if (index.livro(b.id) != null &&
              stageFor(counts[b.id] ?? 0, index.livro(b.id)!.capitulos).index >=
                  Stage.arvore.index)
            'planta:${b.arvore}',
        for (final i in owned)
          if (i.startsWith('planta:') || i.startsWith('animal:')) i,
        for (final a in animals) 'animal:${a.animalId}',
        if (await repo.setting('especie.GEN') case final s?) 'planta:$s',
      };
    });

/// Herbário no estilo das fichas de Forest Shuffle (molduras U08/U10).
class HerbariumScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final c = ref.watch(contentProvider);
    final found = ref.watch(discoveredProvider).value ?? const {};
    final plants = c.plantas;
    final animals = c.animais;
    Widget card(String key, String name, String origem, String? r) {
      final ok = found.contains(key);
      return Card(
        child: ListTile(
          leading: Icon(ok ? Icons.eco : Icons.lock_outline),
          title: Text(ok ? name : t.herbLocked),
          subtitle: ok
              ? Text(
                  [
                    t.herbOrigin(origem),
                    if (r != null) t.herbRef(r),
                  ].join('\n'),
                )
              : null,
        ),
      );
    }

    final pFound = plants.where((p) => found.contains('planta:${p.id}')).length;
    final aFound = animals
        .where((a) => found.contains('animal:${a.id}'))
        .length;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.herbTitle),
          bottom: TabBar(
            tabs: [
              Tab(
                text: '${t.herbPlants} · ${t.herbCount(pFound, plants.length)}',
              ),
              Tab(
                text:
                    '${t.herbAnimals} · ${t.herbCount(aFound, animals.length)}',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              children: [
                for (final p in plants)
                  card('planta:${p.id}', p.nome, p.origem, p.ref),
              ],
            ),
            ListView(
              children: [
                for (final a in animals)
                  card('animal:${a.id}', a.nome, a.origem, a.ref),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
