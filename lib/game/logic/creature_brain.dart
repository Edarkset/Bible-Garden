import 'dart:math' as math;

import 'package:bible_garden/game/logic/garden_layout.dart';

/// O que um ser está fazendo.
enum Activity {
  idle,
  idleVariation,
  walk,
  drink,
  sleep,
  special,
  quirk,
  tapped,
  shelter,
  celebrate,
  sit,
  pickFruit,
  washHands,
  signature,
}

/// Direção em que anda (a esquerda é a direita espelhada).
enum Facing { down, up, right, left }

/// Máquina de estados de um animal ou personagem. Não desenha nada: decide
/// o que fazer e para onde ir. O componente do Flame só obedece.
final class CreatureBrain {
  new({
    required this.rng,
    required this.x,
    required this.y,
    this.isCharacter = false,
    this.speed = 14,
    this.nocturnal = false,
  });

  final math.Random rng;
  final bool isCharacter;
  final bool nocturnal;

  /// Pixels do mundo por segundo.
  final double speed;
  double x;
  double y;
  Activity activity = Activity.idle;
  Facing facing = Facing.down;
  ({double x, double y})? target;
  double _timer = 1;

  /// Segundos até a próxima gracinha (personagens: 2 a 5 minutos).
  double signatureIn = 120;

  bool raining = false;
  bool night = false;

  /// Animação terminou (o componente avisa).
  void animationDone() {
    if (activity == Activity.walk) return;
    _timer = 0;
  }

  /// Toque: para tudo e reage.
  void tap() {
    activity = Activity.tapped;
    target = null;
    _timer = 1.2;
  }

  void celebrate() {
    activity = Activity.celebrate;
    target = null;
    _timer = 1.5;
  }

  void update(double dt) {
    if (isCharacter) signatureIn -= dt;
    if (raining &&
        activity != Activity.shelter &&
        activity != Activity.tapped) {
      activity = Activity.shelter;
      target = null;
      _timer = 4;
    }
    if (activity == Activity.walk) {
      _walk(dt);
      return;
    }
    _timer -= dt;
    if (_timer > 0) return;
    _decide();
  }

  void _walk(double dt) {
    final t = target;
    if (t == null) {
      activity = Activity.idle;
      return;
    }
    final dx = t.x - x;
    final dy = t.y - y;
    final d = math.sqrt(dx * dx + dy * dy);
    final step = speed * dt;
    if (d <= step) {
      x = t.x;
      y = t.y;
      target = null;
      activity = _arrival ?? Activity.idle;
      _arrival = null;
      _timer = activity == Activity.idle ? 1 + rng.nextDouble() * 2 : 2.5;
      if (activity != Activity.idle) facing = Facing.up;
      return;
    }
    x += dx / d * step;
    y += dy / d * step;
    facing = dx.abs() > dy.abs()
        ? (dx > 0 ? Facing.right : Facing.left)
        : (dy > 0 ? Facing.down : Facing.up);
  }

  Activity? _arrival;

  void _decide() {
    if (night && !nocturnal) {
      activity = Activity.sleep;
      _timer = 10;
      return;
    }
    if (isCharacter && signatureIn <= 0) {
      activity = Activity.signature;
      signatureIn = 120 + rng.nextDouble() * 180;
      _timer = 4;
      return;
    }
    final r = rng.nextDouble();
    if (r < 0.45) {
      final tiles = GardenLayout.walkable();
      final tile = tiles[rng.nextInt(tiles.length)];
      _goTo(GardenLayout.footOf(tile));
    } else if (r < 0.6) {
      activity = Activity.idleVariation;
      _timer = 2;
    } else if (r < 0.7) {
      _goTo(GardenLayout.footOf(GardenLayout.pondEdge(rng)));
      _arrival = isCharacter ? Activity.washHands : Activity.drink;
    } else if (r < 0.78) {
      activity = isCharacter ? Activity.sit : Activity.quirk;
      _timer = isCharacter ? 6 : 2;
    } else if (r < 0.84) {
      activity = isCharacter ? Activity.pickFruit : Activity.special;
      _timer = 3;
    } else {
      activity = Activity.idle;
      _timer = 2 + rng.nextDouble() * 3;
    }
  }

  void _goTo(({double x, double y}) p) {
    target = p;
    activity = Activity.walk;
  }

  /// Alterna as duas variações de parado.
  bool _altVariation = false;

  /// Nome da animação no manifesto para o estado atual, conforme o modelo da
  /// folha (A-T, A-V, A-A, A-I, A-G ou H). Quem toca usa 'idle' como reserva.
  String animationName(String? model) {
    final dir = switch (facing) {
      Facing.down => 'down',
      Facing.up => 'up',
      Facing.right || Facing.left => 'right',
    };
    final m = model ?? 'A-T';
    String byModel(Map<String, String> table, String other) =>
        table[m] ?? other;
    switch (activity) {
      case Activity.walk:
        final verb = byModel({
          'A-V': 'fly',
          'A-A': 'swim',
          'A-I': 'move',
        }, 'walk');
        // Grupos não têm "de costas": usam "de frente".
        if (m == 'A-G' && dir == 'up') return 'walk_down';
        return '${verb}_$dir';
      case Activity.idleVariation:
        _altVariation = !_altVariation;
        return switch (m) {
          'A-V' => _altVariation ? 'preen' : 'fluff',
          'A-A' => _altVariation ? 'turn' : 'bubbles',
          'H' => _altVariation ? 'idle_stretch' : 'idle_sky',
          'A-T' => _altVariation ? 'idle_stretch' : 'idle_look',
          _ => 'idle',
        };
      case Activity.drink:
        return byModel({
          'A-V': 'land',
          'A-A': 'bubbles',
          'A-I': 'idle',
        }, 'drink');
      case Activity.sleep:
        return byModel({'H': 'doze', 'A-A': 'glide', 'A-I': 'idle'}, 'sleep');
      case Activity.shelter:
        return byModel({
          'H': 'rain_hurry',
          'A-V': 'rain_tuck',
          'A-I': 'rain_hide',
          'A-A': 'rain_look',
        }, 'rain_shelter');
      case Activity.celebrate:
        return m == 'A-I' ? 'special' : 'celebrate';
      case Activity.idle:
        return 'idle';
      case Activity.special:
        return m == 'H' ? 'pet_animal' : 'special';
      case Activity.quirk:
        return m == 'H' ? 'idle_sky' : 'quirk';
      case Activity.tapped:
        return 'tapped';
      case Activity.sit:
        return 'sit';
      case Activity.pickFruit:
        return 'pick_fruit';
      case Activity.washHands:
        return 'wash_hands';
      case Activity.signature:
        return 'signature';
    }
  }

  /// Desenhar espelhado?
  bool get mirrored => facing == Facing.left;
}
