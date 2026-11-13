import 'dart:math' as math;
import 'dart:ui';

import 'package:bible_garden/core/economy.dart';
import 'package:bible_garden/game/components/frame_sprite.dart';
import 'package:bible_garden/game/logic/creature_brain.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

/// Animal ou personagem: folha animada + cérebro + sombra + balãozinho.
class CreatureComponent extends FrameSprite with TapCallbacks {
  new({
    required super.sheet,
    required super.source,
    required super.cellWorld,
    required this.brain,
    this.age = AnimalAge.adulto,
  }) : super(position: Vector2(brain.x, brain.y));

  final CreatureBrain brain;
  final AnimalAge age;

  /// Sombra calculada pelo jogo (a arte vem sem sombra).
  double shadowAngle = 1.2;
  double shadowLength = 0.5;

  double _bubble = 0;

  bool get _grows => age != AnimalAge.adulto && animator.has('baby_idle');

  @override
  void update(double dt) {
    brain.update(dt);
    position.setValues(brain.x, brain.y);
    mirror = brain.mirrored;
    final name = _grows && brain.activity == Activity.idle
        ? (age == AnimalAge.filhote ? 'baby_idle' : 'young_idle')
        : brain.animationName(sheet.model);
    animator.play(name, fallback: 'idle', onDone: brain.animationDone);
    if (_bubble > 0) _bubble -= dt;
    super.update(dt);
  }

  static final Paint _shadow = Paint()..color = const Color(0x33000000);
  static final Paint _bubblePaint = Paint()..color = const Color(0xFFFFFFFF);
  static final Paint _heart = Paint()..color = const Color(0xFFE2556B);

  @override
  void render(Canvas canvas) {
    final foot = Offset(size.x / 2, size.y * (sheet.baseline ?? 0.85));
    final len = size.x * 0.35 * shadowLength;
    canvas.drawOval(
      Rect.fromCenter(
        center: foot.translate(math.cos(shadowAngle) * len * 0.3, 0),
        width: size.x * 0.4 + len * 0.4,
        height: size.y * 0.08,
      ),
      _shadow,
    );
    super.render(canvas);
    if (_bubble > 0) {
      // E13 (coração) em placeholder
      final c = Offset(size.x * 0.7, size.y * 0.2);
      canvas
        ..drawCircle(c, size.x * 0.12, _bubblePaint)
        ..drawCircle(c, size.x * 0.05, _heart);
    }
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    final r = Rect.fromLTWH(
      size.x * 0.2,
      size.y * 0.35,
      size.x * 0.6,
      size.y * 0.55,
    );
    return r.contains(Offset(point.x, point.y));
  }

  @override
  void onTapUp(TapUpEvent event) {
    brain.tap();
    _bubble = 1.5;
  }
}
