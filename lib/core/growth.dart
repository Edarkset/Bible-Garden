import 'dart:math' as math;

/// Estágios da árvore principal de um livro.
enum Stage {
  semente('Semente'),
  broto('Broto'),
  muda('Muda'),
  arvore('Árvore'),
  frutifera('Árvore frutífera'),
  florida('Árvore florida'),
  plena('Árvore plena');

  new(this.nome);

  final String nome;
}

/// Estágio pelo número de capítulos lidos. O 1º capítulo já faz brotar e só
/// o livro completo chega a "plena".
Stage stageFor(int done, int caps) {
  if (done <= 0) return Stage.semente;
  if (done >= caps) return Stage.plena;
  final f = done / caps;
  if (f < 0.12) return Stage.broto;
  if (f < 0.30) return Stage.muda;
  if (f < 0.55) return Stage.arvore;
  if (f < 0.80) return Stage.frutifera;
  return Stage.florida;
}

/// Progresso contínuo (0 a 6) para animar entre estágios. Nunca regride.
double growthFor(int done, int caps) {
  final s = stageFor(done, caps).index;
  if (s == 0 || s == 6) return s.toDouble();
  final cuts = [0, 1 / caps, 0.12, 0.30, 0.55, 0.80, 1];
  final f = done / caps;
  final a = cuts[s];
  final b = cuts[s + 1];
  return s + math.min(0.99, (f - a) / (b - a));
}

/// Próximo estágio e quantos capítulos faltam para ele.
typedef NextStage = ({Stage estagio, int faltam});

/// Quantos capítulos faltam para o próximo estágio; nulo se já está plena.
///
/// Diferença consciente do core.js: devolve o estágio que será de fato
/// alcançado (em livros curtos pode pular estágios), não sempre o seguinte.
NextStage? nextStageIn(int done, int caps) {
  final s = stageFor(done, caps);
  if (s == Stage.plena) return null;
  for (var n = done + 1; n <= caps; n++) {
    final t = stageFor(n, caps);
    if (t.index > s.index) return (estagio: t, faltam: n - done);
  }
  return null;
}

/// Um canteiro: unidade literária de um livro longo.
final class Section {
  const new(this.nome, this.de, this.ate);

  final String nome;
  final int de;
  final int ate;
}

/// Canteiros dos livros longos.
const Map<String, List<Section>> sections = {
  'GEN': [
    Section('Origens', 1, 11),
    Section('Abraão', 12, 25),
    Section('Isaque e Jacó', 26, 36),
    Section('José', 37, 50),
  ],
  'PSA': [
    Section('Livro I', 1, 41),
    Section('Livro II', 42, 72),
    Section('Livro III', 73, 89),
    Section('Livro IV', 90, 106),
    Section('Livro V', 107, 150),
  ],
};

/// Quais canteiros do livro estão completos.
List<bool> sectionsDone(String book, Set<int> read) => [
  for (final s in sections[book] ?? const <Section>[])
    [for (var c = s.de; c <= s.ate; c++) c].every(read.contains),
];

/// Forma da planta segue o tamanho do livro (minutos a 230 ppm).
enum SizeClass { flor, media, grande }

SizeClass sizeClass(num minutes) => minutes < 15
    ? SizeClass.flor
    : minutes < 60
    ? SizeClass.media
    : SizeClass.grande;

/// Variante visual pelas leituras completas do livro.
enum ReadVariant { normal, florada, dourada }

ReadVariant variantFor(int completions) => completions >= 3
    ? ReadVariant.dourada
    : completions == 2
    ? ReadVariant.florada
    : ReadVariant.normal;

/// Quadro da linha de estágios para um estágio do jogo.
///
/// Árvores (PL-G) têm 8 quadros: 0–6 são os estágios (o 8º, dourada, já
/// está na linha de variantes). Plantas menores (PL-P) têm 6 quadros:
/// frutífera e florida dividem o quadro 4 e plena usa o 5.
int stageFrame(Stage stage, {required int frames}) {
  if (frames >= 7) return stage.index;
  return switch (stage) {
    Stage.semente => 0,
    Stage.broto => 1,
    Stage.muda => 2,
    Stage.arvore => 3,
    Stage.frutifera || Stage.florida => math.min(4, frames - 1),
    Stage.plena => frames - 1,
  };
}
