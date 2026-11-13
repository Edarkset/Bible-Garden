import 'package:bible_garden/core/economy.dart';
import 'package:bible_garden/core/growth.dart';
import 'package:bible_garden/data/repositories/garden_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fixtures.dart';

void main() {
  late FakeClock clock;
  late GardenRepository repo;

  setUp(() {
    clock = FakeClock(DateTime(2026, 11, 13, 8));
    repo = memoryRepo(clock);
  });
  tearDown(() => repo.db.close());

  Future<ChapterOutcome> read(String book, int ch, {int caps = 50}) =>
      repo.completeChapter(
        book: book,
        chapter: ch,
        chaptersInBook: caps,
        minutes: 4,
        method: 'app',
      );

  test('1º capítulo faz brotar e dá a porção de presença', () async {
    final o = await read('GEN', 1);
    expect(o.stageBefore, Stage.semente);
    expect(o.stageAfter, Stage.broto);
    expect(o.firstTime, isTrue);
    expect(o.orvalhoGanho, 20);
    expect(await repo.balance(), 20);
  });

  test('ler 10 capítulos no mesmo dia não dá mais orvalho', () async {
    for (var c = 1; c <= 10; c++) {
      await read('GEN', c);
    }
    expect(await repo.balance(), 20);
    expect((await repo.readChapters('GEN')).length, 10);
  });

  test('oração e devocional completam a porção até o teto de 40', () async {
    await read('GEN', 1);
    expect(await repo.recordPrayer(minutes: 5, guided: false), 10);
    expect(await repo.recordDevotional(note: 'gratidão'), 10);
    expect(await repo.recordPrayer(minutes: 5, guided: true), 0);
    expect(await repo.balance(), 40);
  });

  test('outro dia, nova porção (dia vazio nunca tira nada)', () async {
    await read('GEN', 1);
    clock.advance(const Duration(days: 3));
    expect(await repo.balance(), 20);
    await read('GEN', 2);
    expect(await repo.balance(), 40);
    expect(await repo.porcoesRecebidas(), 2);
  });

  test(
    'Noé é liberado ao ler Gn 6, 7 e 8 — e só então pode ser comprado',
    () async {
      expect(await repo.buyCharacter('noe'), isA<BuyFail>());
      await read('GEN', 6);
      final o7 = await read('GEN', 7);
      expect(o7.newCharacters, isEmpty);
      final o8 = await read('GEN', 8);
      expect(o8.newCharacters, ['noe']);
      expect(await repo.unlockedCharacters(), {'noe'});

      expect(await repo.buyCharacter('noe'), isA<BuyFail>()); // falta orvalho
      await repo.credit(600, reason: 'teste');
      expect(await repo.buyCharacter('noe'), isA<BuyOk>());
      expect(await repo.buyCharacter('noe'), isA<BuyFail>()); // já tem
    },
  );

  test('comprar nunca altera a leitura', () async {
    await read('GEN', 1);
    await repo.credit(1000, reason: 'teste');
    final before = await repo.readChapters('GEN');
    expect(await repo.buyWithOrvalho('banco', 180), isA<BuyOk>());
    expect(await repo.readChapters('GEN'), before);
    expect(await repo.balance(), 1000 + 20 - 180);
    expect(await repo.buyWithOrvalho('banco', 180), isA<BuyFail>());
  });

  test('a pomba chega quando a oliveira de Gênesis vira árvore', () async {
    final arrivals = <String>[];
    for (var c = 1; c <= 15; c++) {
      arrivals.addAll((await read('GEN', c)).newAnimals);
    }
    expect(arrivals, ['pomba']);
    expect(await repo.animalAge('pomba', 'GEN'), AnimalAge.filhote);
  });

  test('canteiro completo e livro completo dão pedras da coroa', () async {
    final stones = <String>[];
    for (var c = 1; c <= 4; c++) {
      stones.addAll((await read('RUT', c, caps: 4)).newCrownStones);
    }
    expect(stones, ['livro:RUT']);
    expect(await repo.crownStoneCount(), 1);
    for (var c = 1; c <= 11; c++) {
      stones.addAll((await read('GEN', c)).newCrownStones);
    }
    expect(stones, contains('canteiro:GEN:1'));
  });

  test('releitura conta e libera a variante florada', () async {
    for (var c = 1; c <= 4; c++) {
      await read('RUT', c, caps: 4);
    }
    expect(await repo.completions('RUT', 4), 1);
    for (var c = 1; c <= 4; c++) {
      final o = await read('RUT', c, caps: 4);
      expect(o.firstTime, isFalse);
    }
    expect(variantFor(await repo.completions('RUT', 4)), ReadVariant.florada);
  });

  test('companheiro cresce com as porções recebidas', () async {
    await repo.setCompanion('ovelha');
    for (var d = 0; d < 12; d++) {
      await repo.recordPrayer(minutes: 2, guided: false);
      clock.advance(const Duration(days: 1));
    }
    expect(await repo.animalAge('ovelha', 'COMP'), AnimalAge.jovem);
  });

  test('ritmo da semana só marca dias com prática', () async {
    await read('GEN', 1);
    clock.advance(const Duration(days: 2));
    await repo.recordPrayer(minutes: 2, guided: false);
    expect(await repo.activeDays(), hasLength(2));
  });

  test('preferências são salvas', () async {
    await repo.setSetting('leitura.fonte', '20');
    expect(await repo.setting('leitura.fonte'), '20');
    await repo.setSetting('leitura.fonte', '22');
    expect(await repo.setting('leitura.fonte'), '22');
  });
}
