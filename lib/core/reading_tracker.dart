import 'dart:math' as math;

import 'package:bible_garden/core/reading.dart';
import 'package:bible_garden/core/rules.dart';

/// Mede uma leitura em andamento, como o protótipo: a cada tique soma tempo
/// ativo e tempo visível dos blocos, registra pausas e velocidade de rolagem,
/// conta toques e, se a pessoa ligou o sensor, se o celular está na mão.
///
/// Não usa relógio próprio: quem chama passa o instante (em ms). Assim os
/// testes simulam leitores honestos, robôs e celulares parados.
final class ReadingTracker {
  new({required List<int> blockWords, required int startMs})
    : _words = List.unmodifiable(blockWords),
      _visibleMs = List.filled(blockWords.length, 0),
      _lastTickMs = startMs,
      _lastInputMs = startMs;

  final List<int> _words;
  final List<double> _visibleMs;
  double _activeMs = 0;
  int _lastTickMs;
  int _lastInputMs;
  int _lastCountedInputMs = -1000000;
  double? _lastScroll;
  int _ticks = 0;
  int _stillTicks = 0;
  final List<double> _velocities = [];
  int _inputs = 0;
  final List<double> _accelBuffer = [];
  final List<bool> _handWindows = [];

  /// Sensor de movimento ligado pela pessoa.
  bool sensorEnabled = false;

  /// Leitura pausada por inatividade (90 s sem toque nem rolagem).
  bool get idle => _idle;
  bool _idle = false;

  double get activeMs => _activeMs;
  int get inputs => _inputs;
  int get blockCount => _words.length;
  int get totalWords => _words.fold(0, (a, b) => a + b);
  List<double> get visibleMs => List.unmodifiable(_visibleMs);

  /// Toque, rolagem com o dedo ou tecla. Conta no máximo 1 a cada 400 ms.
  void onInput(int nowMs) {
    _lastInputMs = nowMs;
    _idle = false;
    if (nowMs - _lastCountedInputMs > 400) {
      _inputs++;
      _lastCountedInputMs = nowMs;
    }
  }

  /// Qualquer rolagem (inclusive inércia) tira da pausa sem contar toque.
  void onScrollActivity(int nowMs) {
    _lastInputMs = nowMs;
    _idle = false;
  }

  /// Amostra do acelerômetro (módulo da aceleração com gravidade).
  void onAccelerometer(double magnitude) {
    if (!sensorEnabled) return;
    _accelBuffer.add(magnitude);
  }

  /// Tique periódico (o app usa 250 ms).
  ///
  /// [visibleBlocks]: blocos com pelo menos metade na tela.
  /// [appVisible]: app em primeiro plano; em segundo plano nada conta.
  /// [scrollOffset]: posição da rolagem em pixels lógicos.
  void tick(
    int nowMs, {
    required Iterable<int> visibleBlocks,
    required bool appVisible,
    required double scrollOffset,
  }) {
    final dt = (nowMs - _lastTickMs).toDouble();
    _lastTickMs = nowMs;
    if (!appVisible || dt <= 0) return;
    if (nowMs - _lastInputMs > Rules.idlePause.inMilliseconds) {
      _idle = true;
      return;
    }
    _activeMs += dt;
    for (final i in visibleBlocks) {
      if (i >= 0 && i < _visibleMs.length) _visibleMs[i] += dt;
    }
    final dy = (_lastScroll == null ? 0 : scrollOffset - _lastScroll!).abs();
    _lastScroll = scrollOffset;
    _ticks++;
    if (dy < 1) {
      _stillTicks++;
    } else {
      _velocities.add(dy / dt * 1000);
    }
    if (_accelBuffer.length >= 20) {
      final m = _accelBuffer.reduce((a, b) => a + b) / _accelBuffer.length;
      final sd = math.sqrt(
        _accelBuffer.fold<double>(0, (a, b) => a + (b - m) * (b - m)) /
            _accelBuffer.length,
      );
      _handWindows.add(sd > 0.08);
      _accelBuffer.clear();
    }
  }

