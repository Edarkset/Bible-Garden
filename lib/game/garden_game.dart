import 'dart:async';
import 'dart:math' as math;

import 'package:bible_garden/core/economy.dart';
import 'package:bible_garden/data/sprites/sprite_manifest.dart';
import 'package:bible_garden/game/art/sprite_library.dart';
import 'package:bible_garden/game/components/creature.dart';
import 'package:bible_garden/game/components/frame_sprite.dart';
import 'package:bible_garden/game/components/ground.dart';
import 'package:bible_garden/game/components/main_plant.dart';
import 'package:bible_garden/game/components/pond.dart';
import 'package:bible_garden/game/components/weather.dart';
import 'package:bible_garden/game/garden_snapshot.dart';
import 'package:bible_garden/game/logic/creature_brain.dart';
import 'package:bible_garden/game/logic/day_cycle.dart';
import 'package:bible_garden/game/logic/garden_layout.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

/// Tamanhos no mundo (px) de cada célula de folha. A arte tem margem e o pé
/// a 85%, então a célula é maior que o ser: árvore plena ~80 px, animais e
/// personagens ~22 px.
abstract final class WorldSizes {
  static const double tree = 96;
  static const double smallPlant = 30;
  static const double creature = 27;
  static const double group = 36;
  static const double insect = 14;
  static const double item = 22;

  static double forSheet(SpriteSheet s) => switch (s.model) {
    'PL-G' => tree,
    'PL-P' => smallPlant,
    'A-G' => group,
    'A-I' => insect,
    'A-T' || 'A-V' || 'A-A' || 'H' => creature,
    _ => item,
  };
}

/// O jardim de um livro, desenhado com o Flame.
///
/// Recebe um [GardenSnapshot] e mantém os componentes em dia. Toques em
/// ladrilhos (modo edição) voltam por [onTileTap].
class GardenGame extends FlameGame {
  new({
    required this.manifest,
    required this.library,
    required this._snapshot,
    this.onTileTap,
    this.pixelRatio = 3,
    int seed = 0,
    double Function()? hourOfDay,
  }) : _rng = math.Random(seed),
       _hour = hourOfDay ?? _localHour,
       super(
         camera: CameraComponent.withFixedResolution(
           width: viewSize,
           height: viewSize,
         ),
       );

  static const double viewSize = 228;

  final SpriteManifest manifest;
  final SpriteLibrary library;
  final void Function(Tile tile)? onTileTap;

  /// Pixels físicos por pixel do mundo (para decodificar a arte no tamanho
  /// certo).
  final double pixelRatio;
  final math.Random _rng;
  final double Function() _hour;
  GardenSnapshot _snapshot;

  late final GroundComponent ground;
  late final WeatherLayer weather;
  PondComponent? _pond;
  MainPlantComponent? plant;
  final Map<String, CreatureComponent> _beings = {};
  final Map<int, FrameSprite> _items = {};

  bool reducedMotion = false;
  double _wind = 0.3;
  double _windTarget = 0.3;
  double _clockCheck = 0;

  static double _localHour() {
    final n = DateTime.now();
    return n.hour + n.minute / 60;
  }

  GardenSnapshot get snapshot => _snapshot;
  int get beingCount => _beings.length;
  Iterable<CreatureComponent> get beings => _beings.values;

  @override
  Future<void> onLoad() async {
    camera.viewfinder
      ..anchor = Anchor.topLeft
      ..position = Vector2.all(-(viewSize - GardenLayout.worldPx) / 2);
    ground = GroundComponent(onTileTap: (t) => onTileTap?.call(t))
      ..editing = _editing;
    weather = WeatherLayer(rng: _rng);
    await world.addAll([ground, weather]);
    await _apply(_snapshot, first: true);
  }

  /// Novo estado vindo do banco. [celebrate]: animar o crescimento.
  Future<void> updateSnapshot(GardenSnapshot s, {bool celebrate = false}) {
    _snapshot = s;
    return isLoaded ? _apply(s, celebrate: celebrate) : Future.value();
  }

  bool _editing = false;
  bool get editing => _editing;
  set editing(bool v) {
    _editing = v;
    if (isLoaded) ground.editing = v;
  }

  /// Todos fazem festa (livro concluído).
  void celebrate() {
    for (final b in _beings.values) {
      b.brain.celebrate();
    }
  }

  Future<FrameSprite?> _sprite(SpriteSheet? sheet, Vector2 at) async {
    if (sheet == null) return null;
    final cell = WorldSizes.forSheet(sheet);
    final src = await library.load(sheet, cellPx: cell * pixelRatio);
    return FrameSprite(
      sheet: sheet,
      source: src,
      cellWorld: cell,
      position: at,
      initial: sheet.animations.isEmpty ? '' : 'idle',
    );
  }

