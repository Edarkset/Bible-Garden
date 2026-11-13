import 'dart:async';
import 'dart:math' as math;

import 'package:bible_garden/app/flavor.dart';
import 'package:bible_garden/app/providers.dart';
import 'package:bible_garden/core/reading.dart';
import 'package:bible_garden/core/reading_tracker.dart';
import 'package:bible_garden/data/bible/bible_models.dart';
import 'package:bible_garden/data/bible/translations.dart';
import 'package:bible_garden/data/repositories/garden_repository.dart';
import 'package:bible_garden/features/common/labels.dart';
import 'package:bible_garden/features/reading/reading_prefs.dart';
import 'package:bible_garden/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Resultado de uma leitura concluída, entregue à tela do jardim.
final class LastOutcome extends Notifier<ChapterOutcome?> {
  @override
  ChapterOutcome? build() => null;

  // Nome curto para o uso `notifier.set(...)`.
  // ignore: use_setters_to_change_properties
  void set(ChapterOutcome? o) => state = o;
}

final NotifierProvider<LastOutcome, ChapterOutcome?> lastOutcomeProvider =
    NotifierProvider<LastOutcome, ChapterOutcome?>(LastOutcome.new);

/// Leitura de um capítulo com validação v2.
class ReaderScreen extends ConsumerStatefulWidget {
  const new({required this.bookId, required this.chapter, super.key});

