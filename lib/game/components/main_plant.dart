import 'dart:ui';

import 'package:bible_garden/core/growth.dart';
import 'package:bible_garden/game/components/frame_sprite.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

/// Árvore (ou flor) principal do livro: estágio pela leitura, vento,
/// variantes de releitura, toque e explosão de crescimento.
class MainPlantComponent extends FrameSprite with TapCallbacks {
  new({
    required super.sheet,
    required super.source,
    required super.cellWorld,
    required super.position,
  }) : super(initial: 'stages');

  Stage stage = Stage.semente;
  ReadVariant variant = ReadVariant.normal;
  double wind = 0.3;
  bool raining = false;
  bool _busy = false;

  /// Atualiza o estágio. Se cresceu, toca a explosão de crescimento.
  void setGrowth(Stage s, ReadVariant v, {bool celebrate = false}) {
    final grew = s.index > stage.index;
    stage = s;
    variant = v;
    if (celebrate && grew && animator.has('growth_burst')) {
      _busy = true;
      animator.play(
        'growth_burst',
        onDone: () {
          _busy = false;
          _rest();
        },
      );
    } else {
      _rest();
    }
  }

  int get _frames => sheet.animations['stages']?.count ?? 8;

  void _rest() {
    if (_busy) return;
    if (stage == Stage.plena) {
      final name = raining
          ? 'rain_drip'
          : switch (variant) {
              ReadVariant.dourada => 'dourada',
              ReadVariant.florada => 'florada',
              ReadVariant.normal => 'wind',
            };
      animator.play(name, fallback: 'wind');
    } else {
      animator.hold('stages', stageFrame(stage, frames: _frames));
    }
  }

  @override
  void update(double dt) {
    animator.speed = 0.6 + wind;
    if (animator.done && !_busy) _rest();
    super.update(dt);
  }

  @override
  bool containsLocalPoint(Vector2 point) => Rect.fromLTWH(
    size.x * 0.15,
    size.y * 0.1,
    size.x * 0.7,
    size.y * 0.75,
  ).contains(Offset(point.x, point.y));

  @override
  void onTapUp(TapUpEvent event) {
    if (stage.index < Stage.arvore.index || _busy) return;
    _busy = true;
    final drop = sheet.hasFruit && animator.has('tapped_drop');
    animator.play(
      'tapped',
      onDone: () {
        if (drop) {
          animator.play(
            'tapped_drop',
            onDone: () {
              _busy = false;
              _rest();
            },
          );
        } else {
          _busy = false;
          _rest();
        }
      },
    );
  }
}
