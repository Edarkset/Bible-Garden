// Importa a Bíblia Livre (BLIVRE) do eBible.org para assets/bible/blivre/.
//
// Uso:
//   dart run tool/import_blivre.dart            (baixa o USFM oficial)
//   dart run tool/import_blivre.dart <pasta>    (usa uma pasta com .usfm)
//
// Gera um JSON por livro (GEN.json...) e index.json com nomes, palavras por
// capítulo, crédito e SHA-256 de cada arquivo.
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:bible_garden/core/reading.dart';
import 'package:bible_garden/data/bible/bible_models.dart';
import 'package:bible_garden/data/bible/usfm_parser.dart';
import 'package:crypto/crypto.dart';

const _url = 'https://eBible.org/Scriptures/porbr2018_usfm.zip';
const _credito =
    'Bíblia Livre (BLIVRE), © Diego Santos, Mario Sérgio e Marco Teles, '
    '2018 — Licença Creative Commons Atribuição 4.0 Brasil. Texto via '
    'eBible.org (porbr2018).';

Future<void> main(List<String> args) async {
  final sources = <String, String>{};
  if (args.isNotEmpty) {
    for (final f in Directory(args.first).listSync().whereType<File>()) {
      if (f.path.endsWith('.usfm')) {
        sources[f.uri.pathSegments.last] = f.readAsStringSync();
      }
    }
  } else {
    stdout.writeln('Baixando $_url ...');
    final client = HttpClient();
    try {
      final req = await client.getUrl(Uri.parse(_url));
      final res = await req.close();
      if (res.statusCode != 200) {
        throw HttpException('HTTP ${res.statusCode} em $_url');
      }
      final bytes = await res.fold<List<int>>([], (a, b) => a..addAll(b));
      for (final f in ZipDecoder().decodeBytes(bytes)) {
        if (f.isFile && f.name.endsWith('.usfm')) {
          sources[f.name] = utf8.decode(f.content);
        }
      }
    } finally {
      client.close();
    }
  }
  if (sources.length != 66) {
    stderr.writeln('Esperava 66 livros, encontrei ${sources.length}.');
    exitCode = 1;
    return;
  }

  final out = Directory('assets/bible/blivre')..createSync(recursive: true);
  final entries = <BookIndexEntry>[];
  final hashes = <String, String>{};
  var verses = 0;
  for (final name in sources.keys.toList()..sort()) {
    final book = parseUsfm(sources[name]!);
    final json = jsonEncode(book.toJson());
    File('${out.path}/${book.id}.json').writeAsStringSync(json);
    hashes[book.id] = sha256.convert(utf8.encode(json)).toString();
    entries.add(
      BookIndexEntry(
        id: book.id,
        nome: book.nome,
        abrev: book.abrev,
        palavrasPorCapitulo: [
          for (final c in book.capitulos)
            c.versiculos.fold(0, (a, v) => a + wordsOf(v.texto)),
        ],
      ),
    );
    verses += book.capitulos.fold(0, (a, c) => a + c.versiculos.length);
  }
  const encoder = JsonEncoder.withIndent(' ');
  File('${out.path}/index.json').writeAsStringSync(
    encoder.convert({
      'traducao': 'blivre',
      'credito': _credito,
      'livros': [for (final e in entries) e.toJson()],
      'sha256': hashes,
    }),
  );
  final chapters = entries.fold(0, (a, e) => a + e.capitulos);
  stdout.writeln(
    'OK: ${entries.length} livros, $chapters capítulos, $verses versículos.',
  );
}