  final String bookId;
  final int chapter;

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  final ScrollController _scroll = ScrollController();
  final GlobalKey<State<StatefulWidget>> _viewportKey = GlobalKey();
  List<GlobalKey> _blockKeys = const [];
  List<ReadingBlock> _blocks = const [];
  Chapter? _chapter;
  String _bookName = '';
  ReadingTracker? _tracker;
  Timer? _timer;
  StreamSubscription<AccelerometerEvent>? _accel;
  late final AppLifecycleListener _lifecycle;
  bool _appVisible = true;
  Set<int> _flagged = const {};
  RejectReason? _reject;
  bool _busy = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onStateChange: (s) => _appVisible = s == AppLifecycleState.resumed,
    );
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      final repo = ref.read(bibleRepositoryProvider);
      final book = await repo.book(widget.bookId);
      final ch = book.capitulos[widget.chapter - 1];
      final blocks = makeBlocks(ch.textos);
      if (!mounted) return;
      final now = _nowMs();
      setState(() {
        _bookName = book.nome;
        _chapter = ch;
        _blocks = blocks;
        _blockKeys = [for (final _ in blocks) GlobalKey()];
        _tracker = ReadingTracker(
          blockWords: [for (final b in blocks) b.words],
          startMs: now,
        )..sensorEnabled = ref.read(readerPrefsProvider).sensor;
      });
      _timer = Timer.periodic(
        const Duration(milliseconds: 250),
        (_) => _tick(),
      );
      _syncSensor();
    } on Object catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  int _nowMs() => DateTime.now().millisecondsSinceEpoch;

  void _syncSensor() {
    final on = ref.read(readerPrefsProvider).sensor;
    _tracker?.sensorEnabled = on;
    if (on && _accel == null) {
      _accel =
          accelerometerEventStream(samplingPeriod: SensorInterval.uiInterval)
              .listen(
                (e) => _tracker?.onAccelerometer(
                  math.sqrt(e.x * e.x + e.y * e.y + e.z * e.z),
                ),
                onError: (Object _) {},
              );
    } else if (!on) {
      unawaited(_accel?.cancel());
      _accel = null;
    }
  }

  /// Blocos com pelo menos metade visível (ou que cobrem a tela inteira).
  List<int> _visibleBlocks() {
    final vp = _viewportKey.currentContext?.findRenderObject() as RenderBox?;
    if (vp == null || !vp.hasSize) return const [];
    final top = vp.localToGlobal(Offset.zero).dy;
    final bottom = top + vp.size.height;
    final out = <int>[];
    for (var i = 0; i < _blockKeys.length; i++) {
      final box =
          _blockKeys[i].currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.attached || !box.hasSize) continue;
      final y = box.localToGlobal(Offset.zero).dy;
      final h = box.size.height;
      final seen = math.max(0, math.min(bottom, y + h) - math.max(top, y));
      if (seen >= h * 0.5 || seen >= vp.size.height * 0.9) out.add(i);
    }
    return out;
  }

  void _tick() {
    final tr = _tracker;
    if (tr == null) return;
    final wasIdle = tr.idle;
    tr.tick(
      _nowMs(),
      visibleBlocks: _visibleBlocks(),
      appVisible: _appVisible,
      scrollOffset: _scroll.hasClients ? _scroll.offset : 0,
    );
    if (tr.idle != wasIdle && mounted) setState(() {});
  }

  void _onInput() {
    final tr = _tracker;
    if (tr == null) return;
    final wasIdle = tr.idle;
    tr.onInput(_nowMs());
    if (wasIdle) setState(() {});
  }

  Future<void> _finish({bool printed = false}) async {
    final tr = _tracker;
    final ch = _chapter;
    if (tr == null || ch == null || _busy) return;
    final t = AppLocalizations.of(context);
    final repo = ref.read(gardenRepositoryProvider);
    final entry = ref.read(bibleRepositoryProvider).index.livro(widget.bookId)!;
    final words = entry.palavrasPorCapitulo[widget.chapter - 1];
    ValidationSummary? summary;
    double minutes;
    if (printed) {
      final ok = printedReadingAllowed(
        lastPrintedAt: await repo.lastPrintedReadingAt(),
        now: DateTime.now(),
        chapterWords: words,
      );
      if (!mounted) return;
      if (!ok) {
        _snack(t.readPrintedTooSoon);
        return;
      }
      final confirm = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          content: Text(t.readPrintedConfirm(_ref)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: Text(t.readCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(c, true),
              child: Text(t.readConfirm),
            ),
          ],
        ),
      );
      if (confirm != true) return;
      minutes = words / 230;
    } else {
      final v = tr.validate();
      setState(() {
        _flagged = v.check.flagged.toSet();
        _reject = v.motivo;
      });
      if (!v.ok) return;
      summary = tr.summary(v);
      minutes = tr.activeMs / 60000;
    }
    setState(() => _busy = true);
    try {
      final outcome = await repo.completeChapter(
        book: widget.bookId,
        chapter: widget.chapter,
        chaptersInBook: entry.capitulos,
        minutes: minutes,
        method: printed ? 'impressa' : 'app',
        summary: summary,
      );
      ref.read(lastOutcomeProvider.notifier).set(outcome);
      if (mounted) context.go('/');
    } on Object {
      if (mounted) {
        setState(() => _busy = false);
        _snack(t.commonError);
      }
    }
  }

  String get _ref => '$_bookName ${widget.chapter}';

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  void dispose() {
    _timer?.cancel();
    unawaited(_accel?.cancel());
    _lifecycle.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final prefs = ref.watch(readerPrefsProvider);
    ref.listen(readerPrefsProvider, (_, _) => _syncSensor());
    final colors = _ReaderColors.of(prefs.theme);
    final ch = _chapter;
    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        foregroundColor: colors.ink,
        title: Text(_ref),
        actions: [
          IconButton(
            tooltip: t.readFontSmaller,
            icon: const Icon(Icons.text_decrease),
            onPressed: () => ref.setFont(prefs.fontSize - 2),
          ),
          IconButton(
            tooltip: t.readFontBigger,
            icon: const Icon(Icons.text_increase),
            onPressed: () => ref.setFont(prefs.fontSize + 2),
          ),
          IconButton(
            tooltip: t.readTheme,
            icon: const Icon(Icons.contrast),
            onPressed: () => ref.setReaderTheme(
              ReaderTheme.values[(prefs.theme.index + 1) %
                  ReaderTheme.values.length],
            ),
          ),
          IconButton(
            tooltip: t.readTranslation,
            icon: const Icon(Icons.translate),
            onPressed: () => _pickTranslation(context),
          ),
        ],
      ),
      body: _error != null
          ? Center(child: Text(t.commonError))
          : ch == null
          ? const Center(child: CircularProgressIndicator())
          : Listener(
              onPointerDown: (_) => _onInput(),
              onPointerSignal: (_) => _onInput(),
              child: NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  _tracker?.onScrollActivity(_nowMs());
                  return false;
                },
                child: Stack(
                  children: [
                    _buildText(context, ch, prefs, colors, t),
                    if (_tracker?.idle ?? false)
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        child: Material(
                          color: colors.note,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: _onInput,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                t.readPaused,
                                style: TextStyle(color: colors.ink),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildText(
    BuildContext context,
    Chapter ch,
    ReaderPrefs prefs,
    _ReaderColors colors,
    AppLocalizations t,
  ) {
    final textStyle = TextStyle(
      fontSize: prefs.fontSize,
      height: 1.6,
      color: colors.ink,
    );
    final tr = translationById(prefs.translationId);
    return CustomScrollView(
      key: _viewportKey,
      controller: _scroll,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          sliver: SliverList.list(
            children: [
              if (tr.status != LicenseStatus.liberada)
                _Note(
                  text: tr.status == LicenseStatus.abertaPendente
                      ? t.readTranslationPending
                      : t.readTranslationLicense,
                  colors: colors,
                ),
              if (ch.titulo != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    ch.titulo!,
                    style: textStyle.copyWith(
                      fontStyle: FontStyle.italic,
                      fontSize: prefs.fontSize * 0.9,
                    ),
                  ),
                ),
              for (var i = 0; i < _blocks.length; i++)
                _Block(
                  key: _blockKeys[i],
                  verses: [
                    for (final v in _blocks[i].verses) ch.versiculos[v.n - 1],
                  ],
                  style: textStyle,
                  colors: colors,
                  flagged: _flagged.contains(i),
                  noteLabel: t.readNote,
                ),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList.list(
            children: [
              if (_reject != null)
                _Note(text: t.reject(_reject!), colors: colors),
              FilledButton(
                onPressed: _busy ? null : _finish,
                child: Text(t.readFinish),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _busy ? null : () => _finish(printed: true),
                child: Text(t.readPrinted),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.setSensor(on: !prefs.sensor),
                child: Text(prefs.sensor ? t.readSensorOn : t.readSensorOff),
              ),
              Text(
                t.readSensorInfo,
                style: TextStyle(color: colors.muted, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              if (isDev) ...[
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    _tracker?.simulateAttentiveReading();
                    unawaited(_finish());
                  },
                  child: Text(t.readSimulate),
                ),
              ],
              const SizedBox(height: 24),
              Text(
                ref.read(bibleRepositoryProvider).index.credito,
                style: TextStyle(color: colors.muted, fontSize: 12),
              ),
              SizedBox(height: MediaQuery.paddingOf(context).bottom + 24),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pickTranslation(BuildContext context) async {
    final t = AppLocalizations.of(context);
    final current = ref.read(readerPrefsProvider).translationId;
    final picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (c) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final tr in translations)
              ListTile(
                title: Text('${tr.nome} (${tr.sigla})'),
                subtitle: tr.disponivel
                    ? null
                    : Text(
                        tr.status == LicenseStatus.abertaPendente
                            ? t.readTranslationPending
                            : t.readTranslationLicense,
                      ),
                trailing: tr.id == current ? const Icon(Icons.check) : null,
                onTap: () => Navigator.pop(c, tr.id),
              ),
          ],
        ),
      ),
    );
    if (picked != null) await ref.setTranslation(picked);
  }
}

class _Block extends StatelessWidget {
  const new({
    required this.verses,
    required this.style,
    required this.colors,
    required this.flagged,
    required this.noteLabel,
    super.key,
  });

  final List<Verse> verses;
  final TextStyle style;
  final _ReaderColors colors;
  final bool flagged;
  final String noteLabel;

  @override
  Widget build(BuildContext context) {
    final spans = <InlineSpan>[];
    for (final v in verses) {
      spans.add(
        TextSpan(
          text: '${v.numero} ',
          style: style.copyWith(
            fontSize: (style.fontSize ?? 18) * 0.65,
            color: colors.muted,
            fontFeatures: const [FontFeature.superscripts()],
          ),
        ),
      );
      var pos = 0;
      for (final (a, b) in v.italicos) {
        if (a > pos) spans.add(TextSpan(text: v.texto.substring(pos, a)));
        spans.add(
          TextSpan(
            text: v.texto.substring(a, b),
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        );
        pos = b;
      }
      spans.add(TextSpan(text: '${v.texto.substring(pos)} '));
      if (v.notas.isNotEmpty) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: _NoteButton(verse: v, label: noteLabel, colors: colors),
          ),
        );
      }
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: flagged ? colors.gold : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      child: Text.rich(TextSpan(style: style, children: spans)),
    );
  }
}

