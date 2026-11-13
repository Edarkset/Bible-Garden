// Tabelas de dados copiadas do protótipo ficam numa linha por item.
// ignore_for_file: lines_longer_than_80_chars
// Gera assets/data/conteudo.json a partir de docs/arte/03-anexo-de-dados.md.
//
// Uso: dart run tool/gerar_conteudo.dart
//
// Nada é digitado à mão: livros, personagens, animais e plantas vêm do
// anexo. Os preços seguem as regras registradas em docs/DECISOES.md. O
// script falha se uma referência não fechar (árvore, animal ou capítulo
// que não existe).
import 'dart:convert';
import 'dart:io';

/// Abreviações usadas no anexo → código USFM.
const abrevs = {
  'Gn': 'GEN',
  'Êx': 'EXO',
  'Lv': 'LEV',
  'Nm': 'NUM',
  'Dt': 'DEU',
  'Js': 'JOS',
  'Jz': 'JDG',
  'Rt': 'RUT',
  '1 Sm': '1SA',
  '2 Sm': '2SA',
  '1 Rs': '1KI',
  '2 Rs': '2KI',
  '1 Cr': '1CH',
  '2 Cr': '2CH',
  'Ed': 'EZR',
  'Ne': 'NEH',
  'Et': 'EST',
  'Jó': 'JOB',
  'Sl': 'PSA',
  'Pv': 'PRO',
  'Ec': 'ECC',
  'Ct': 'SNG',
  'Is': 'ISA',
  'Jr': 'JER',
  'Lm': 'LAM',
  'Ez': 'EZK',
  'Dn': 'DAN',
  'Os': 'HOS',
  'Jl': 'JOL',
  'Am': 'AMO',
  'Ob': 'OBA',
  'Jn': 'JON',
  'Mq': 'MIC',
  'Na': 'NAM',
  'Hc': 'HAB',
  'Sf': 'ZEP',
  'Ag': 'HAG',
  'Zc': 'ZEC',
  'Ml': 'MAL',
  'Mt': 'MAT',
  'Mc': 'MRK',
  'Lc': 'LUK',
  'Jo': 'JHN',
  'At': 'ACT',
  'Rm': 'ROM',
  '1 Co': '1CO',
  '2 Co': '2CO',
  'Gl': 'GAL',
  'Ef': 'EPH',
  'Fp': 'PHP',
  'Cl': 'COL',
  '1 Ts': '1TH',
  '2 Ts': '2TH',
  '1 Tm': '1TI',
  '2 Tm': '2TI',
  'Tt': 'TIT',
  'Fm': 'PHM',
  'Hb': 'HEB',
  'Tg': 'JAS',
  '1 Pe': '1PE',
  '2 Pe': '2PE',
  '1 Jo': '1JN',
  '2 Jo': '2JN',
  '3 Jo': '3JN',
  'Jd': 'JUD',
  'Ap': 'REV',
  'Tb': 'TOB',
  'Jt': 'JDT',
  '1 Mc': '1MA',
  '2 Mc': '2MA',
  'Sb': 'WIS',
  'Eclo': 'SIR',
  'Br': 'BAR',
};

/// Ordem do cânon de 73 livros (os 7 deuterocanônicos nos seus lugares).
const canon73 = [
  'GEN',
  'EXO',
  'LEV',
  'NUM',
  'DEU',
  'JOS',
  'JDG',
  'RUT',
  '1SA',
  '2SA',
  '1KI',
  '2KI',
  '1CH',
  '2CH',
  'EZR',
  'NEH',
  'TOB',
  'JDT',
  'EST',
  '1MA',
  '2MA',
  'JOB',
  'PSA',
  'PRO',
  'ECC',
  'SNG',
  'WIS',
  'SIR',
  'ISA',
  'JER',
  'LAM',
  'BAR',
  'EZK',
  'DAN',
  'HOS',
  'JOL',
  'AMO',
  'OBA',
  'JON',
  'MIC',
  'NAM',
  'HAB',
  'ZEP',
  'HAG',
  'ZEC',
  'MAL',
  'MAT',
  'MRK',
  'LUK',
  'JHN',
  'ACT',
  'ROM',
  '1CO',
  '2CO',
  'GAL',
  'EPH',
  'PHP',
  'COL',
  '1TH',
  '2TH',
  '1TI',
  '2TI',
  'TIT',
  'PHM',
  'HEB',
  'JAS',
  '1PE',
  '2PE',
  '1JN',
  '2JN',
  '3JN',
  'JUD',
  'REV',
];

const deutero = {'TOB', 'JDT', '1MA', '2MA', 'WIS', 'SIR', 'BAR'};

