import 'dart:math' as math;
import 'dart:ui';

import 'package:bible_garden/game/logic/garden_layout.dart';
import 'package:flame/components.dart';

/// Laguinho com borda e ondinhas (placeholder de C03/C04).
class PondComponent extends PositionComponent {
  new()
    : super(
        position: Vector2(7 * GardenLayout.tilePx, 8 * GardenLayout.tilePx),
        size: Vector2(4 * GardenLayout.tilePx, 3 * GardenLayout.tilePx),
        priority: -50000,
      );

  double _t = 0;
  bool raining = false;

  static final Paint _rim = Paint()..color = const Color(0xFF9C8A6E);
  static final Paint _water = Paint()..color = const Color(0xFF4FA3C7);
  static final Paint _ripple = Paint()
    ..color = const Color(0x88FFFFFF)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.8;

  @override
  void update(double dt) => _t += dt;

  @override
  void render(Canvas canvas) {
    final r = Offset.zero & Size(size.x, size.y);
    canvas
      ..drawOval(r, _rim)
      ..drawOval(r.deflate(3), _water);
    final rings = raining ? 4 : 2;
    for (var i = 0; i < rings; i++) {
      final phase = (_t * 0.5 + i / rings) % 1;
      final c = Offset(
        r.center.dx + math.cos(i * 2.1) * r.width * 0.2,
        r.center.dy + math.sin(i * 1.7) * r.height * 0.15,
      );
      _ripple.color = Color.fromRGBO(255, 255, 255, 0.6 * (1 - phase));
      canvas.drawOval(
        Rect.fromCenter(
          center: c,
          width: 4 + 14 * phase,
          height: 2 + 6 * phase,
        ),
        _ripple,
      );
    }
  }
}
