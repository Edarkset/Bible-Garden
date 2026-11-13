import 'package:bible_garden/core/prayer.dart';
import 'package:bible_garden/core/rules.dart';

enum PrayerState { running, paused, finished, abandoned }

/// Uma oração em andamento. O relógio vem de fora (ms), para testar.
///
/// Fora do app por até 15 s (a tela bloqueou, uma notificação) não
/// interrompe. Depois disso a oração pausa e oferece retomar.
final class PrayerSession {
  new({required this.plannedMinutes, required int startMs, this.guided = false})
    : _lastMs = startMs;

  final int plannedMinutes;
  final bool guided;
  double _elapsedMs = 0;
  int _lastMs;
  int? _hiddenAtMs;
  PrayerState state = PrayerState.running;

  double get elapsedMs => _elapsedMs;
  double get totalMs => plannedMinutes * 60000.0;
  double get remainingMs => (totalMs - _elapsedMs).clamp(0, totalMs);
  double get progress => (_elapsedMs / totalMs).clamp(0, 1);

  /// Etapa do modo guiado (quatro partes iguais).
  PrayerStep get step =>
      PrayerStep.values[(progress * PrayerStep.values.length).floor().clamp(
        0,
        3,
      )];

  void tick(int nowMs) {
    final dt = nowMs - _lastMs;
    _lastMs = nowMs;
    if (state != PrayerState.running || dt <= 0) return;
    _elapsedMs += dt;
    if (_elapsedMs >= totalMs) state = PrayerState.finished;
  }

  /// O app foi para segundo plano.
  void onHidden(int nowMs) {
    tick(nowMs);
    _hiddenAtMs ??= nowMs;
  }

  /// O app voltou. Até 15 s fora, conta como oração; mais que isso, pausa
  /// e o tempo fora não conta.
  void onVisible(int nowMs) {
    final hidden = _hiddenAtMs;
    _hiddenAtMs = null;
    if (hidden == null || state != PrayerState.running) {
      _lastMs = nowMs;
      return;
    }
    final away = nowMs - hidden;
    if (away <= Rules.prayerGrace.inMilliseconds) {
      tick(nowMs);
    } else {
      _lastMs = nowMs;
      state = PrayerState.paused;
    }
  }

  void resume(int nowMs) {
    if (state != PrayerState.paused) return;
    _lastMs = nowMs;
    state = PrayerState.running;
  }

  void abandon() => state = PrayerState.abandoned;

  /// Conta para o jardim? (desistir não registra)
  bool get counts => prayerCounts(
    plannedMinutes,
    _elapsedMs,
    abandoned: state == PrayerState.abandoned,
  );
}