  Future<void> _apply(
    GardenSnapshot s, {
    bool first = false,
    bool celebrate = false,
  }) async {
    // lago
    if (s.hasPond && _pond == null) {
      await world.add(_pond = PondComponent());
    } else if (!s.hasPond && _pond != null) {
      _pond!.removeFromParent();
      _pond = null;
    }
    ground.ebenezer = s.ebenezerStones;

    // planta principal (troca de espécie mantém o estágio)
    final plantSheet = manifest.byCode(s.plantCode);
    if (plantSheet != null && plant?.sheet.code != plantSheet.code) {
      plant?.removeFromParent();
      final cell = WorldSizes.forSheet(plantSheet);
      final foot = GardenLayout.footOf(GardenLayout.treeBase);
      plant = MainPlantComponent(
        sheet: plantSheet,
        source: await library.load(plantSheet, cellPx: cell * pixelRatio),
        cellWorld: cell,
        position: Vector2(foot.x - GardenLayout.tilePx / 2, foot.y),
      );
      await world.add(plant!);
    }
    plant
      ?..raining = s.raining
      ..setGrowth(s.stage, s.variant, celebrate: celebrate && !first);

    // seres
    final wanted = {for (final b in s.beings) '${b.code}:${b.id}': b};
    for (final k in _beings.keys.toList()) {
      if (!wanted.containsKey(k)) _beings.remove(k)!.removeFromParent();
    }
    for (final e in wanted.entries) {
      final old = _beings[e.key];
      if (old != null && old.age == e.value.age) continue;
      old?.removeFromParent();
      final sheet = manifest.byCode(e.value.code);
      if (sheet == null || !sheet.hasGrid) continue;
      if (_beings.length >= 40) break; // orçamento de desempenho
      final cell = WorldSizes.forSheet(sheet);
      final tiles = GardenLayout.walkable();
      final start = GardenLayout.footOf(tiles[_rng.nextInt(tiles.length)]);
      final c = CreatureComponent(
        sheet: sheet,
        source: await library.load(sheet, cellPx: cell * pixelRatio),
        cellWorld: cell * (e.value.age == AnimalAge.adulto ? 1 : 0.85),
        age: e.value.age,
        brain: CreatureBrain(
          rng: math.Random(_rng.nextInt(1 << 30)),
          x: start.x,
          y: start.y,
          isCharacter: sheet.model == 'H',
          nocturnal: e.value.nocturnal,
          speed: sheet.model == 'A-I' ? 20 : 14,
        ),
      );
      _beings[e.key] = c;
      await world.add(c);
    }

    // decoração colocada
    final placed = {for (final p in s.placements) p.id: p};
    for (final k in _items.keys.toList()) {
      if (!placed.containsKey(k)) _items.remove(k)!.removeFromParent();
    }
    for (final p in placed.values) {
      if (_items.containsKey(p.id)) continue;
      final sheet = _itemSheet(p.itemId);
      final foot = GardenLayout.footOf(p.tile);
      final sprite = await _sprite(sheet, Vector2(foot.x, foot.y));
      if (sprite != null) {
        _items[p.id] = sprite;
        await world.add(sprite);
      }
    }
    ground.occupied = {for (final p in s.placements) p.tile};

    _pond?.raining = s.raining;
    weather.raining = s.raining;
    for (final b in _beings.values) {
      b.brain.raining = s.raining;
    }
  }

  /// Item da loja → folha do manifesto (itens I01–I13; o resto usa o
  /// conjunto de decoração estática I13).
  SpriteSheet? _itemSheet(String itemId) {
    for (final s in manifest.sheets) {
      if (s.group == 'Itens' && s.id == itemId) return s;
    }
    return manifest.byCode('I13');
  }

  @override
  void update(double dt) {
    // vento global: muda devagar
    if (_rng.nextDouble() < dt * 0.1) _windTarget = _rng.nextDouble();
    _wind += (_windTarget - _wind) * math.min(1, dt * 0.5);
    plant?.wind = reducedMotion ? 0 : _wind;

    _clockCheck -= dt;
    if (_clockCheck <= 0) {
      _clockCheck = 30;
      final day = DayCycle(_hour());
      weather
        ..day = day
        ..reducedMotion = reducedMotion;
      final sh = day.shadow;
      for (final b in _beings.values) {
        b
          ..brain.night = day.isNight
          ..shadowAngle = sh.angle
          ..shadowLength = sh.length;
      }
    }
    super.update(reducedMotion ? dt * 0.5 : dt);
  }
}
