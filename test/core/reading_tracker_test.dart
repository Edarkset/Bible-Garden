import 'package:bible_garden/core/reading.dart';
import 'package:bible_garden/core/reading_tracker.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/texto.dart';

/// Simula uma leitura: anda pelos blocos no ritmo dado, tocando na tela a
/// cada [touchEveryMs] e rolando de forma humana (pausas) ou robótica.
ReadingTracker simulate({
  required num wpm,
  bool human = true,
  int? touchEveryMs = 4000,
  bool pauseInBackground = false,
}) {
  final blocks = makeBlocks(genChapter(1));
  final t = ReadingTracker(
    blockWords: [for (final b in blocks) b.words],
    startMs: 0,
  );
  var now = 0;
  var scroll = 0.0;
  var lastTouch = 0;
  for (var i = 0; i < blocks.length; i++) {
    final ms = blocks[i].words / wpm * 60000;
    final end = now + ms;
    var step = 0;
    while (now < end) {
      now += 250;
      step++;
      if (human) {
        // lê parado e rola de vez em quando, com velocidades diferentes
        if (step % 12 == 0) scroll += 40 + (step % 5) * 30;
      } else {
        scroll += 20; // rolagem automática constante
      }
      if (touchEveryMs != null && now - lastTouch >= touchEveryMs) {
        t.onInput(now);
        lastTouch = now;
      } else {
        t.onScrollActivity(now);
      }
      t.tick(
        now,
        visibleBlocks: [i],
        appVisible: !pauseInBackground || i.isEven,
        scrollOffset: scroll,
      );
    }
  }
  return t;
}

void main() {
  test('leitor humano a 230 ppm é aprovado', () {
    final t = simulate(wpm: 230);
    final v = t.validate();
    expect(v.ok, isTrue, reason: '${v.motivo}');
    final s = t.summary(v);
    expect(s.ppm, inInclusiveRange(200, 260));
    expect(s.blocosOk, s.blocos);
  });

  test('rolagem automática constante é recusada por ritmo', () {
    final t = simulate(wpm: 230, human: false, touchEveryMs: null);
    final v = t.validate();
    expect(v.ok, isFalse);
    expect(v.motivo, RejectReason.ritmo);
  });

  test('sem nenhum toque é recusado por presença', () {
    final t = simulate(wpm: 230, touchEveryMs: null);
    expect(t.validate().motivo, RejectReason.presenca);
  });

  test('passar voando (2000 ppm) é recusado como rápido', () {
    expect(simulate(wpm: 2000).validate().motivo, RejectReason.rapido);
  });

  test('app em segundo plano não conta tempo', () {
    final t = simulate(wpm: 230, pauseInBackground: true);
    expect(t.validate().ok, isFalse);
  });

  test('90 s sem toque pausa a contagem e o toque retoma', () {
    final t = ReadingTracker(blockWords: [60], startMs: 0);
    for (var now = 250; now <= 120000; now += 250) {
      t.tick(now, visibleBlocks: [0], appVisible: true, scrollOffset: 0);
    }
    expect(t.idle, isTrue);
    expect(t.activeMs, closeTo(90000, 300));
    t
      ..onInput(120250)
      ..tick(120500, visibleBlocks: [0], appVisible: true, scrollOffset: 0);
    expect(t.idle, isFalse);
    expect(t.activeMs, closeTo(90250, 300));
  });

  test('toques muito seguidos contam uma vez só', () {
    final t = ReadingTracker(blockWords: [60], startMs: 0)
      ..onInput(1000)
      ..onInput(1100)
      ..onInput(1300)
      ..onInput(1500);
    expect(t.inputs, 2);
  });

  test('sensor: celular na mão vira presença; desligado é ignorado', () {
    final t = ReadingTracker(blockWords: [60, 60, 60], startMs: 0);
    for (var k = 0; k < 40; k++) {
      t.onAccelerometer(9.8 + (k.isEven ? 0.3 : -0.3));
    }
    t.tick(250, visibleBlocks: [0], appVisible: true, scrollOffset: 0);
    expect(t.signals().handShare, isNull);
    t.sensorEnabled = true;
    for (var k = 0; k < 20; k++) {
      t.onAccelerometer(9.8 + (k.isEven ? 0.3 : -0.3));
    }
    t.tick(500, visibleBlocks: [0], appVisible: true, scrollOffset: 0);
    expect(t.signals().handShare, 1.0);
  });

  test('resumo vira JSON e volta igual', () {
    final t = simulate(wpm: 230);
    final s = t.summary(t.validate());
    final back = ValidationSummary.fromJson(s.toJson());
    expect(back.ppm, s.ppm);
    expect(back.toques, s.toques);
    expect(back.maoPct, isNull);
  });

  group('li na minha Bíblia', () {
    final t0 = DateTime(2026, 11, 13, 8);
    test('primeiro registro sempre pode', () {
      expect(
        printedReadingAllowed(lastPrintedAt: null, now: t0, chapterWords: 800),
        isTrue,
      );
    });
    test('respeita o tempo mínimo do capítulo entre registros', () {
      // 800 palavras a 500 ppm = 96 s
      expect(
        printedReadingAllowed(
          lastPrintedAt: t0,
          now: t0.add(const Duration(seconds: 60)),
          chapterWords: 800,
        ),
        isFalse,
      );
      expect(
        printedReadingAllowed(
          lastPrintedAt: t0,
          now: t0.add(const Duration(seconds: 97)),
          chapterWords: 800,
        ),
        isTrue,
      );
    });
    test('relógio voltando no tempo não libera', () {
      expect(
        printedReadingAllowed(
          lastPrintedAt: t0,
          now: t0.subtract(const Duration(hours: 1)),
          chapterWords: 10,
        ),
        isFalse,
      );
    });
  });
}
