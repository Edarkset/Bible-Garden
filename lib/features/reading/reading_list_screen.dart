import 'package:bible_garden/app/providers.dart';
import 'package:bible_garden/features/reading/reading_prefs.dart';
import 'package:bible_garden/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Lista dos livros do cânon escolhido, agrupados por bioma.
class ReadingListScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final content = ref.watch(contentProvider);
    final bible = ref.watch(bibleRepositoryProvider);
    final prefs = ref.watch(readerPrefsProvider);
    final books = content.livrosDoCanone(catolico: prefs.catholicCanon);
    final items = <Widget>[];
    String? biome;
    for (final b in books) {
      if (b.bioma != biome) {
        biome = b.bioma;
        items.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
            child: Semantics(
              header: true,
              child: Text(biome, style: Theme.of(context).textTheme.titleSmall),
            ),
          ),
        );
      }
      final entry = bible.index.livro(b.id);
      items.add(
        _BookTile(
          id: b.id,
          name: b.nome,
          chapters: entry?.capitulos,
          onTap: () => context.go('/ler/${b.id}'),
          noText: t.readNoText,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(t.readTitle)),
      body: ListView(children: items),
    );
  }
}

class _BookTile extends ConsumerWidget {
  const new({
    required this.id,
    required this.name,
    required this.chapters,
    required this.onTap,
    required this.noText,
  });

  final String id;
  final String name;
  final int? chapters;
  final VoidCallback onTap;
  final String noText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final read = ref.watch(readChaptersProvider(id)).value?.length ?? 0;
    final total = chapters;
    return ListTile(
      title: Text(name),
      subtitle: Text(
        total == null ? noText : t.readChaptersOf(read, total),
        maxLines: 2,
      ),
      trailing: total == null
          ? null
          : SizedBox(
              width: 48,
              child: LinearProgressIndicator(value: read / total),
            ),
      enabled: total != null,
      onTap: total == null ? null : onTap,
    );
  }
}