/// Preço em orvalho dos animais liberados na loja, pelo modelo de folha
/// (faixa da especificação: 80 a 450).
const animalPrice = {'A-I': 80, 'A-A': 150, 'A-V': 200, 'A-T': 250, 'A-G': 450};

/// Plantas extras: preço pela forma.
const plantPrice = {
  'erva': 60,
  'flor': 80,
  'aquatica': 120,
  'trepadeira': 150,
  'arbusto': 150,
  'palmeira': 300,
  'arvore': 350,
};

/// Pacotes visuais pagos também podem ser liberados com orvalho
/// (princípio 3: tudo pode ser conseguido de graça).
const packOrvalho = 1500;

late final List<String> lines;

void fail(String msg) {
  stderr.writeln('ERRO: $msg');
  exit(1);
}

String norm(String s) => s.toLowerCase().trim();

void main() {
  lines = File('docs/arte/03-anexo-de-dados.md').readAsLinesSync();
  final bibleIndex = jsonDecode(
    File('assets/bible/blivre/index.json').readAsStringSync(),
  ) as Map<String, Object?>;
  final chaptersPerBook = {
    for (final b in bibleIndex['livros']! as List<Object?>)
      (b! as Map)['id'] as String: ((b as Map)['w'] as List).length,
  };
  final namesFromBible = {
    for (final b in bibleIndex['livros']! as List<Object?>)
      (b! as Map)['id'] as String: (b as Map)['nome'] as String,
  };

  final characters = parseCharacters();
  final animals = parseAnimals();
  final plants = parsePlants();
  final books = parseBooks(characters, animals, plants, namesFromBible);

  // Liberação de personagem: capítulos da 1ª referência.
  for (final c in characters) {
    var ref = parseRef(c['libera']! as String);
    final book = ref.$1;
    // Livros de um capítulo só: "Jd 14" é o versículo 14 do capítulo 1.
    if (chaptersPerBook[book] == 1) ref = (book, [1]);
    if (!deutero.contains(book)) {
      final max = chaptersPerBook[book];
      if (max == null) fail('${c['id']}: livro $book desconhecido');
      for (final ch in ref.$2) {
        if (ch < 1 || ch > max!) fail('${c['id']}: $book $ch não existe');
      }
    }
    c['liberaLivro'] = book;
    c['liberaCapitulos'] = ref.$2;
  }

  final out = {
    'versao': 1,
    'fonte': 'docs/arte/03-anexo-de-dados.md',
    'canone73': canon73,
    'deuterocanonicos': deutero.toList(),
    'livros': books,
    'personagens': characters,
    'animais': animals,
    'plantas': plants,
    'decoracao': decoracao,
    'melhorias': melhorias,
    'pacotes': [...pacotes, ...animalPacks(animals)],
  };
  File('assets/data/conteudo.json')
      .writeAsStringSync(const JsonEncoder.withIndent(' ').convert(out));
  stdout.writeln(
    'OK: ${books.length} livros, ${characters.length} personagens, '
    '${animals.length} animais, ${plants.length} plantas.',
  );
}

String slug(String s) {
  const from = 'áàâãéêíóôõúüç';
  const to = 'aaaaeeiooouuc';
  final b = StringBuffer();
  for (final ch in s.toLowerCase().split('')) {
    final i = from.indexOf(ch);
    b.write(i >= 0 ? to[i] : (ch == ' ' ? '-' : ch));
  }
  return b.toString();
}

/// Animais marcados "pacote X" no anexo formam pacotes de animais.
List<Map<String, Object?>> animalPacks(List<Map<String, Object?>> animals) {
  final packs = <String, List<String>>{};
  for (final a in animals) {
    final d = a['disponibilidade']! as String;
    if (d.startsWith('pacote ')) {
      packs.putIfAbsent(d.substring(7), () => []).add(a['id']! as String);
    }
  }
  return [
    for (final e in packs.entries)
      {
        'id': 'animais-${slug(e.key)}',
        'nome': 'Pacote ${e.key}',
        'tipo': 'animais',
        'precoReais': 990,
        'orvalho': packOrvalho,
        'itens': e.value,
        'desc': 'Animais que chegam juntos ao seu jardim.',
      },
  ];
}

/// "Gn 6–8" → (GEN, [6, 7, 8]); "Lm 3:22-23" → (LAM, [3]).
(String, List<int>) parseRef(String ref) {
  final first = ref.split('·').first.trim();
  final m = RegExp(r'^((?:\d )?\S+) (\d+)(?::[\d\-–]+)?(?:[–-](\d+))?')
      .firstMatch(first);
  if (m == null) fail('referência ilegível: $ref');
  final book = abrevs[m!.group(1)!];
  if (book == null) fail('abreviação desconhecida: ${m.group(1)} em $ref');
  final a = int.parse(m.group(2)!);
  final b = m.group(3) == null ? a : int.parse(m.group(3)!);
  return (book!, [for (var c = a; c <= b; c++) c]);
}