class _NoteButton extends StatelessWidget {
  const new({required this.verse, required this.label, required this.colors});

  final Verse verse;
  final String label;
  final _ReaderColors colors;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: '$label ${verse.numero}',
    excludeSemantics: true,
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: () => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (c) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final n in verse.notas) ...[
                  if (n.trecho != null)
                    Text(
                      n.trecho!,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  Text(n.texto),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          Icons.sticky_note_2_outlined,
          size: 16,
          color: colors.muted,
        ),
      ),
    ),
  );
}

class _Note extends StatelessWidget {
  const new({required this.text, required this.colors});

  final String text;
  final _ReaderColors colors;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: colors.note,
      borderRadius: BorderRadius.circular(12),
      border: Border(left: BorderSide(color: colors.gold, width: 3)),
    ),
    child: Semantics(
      liveRegion: true,
      child: Text(text, style: TextStyle(color: colors.ink)),
    ),
  );
}

/// Cores dos três temas de leitura (contraste AA).
final class _ReaderColors {
  const new({
    required this.bg,
    required this.ink,
    required this.muted,
    required this.note,
    required this.gold,
  });

  factory of(ReaderTheme t) => switch (t) {
    ReaderTheme.claro => const _ReaderColors(
      bg: Color(0xFFFBFAF5),
      ink: Color(0xFF26302B),
      muted: Color(0xFF5B6B62),
      note: Color(0xFFF6E3B0),
      gold: Color(0xFFC98F12),
    ),
    ReaderTheme.sepia => const _ReaderColors(
      bg: Color(0xFFF4ECD8),
      ink: Color(0xFF3B2F22),
      muted: Color(0xFF6B5A44),
      note: Color(0xFFEAD9B0),
      gold: Color(0xFFA9740C),
    ),
    ReaderTheme.noturno => const _ReaderColors(
      bg: Color(0xFF141C1F),
      ink: Color(0xFFDCE3DA),
      muted: Color(0xFF9BAAA2),
      note: Color(0xFF3A3220),
      gold: Color(0xFFF0C24E),
    ),
  };

  final Color bg;
  final Color ink;
  final Color muted;
  final Color note;
  final Color gold;
}