  /// Sinais de leitura humana até agora.
  ReadingSignalsInput signals() {
    final mv = _velocities;
    final mean = mv.isEmpty ? 0 : mv.reduce((a, b) => a + b) / mv.length;
    final cv = mv.length > 3 && mean > 0
        ? math.sqrt(
                mv.fold<double>(0, (a, b) => a + (b - mean) * (b - mean)) /
                    mv.length,
              ) /
              mean
        : 0.0;
    return ReadingSignalsInput(
      still: _stillTicks / math.max(1, _ticks),
      velCV: cv,
      inputs: _inputs,
      blocks: _words.length,
      handShare: sensorEnabled && _handWindows.isNotEmpty
          ? _handWindows.where((h) => h).length / _handWindows.length
          : null,
    );
  }

  List<BlockTiming> timings() => [
    for (var i = 0; i < _words.length; i++)
      BlockTiming(words: _words[i], visibleMs: _visibleMs[i]),
  ];

  /// Valida o capítulo com tudo o que foi medido.
  ChapterCheckV2 validate() =>
      validateChapterV2(timings(), _activeMs, signals());

  /// Resumo para a tela "Como sua última leitura foi validada".
  /// Só números: nada do texto, nada sai do aparelho.
  ValidationSummary summary(ChapterCheckV2 v) {
    final s = signals();
    final min = _activeMs / 60000;
    return ValidationSummary(
      minutos: min,
      ppm: min > 0 ? (totalWords / min).round() : 0,
      blocosOk: _words.length - v.check.flagged.length,
      blocos: _words.length,
      pausasPct: (s.still * 100).round(),
      toques: s.inputs,
      maoPct: s.handShare == null ? null : (s.handShare! * 100).round(),
    );
  }

  /// Versão mod: simula uma leitura atenta (só existe para testes manuais).
  void simulateAttentiveReading() {
    for (var i = 0; i < _words.length; i++) {
      _visibleMs[i] = _words[i] / Rules.estimateWpm * 60000;
    }
    _activeMs = _visibleMs.fold(0, (a, b) => a + b);
    _ticks = 400;
    _stillTicks = 280;
    _velocities
      ..clear()
      ..addAll([400, 900, 650, 1100, 500, 800]);
    _inputs = _words.length;
  }
}

/// Números de uma leitura validada.
final class ValidationSummary {
  const new({
    required this.minutos,
    required this.ppm,
    required this.blocosOk,
    required this.blocos,
    required this.pausasPct,
    required this.toques,
    this.maoPct,
  });

  factory fromJson(Map<String, Object?> j) => ValidationSummary(
    minutos: (j['min']! as num).toDouble(),
    ppm: j['ppm']! as int,
    blocosOk: j['ok']! as int,
    blocos: j['blocos']! as int,
    pausasPct: j['pausas']! as int,
    toques: j['toques']! as int,
    maoPct: j['mao'] as int?,
  );

  final double minutos;
  final int ppm;
  final int blocosOk;
  final int blocos;
  final int pausasPct;
  final int toques;
  final int? maoPct;

  Map<String, Object?> toJson() => {
    'min': double.parse(minutos.toStringAsFixed(1)),
    'ppm': ppm,
    'ok': blocosOk,
    'blocos': blocos,
    'pausas': pausasPct,
    'toques': toques,
    'mao': maoPct,
  };
}

/// "Li na minha Bíblia": registro por confiança, com limite de ritmo. Cada
/// registro precisa de um intervalo mínimo desde o anterior, igual ao tempo
/// de leitura do capítulo a 500 ppm.
bool printedReadingAllowed({
  required DateTime? lastPrintedAt,
  required DateTime now,
  required int chapterWords,
}) {
  if (lastPrintedAt == null) return true;
  final need = Duration(milliseconds: minChapterMs(chapterWords).round());
  return !now.difference(lastPrintedAt).isNegative &&
      now.difference(lastPrintedAt) >= need;
}
