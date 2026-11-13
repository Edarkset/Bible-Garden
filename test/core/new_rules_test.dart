import 'package:bible_garden/core/economy.dart';
import 'package:bible_garden/core/growth.dart';
import 'package:bible_garden/core/prayer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('próximo estágio em livros curtos (correção do core.js)', () {
    test('livro de 1 capítulo anuncia a planta plena, não o broto', () {
      expect(nextStageIn(0, 1), (estagio: Stage.plena, faltam: 1));
    });
    test('o estágio anunciado é o que o capítulo realmente alcança', () {
      for (final caps in [1, 2, 3, 4, 5, 13, 50, 150]) {
        for (var done = 0; done < caps; done++) {
          final n = nextStageIn(done, caps)!;
          expect(stageFor(done + n.faltam, caps), n.estagio);
        }
      }
    });
  });

  group('animais crescem com as porções', () {
    test('filhote, jovem (10) e adulto (30)', () {
      expect(animalAgeFor(0), AnimalAge.filhote);
      expect(animalAgeFor(9), AnimalAge.filhote);
      expect(animalAgeFor(10), AnimalAge.jovem);
      expect(animalAgeFor(29), AnimalAge.jovem);
      expect(animalAgeFor(30), AnimalAge.adulto);
    });
    test('nunca regride', () {
      var prev = 0;
      for (var p = 0; p < 60; p++) {
        expect(animalAgeFor(p).index, greaterThanOrEqualTo(prev));
        prev = animalAgeFor(p).index;
      }
    });
  });

  group('releituras', () {
    test('1ª normal, 2ª florada, 3ª em diante dourada', () {
      expect(variantFor(0), ReadVariant.normal);
      expect(variantFor(1), ReadVariant.normal);
      expect(variantFor(2), ReadVariant.florada);
      expect(variantFor(3), ReadVariant.dourada);
      expect(variantFor(7), ReadVariant.dourada);
    });
  });

  group('quadro do estágio na folha', () {
    test('árvores (8 quadros): estágio = quadro', () {
      for (final s in Stage.values) {
        expect(stageFrame(s, frames: 8), s.index);
      }
    });
    test('plantas menores (6 quadros): plena no último, sem estourar', () {
      expect(stageFrame(Stage.semente, frames: 6), 0);
      expect(stageFrame(Stage.frutifera, frames: 6), 4);
      expect(stageFrame(Stage.florida, frames: 6), 4);
      expect(stageFrame(Stage.plena, frames: 6), 5);
      for (final s in Stage.values) {
        expect(stageFrame(s, frames: 6), inInclusiveRange(0, 5));
      }
    });
  });

  group('loja e preços', () {
    test('personagem custa 400, ou 600 com objeto grande', () {
      expect(characterPrice(largeProp: false), 400);
      expect(characterPrice(largeProp: true), 600);
    });
    test('não compra duas vezes o mesmo item', () {
      const w = Wallet(orvalho: 500, itens: ['banco']);
      expect(buy(w, const ShopItem(id: 'banco', preco: 10)), isA<BuyFail>());
    });
  });

  test('oração: durações oferecidas', () {
    expect(prayerDurations, [2, 5, 10, 15]);
    for (final d in prayerDurations) {
      expect(prayerCounts(d, d * 60000, abandoned: false), isTrue);
      expect(prayerCounts(d, d * 60000 - 2000, abandoned: false), isFalse);
    }
  });
}
