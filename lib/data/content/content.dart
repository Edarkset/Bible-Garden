import 'dart:convert';

/// Um livro da Bíblia e o seu jardim.
final class BookGarden {
  const new({
    required this.id,
    required this.nome,
    required this.bioma,
    required this.deuterocanonico,
    required this.arvore,
    required this.animal,
    required this.personagem,
    required this.precoPersonagem,
    this.animalRef,
  });

  factory fromJson(Map<String, Object?> j) => BookGarden(
    id: j['id']! as String,
    nome: j['nome']! as String,
    bioma: j['bioma']! as String,
    deuterocanonico: j['deuterocanonico']! as bool,
    arvore: j['arvore']! as String,
    animal: j['animal']! as String,
    animalRef: j['animalRef'] as String?,
    personagem: j['personagem']! as String,
    precoPersonagem: j['preco']! as int,
  );

  /// Código USFM (GEN, EXO...).
  final String id;
  final String nome;
  final String bioma;
  final bool deuterocanonico;

  /// Id da planta principal (árvore ou flor).
  final String arvore;

  /// Id do animal do livro e a referência bíblica dele.
  final String animal;
  final String? animalRef;
  final String personagem;
  final int precoPersonagem;
}

/// Personagem bíblico que mora num jardim.
final class BibleCharacter {
  const new({
    required this.id,
    required this.nome,
    required this.livro,
    required this.libera,
    required this.liberaLivro,
    required this.liberaCapitulos,
    required this.gracinha,
    required this.temObjeto,
    required this.preco,
  });

  factory fromJson(Map<String, Object?> j) => BibleCharacter(
    id: j['id']! as String,
    nome: j['nome']! as String,
    livro: j['livro']! as String,
    libera: j['libera']! as String,
    liberaLivro: j['liberaLivro']! as String,
    liberaCapitulos: (j['liberaCapitulos']! as List<Object?>).cast<int>(),
    gracinha: j['gracinha']! as String,
    temObjeto: j['temObjeto']! as bool,
    preco: j['preco']! as int,
  );

  final String id;
  final String nome;

  /// Jardim onde mora.
  final String livro;

  /// Referência legível ("Gn 6–8").
  final String libera;

  /// Livro e capítulos que precisam ser lidos para liberar.
  final String liberaLivro;
  final List<int> liberaCapitulos;
  final String gracinha;
  final bool temObjeto;
  final int preco;
}

final class AnimalInfo {
  const new({
    required this.id,
    required this.nome,
    required this.modelo,
    required this.origem,
    required this.disponibilidade,
    required this.companheiroInicial,
    required this.cresce,
    required this.livros,
    this.preco,
    this.ref,
  });

  factory fromJson(Map<String, Object?> j) => AnimalInfo(
    id: j['id']! as String,
    nome: j['nome']! as String,
    modelo: j['modelo']! as String,
    origem: j['origem']! as String,
    disponibilidade: j['disponibilidade']! as String,
    companheiroInicial: j['companheiroInicial']! as bool,
    cresce: j['cresce']! as bool,
    livros: (j['livros']! as List<Object?>).cast<String>(),
    preco: j['preco'] as int?,
    ref: j['ref'] as String?,
  );

  final String id;
  final String nome;
  final String modelo;
  final String origem;
  final String disponibilidade;
  final bool companheiroInicial;
  final bool cresce;
  final List<String> livros;

  /// Preço em orvalho; nulo quando chega de outro jeito (livro, cena...).
  final int? preco;
  final String? ref;
}

final class PlantInfo {
  const new({
    required this.id,
    required this.nome,
    required this.forma,
    required this.origem,
    required this.frutifera,
    this.preco,
    this.ref,
  });

  factory fromJson(Map<String, Object?> j) => PlantInfo(
    id: j['id']! as String,
    nome: j['nome']! as String,
    forma: j['forma']! as String,
    origem: j['origem']! as String,
    frutifera: j['frutifera']! as bool,
    preco: j['preco'] as int?,
    ref: j['ref'] as String?,
  );

  final String id;
  final String nome;

  /// arvore, palmeira, arbusto, flor, erva, trepadeira, aquatica.
  final String forma;
  final String origem;
  final bool frutifera;
  final int? preco;
  final String? ref;

