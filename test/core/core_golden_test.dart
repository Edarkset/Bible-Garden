// Valores gerados pelo core.js (node) para conferir o porte número a número.
import 'package:bible_garden/core/calendar.dart';
import 'package:bible_garden/core/growth.dart';
import 'package:bible_garden/core/reading.dart';
import 'package:bible_garden/core/signature.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/texto.dart';

void main() {
  test('hashSeed igual ao JavaScript (inclui acentos e emoji)', () {
    expect(hashSeed('Jardim da Ana'), 2261237217);
    expect(hashSeed('Ação 🌿'), 258462810);
    expect(hashSeed(''), 2166136261);
  });

  test('rng igual ao JavaScript', () {
    final r = rng(hashSeed('Jardim da Ana'));
    const seq = [
      0.36741726752370596,
      0.2705302215181291,
      0.1105923077557236,
      0.4431723724119365,
      0.8229944738559425,
    ];
    for (final v in seq) {
      expect(r(), closeTo(v, 1e-15));
    }
    final r0 = rng(0);
    expect(r0(), closeTo(0.00006295018829405308, 1e-15));
    expect(r0(), closeTo(0.015739798778668046, 1e-15));
  });

  test('blocos de Gn 1 e Gn 2 iguais ao JavaScript', () {
    List<List<int>> shape(List<ReadingBlock> b) => [
      for (final x in b) [x.from, x.verses.length, x.words],
    ];
    expect(shape(makeBlocks(genChapter(1))), [
      [1, 4, 60],
      [5, 3, 60],
      [8, 4, 91],
      [12, 3, 71],
      [15, 4, 81],
      [19, 3, 68],
      [22, 4, 90],
      [26, 2, 60],
      [28, 2, 73],
      [30, 2, 63],
    ]);
    expect(shape(makeBlocks(genChapter(2))), [
      [1, 4, 82],
      [5, 3, 77],
      [8, 3, 74],
      [11, 4, 73],
      [15, 4, 75],
      [19, 2, 69],
      [21, 3, 66],
      [24, 2, 34],
    ]);
  });

  test('crescimento contínuo igual ao JavaScript', () {
    const exp = [1, 1.2, 1.8, 2.4444444444444446, 3.4, 4.2, 5.9];
    final got = [1, 2, 5, 10, 20, 30, 49].map((n) => growthFor(n, 50));
    for (final (g, e) in zip2(got, exp)) {
      expect(g, closeTo(e, 1e-9));
    }
  });

  test('livros curtos: estágios iguais ao JavaScript', () {
    List<int> row(int c) => [for (var n = 0; n <= c; n++) stageFor(n, c).index];
    expect(row(1), [0, 6]);
    expect(row(2), [0, 3, 6]);
    expect(row(3), [0, 3, 4, 6]);
    expect(row(4), [0, 2, 3, 4, 6]);
  });

  test('Páscoa e Advento de vários anos', () {
    expect(
      [
        2024,
        2025,
        2026,
        2027,
        2028,
        2030,
        2038,
        2100,
      ].map((y) => isoDay(easter(y))),
      [
        '2024-03-31',
        '2025-04-20',
        '2026-04-05',
        '2027-03-28',
        '2028-04-16',
        '2030-04-21',
        '2038-04-25',
        '2100-03-28',
      ],
    );
    expect(
      [2024, 2025, 2026, 2027, 2028, 2033].map((y) => isoDay(adventStart(y))),
      [
        '2024-12-01',
        '2025-11-30',
        '2026-11-29',
        '2027-11-28',
        '2028-12-03',
        '2033-11-27',
      ],
    );
  });

  test('bordas das estações iguais ao JavaScript', () {
    const datas = {
      '2026-01-06': SeasonId.natal,
      '2026-01-07': SeasonId.comum,
      '2026-02-17': SeasonId.comum,
      '2026-02-18': SeasonId.quaresma,
      '2026-04-04': SeasonId.quaresma,
      '2026-04-05': SeasonId.pascoa,
      '2026-05-23': SeasonId.pascoa,
      '2026-05-25': SeasonId.comum,
      '2026-11-28': SeasonId.comum,
      '2026-11-29': SeasonId.advento,
      '2026-12-24': SeasonId.advento,
      '2026-12-25': SeasonId.natal,
      '2026-12-31': SeasonId.natal,
    };
    datas.forEach((iso, id) {
      expect(liturgicalSeason(DateTime.parse(iso)).id, id, reason: iso);
    });
  });

  test('luz preferida com empate igual ao JavaScript', () {
    expect(preferredLight([]), isNull);
    expect(preferredLight([1, 2, 13, 14, 15]), LightPreference.tarde);
    expect(preferredLight([20, 21, 6]), LightPreference.noite);
    expect(preferredLight([3, 3, 9, 9]), LightPreference.madrugada);
  });

  test('próximo estágio igual ao JavaScript nos livros longos', () {
    expect(nextStageIn(1, 50), (estagio: Stage.muda, faltam: 5));
    expect(nextStageIn(5, 50), (estagio: Stage.muda, faltam: 1));
    expect(nextStageIn(49, 50), (estagio: Stage.plena, faltam: 1));
    expect(nextStageIn(1, 4), (estagio: Stage.arvore, faltam: 1));
  });
}

/// Percorre dois iteráveis lado a lado.
Iterable<(A, B)> zip2<A, B>(Iterable<A> a, Iterable<B> b) sync* {
  final ia = a.iterator;
  final ib = b.iterator;
  while (ia.moveNext() && ib.moveNext()) {
    yield (ia.current, ib.current);
  }
}
