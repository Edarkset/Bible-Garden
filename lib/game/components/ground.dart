import 'dart:ui';

import 'package:bible_garden/game/logic/garden_layout.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

/// Chão do jardim (grama, caminho, borda) e área de toque dos ladrilhos.
/// É o placeholder de C01/C02/C05 até os ladrilhos de arte chegarem.
class GroundComponent extends PositionComponent with TapCallbacks {
  new({required this.onTileTap})
    : super(size: Vector2.all(GardenLayout.worldPx), priority: -100000);

  final void Function(Tile tile) onTileTap;

  /// Mostra a grade de edição (livre × reservado).
  bool editing = false;
  Set<Tile> occupied = const {};

  static final Paint _grassA = Paint()..color = const Color(0xFF7FB069);
  static final Paint _grassB = Paint()..color = const Color(0xFF76A862);
  static final Paint _path = Paint()..color = const Color(0xFFC9B18A);
  static final Paint _edge = Paint()
    ..color = const Color(0xFF4B6B3A)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;
  static final Paint _free = Paint()..color = const Color(0x3346A0C0);
  static final Paint _blocked = Paint()..color = const Color(0x22B4413A);
  static final Paint _stone = Paint()..color = const Color(0xFFB8B0A2);

  int ebenezer = 0;

  @override
  void render(Canvas canvas) {
    const t = GardenLayout.tilePx;
    for (var y = 0; y < GardenLayout.size; y++) {
      for (var x = 0; x < GardenLayout.size; x++) {
        final tile = (x: x, y: y);
        final r = Rect.fromLTWH(x * t, y * t, t, t);
        canvas.drawRect(r, (x + y).isEven ? _grassA : _grassB);
        if (GardenLayout.isPath(tile)) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(r.deflate(3), const Radius.circular(4)),
            _path,
          );
        }
        if (editing) {
          final free = GardenLayout.canPlace(tile, occupied);
          canvas.drawRect(r.deflate(1), free ? _free : _blocked);
        }
      }
    }
    // pedras de Ebenézer (uma por oração respondida, até 3 visíveis)
    for (var i = 0; i < ebenezer.clamp(0, 3); i++) {
      final f = GardenLayout.footOf((x: 2, y: 3 + i));
      canvas.drawOval(
        Rect.fromCenter(center: Offset(f.x, f.y - 3), width: 9, height: 6),
        _stone,
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(10),
      ),
      _edge,
    );
  }

  @override
  void onTapUp(TapUpEvent event) {
    final p = event.localPosition;
    onTileTap(GardenLayout.tileAt(p.x, p.y));
  }
}
