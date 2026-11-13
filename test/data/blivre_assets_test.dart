import 'dart:convert';
import 'dart:io';

import 'package:bible_garden/data/bible/bible_models.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/texto.dart';

void main() {
  final index = TranslationIndex.parse(
    File('assets/bible/blivre/index.json').readAsStringSync(),
  );

  test('66 livros, 1189 capítulos, crédito CC BY 4.0', () {
    expect(index.livros, hasLength(66));
    expect(index.livros.fold(0, (a, b) => a + b.capitulos), 1189);
    expect(index.credito, contains('Creative Commons Atribuição 4.0'));
    expect(index.credito, contains('Diego Santos'));
  });

  test('integridade: cada arquivo bate com o SHA-256 do índice', () {
    for (final b in index.livros) {
      final bytes = File('assets/bible/blivre/${b.id}.json').readAsBytesSync();
      expect(
        sha256.convert(bytes).toString(),
        index.sha256[b.id],
        reason: b.id,
      );
    }
  });

  test('Gênesis 1 e 2 idênticos ao texto validado no protótipo', () {
    final gen = BookText.parse(
      File('assets/bible/blivre/GEN.json').readAsStringSync(),
    );
    expect(gen.capitulos[0].textos, genChapter(1));
    expect(gen.capitulos[1].textos, genChapter(2));
  });

  test('nenhum marcador USFM sobrou no texto', () {
    for (final b in index.livros) {
      final raw = File('assets/bible/blivre/${b.id}.json').readAsStringSync();
      expect(raw, isNot(contains(r'\\')), reason: b.id);
      expect(raw, isNot(contains(r'$1')), reason: b.id);
    }
  });

  test('palavras por capítulo do índice batem com o texto', () {
    final sl = BookText.parse(
      File('assets/bible/blivre/PSA.json').readAsStringSync(),
    );
    final entry = index.livro('PSA')!;
    expect(entry.capitulos, 150);
    expect(sl.capitulos, hasLength(150));
    final w = sl.capitulos[22].versiculos.fold<int>(
      0,
      (a, v) => a + RegExp(r'\S+').allMatches(v.texto).length,
    );
    expect(entry.palavrasPorCapitulo[22], w);
    expect(jsonEncode(sl.capitulos[22].toJson()), contains('pastor'));
  });
}
