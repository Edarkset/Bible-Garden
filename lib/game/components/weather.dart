import 'dart:math' as math;
import 'dart:ui';

import 'package:bible_garden/game/logic/day_cycle.dart';
import 'package:bible_garden/game/logic/garden_layout.dart';
import 'package:flame/components.dart';

/// Chuva (E05), vaga-lumes (E04) e a luz do dia por cima de tudo.
class WeatherLayer extends PositionComponent {
  new({required this.rng})
    : super(size: Vector2.all(GardenLayout.worldPx), priority: 1 << 30);

  final math.Random rng;
  bool raining = false;
  bool reducedMotion = false;

  /// Pacote 'noite-estrelada': estrelas e vaga-lumes azulados.
  bool starryNight = false;
  DayCycle day = const DayCycle(12);
  double _t = 0;

  final List<Offset> _drops = [];
  final List<Offset> _flies = [];

  @override
  Future<void> onLoad() async {
    for (var i = 0; i < 60; i++) {
      _drops.add(Offset(rng.nextDouble() * size.x, rng.nextDouble() * size.y));
    }
    for (var i = 0; i < 10; i++) {
      _flies.add(Offset(rng.nextDouble() * size.x, rng.nextDouble() * size.y));
    }
  }

  @override
  void update(double dt) {
    _t += dt;
    if (raining && !reducedMotion) {
      for (var i = 0; i < _drops.length; i++) {
        var d = _drops[i].translate(-dt * 30, dt * 160);
        if (d.dy > size.y) d = Offset(rng.nextDouble() * size.x + 20, -4);
        _drops[i] = d;
      }
    }
  }

  static final Paint _drop = Paint()
    ..color = const Color(0x99D6ECF5)
    ..strokeWidth = 1;
  final Paint _tint = Paint()..blendMode = BlendMode.multiply;
  static final Paint _fly = Paint()
    ..color = const Color(0xFFFFF2A0)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

  @override
  void render(Canvas canvas) {
    final r = Offset.zero & Size(size.x, size.y);
    _tint.color = day.tint;
    canvas.drawRect(r, _tint);
    if (raining) {
      canvas.drawRect(r, Paint()..color = const Color(0x22364A5C));
      for (final d in _drops) {
        canvas.drawLine(d, d.translate(-1.5, 6), _drop);
      }
    }
    if (day.isNight && !raining && starryNight) {
      for (var i = 0; i < 18; i++) {
        final s = Offset((i * 37) % size.x, (i * 53) % (size.y * 0.5));
        final tw = 0.5 + 0.5 * math.sin(_t * 1.5 + i);
        canvas.drawCircle(
          s,
          0.8,
          Paint()..color = Color.fromRGBO(220, 230, 255, 0.4 + 0.6 * tw),
        );
      }
    }
    if (day.isNight && !raining) {
      for (var i = 0; i < _flies.length; i++) {
        final f = _flies[i];
        final o = reducedMotion
            ? f
            : f.translate(math.sin(_t + i) * 6, math.cos(_t * 0.7 + i) * 4);
        _fly.color = Color.fromRGBO(
          starryNight ? 170 : 255,
          starryNight ? 210 : 242,
          starryNight ? 255 : 160,
          0.4 + 0.6 * (0.5 + 0.5 * math.sin(_t * 2 + i)),
        );
        canvas.drawCircle(o, 1.4, _fly);
      }
    }
  }
}
