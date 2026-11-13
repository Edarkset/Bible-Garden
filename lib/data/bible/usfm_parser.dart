import 'package:bible_garden/data/bible/bible_models.dart';

/// Converte um arquivo USFM da Bíblia Livre (eBible.org) em [BookText].
///
/// Marcadores tratados: \id \toc2 \toc3 \c \d \p \v, e inline \add (itálico),
/// \f…\f* (notas com \fr \fq \ft) e \rq…\rq* (referência citada). O texto
/// bíblico não é alterado: só os marcadores saem e espaços que sobram antes
/// de pontuação (resto dos marcadores) são removidos.
BookText parseUsfm(String source) {
  String? id;
  String? nome;
  String? abrev;
  final chapters = <Chapter>[];
  var verses = <Verse>[];
  String? titulo;
  var chapterNo = 0;

  void closeChapter() {
    if (chapterNo > 0) {
      chapters.add(
        Chapter(numero: chapterNo, titulo: titulo, versiculos: verses),
      );
    }
    verses = <Verse>[];
    titulo = null;
  }

  for (final raw in source.split('\n')) {
    final line = raw.trimRight();
    if (line.isEmpty) continue;
    final m = RegExp(r'^\\(\w+)\s?(.*)$').firstMatch(line);
    if (m == null) {
      throw FormatException('Linha sem marcador: $line');
    }
    final tag = m.group(1)!;
    final rest = m.group(2)!.trim();
    switch (tag) {
      case 'id':
        id = rest.split(' ').first;
      case 'toc2':
        nome = rest;
      case 'toc3':
        abrev = rest;
      case 'c':
        closeChapter();
        chapterNo = int.parse(rest);
        if (chapterNo != chapters.length + 1) {
          throw FormatException('$id: capítulo $chapterNo fora de ordem');
        }
      case 'd':
        titulo = _plain(rest);
      case 'v':
        final vm = RegExp(r'^(\d+)\s+(.*)$').firstMatch(rest);
        if (vm == null) throw FormatException('$id $chapterNo: $line');
        final n = int.parse(vm.group(1)!);
        if (n != verses.length + 1) {
          throw FormatException('$id $chapterNo:$n fora de ordem');
        }
        verses.add(_verse(n, vm.group(2)!));
      case 'ide' || 'h' || 'toc1' || 'mt1' || 'p':
        break;
      default:
        throw FormatException('Marcador não tratado: \\$tag em $id');
    }
  }
  closeChapter();
  if (id == null || nome == null || abrev == null) {
    throw const FormatException('Cabeçalho do livro incompleto');
  }
  return BookText(id: id, nome: nome, abrev: abrev, capitulos: chapters);
}

String _tidy(String s) => s
    .replaceAll(RegExp(r'\s+'), ' ')
    .replaceAllMapped(RegExp(' ([,.;:!?)])'), (m) => m.group(1)!)
    .trim();

String _plain(String s) => _tidy(s.replaceAll(RegExp(r'\\\w+\*?'), ''));

Verse _verse(int n, String body) {
  // 1. notas de rodapé
  final notas = <VerseNote>[];
  var s = body.replaceAllMapped(RegExp(r'\\f \+(.*?)\\f\*'), (m) {
    final f = m.group(1)!;
    final q = RegExp(r'\\fq (.*?)(?=\\ft|$)').firstMatch(f)?.group(1);
    final t = RegExp(r'\\ft (.*)$').firstMatch(f)?.group(1) ?? '';
    notas.add(VerseNote(trecho: q == null ? null : _tidy(q), texto: _tidy(t)));
    return ' ';
  });
  // 2. referência citada
  String? citacao;
  s = s.replaceAllMapped(RegExp(r'\\rq (.*?)\\rq\*'), (m) {
    citacao = _tidy(m.group(1)!);
    return ' ';
  });
  // 3. palavras acrescentadas (itálico): marca com sentinelas e mede depois
  const open = '\u0001';
  const close = '\u0002';
  s = s.replaceAllMapped(
    RegExp(r'\\add (.*?)\\add\*'),
    (m) => '$open${m.group(1)!.trim()}$close',
  );
  if (s.contains(r'\')) {
    throw FormatException('Marcador inline não tratado no versículo $n: $s');
  }
  s = _tidy(s);
  final italicos = <(int, int)>[];
  final out = StringBuffer();
  var start = -1;
  for (final ch in s.split('')) {
    if (ch == open) {
      start = out.length;
    } else if (ch == close) {
      italicos.add((start, out.length));
    } else {
      out.write(ch);
    }
  }
  return Verse(
    numero: n,
    texto: out.toString(),
    italicos: italicos,
    notas: notas,
    citacao: citacao,
  );
}
