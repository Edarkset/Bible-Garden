import 'dart:async';
import 'dart:math' as math;

import 'package:bible_garden/app/providers.dart';
import 'package:bible_garden/core/prayer.dart';
import 'package:bible_garden/core/prayer_session.dart';
import 'package:bible_garden/data/db/app_database.dart';
import 'package:bible_garden/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

final StreamProvider<List<PrayerRequestRow>> prayerRequestsProvider =
    StreamProvider<List<PrayerRequestRow>>(
      (ref) => ref.watch(gardenRepositoryProvider).watchPrayerRequests(),
    );

/// Aba de oração: escolher o tempo, orar e cuidar dos pedidos.
class PrayerScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends ConsumerState<PrayerScreen> {
  int _minutes = 5;
  bool _guided = false;

  Future<void> _start() async {
    final t = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final done = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => PrayerSessionScreen(minutes: _minutes, guided: _guided),
      ),
    );
    if (done ?? false) {
      await ref
          .read(gardenRepositoryProvider)
          .recordPrayer(minutes: _minutes, guided: _guided);
      messenger.showSnackBar(SnackBar(content: Text(t.prayDone)));
    }
  }

  Future<void> _addRequest() async {
    final text = await showDialog<String>(
      context: context,
      builder: (_) => const _RequestDialog(),
    );
    if (text != null && text.trim().isNotEmpty) {
      await ref.read(gardenRepositoryProvider).addPrayerRequest(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final requests = ref.watch(prayerRequestsProvider).value ?? const [];
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.prayTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(t.prayIntro),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              for (final m in prayerDurations)
                ChoiceChip(
                  label: Text(t.prayMinutes(m)),
                  selected: m == _minutes,
                  onSelected: (_) => setState(() => _minutes = m),
                ),
            ],
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(t.prayGuided),
            value: _guided,
            onChanged: (v) => setState(() => _guided = v),
          ),
          FilledButton(onPressed: _start, child: Text(t.prayStart)),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: Text(t.prayRequests, style: theme.textTheme.titleMedium),
              ),
              IconButton(
                tooltip: t.prayRequestAdd,
                onPressed: _addRequest,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          Text(
            t.prayRequestsPrivacy,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          for (final r in requests)
            Card(
              child: ListTile(
                title: Text(r.body),
                subtitle: r.answeredAt == null
                    ? null
                    : Text(t.prayRequestAnsweredOn),
                trailing: PopupMenuButton<String>(
                  onSelected: (v) async {
                    final repo = ref.read(gardenRepositoryProvider);
                    final messenger = ScaffoldMessenger.of(context);
                    if (v == 'ok') {
                      await repo.answerPrayerRequest(r.id);
                      messenger.showSnackBar(
                        SnackBar(content: Text(t.prayRequestEbenezer)),
                      );
                    } else {
                      await repo.deletePrayerRequest(r.id);
                    }
                  },
                  itemBuilder: (_) => [
                    if (r.answeredAt == null)
                      PopupMenuItem(
                        value: 'ok',
                        child: Text(t.prayRequestAnswered),
                      ),
                    PopupMenuItem(
                      value: 'del',
                      child: Text(t.prayRequestDelete),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RequestDialog extends StatefulWidget {
  const new();

  @override
  State<_RequestDialog> createState() => _RequestDialogState();
}

class _RequestDialogState extends State<_RequestDialog> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(t.prayRequestAdd),
      content: TextField(
        controller: _ctrl,
        autofocus: true,
        maxLines: 4,
        maxLength: 500,
        decoration: InputDecoration(hintText: t.prayRequestHint),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.readCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _ctrl.text),
          child: Text(t.prayRequestSave),
        ),
      ],
    );
  }
}

/// Tela da oração em camadas (placeholder de U05: céu, lua no lago, vela).
class PrayerSessionScreen extends StatefulWidget {
  const new({required this.minutes, required this.guided, super.key});

  final int minutes;
  final bool guided;

  @override
  State<PrayerSessionScreen> createState() => _PrayerSessionScreenState();
}

class _PrayerSessionScreenState extends State<PrayerSessionScreen> {
  late final PrayerSession _s = PrayerSession(
    plannedMinutes: widget.minutes,
    startMs: _now(),
    guided: widget.guided,
  );
  late final AppLifecycleListener _life;
  Timer? _timer;

  static int _now() => DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    _life = AppLifecycleListener(
      onHide: () => _s.onHidden(_now()),
      onShow: () => setState(() => _s.onVisible(_now())),
    );
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() => _s.tick(_now()));
      if (_s.state == PrayerState.finished) {
        _timer?.cancel();
        Navigator.of(context).pop(_s.counts);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _life.dispose();
    super.dispose();
  }

  String _stepText(AppLocalizations t) => switch (_s.step) {
    PrayerStep.adoracao => t.prayStepAdoracao,
    PrayerStep.confissao => t.prayStepConfissao,
    PrayerStep.gratidao => t.prayStepGratidao,
    PrayerStep.suplica => t.prayStepSuplica,
  };

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final rem = _s.remainingMs ~/ 1000;
    final mm = (rem ~/ 60).toString();
    final ss = (rem % 60).toString().padLeft(2, '0');
    const ink = Color(0xFFE5ECE4);
    return Scaffold(
      backgroundColor: const Color(0xFF0F1A2A),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _NightPainter(_s.progress)),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      t.prayRemaining(mm, ss),
                      style: const TextStyle(color: ink, fontSize: 40),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_s.guided)
                    Text(
                      _stepText(t),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: ink, fontSize: 18),
                    ),
                  const Spacer(),
                  if (_s.state == PrayerState.paused) ...[
                    Text(
                      t.prayPaused,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: ink),
                    ),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: () => setState(() => _s.resume(_now())),
                      child: Text(t.prayResume),
                    ),
                  ],
                  TextButton(
                    onPressed: () {
                      _s.abandon();
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      t.prayGiveUp,
                      style: const TextStyle(color: ink),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NightPainter extends CustomPainter {
  new(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final moon = Offset(size.width * 0.75, size.height * 0.18);
    canvas
      ..drawCircle(moon, 22, Paint()..color = const Color(0xFFF3EBC8))
      // reflexo da lua no lago
      ..drawOval(
        Rect.fromCenter(
          center: Offset(moon.dx, size.height * 0.82),
          width: 36,
          height: 8,
        ),
        Paint()..color = const Color(0x55F3EBC8),
      );
    // vela: a chama cresce com o tempo de oração
    final base = Offset(size.width * 0.5, size.height * 0.72);
    canvas.drawRect(
      Rect.fromCenter(center: base, width: 14, height: 40),
      Paint()..color = const Color(0xFFEDE3CF),
    );
    final h = 14 + 10 * math.sin(progress * math.pi);
    canvas.drawOval(
      Rect.fromCenter(center: base.translate(0, -28), width: 10, height: h),
      Paint()
        ..color = const Color(0xFFFFC857)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
  }

  @override
  bool shouldRepaint(_NightPainter old) => old.progress != progress;
}
