import 'dart:async';

import 'package:bible_garden/app/flavor.dart';
import 'package:bible_garden/app/providers.dart';
import 'package:bible_garden/core/growth.dart';
import 'package:bible_garden/core/reading.dart';
import 'package:bible_garden/core/rules.dart';
import 'package:bible_garden/data/content/content.dart';
import 'package:bible_garden/data/repositories/garden_repository.dart';
import 'package:bible_garden/features/common/labels.dart';
import 'package:bible_garden/features/garden/garden_state.dart';
import 'package:bible_garden/features/garden/garden_view.dart';
import 'package:bible_garden/features/garden/today_card.dart';
import 'package:bible_garden/features/reading/reader_screen.dart';
import 'package:bible_garden/game/logic/garden_layout.dart';
import 'package:bible_garden/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Livro em foco no jardim (salvo nas preferências).
final Provider<String> currentBookProvider = Provider<String>(
  (ref) => ref.watch(settingProvider('livro.atual')).value ?? 'GEN',
);

/// Tela do jardim.
class GardenScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<GardenScreen> createState() => _GardenScreenState();
}

class _GardenScreenState extends ConsumerState<GardenScreen> {
  bool _editing = false;
  String? _selected;
  Set<String> _owned = const {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOutcome();
      unawaited(_welcome());
    });
  }

  /// Volta acolhedora: 3 dias ou mais longe → chuva e mensagem gentil.
  Future<void> _welcome() async {
    final days = await ref.read(gardenRepositoryProvider).registerVisit();
    if (!mounted || days == null || days < Rules.welcomeBackDays) return;
    ref.read(welcomeRainProvider.notifier).start();
    final t = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.gardenWelcomeBack),
        duration: const Duration(seconds: 8),
      ),
    );
    await Future<void>.delayed(const Duration(seconds: 90));
    if (mounted) ref.read(welcomeRainProvider.notifier).stop();
  }

  Future<void> _toggleEdit() async {
    final owned = await ref.read(gardenRepositoryProvider).ownedItems();
    if (!mounted) return;
    setState(() {
      _editing = !_editing;
      _owned = owned;
      _selected = null;
    });
  }

  Future<void> _onTile(String book, Tile tile) async {
    if (!_editing) return;
    final repo = ref.read(gardenRepositoryProvider);
    if (await repo.unplaceAt(book, tile.x, tile.y)) return;
    final item = _selected;
    if (item == null) return;
    final occupied = {
      for (final p in await repo.placements(book)) (x: p.x, y: p.y),
    };
    if (GardenLayout.canPlace(tile, occupied)) {
      await repo.place(book, item, tile.x, tile.y);
    }
  }

  void _showOutcome() {
    final o = ref.read(lastOutcomeProvider);
    if (o == null || !mounted) return;
    ref.read(lastOutcomeProvider.notifier).set(null);
    final t = AppLocalizations.of(context);
    final content = ref.read(contentProvider);
    final name = content.livro(o.book)?.nome ?? o.book;
    final lines = <String>[
      t.readDone('$name ${o.chapter}'),
      if (o.stageBefore == Stage.semente && o.stageAfter == Stage.broto)
        t.readSprouted
      else if (o.stageAfter != o.stageBefore)
        t.readStageReached(t.stage(o.stageAfter))
      else
        t.readNewLeaf,
      if (o.orvalhoGanho > 0) t.readOrvalho(o.orvalhoGanho),
      for (final c in o.newCharacters)
        t.readCharacterUnlocked(content.personagem(c)?.nome ?? c),
      for (final a in o.newAnimals)
        t.readAnimalArrived(content.animal(a)?.nome ?? a),
      if (o.newCrownStones.isNotEmpty) t.readCrownStone,
      if (o.bookCompleted) t.readBookDone(name),
    ];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(lines.join('\n')),
        duration: const Duration(seconds: 7),
      ),
    );
  }

  Widget _tray(AppLocalizations t, GameContent content) {
    final items = [
      for (final d in content.decoracao)
        if (_owned.contains(d.id)) d,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(items.isEmpty ? t.gardenEditEmpty : t.gardenEditHint),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final d in items)
              ChoiceChip(
                label: Text(d.nome),
                selected: _selected == d.id,
                onSelected: (v) => setState(() => _selected = v ? d.id : null),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ChapterOutcome?>(lastOutcomeProvider, (_, o) {
      if (o != null) unawaited(Future.microtask(_showOutcome));
    });
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final book = ref.watch(currentBookProvider);
    final content = ref.watch(contentProvider);
    final entry = ref.watch(bibleRepositoryProvider).index.livro(book);
    final read = ref.watch(readChaptersProvider(book)).value ?? const {};
    final balance = ref.watch(balanceProvider).value ?? 0;
    final name = content.livro(book)?.nome ?? book;
    final caps = entry?.capitulos ?? 1;
    final stage = stageFor(read.length, caps);
    final next = nextStageIn(read.length, caps);
    int? nextChapter;
    for (var c = 1; c <= caps; c++) {
      if (!read.contains(c)) {
        nextChapter = c;
        break;
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(t.gardenTitle),
        actions: [
          IconButton(
            tooltip: t.navCustomize,
            icon: const Icon(Icons.brush_outlined),
            onPressed: () => context.push('/personalizar'),
          ),
          IconButton(
            tooltip: t.navSettings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/ajustes'),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(t.gardenOrvalho(balance)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 8),
            Text(
              t.gardenStage(name, t.stage(stage)),
              style: theme.textTheme.titleMedium,
            ),
            if (next != null) Text(t.readNextStage(next.faltam)),
            const SizedBox(height: 16),
            if (entry != null && nextChapter != null)
              FilledButton(
                onPressed: () => context.go('/ler/$book/$nextChapter'),
                child: Text(
                  t.gardenReadNext(
                    '$name $nextChapter',
                    minutosCapitulo(entry.palavrasPorCapitulo[nextChapter - 1]),
                  ),
                ),
              )
            else
              Text(t.gardenBookDone(name)),
            const SizedBox(height: 16),
            GardenView(
              book: book,
              editing: _editing,
              onTileTap: (tile) => unawaited(_onTile(book, tile)),
              semanticLabel: t.gardenSemanticLabel(name, t.stage(stage)),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _toggleEdit,
                icon: Icon(_editing ? Icons.check : Icons.edit_outlined),
                label: Text(_editing ? t.gardenEditDone : t.gardenEdit),
              ),
            ),
            if (_editing) _tray(t, content),
            const SizedBox(height: 8),
            const TodayCard(),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.push('/validacao'),
              child: Text(t.readHowValidated),
            ),
            if (isDev)
              FilledButton.tonal(
                onPressed: () => context.push('/dev'),
                child: Text(t.devToolsOpen),
              ),
            const SizedBox(height: 24),
            Text(
              t.bibleCredit,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
