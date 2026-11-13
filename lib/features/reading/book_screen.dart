import 'package:bible_garden/app/providers.dart';
import 'package:bible_garden/core/growth.dart';
import 'package:bible_garden/core/reading.dart';
import 'package:bible_garden/features/common/labels.dart';
import 'package:bible_garden/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Capítulos de um livro, agrupados em canteiros quando houver.
class BookScreen extends ConsumerWidget {
  const new({required this.bookId, super.key});

  final String bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final content = ref.watch(contentProvider);
    final entry = ref.watch(bibleRepositoryProvider).index.livro(bookId);
    final book = content.livro(bookId);
    if (entry == null || book == null) {
      return Scaffold(
        appBar: AppBar(title: Text(book?.nome ?? bookId)),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(t.readNoText),
        ),
      );
    }
    final read = ref.watch(readChaptersProvider(bookId)).value ?? const {};
    final caps = entry.capitulos;
    final groups = sections[bookId] ?? [Section(book.nome, 1, caps)];
    final stage = stageFor(read.length, caps);
    final next = nextStageIn(read.length, caps);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(book.nome)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(t.stage(stage), style: theme.textTheme.titleMedium),
          if (next != null) Text(t.readNextStage(next.faltam)),
          const SizedBox(height: 8),
          for (final s in groups) ...[
            if (groups.length > 1)
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Text(
                  t.readSection(s.nome),
                  style: theme.textTheme.titleSmall,
                ),
              ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var c = s.de; c <= s.ate; c++)
                  _ChapterChip(
                    n: c,
                    done: read.contains(c),
                    minutes: minutosCapitulo(entry.palavrasPorCapitulo[c - 1]),
                    onTap: () => context.go('/ler/$bookId/$c'),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ChapterChip extends StatelessWidget {
  const new({
    required this.n,
    required this.done,
    required this.minutes,
    required this.onTap,
  });

  final int n;
  final bool done;
  final int minutes;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: done ? t.readChapterRead(n) : t.readChapterLabel(n),
      hint: t.readMinutes(minutes),
      excludeSemantics: true,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Material(
          color: done ? scheme.secondary : scheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: scheme.outline),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Center(
              child: Text(
                '$n',
                style: TextStyle(
                  color: done ? scheme.onSecondary : scheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
