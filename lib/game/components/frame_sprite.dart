import 'dart:ui';

import 'package:bible_garden/data/sprites/sprite_manifest.dart';
import 'package:bible_garden/game/art/frame_source.dart';
import 'package:bible_garden/game/logic/sheet_animator.dart';
import 'package:flame/components.dart';

/// Componente que desenha uma folha do manifesto com um [SheetAnimator].
/// A âncora fica no pé (85% da célula), então a posição é o ponto no chão e
/// a ordem de desenho segue o pé.
class FrameSprite extends PositionComponent {
  new({
    required this.sheet,
    required this.source,
    required double cellWorld,
    String initial = 'idle',
    super.position,
  }) : animator = SheetAnimator(sheet, initial: initial),
       super(
         size: Vector2.all(cellWorld),
         anchor: Anchor(0.5, sheet.baseline ?? 0.85),
       );

  final SpriteSheet sheet;
  FrameSource source;
  final SheetAnimator animator;
  bool mirror = false;

  /// Opacidade (para chegar e sair suavemente).
  double opacity = 1;
  final Paint _paint = Paint()..filterQuality = FilterQuality.medium;

  @override
  void update(double dt) {
    super.update(dt);
    animator.update(dt);
    priority = (position.y * 10).round();
  }

  @override
  void render(Canvas canvas) {
    final (row, col) = animator.frame;
    _paint.color = Color.fromRGBO(255, 255, 255, opacity.clamp(0, 1));
    source.draw(
      canvas,
      row,
      col,
      Offset.zero & Size(size.x, size.y),
      mirror: mirror,
      paint: _paint,
    );
  }
}