/// Blocos "### Título `id` · a · b" e seus campos "- **Campo:** valor".
List<(String, String, List<String>, Map<String, String>)> sections(
  String from,
  String? to,
) {
  final start = lines.indexOf(from);
  final end = to == null ? lines.length : lines.indexOf(to);
  if (start < 0 || end < 0) fail('seção não encontrada: $from');
  final out = <(String, String, List<String>, Map<String, String>)>[];
  for (var i = start; i < end; i++) {
    final h = RegExp(r'^### (.+?) `([^`]+)`(.*)$').firstMatch(lines[i]);
    if (h == null) continue;
    final tags = [for (final t in h.group(3)!.split('·').skip(1)) t.trim()];
    final fields = <String, String>{};
    for (var j = i + 1; j < end && lines[j].startsWith('- **'); j++) {
      final f = RegExp(r'^- \*\*(.+?):\*\* ?(.*)$').firstMatch(lines[j]);
      if (f != null) fields[f.group(1)!] = f.group(2)!.trim();
    }
    out.add((h.group(1)!.trim(), h.group(2)!, tags, fields));
  }
  return out;
}

List<Map<String, Object?>> parseCharacters() => [
  for (final (nome, id, tags, f) in sections(
    '## Personagens bíblicos',
    '## Animais',
  ))
    {
      'id': id,
      'nome': nome,
      'livro': tags[0],
      'libera': tags.sublist(1).join(' · ').replaceFirst('libera ao ler ', ''),
      'gracinha': (f['Gracinha'] ?? '').split(' · *(').first.trim(),
      'temObjeto': (f['Objeto'] ?? '').isNotEmpty,
    },
];

List<Map<String, Object?>> parseAnimals() => [
  for (final (nome, id, tags, f) in sections('## Animais', '## Plantas'))
    () {
      final modelo = tags[0].replaceFirst('modelo ', '');
      final disp = tags.length > 2 ? tags[2] : '';
      final livrosRef = f['Livros'] ?? '';
      final parts = livrosRef.split(' · ref.: ');
      final livros = parts[0] == '—'
          ? <String>[]
          : [for (final b in parts[0].split(',')) b.trim()];
      final buyable =
          disp.startsWith('liberado com orvalho') ||
          disp.startsWith('extra brasileiro');
      return {
        'id': id,
        'nome': nome,
        'modelo': modelo,
        'origem': tags[1],
        'disponibilidade': disp,
        'companheiroInicial': disp.contains('inicial'),
        'preco': buyable ? animalPrice[modelo] : null,
        'cresce': (f['Formas/estágios'] ?? '').contains('filhote'),
        'livros': livros,
        'ref': parts.length > 1 ? parts[1] : null,
      };
    }(),
];

List<Map<String, Object?>> parsePlants() => [
  for (final (nome, id, tags, f) in sections('## Plantas', null))
    () {
      final forma = tags[0];
      final extra = tags.length > 2 ? tags.sublist(2).join(' · ') : '';
      return {
        'id': id,
        'nome': nome,
        'forma': forma,
        'origem': tags[1],
        'frutifera': extra.contains('frutífera'),
        'preco': plantPrice[forma],
        'ref': f['Referência'],
      };
    }(),
];

