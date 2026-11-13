import 'package:bible_garden/data/bible/usfm_parser.dart';
import 'package:flutter_test/flutter_test.dart';

const _sample = r'''
\id MRK Bíblia Livre
\ide UTF-8
\h Marcos
\toc1 Evangelho de Marcos
\toc2 Marcos
\toc3 Mc
\mt1 Marcos
\c 1
\p
\v 1 Princípio do evangelho.
\v 2 Como está escrito: eu envio o meu mensageiro diante de ti . \rq Malaquias 3:1 \rq*
\v 3 E puseram sobre \add o povo\add* capatazes; \f + \fr 1:3 \fq capatazes \ft lit. chefes \f* e foi assim.
\c 2
\d Salmo de Davi:
\p
\v 1 Ah SENHOR, \add e\add* outra vez.
''';

void main() {
  final book = parseUsfm(_sample);

  test('cabeçalho: código, nome curto e abreviação', () {
    expect(book.id, 'MRK');
    expect(book.nome, 'Marcos');
    expect(book.abrev, 'Mc');
    expect(book.capitulos, hasLength(2));
  });

  test('referência citada sai do texto e fica no campo próprio', () {
    final v = book.capitulos[0].versiculos[1];
    expect(
      v.texto,
      'Como está escrito: eu envio o meu mensageiro diante de ti.',
    );
    expect(v.citacao, 'Malaquias 3:1');
  });

  test(
    'palavras acrescentadas viram faixa de itálico e notas saem do texto',
    () {
      final v = book.capitulos[0].versiculos[2];
      expect(v.texto, 'E puseram sobre o povo capatazes; e foi assim.');
      final (a, b) = v.italicos.single;
      expect(v.texto.substring(a, b), 'o povo');
      expect(v.notas.single.trecho, 'capatazes');
      expect(v.notas.single.texto, 'lit. chefes');
    },
  );

  test('título de salmo fica no capítulo', () {
    expect(book.capitulos[1].titulo, 'Salmo de Davi:');
    final v = book.capitulos[1].versiculos[0];
    expect(v.texto, 'Ah SENHOR, e outra vez.');
    expect(v.texto.substring(v.italicos[0].$1, v.italicos[0].$2), 'e');
  });

  test('marcador desconhecido falha em vez de vazar no texto', () {
    expect(
      () => parseUsfm('${_sample.trim()}\n\\zz algo'),
      throwsFormatException,
    );
  });

  test('versículo fora de ordem falha', () {
    expect(
      () => parseUsfm(_sample.replaceFirst(r'\v 3', r'\v 5')),
      throwsFormatException,
    );
  });
}
