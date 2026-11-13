import 'package:bible_garden/app/providers.dart';
import 'package:bible_garden/core/growth.dart';
import 'package:bible_garden/core/reading.dart';
import 'package:bible_garden/data/content/content.dart';
import 'package:bible_garden/features/common/labels.dart';
import 'package:bible_garden/features/reading/reading_prefs.dart';
import 'package:bible_garden/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Capítulos lidos por livro (para a floresta inteira).
final FutureProvider<Map<String, int>> readCountsProvider =
    FutureProvider<Map<String, int>>((ref) async {
      ref.watch(balanceProvider);
      final db = ref.watch(databaseProvider);
      final rows = await db.select(db.chapterReads).get();
      final out = <String, int>{};
      for (final r in rows) {
        out[r.book] = (out[r.book] ?? 0) + 1;
      }
      return out;
    });

/// Mapa dos biomas e jardins. A forma segue o tamanho do livro; o rio
/// atravessa os jardins concluídos.
class ForestScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final content = ref.watch(contentProvider);
    final index = ref.watch(bibleIndexProvider);
    final prefs = ref.watch(readerPrefsProvider);
    final counts = ref.watch(readCountsProvider).value ?? const {};
    final books = content.livrosDoCanone(catolico: prefs.catholicCanon);
    final done = books.where((b) {
      final caps = index.livro(b.id)?.capitulos;
      return caps != null && (counts[b.id] ?? 0) >= caps;
    }).length;
    final byBiome = <String, List<BookGarden>>{};
    for (final b in books) {
      byBiome.putIfAbsent(b.bioma, () => []).add(b);
    }
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.forestTitle),
        actions: [
          TextButton(
            onPressed: () => context.push('/herbario'),
            child: Text(t.forestHerbarium),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(t.forestIntro),
          const SizedBox(height: 8),
          Text(t.forestRiver(done, books.length)),
          LinearProgressIndicator(value: done / books.length),
          for (final e in byBiome.entries) ...[
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 8),
              child: Semantics(
                header: true,
                child: Text(e.key, style: theme.textTheme.titleMedium),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final b in e.value)
                  _GardenTile(
                    book: b,
                    chapters: index.livro(b.id)?.capitulos,
                    words: index.livro(b.id)?.palavras,
                    read: counts[b.id] ?? 0,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _GardenTile extends ConsumerWidget {
  const new({
    required this.book,
    required this.chapters,
    required this.words,
    required this.read,
  });

  final BookGarden book;
  final int? chapters;
  final int? words;
  final int read;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final caps = chapters;
    final stage = caps == null ? Stage.semente : stageFor(read, caps);
    final size = words == null
        ? SizeClass.flor
        : sizeClass(minutosCapitulo(words!));
    final icon = switch (size) {
      SizeClass.flor => Icons.local_florist,
      SizeClass.media => Icons.park_outlined,
      SizeClass.grande => Icons.forest,
    };
    final label = caps == null
        ? '${book.nome}: ${t.forestNoText}'
        : '${book.nome}: ${t.stage(stage)}';
    return Semantics(
      button: caps != null,
      label: label,
      excludeSemantics: true,
      child: SizedBox(
        width: 96,
        height: 88,
        child: Card(
          margin: EdgeInsets.zero,
          color: stage == Stage.plena ? scheme.secondaryContainer : null,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: caps == null
                ? null
                : () async {
                    await ref
                        .read(gardenRepositoryProvider)
                        .setSetting('livro.atual', book.id);
                    if (context.mounted) context.go('/');
                  },
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 14 + stage.index * 3.0,
                    color: caps == null ? scheme.outline : scheme.secondary,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.nome,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
