import 'package:bible_garden/core/prayer.dart';
import 'package:bible_garden/core/prayer_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  PrayerSession run(int minutes, {int stepMs = 250}) {
    final s = PrayerSession(plannedMinutes: minutes, startMs: 0);
    for (var t = stepMs; s.state == PrayerState.running; t += stepMs) {
      s.tick(t);
    }
    return s;
  }

  test('oração até o fim conta', () {
    final s = run(2);
    expect(s.state, PrayerState.finished);
    expect(s.counts, isTrue);
  });

  test('desistir não registra', () {
    final s = PrayerSession(plannedMinutes: 5, startMs: 0)
      ..tick(200000)
      ..abandon();
    expect(s.counts, isFalse);
  });

  test('tela bloqueada por 10 s não interrompe e o tempo conta', () {
    final s = PrayerSession(plannedMinutes: 2, startMs: 0)
      ..tick(30000)
      ..onHidden(30000)
      ..onVisible(40000);
    expect(s.state, PrayerState.running);
    expect(s.elapsedMs, 40000);
  });

  test('mais de 15 s fora pausa, não conta o tempo fora e oferece retomar', () {
    final s = PrayerSession(plannedMinutes: 2, startMs: 0)
      ..tick(30000)
      ..onHidden(30000)
      ..onVisible(90000);
    expect(s.state, PrayerState.paused);
    expect(s.elapsedMs, 30000);
    s
      ..tick(100000)
      ..resume(100000)
      ..tick(190000);
    expect(s.state, PrayerState.finished);
    expect(s.counts, isTrue);
  });

  test('modo guiado passa pelas quatro etapas', () {
    final s = PrayerSession(plannedMinutes: 4, startMs: 0, guided: true);
    final seen = <PrayerStep>{};
    for (var t = 0; t <= 240000; t += 1000) {
      s.tick(t);
      seen.add(s.step);
    }
    expect(seen, PrayerStep.values.toSet());
  });
}