List<Map<String, Object?>> parseBooks(
  List<Map<String, Object?>> characters,
  List<Map<String, Object?>> animals,
  List<Map<String, Object?>> plants,
  Map<String, String> bibleNames,
) {
  final start = lines.indexOf('## Jardins dos livros');
  final rows = <List<String>>[];
  for (var i = start; i < lines.length && i < start + 90; i++) {
    final l = lines[i];
    if (!l.startsWith('| ') ||
        l.startsWith('| Livro') ||
        l.startsWith('| ---')) {
      continue;
    }
    rows.add([for (final c in l.split('|').skip(1)) c.trim()]..removeLast());
  }
  final byName = {for (final e in bibleNames.entries) norm(e.value): e.key};
  const extraNames = {
    'cantares': 'SNG',
    'tobias': 'TOB',
    'judite': 'JDT',
    '1 macabeus': '1MA',
    '2 macabeus': '2MA',
    'sabedoria': 'WIS',
    'eclesiástico': 'SIR',
    'baruc': 'BAR',
  };
  final out = <Map<String, Object?>>[];
  for (final r in rows) {
    final nome = r[0].replaceAll(' (deuterocanônico)', '');
    final id = byName[norm(nome)] ?? extraNames[norm(nome)];
    if (id == null) fail('livro sem código: $nome');
    final tree = plants.where((p) => norm(p['nome']! as String) == norm(r[2]));
    if (tree.isEmpty) fail('$nome: árvore "${r[2]}" não está nas plantas');
    // Nome mais longo de animal que começa a célula (há parênteses
    // aninhados, ex.: "Peixe-de-são-pedro (tilápia) (Ez 47:9-10)").
    final cell = norm(r[3]);
    final animal =
        animals
            .where((a) => cell.startsWith(norm(a['nome']! as String)))
            .toList()
          ..sort(
            (a, b) => (b['nome']! as String).length.compareTo(
              (a['nome']! as String).length,
            ),
          );
    if (animal.isEmpty) fail('$nome: animal de "${r[3]}" não está nos animais');
    final ch = characters.where((c) => c['livro'] == id);
    if (ch.length != 1) fail('$nome: personagem não encontrado');
    final rest = r[3]
        .substring((animal.first['nome']! as String).length)
        .trim();
    final animalRef = rest.startsWith('(') && rest.endsWith(')')
        ? rest.substring(1, rest.length - 1)
        : null;
    out.add({
      'id': id,
      'nome': nome,
      'bioma': r[1],
      'deuterocanonico': deutero.contains(id),
      'arvore': tree.first['id'],
      'animal': animal.first['id'],
      'animalRef': animalRef,
      'personagem': ch.first['id'],
      'preco': int.parse(r[7]),
    });
    ch.first['preco'] = int.parse(r[7]);
  }
  out.sort(
    (a, b) => canon73
        .indexOf(a['id']! as String)
        .compareTo(canon73.indexOf(b['id']! as String)),
  );
  if (out.length != 73) fail('esperava 73 livros, achei ${out.length}');
  return out;
}

// Decoração, melhorias e pacotes: valores do protótipo validado.
const List<Map<String, Object>> decoracao = [
  {'id': 'flores', 'nome': 'Canteiro de flores', 'preco': 60},
  {'id': 'cogumelos', 'nome': 'Cogumelos', 'preco': 60},
  {'id': 'rocha', 'nome': 'Pedra com musgo', 'preco': 70},
  {'id': 'arbusto', 'nome': 'Arbusto', 'preco': 90},
  {'id': 'banco', 'nome': 'Banco de madeira', 'preco': 180},
  {
    'id': 'lanterna',
    'nome': 'Lanterna',
    'preco': 220,
    'nota': 'Acende à noite',
  },
  {'id': 'colmeia', 'nome': 'Colmeia', 'preco': 260, 'nota': 'Sl 19:10'},
  {'id': 'poco', 'nome': 'Poço', 'preco': 420, 'nota': 'Gn 24'},
  {'id': 'fonte', 'nome': 'Fonte de pedra', 'preco': 600},
];

const List<Map<String, Object>> melhorias = [
  {'id': 'caminho', 'nome': 'Caminho de pedras até a árvore', 'preco': 120},
  {'id': 'lago', 'nome': 'Laguinho', 'preco': 400},
  {
    'id': 'ponte',
    'nome': 'Ponte sobre o rio',
    'preco': 250,
    'requer': 'nascente',
  },
  {'id': 'cerca', 'nome': 'Cerca de madeira', 'preco': 300},
  {'id': 'mureta', 'nome': 'Mureta de pedra', 'preco': 900, 'requer': 'cerca'},
];

const List<Map<String, Object>> pacotes = [
  {
    'id': 'noite-estrelada',
    'nome': 'Noite Estrelada',
    'tipo': 'ceu',
    'precoReais': 990,
    'orvalho': packOrvalho,
    'desc': 'Aurora suave, estrela cadente e vaga-lumes azulados, do entardecer ao amanhecer.',
  },
  {
    'id': 'cerrado',
    'nome': 'Cerrado em Flor',
    'tipo': 'flora',
    'precoReais': 990,
    'orvalho': packOrvalho,
    'desc': 'Capim dourado, flores roxas e borda de cerâmica.',
  },
  {
    'id': 'cascata',
    'nome': 'Cascata Cristalina',
    'tipo': 'cascata',
    'precoReais': 790,
    'orvalho': packOrvalho,
    'desc': 'Uma cascata cai da beira do jardim, com arco-íris na névoa durante o dia.',
  },
  {
    'id': 'natal',
    'nome': 'Natal em Casa',
    'tipo': 'sazonal',
    'precoReais': 490,
    'orvalho': packOrvalho,
    'desc': 'Luzinhas na borda do jardim e uma estrela no topo da árvore. Volta todo ano.',
  },
];
