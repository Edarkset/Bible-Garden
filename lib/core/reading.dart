import 'dart:math' as math;

import 'package:bible_garden/core/rules.dart';

/// Conta palavras como `wordsOf` do core.js (sequências sem espaço).
int wordsOf(String s) => RegExp(r'\S+').allMatches(s.trim()).length;

/// Um versículo dentro de um bloco de leitura.
final class BlockVerse {
  const new(this.n, this.text);

  /// Número do versículo (1 = primeiro da lista recebida).
  final int n;
  final String text;
}

/// Um bloco de cerca de 60 palavras, sem quebrar versículo.
final class ReadingBlock {
  new(this.from);

  /// Número do primeiro versículo previsto para o bloco.
  final int from;
  final List<BlockVerse> verses = [];
  int words = 0;
}

/// Agrupa versículos em blocos de ~[target] palavras sem quebrar versículo.
/// Um resto pequeno (menos de 1/3 do alvo) é juntado ao último bloco.
List<ReadingBlock> makeBlocks(
  List<String> verses, {
  int target = Rules.blockTargetWords,
}) {
  final blocks = <ReadingBlock>[];
  var cur = ReadingBlock(1);
  for (var i = 0; i < verses.length; i++) {
    cur.verses.add(BlockVerse(i + 1, verses[i]));
    cur.words += wordsOf(verses[i]);
    if (cur.words >= target) {
      blocks.add(cur);
      cur = ReadingBlock(i + 2);
    }
  }
  if (cur.verses.isNotEmpty) {
    if (cur.words < target / 3 && blocks.isNotEmpty) {
      blocks.last.verses.addAll(cur.verses);
      blocks.last.words += cur.words;
    } else {
      blocks.add(cur);
    }
  }
  return blocks;
}

/// Tempo mínimo que um bloco precisa ficar visível.
double minBlockMs(int words) => words / Rules.blockMaxWpm * 60000;

/// Tempo ativo mínimo do capítulo inteiro.
double minChapterMs(int words) => words / Rules.chapterMaxWpm * 60000;

/// Tempo que um bloco ficou visível.
final class BlockTiming {
  const new({required this.words, required this.visibleMs});

  final int words;
  final double visibleMs;
}

/// Resultado da validação por tempo (v1).
final class ChapterCheck {
  const new({
    required this.ok,
    required this.flagged,
    required this.okShare,
    required this.needMs,
    required this.remainingMs,
  });

  final bool ok;

  /// Índices dos blocos que passaram rápido demais.
  final List<int> flagged;
  final double okShare;
  final double needMs;
  final double remainingMs;
}

/// Valida o capítulo pelo tempo de cada bloco e pelo tempo ativo total.
ChapterCheck validateChapter(List<BlockTiming> blocks, double activeMs) {
  final total = blocks.fold<int>(0, (a, b) => a + b.words);
  final flagged = <int>[
    for (var i = 0; i < blocks.length; i++)
      if (blocks[i].visibleMs < minBlockMs(blocks[i].words)) i,
  ];
  final okShare = 1 - flagged.length / math.max(1, blocks.length);
  final needMs = minChapterMs(total);
  return ChapterCheck(
    ok: okShare >= Rules.blockOkShare && activeMs >= needMs,
    flagged: flagged,
    okShare: okShare,
    needMs: needMs,
    remainingMs: math.max(0, needMs - activeMs),
  );
}

/// Sinais de leitura humana (v2).
final class ReadingSignalsInput {
  const new({
    this.still = 0,
    this.velCV = 0,
    this.inputs = 0,
    this.blocks = 1,
    this.handShare,
  });

  /// Fração do tempo ativo sem rolar.
  final double still;

  /// Coeficiente de variação da velocidade quando rola.
  final double velCV;

  /// Toques e rolagens humanas.
  final int inputs;

  /// Quantidade de blocos do capítulo.
  final int blocks;

  /// Fração de janelas de 5 s com o celular na mão; nulo = sem sensor.
  final double? handShare;

  ReadingSignalsInput withBlocks(int n) => ReadingSignalsInput(
    still: still,
    velCV: velCV,
    inputs: inputs,
    blocks: n,
    handShare: handShare,
  );
}

final class ReadingSignals {
  const new({
    required this.ritmo,
    required this.presenca,
    required this.presencaToque,
    required this.presencaMao,
    required this.sensor,
  });

  final bool ritmo;
  final bool presenca;
  final bool presencaToque;
  final bool presencaMao;
  final bool sensor;
}

/// Ritmo humano e presença (toques ou celular na mão).
ReadingSignals readingSignals(ReadingSignalsInput s) {
  final ritmo = s.still >= 0.25 || s.velCV >= 0.5;
  final presencaToque = s.inputs >= math.max(1, (s.blocks / 3).ceil());
  final presencaMao = s.handShare != null && s.handShare! >= 0.3;
  return ReadingSignals(
    ritmo: ritmo,
    presenca: presencaToque || presencaMao,
    presencaToque: presencaToque,
    presencaMao: presencaMao,
    sensor: s.handShare != null,
  );
}

/// Motivo gentil de uma leitura não contar.
enum RejectReason { rapido, tempo, ritmo, presenca }

final class ChapterCheckV2 {
  const new({required this.check, required this.sinais, required this.motivo});

  final ChapterCheck check;
  final ReadingSignals sinais;

  /// Nulo quando a leitura foi aprovada.
  final RejectReason? motivo;

  bool get ok => motivo == null;
}

/// Validação completa: tempo (v1) + ritmo + presença.
ChapterCheckV2 validateChapterV2(
  List<BlockTiming> blocks,
  double activeMs,
  ReadingSignalsInput sig,
) {
  final v = validateChapter(blocks, activeMs);
  final s = readingSignals(sig.withBlocks(blocks.length));
  RejectReason? motivo;
  if (!v.ok) {
    motivo = v.flagged.isNotEmpty ? RejectReason.rapido : RejectReason.tempo;
  } else if (!s.ritmo) {
    motivo = RejectReason.ritmo;
  } else if (!s.presenca) {
    motivo = RejectReason.presenca;
  }
  return ChapterCheckV2(check: v, sinais: s, motivo: motivo);
}

/// Minutos estimados de um capítulo (mínimo 1).
int minutosCapitulo(int palavras, {int ppm = Rules.estimateWpm}) =>
    math.max(1, (palavras / ppm).round());
