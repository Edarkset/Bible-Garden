import 'dart:convert';

/// Situação de licença de uma tradução.
enum LicenseStatus {
  /// Texto liberado e embarcado no app.
  liberada,

  /// Licença aberta, ainda não importada.
  abertaPendente,

  /// Precisa de contrato: aparece só como preferência salva.
  licencaNecessaria,
}

/// Uma tradução da Bíblia.
final class Translation {
  const new({
    required this.id,
    required this.sigla,
    required this.nome,
    required this.status,
    this.credito,
    this.editora,
    this.temDeuterocanonicos = false,
  });

  final String id;
  final String sigla;
  final String nome;
  final LicenseStatus status;

  /// Crédito obrigatório, mostrado sempre junto do texto.
  final String? credito;
  final String? editora;
  final bool temDeuterocanonicos;

  bool get disponivel => status == LicenseStatus.liberada;
}

/// Nota de rodapé de um versículo.
final class VerseNote {
  const new({required this.texto, this.trecho});

  factory fromJson(Map<String, Object?> j) =>
      VerseNote(trecho: j['q'] as String?, texto: j['t']! as String);

  /// Trecho do versículo a que a nota se refere.
  final String? trecho;
  final String texto;

  Map<String, Object?> toJson() => {
    if (trecho != null) 'q': trecho,
    't': texto,
  };
}

/// Um versículo. [italicos] marca as palavras acrescentadas pelos tradutores
/// (no original ficam em itálico), como pares [início, fim) em [texto].
final class Verse {
  const new({
    required this.numero,
    required this.texto,
    this.italicos = const [],
    this.notas = const [],
    this.citacao,
  });

  factory fromJson(int numero, Map<String, Object?> j) => Verse(
    numero: numero,
    texto: j['t']! as String,
    italicos: [
      for (final r in (j['i'] as List<Object?>?) ?? const [])
        ((r! as List<Object?>)[0]! as int, (r as List<Object?>)[1]! as int),
    ],
    notas: [
      for (final n in (j['n'] as List<Object?>?) ?? const [])
        VerseNote.fromJson(n! as Map<String, Object?>),
    ],
    citacao: j['r'] as String?,
  );

  final int numero;
  final String texto;
  final List<(int, int)> italicos;
  final List<VerseNote> notas;

  /// Referência do texto citado (ex.: "Malaquias 3:1").
  final String? citacao;

  Map<String, Object?> toJson() => {
    't': texto,
    if (italicos.isNotEmpty)
      'i': [
        for (final (a, b) in italicos) [a, b],
      ],
    if (notas.isNotEmpty) 'n': [for (final n in notas) n.toJson()],
    if (citacao != null) 'r': citacao,
  };
}

/// Um capítulo.
final class Chapter {
  const new({required this.numero, required this.versiculos, this.titulo});

  factory fromJson(int numero, Map<String, Object?> j) {
    final vs = j['v']! as List<Object?>;
    return Chapter(
      numero: numero,
      titulo: j['d'] as String?,
      versiculos: [
        for (var i = 0; i < vs.length; i++)
          Verse.fromJson(i + 1, vs[i]! as Map<String, Object?>),
      ],
    );
  }

  final int numero;

  /// Título do salmo (ex.: "Salmo de Davi..."), quando houver.
  final String? titulo;
  final List<Verse> versiculos;

  List<String> get textos => [for (final v in versiculos) v.texto];

  Map<String, Object?> toJson() => {
    if (titulo != null) 'd': titulo,
    'v': [for (final v in versiculos) v.toJson()],
  };
}

/// Um livro com todos os capítulos.
final class BookText {
  const new({
    required this.id,
    required this.nome,
    required this.abrev,
    required this.capitulos,
  });

  factory fromJson(Map<String, Object?> j) {
    final cs = j['c']! as List<Object?>;
    return BookText(
      id: j['id']! as String,
      nome: j['nome']! as String,
      abrev: j['abrev']! as String,
      capitulos: [
        for (var i = 0; i < cs.length; i++)
          Chapter.fromJson(i + 1, cs[i]! as Map<String, Object?>),
      ],
    );
  }

  factory parse(String source) =>
      BookText.fromJson(jsonDecode(source) as Map<String, Object?>);

  final String id;
  final String nome;
  final String abrev;
  final List<Chapter> capitulos;

  Map<String, Object?> toJson() => {
    'id': id,
    'nome': nome,
    'abrev': abrev,
    'c': [for (final c in capitulos) c.toJson()],
  };
}

/// Resumo de um livro no índice da tradução (sem o texto).
final class BookIndexEntry {
  const new({
    required this.id,
    required this.nome,
    required this.abrev,
    required this.palavrasPorCapitulo,
  });

  factory fromJson(Map<String, Object?> j) => BookIndexEntry(
    id: j['id']! as String,
    nome: j['nome']! as String,
    abrev: j['abrev']! as String,
    palavrasPorCapitulo: (j['w']! as List<Object?>).cast<int>(),
  );

  final String id;
  final String nome;
  final String abrev;

  /// Palavras de cada capítulo (para estimar minutos sem abrir o texto).
  final List<int> palavrasPorCapitulo;

  int get capitulos => palavrasPorCapitulo.length;
  int get palavras => palavrasPorCapitulo.fold(0, (a, b) => a + b);

  Map<String, Object?> toJson() => {
    'id': id,
    'nome': nome,
    'abrev': abrev,
    'w': palavrasPorCapitulo,
  };
}

/// Índice de uma tradução embarcada.
final class TranslationIndex {
  const new({
    required this.translationId,
    required this.credito,
    required this.livros,
    required this.sha256,
  });

  factory parse(String source) {
    final j = jsonDecode(source) as Map<String, Object?>;
    return TranslationIndex(
      translationId: j['traducao']! as String,
      credito: j['credito']! as String,
      livros: [
        for (final b in j['livros']! as List<Object?>)
          BookIndexEntry.fromJson(b! as Map<String, Object?>),
      ],
      sha256: (j['sha256']! as Map<String, Object?>).cast<String, String>(),
    );
  }

  final String translationId;
  final String credito;
  final List<BookIndexEntry> livros;

  /// SHA-256 de cada arquivo de livro, para conferir integridade.
  final Map<String, String> sha256;

  BookIndexEntry? livro(String id) {
    for (final b in livros) {
      if (b.id == id) return b;
    }
    return null;
  }
}
