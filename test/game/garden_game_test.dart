import 'dart:io';
import 'dart:ui';

import 'package:bible_garden/core/economy.dart';
import 'package:bible_garden/core/growth.dart';
import 'package:bible_garden/data/sprites/sprite_manifest.dart';
import 'package:bible_garden/game/art/frame_source.dart';
import 'package:bible_garden/game/art/sprite_library.dart';
import 'package:bible_garden/game/garden_game.dart';
import 'package:bible_garden/game/garden_snapshot.dart';
import 'package:bible_garden/game/logic/garden_layout.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

final SpriteManifest manifest = SpriteManifest.parse(
  File('assets/data/sprites_manifest.json').readAsStringSync(),
);

GardenSnapshot snap({
  double growth = 0,
  List<BeingSpec> beings = const [],
  List<PlacedItem> placements = const [],
  bool raining = false,
}) => GardenSnapshot(
  book: 'GEN',
  plantCode: 'PL001',
  growth: growth,
  beings: beings,
  placements: placements,
  raining: raining,
);

void main() {
  final tiles = <Tile>[];
  GardenGame make(GardenSnapshot s, {double hour = 12}) => GardenGame(
    manifest: manifest,
    library: SpriteLibrary(knownAssets: {}),
    snapshot: s,
    onTileTap: tiles.add,
    hourOfDay: () => hour,
  );

  setUp(tiles.clear);

  testWithGame<GardenGame>(
    'carrega com placeholders: chão, lago, árvore e seres',
    () => make(
      snap(
        growth: 3.2,
        beings: const [
          BeingSpec(code: 'A001', id: 'ovelha', age: AnimalAge.filhote),
          BeingSpec(code: 'H01', id: 'noe'),
        ],
      ),
    ),
    (game) async {
      await game.ready();
      expect(game.plant, isNotNull);
      expect(game.plant!.source, isA<PlaceholderFrameSource>());
      expect(game.plant!.stage, Stage.arvore);
      expect(game.beingCount, 2);
      // roda 20 s de jogo sem erros
      for (var i = 0; i < 200; i++) {
        game.update(0.1);
      }
      // desenha um quadro inteiro
      final rec = PictureRecorder();
      game.render(Canvas(rec));
      rec.endRecording().dispose();
    },
  );

  testWithGame<GardenGame>(
    'quem está mais embaixo é desenhado na frente',
    () => make(
      snap(
        beings: const [
          BeingSpec(code: 'A001', id: 'ovelha'),
          BeingSpec(code: 'A002', id: 'x'),
        ],
      ),
    ),
    (game) async {
      await game.ready();
      final list = game.beings.toList();
      list[0].brain
        ..x = 20
        ..y = 50;
      list[1].brain
        ..x = 20
        ..y = 150;
      game.update(0.01);
      expect(list[1].priority, greaterThan(list[0].priority));
    },
  );

  testWithGame<GardenGame>(
    'crescimento: o estágio muda e a planta celebra',
    () => make(snap(growth: 1)),
    (game) async {
      await game.ready();
      expect(game.plant!.stage, Stage.broto);
      await game.updateSnapshot(snap(growth: 2.1), celebrate: true);
      expect(game.plant!.stage, Stage.muda);
      expect(game.plant!.animator.current, 'growth_burst');
      for (var i = 0; i < 30; i++) {
        game.update(0.1);
      }
      expect(game.plant!.animator.current, 'stages');
      expect(game.plant!.animator.frame, (0, 2));
    },
  );

  testWithGame<GardenGame>(
    'árvore plena balança ao vento; na chuva, pinga',
    () => make(snap(growth: 6)),
    (game) async {
      await game.ready();
      expect(game.plant!.animator.current, 'wind');
      await game.updateSnapshot(snap(growth: 6, raining: true));
      expect(game.plant!.animator.current, 'rain_drip');
      expect(game.weather.raining, isTrue);
    },
  );

  testWithGame<GardenGame>(
    'seres entram e saem conforme o banco, até 40',
    () => make(snap()),
    (game) async {
      await game.ready();
      await game.updateSnapshot(
        snap(
          beings: [
            for (var i = 0; i < 50; i++) BeingSpec(code: 'A001', id: 'o$i'),
          ],
        ),
      );
      expect(game.beingCount, 40);
      await game.updateSnapshot(snap());
      expect(game.beingCount, 0);
    },
  );

  testWithGame<GardenGame>(
    'decoração colocada aparece no ladrilho e some ao guardar',
    () => make(snap()),
    (game) async {
      await game.ready();
      const item = PlacedItem(id: 1, itemId: 'lanterna', tile: (x: 1, y: 9));
      await game.updateSnapshot(snap(placements: const [item]));
      expect(game.ground.occupied, {(x: 1, y: 9)});
      await game.updateSnapshot(snap());
      expect(game.ground.occupied, isEmpty);
    },
  );

  testWithGame<GardenGame>(
    'à noite os animais dormem',
    () => make(
      snap(
        beings: const [BeingSpec(code: 'A001', id: 'ovelha')],
      ),
      hour: 23,
    ),
    (game) async {
      await game.ready();
      for (var i = 0; i < 100; i++) {
        game.update(0.2);
      }
      expect(game.beings.single.brain.night, isTrue);
    },
  );
}
