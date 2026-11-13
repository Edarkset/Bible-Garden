import 'dart:io';

import 'package:bible_garden/core/unlocks.dart';
import 'package:bible_garden/data/bible/bible_models.dart';
import 'package:bible_garden/data/content/content.dart';
import 'package:bible_garden/data/sprites/sprite_manifest.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final c = GameContent.parse(
    File('assets/data/conteudo.json').readAsStringSync(),
  );
  final manifest = SpriteManifest.parse(
    File('assets/data/sprites_manifest.json').readAsStringSync(),
  );
  final bible = TranslationIndex.parse(
    File('assets/bible/blivre/index.json').readAsStringSync(),
  );

  test('cânon: 66 protestante, 73 católico, na ordem da Bíblia', () {
    final p = c.livrosDoCanone(catolico: false);
    final k = c.livrosDoCanone(catolico: true);
    expect(p, hasLength(66));
    expect(k, hasLength(73));
    expect(p.first.id, 'GEN');
    expect(p.last.id, 'REV');
    expect([for (final b in p) b.id], [for (final b in bible.livros) b.id]);
    expect(k.where((b) => b.deuterocanonico), hasLength(7));
  });

  test('todo livro tem árvore, animal e personagem que existem', () {
    for (final b in c.livros) {
      expect(c.planta(b.arvore), isNotNull, reason: b.id);
      expect(c.animal(b.animal), isNotNull, reason: b.id);
      final p = c.personagem(b.personagem)!;
      expect(p.livro, b.id);
      expect(p.preco, anyOf(400, 600));
    }
  });

  test('personagem com objeto grande custa 600 (regra) ou 400', () {
    for (final p in c.personagens) {
      expect([400, 600], contains(p.preco), reason: p.id);
    }
  });

  test('capítulo que libera o personagem existe na Bíblia Livre', () {
    for (final p in c.personagens) {
      final book = bible.livro(p.liberaLivro);
      if (book == null) {
        expect(c.deuterocanonicos, contains(p.liberaLivro), reason: p.id);
        continue;
      }
      for (final ch in p.liberaCapitulos) {
        expect(ch, inInclusiveRange(1, book.capitulos), reason: p.id);
      }
    }
  });

  test('Noé é liberado só depois de ler Gênesis 6, 7 e 8', () {
    final noe = c.personagem('noe')!;
    expect(noe.liberaCapitulos, [6, 7, 8]);
    bool ok(Set<int> r) =>
        characterUnlocked(readInBook: r, requiredChapters: noe.liberaCapitulos);
    expect(ok({1, 2, 3, 6, 7}), isFalse);
    expect(ok({6, 7, 8}), isTrue);
  });

  test('todo animal, planta e personagem tem folha no manifesto', () {
    bool has(String group, String id) =>
        manifest.sheets.any((s) => s.group == group && s.id == id);
    for (final a in c.animais) {
      expect(has('Animais', a.id), isTrue, reason: a.id);
    }
    for (final p in c.plantas) {
      expect(has('Plantas', p.id), isTrue, reason: p.id);
    }
    for (final p in c.personagens) {
      expect(has('Personagens bíblicos', p.id), isTrue, reason: p.id);
    }
  });

  test('preços dentro das faixas da especificação', () {
    for (final a in c.animais.where((a) => a.preco != null)) {
      expect(a.preco, inInclusiveRange(80, 450), reason: a.id);
    }
    for (final d in c.decoracao) {
      expect(d.preco, inInclusiveRange(60, 600), reason: d.id);
    }
    for (final m in c.melhorias) {
      expect(m.preco, inInclusiveRange(120, 900), reason: m.id);
    }
  });

  test('pacotes pagos também saem com orvalho (tudo pode ser grátis)', () {
    expect(c.pacotes, isNotEmpty);
    for (final p in c.pacotes) {
      expect(p.orvalho, greaterThan(0), reason: p.id);
      expect(p.precoReaisCentavos, greaterThan(0), reason: p.id);
    }
  });

  test('companheiros iniciais: ovelha, capivara e beija-flor', () {
    expect([
      for (final a in c.animais.where((a) => a.companheiroInicial)) a.id,
    ], unorderedEquals(['ovelha', 'capivara', 'beija-flor']));
  });

  test('38 frutíferas, como no pedido de sprites', () {
    expect(c.plantas.where((p) => p.frutifera), hasLength(38));
  });

  test('pedras da coroa por tamanho do livro', () {
    expect(crownStonesForBook(1), 1);
    expect(crownStonesForBook(13), 2);
    expect(crownStonesForBook(50), 3);
  });
}
