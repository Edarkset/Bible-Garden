import 'package:bible_garden/app/providers.dart';
import 'package:bible_garden/data/content/devotionals.dart';
import 'package:bible_garden/data/db/app_database.dart';
import 'package:bible_garden/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

final Provider<Devotional> todayDevotionalProvider = Provider<Devotional>((
  ref,
) {
  final list = ref.watch(devotionalsProvider);
  final now = ref.watch(clockProvider)();
  return list[devotionalIndexFor(now, list.length)];
});

final FutureProvider<String> devotionalTextProvider = FutureProvider<String>((
  ref,
) async {
  final d = ref.watch(todayDevotionalProvider);
  final ch = await ref
      .watch(bibleRepositoryProvider)
      .chapter(d.livro, d.capitulo);
  return [for (var v = d.de; v <= d.ate; v++) ch.versiculos[v - 1].texto]
      .join(' ');
});

final StreamProvider<List<JournalRow>> journalProvider =
    StreamProvider<List<JournalRow>>(
      (ref) => ref.watch(gardenRepositoryProvider).watchJournal(),
    );

/// Devocional do dia: ilustração (U06), texto, reflexão, aplicação e baú.
class DevotionalScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<DevotionalScreen> createState() => _DevotionalScreenState();
}

class _DevotionalScreenState extends ConsumerState<DevotionalScreen> {
  final TextEditingController _note = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final t = AppLocalizations.of(context);
    final repo = ref.read(gardenRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    setState(() => _saving = true);
    final already = (await repo.dayActivity()).devocional;
    await repo.recordDevotional(
      note: _note.text,
      devotionalId: ref.read(todayDevotionalProvider).id,
    );
    messenger.showSnackBar(
      SnackBar(content: Text(already ? t.devAlready : t.devCompleted)),
    );
    if (nav.canPop()) nav.pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final d = ref.watch(todayDevotionalProvider);
    final text = ref.watch(devotionalTextProvider);
    final content = ref.watch(contentProvider);
    final abrev =
        ref.watch(bibleIndexProvider).livro(d.livro)?.abrev ?? d.livro;
    final ref0 =
        '$abrev ${d.capitulo}:${d.de}${d.ate > d.de ? '-${d.ate}' : ''}';
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.devTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Illustration(theme: d.tema),
          const SizedBox(height: 16),
          text.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => Text(t.commonError),
            data: (s) => Text(
              '“$s”',
              style: theme.textTheme.titleMedium?.copyWith(height: 1.5),
            ),
          ),
          Text(
            '$ref0 · ${content.livro(d.livro)?.nome ?? ''} · BLIVRE',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          Text(t.devQuestion, style: theme.textTheme.titleSmall),
          Text(d.pergunta),
          const SizedBox(height: 12),
          Text(t.devApply, style: theme.textTheme.titleSmall),
          Text(d.aplicacao),
          const SizedBox(height: 16),
          TextField(
            controller: _note,
            maxLines: 4,
            maxLength: 2000,
            decoration: InputDecoration(
              labelText: t.devNote,
              hintText: t.devNoteHint,
              helperText: t.devNotePrivacy,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _saving ? null : _finish,
            child: Text(t.devDone),
          ),
        ],
      ),
    );
  }
}

/// Ilustração do tema. Usa `assets/arte/interface/devocional__temas.png`
/// quando existir; até lá, um degradê por tema.
class _Illustration extends StatelessWidget {
  const new({required this.theme});

  final String theme;

  static const _colors = {
    'luz': [Color(0xFFF6E3B0), Color(0xFFE8B931)],
    'semente': [Color(0xFFCDE3B8), Color(0xFF7FB069)],
    'caminho': [Color(0xFFE6D9C2), Color(0xFFC9B18A)],
    'agua': [Color(0xFFBFE3F0), Color(0xFF4FA3C7)],
    'pao': [Color(0xFFF2DFC0), Color(0xFFC98F12)],
    'pastor': [Color(0xFFE2EBD6), Color(0xFF8BBF5E)],
    'videira': [Color(0xFFE3D3EC), Color(0xFF6B4C8A)],
    'estrela': [Color(0xFF2B3A5C), Color(0xFF0F1A2A)],
  };

  @override
  Widget build(BuildContext context) {
    final c = _colors[theme] ?? _colors['luz']!;
    return Semantics(
      image: true,
      excludeSemantics: true,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: c,
            ),
          ),
        ),
      ),
    );
  }
}
