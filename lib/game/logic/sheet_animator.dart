import 'package:bible_garden/data/sprites/sprite_manifest.dart';

/// Toca uma animação de uma folha do manifesto: diz qual quadro (linha e
/// coluna) mostrar em cada instante. Serve igual para a arte real e para os
/// placeholders.
final class SheetAnimator {
  new(this.sheet, {String initial = 'idle'}) {
    play(initial);
  }

  final SpriteSheet sheet;
  SpriteAnimation? _anim;
  double _t = 0;
  void Function()? _onDone;
  bool _done = false;

  /// Multiplica o fps (o vento forte acelera a linha de vento).
  double speed = 1;

  String? get current => _anim?.name;
  bool get done => _done;

  bool has(String name) => sheet.animations.containsKey(name);

  /// Começa uma animação. Se ela não existir na folha, usa [fallback].
  void play(String name, {String? fallback, void Function()? onDone}) {
    final a =
        sheet.animations[name] ??
        (fallback == null ? null : sheet.animations[fallback]);
    if (a == null) return;
    if (identical(a, _anim) && !_done) {
      _onDone = onDone ?? _onDone;
      return;
    }
    _anim = a;
    _t = 0;
    _done = false;
    _onDone = onDone;
  }

  /// Mostra um quadro fixo (ex.: estágio de crescimento).
  void hold(String name, int frame) {
    final a = sheet.animations[name];
    if (a == null) return;
    _anim = a;
    _t = frame / (a.fps ?? 1);
    _done = true;
    _onDone = null;
  }

  void update(double dt) {
    final a = _anim;
    if (a == null || a.isStatic || _done) return;
    _t += dt * speed;
    final fps = a.fps ?? 1;
    if (!a.loop && _t * fps >= a.count) {
      _t = (a.count - 1) / fps;
      _done = true;
      final cb = _onDone;
      _onDone = null;
      cb?.call();
    }
  }

  /// Quadro atual como (linha, coluna) da folha.
  (int, int) get frame {
    final a = _anim;
    if (a == null) return (0, 0);
    final fps = a.fps ?? 1;
    var i = (_t * fps).floor();
    i = a.loop ? i % a.count : i.clamp(0, a.count - 1);
    return (a.row, a.from + i);
  }
}