  /// Usa a folha grande de árvores (PL-G).
  bool get isTree => forma == 'arvore' || forma == 'palmeira';
}

/// Item simples da loja (decoração ou melhoria).
final class CatalogItem {
  const new({
    required this.id,
    required this.nome,
    required this.preco,
    this.nota,
    this.requer,
  });

  factory fromJson(Map<String, Object?> j) => CatalogItem(
    id: j['id']! as String,
    nome: j['nome']! as String,
    preco: j['preco']! as int,
    nota: j['nota'] as String?,
    requer: j['requer'] as String?,
  );

  final String id;
  final String nome;
  final int preco;
  final String? nota;
  final String? requer;
}

/// Pacote visual ou de animais: compra única e permanente, com dinheiro
/// ou com orvalho.
final class VisualPack {
  const new({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.precoReaisCentavos,
    required this.orvalho,
    required this.desc,
    this.itens = const [],
  });

  factory fromJson(Map<String, Object?> j) => VisualPack(
    id: j['id']! as String,
    nome: j['nome']! as String,
    tipo: j['tipo']! as String,
    precoReaisCentavos: j['precoReais']! as int,
    orvalho: j['orvalho']! as int,
    desc: j['desc']! as String,
    itens: ((j['itens'] as List<Object?>?) ?? const []).cast<String>(),
  );

  final String id;
  final String nome;

  /// ceu, flora, cascata, sazonal, animais.
  final String tipo;

  /// Preço de referência em centavos de real (a loja mostra o preço real).
  final int precoReaisCentavos;
  final int orvalho;
  final String desc;
  final List<String> itens;
}

/// Tudo o que vem de assets/data/conteudo.json.
final class GameContent {
  const new({
    required this.livros,
    required this.personagens,
    required this.animais,
    required this.plantas,
    required this.decoracao,
    required this.melhorias,
    required this.pacotes,
    required this.canone73,
    required this.deuterocanonicos,
  });

  factory parse(String source) {
    final j = jsonDecode(source) as Map<String, Object?>;
    List<T> list<T>(String k, T Function(Map<String, Object?>) f) => [
      for (final e in j[k]! as List<Object?>) f(e! as Map<String, Object?>),
    ];
    return GameContent(
      livros: list('livros', BookGarden.fromJson),
      personagens: list('personagens', BibleCharacter.fromJson),
      animais: list('animais', AnimalInfo.fromJson),
      plantas: list('plantas', PlantInfo.fromJson),
      decoracao: list('decoracao', CatalogItem.fromJson),
      melhorias: list('melhorias', CatalogItem.fromJson),
      pacotes: list('pacotes', VisualPack.fromJson),
      canone73: (j['canone73']! as List<Object?>).cast<String>(),
      deuterocanonicos: (j['deuterocanonicos']! as List<Object?>)
          .cast<String>()
          .toSet(),
    );
  }

  final List<BookGarden> livros;
  final List<BibleCharacter> personagens;
  final List<AnimalInfo> animais;
  final List<PlantInfo> plantas;
  final List<CatalogItem> decoracao;
  final List<CatalogItem> melhorias;
  final List<VisualPack> pacotes;
  final List<String> canone73;
  final Set<String> deuterocanonicos;

  /// Livros do cânon escolhido, na ordem.
  List<BookGarden> livrosDoCanone({required bool catolico}) => [
    for (final id in canone73)
      if (catolico || !deuterocanonicos.contains(id)) livro(id)!,
  ];

  BookGarden? livro(String id) => _find(livros, id, (b) => b.id);
  BibleCharacter? personagem(String id) => _find(personagens, id, (c) => c.id);
  AnimalInfo? animal(String id) => _find(animais, id, (a) => a.id);
  PlantInfo? planta(String id) => _find(plantas, id, (p) => p.id);

  /// Biomas na ordem em que aparecem.
  List<String> get biomas => [
    for (final b in livros.map((b) => b.bioma).toSet()) b,
  ];

  static T? _find<T>(List<T> l, String id, String Function(T) key) {
    for (final e in l) {
      if (key(e) == id) return e;
    }
    return null;
  }
}
