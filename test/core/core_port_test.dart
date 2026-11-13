// Porte dos 37 testes de docs/referencia/core.test.js, na mesma ordem.
import 'package:bible_garden/core/calendar.dart';
import 'package:bible_garden/core/economy.dart';
import 'package:bible_garden/core/growth.dart';
import 'package:bible_garden/core/prayer.dart';
import 'package:bible_garden/core/reading.dart';
import 'package:bible_garden/core/signature.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/texto.dart';

List<BlockTiming> blocksAt(List<String> verses, num wpm) => [
  for (final b in makeBlocks(verses))
    BlockTiming(words: b.words, visibleMs: b.words / wpm * 60000),
];

double total(List<BlockTiming> bl) => bl.fold(0, (a, b) => a + b.visibleMs);

void main() {
  final gen1 = genChapter(1);

  test('blocos: Gn 1 vira blocos de ~60 palavras sem perder versículos', () {
    final b = makeBlocks(gen1);
    final n = b.fold<int>(0, (a, x) => a + x.verses.length);
    expect(n, 31);
    expect(b.length, inInclusiveRange(9, 14));
  });

  for (final wpm in [120, 230, 300, 400, 480]) {
    test('validação: leitor honesto a $wpm ppm é aprovado', () {
      final bl = blocksAt(gen1, wpm);
      expect(validateChapter(bl, total(bl)).ok, isTrue);
    });
  }

  test('validação: rolagem a 2000 ppm é reprovada', () {
    final bl = blocksAt(gen1, 2000);
    expect(validateChapter(bl, total(bl)).ok, isFalse);
  });

  test('validação: leitura dinâmica a 700 ppm é reprovada pelo tempo', () {
    final bl = blocksAt(gen1, 700);
    expect(validateChapter(bl, total(bl)).ok, isFalse);
  });

  test('validação: celular parado no 1º bloco é reprovado', () {
    final bl = [
      for (final (i, b) in makeBlocks(gen1).indexed)
        BlockTiming(words: b.words, visibleMs: i == 0 ? 600000 : 0),
    ];
    expect(validateChapter(bl, 600000).ok, isFalse);
  });

  test('validação: 1 bloco pulado não reprova quem leu o resto', () {
    final bl = blocksAt(gen1, 230);
    bl[3] = BlockTiming(words: bl[3].words, visibleMs: 100);
    expect(validateChapter(bl, total(bl)).ok, isTrue);
  });

  test('estágio: o 1º capítulo já faz brotar (vitória rápida)', () {
    expect(stageFor(1, 50), Stage.broto);
    expect(stageFor(0, 50), Stage.semente);
  });

  test("estágio: monotônico e só chega a 'plena' ao concluir o livro", () {
    var prev = 0;
    for (var n = 0; n <= 50; n++) {
      final s = stageFor(n, 50).index;
      expect(s, greaterThanOrEqualTo(prev));
      prev = s;
      if (n < 50) expect(s, lessThan(6));
    }
    expect(stageFor(50, 50), Stage.plena);
  });

  test('crescimento contínuo nunca regride', () {
    var p = -1.0;
    for (var n = 0; n <= 50; n++) {
      final g = growthFor(n, 50);
      expect(g, greaterThanOrEqualTo(p), reason: 'n=$n');
      p = g;
    }
  });

  test('canteiros de Gênesis cobrem 1–50 sem lacunas', () {
    final s = sections['GEN']!;
    expect(s.first.de, 1);
    expect(s.last.ate, 50);
    for (var i = 1; i < s.length; i++) {
      expect(s[i].de, s[i - 1].ate + 1);
    }
  });

  test('canteiros dos Salmos seguem os 5 livros do Saltério', () {
    expect(sections['PSA']!.map((s) => s.ate), [41, 72, 89, 106, 150]);
  });

  test("porção: ler 10 capítulos não vale mais que ler 1 (sem 'farmar')", () {
    expect(
      porcaoDoDia(const DayActivity(readMin: 5)),
      porcaoDoDia(const DayActivity(readMin: 120)),
    );
  });

  test('porção: teto diário respeitado', () {
    expect(
      porcaoDoDia(
        const DayActivity(readMin: 60, prayMin: 30, devocional: true),
      ),
      40,
    );
  });

  test('porção: quem não leu mas orou também recebe (graça)', () {
    expect(porcaoDoDia(const DayActivity(prayMin: 3)), greaterThan(0));
  });

  test('porção: dia sem nada dá zero (sem punição, sem negativo)', () {
    expect(porcaoDoDia(const DayActivity()), 0);
  });

  test('oração: desistir não registra; concluir registra', () {
    expect(prayerCounts(5, 300000, abandoned: true), isFalse);
    expect(prayerCounts(5, 300000, abandoned: false), isTrue);
    expect(prayerCounts(5, 120000, abandoned: false), isFalse);
  });

  test('loja: comprar nunca altera progresso de leitura', () {
    // A carteira nem tem campo de leitura: a separação é pelo tipo.
    const w = Wallet(orvalho: 200);
    final r = buy(w, const ShopItem(id: 'banco', preco: 120));
    expect(r, isA<BuyOk>());
    final w2 = (r as BuyOk).wallet;
    expect(w2.orvalho, 80);
    expect(buy(w2, const ShopItem(id: 'fonte', preco: 500)), isA<BuyFail>());
  });

  test('calendário: Páscoa 2026 = 5/abr; 2027 = 28/mar', () {
    expect(isoDay(easter(2026)), '2026-04-05');
    expect(isoDay(easter(2027)), '2027-03-28');
  });

  test('calendário: Advento 2026 começa em 29/nov', () {
    expect(isoDay(adventStart(2026)), '2026-11-29');
  });

  test('calendário: estações de exemplo', () {
    expect(liturgicalSeason(DateTime(2026, 10, 31)).id, SeasonId.comum);
    expect(liturgicalSeason(DateTime(2026, 12)).id, SeasonId.advento);
    expect(liturgicalSeason(DateTime(2026, 12, 25)).id, SeasonId.natal);
    expect(liturgicalSeason(DateTime(2027, 3)).id, SeasonId.quaresma);
    expect(liturgicalSeason(DateTime(2026, 5, 24)).id, SeasonId.pentecostes);
  });

  test("ritmo semanal: 7 posições, nada 'zera'", () {
    final r = weekRhythm(['2026-10-30', '2026-10-31'], DateTime(2026, 10, 31));
    expect(r, hasLength(7));
    expect(r.sublist(5), [true, true]);
  });

  test('assinatura: luz preferida e semente estável', () {
    expect(preferredLight([6, 7, 7, 22]), LightPreference.manha);
    expect(hashSeed('Jardim da Ana'), hashSeed('Jardim da Ana'));
    expect(hashSeed('Jardim da Ana'), isNot(hashSeed('Jardim do Beto')));
  });

  test('tamanho da planta segue o livro', () {
    expect(sizeClass(2), SizeClass.flor);
    expect(sizeClass(30), SizeClass.media);
    expect(sizeClass(153), SizeClass.grande);
  });

  test('v2: ritmo humano aprova; rolagem automática constante reprova', () {
    expect(
      readingSignals(
        const ReadingSignalsInput(still: .7, velCV: .3, inputs: 8, blocks: 12),
      ).ritmo,
      isTrue,
    );
    expect(
      readingSignals(const ReadingSignalsInput(velCV: .02, blocks: 12)).ritmo,
      isFalse,
    );
  });

  test('v2: quem arrasta o dedo devagar passa no ritmo', () {
    expect(
      readingSignals(
        const ReadingSignalsInput(still: .1, velCV: .9, inputs: 30, blocks: 12),
      ).ritmo,
      isTrue,
    );
  });

  test('v2: sem sensor de movimento, toques bastam', () {
    final s = readingSignals(
      const ReadingSignalsInput(still: .6, velCV: .3, inputs: 6, blocks: 12),
    );
    expect(s.presenca, isTrue);
    expect(s.sensor, isFalse);
  });

  test('v2: celular na mão conta como presença mesmo com poucos toques', () {
    expect(
      readingSignals(
        const ReadingSignalsInput(
          still: .6,
          velCV: .3,
          inputs: 1,
          blocks: 12,
          handShare: .8,
        ),
      ).presenca,
      isTrue,
    );
  });

  test('v2: robô sem toques e celular na mesa reprova por presença', () {
    final bl = blocksAt(gen1, 400);
    final r = validateChapterV2(
      bl,
      total(bl),
      const ReadingSignalsInput(still: .8, velCV: .2, handShare: 0),
    );
    expect(r.ok, isFalse);
    expect(r.motivo, RejectReason.presenca);
  });

  test('v2: leitor honesto na mão é aprovado e o motivo fica vazio', () {
    final bl = blocksAt(gen1, 230);
    final r = validateChapterV2(
      bl,
      total(bl),
      const ReadingSignalsInput(still: .7, velCV: .4, inputs: 9, handShare: .9),
    );
    expect(r.ok, isTrue);
    expect(r.motivo, isNull);
  });

  test('antecipação: diz quantos capítulos faltam para o próximo estágio', () {
    expect(nextStageIn(0, 50), (estagio: Stage.broto, faltam: 1));
    expect(nextStageIn(50, 50), isNull);
    final n = nextStageIn(1, 50)!;
    expect(n.estagio, Stage.muda);
    expect(n.faltam, greaterThan(0));
  });

  test('aderência: dias desde a última visita', () {
    expect(diasDesde('2026-10-28', '2026-10-31'), 3);
    expect(diasDesde(null, '2026-10-31'), isNull);
    expect(diasDesde('2026-10-31', '2026-10-31'), 0);
  });

  test('aderência: próxima conquista', () {
    const it = [
      ShopItem(id: 'a', nome: 'A', preco: 80, tem: true),
      ShopItem(id: 'b', nome: 'B', preco: 180),
      ShopItem(id: 'c', nome: 'C', preco: 300),
    ];
    expect(proximaConquista(200, it)!.id, 'b');
    expect(proximaConquista(200, it)!.falta, 0);
    final r = proximaConquista(100, it)!;
    expect(r.id, 'b');
    expect(r.falta, 80);
    expect(r.pct, allOf(greaterThan(0.5), lessThan(0.6)));
    expect(
      proximaConquista(100, const [ShopItem(id: 'x', preco: 10, tem: true)]),
      isNull,
    );
  });

  test('aderência: estimativa de minutos por capítulo (Gn 1 ≈ 3 min)', () {
    final w = gen1.fold<int>(0, (a, v) => a + wordsOf(v));
    expect(minutosCapitulo(w), 3);
    expect(minutosCapitulo(10), 1);
  });
}
