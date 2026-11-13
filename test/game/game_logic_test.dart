import 'dart:io';
import 'dart:math' as math;

import 'package:bible_garden/data/sprites/sprite_manifest.dart';
import 'package:bible_garden/game/logic/creature_brain.dart';
import 'package:bible_garden/game/logic/day_cycle.dart';
import 'package:bible_garden/game/logic/garden_layout.dart';
import 'package:bible_garden/game/logic/sheet_animator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final manifest = SpriteManifest.parse(
    File('assets/data/sprites_manifest.json').readAsStringSync(),
  );
  final ovelha = manifest.byCode('A001')!;
  final oliveira = manifest.sheets.firstWhere((s) => s.id == 'oliveira');

  group('animador de folha', () {
    test('idle da ovelha: linha 0, 6 quadros a 6 fps, em loop', () {
      final a = SheetAnimator(ovelha);
      expect(a.frame, (0, 0));
      a.update(1 / 6);
      expect(a.frame, (0, 1));
      a.update(5 / 6);
      expect(a.frame, (0, 0)); // voltou ao início
      expect(a.done, isFalse);
    });

    test('animação sem loop termina, avisa e para no último quadro', () {
      var called = 0;
      final a = SheetAnimator(ovelha)..play('tapped', onDone: () => called++);
      final tapped = ovelha.animations['tapped']!;
      a.update(10);
      expect(a.done, isTrue);
      expect(called, 1);
      expect(a.frame, (tapped.row, tapped.from + tapped.count - 1));
      a.update(1);
      expect(called, 1);
    });

    test('quadro fixo de estágio da oliveira', () {
      final a = SheetAnimator(oliveira, initial: 'stages')..hold('stages', 3);
      expect(a.frame, (0, 3));
      a.update(5);
      expect(a.frame, (0, 3));
    });

    test('animação inexistente usa a reserva', () {
      final a = SheetAnimator(ovelha)..play('voar', fallback: 'sleep');
      expect(a.current, 'sleep');
    });
  });

  group('jardim 12 × 12', () {
    test('árvore, lago, caminho e Ebenézer são reservados', () {
      expect(GardenLayout.canPlace((x: 5, y: 3), {}), isFalse); // árvore
      expect(GardenLayout.canPlace((x: 8, y: 9), {}), isFalse); // lago
      expect(GardenLayout.canPlace((x: 5, y: 8), {}), isFalse); // caminho
      expect(GardenLayout.canPlace((x: 2, y: 4), {}), isFalse); // Ebenézer
      expect(GardenLayout.canPlace((x: 1, y: 9), {}), isTrue);
      expect(GardenLayout.canPlace((x: 1, y: 9), {(x: 1, y: 9)}), isFalse);
      expect(GardenLayout.canPlace((x: 12, y: 0), {}), isFalse);
    });

    test('ladrilho e pé se convertem nos dois sentidos', () {
      for (final t in [(x: 0, y: 0), (x: 11, y: 11), (x: 3, y: 7)]) {
        final f = GardenLayout.footOf(t);
        expect(GardenLayout.tileAt(f.x, f.y), t);
      }
      expect(GardenLayout.worldPx, 216);
    });

    test('ninguém anda dentro da árvore nem do lago', () {
      for (final t in GardenLayout.walkable()) {
        expect(GardenLayout.isTree(t) || GardenLayout.isPond(t), isFalse);
      }
    });
  });

  group('dia e noite', () {
    test('meio-dia claro, meia-noite escura, lanterna ao anoitecer', () {
      expect(const DayCycle(12).night, 0);
      expect(const DayCycle(0).night, 1);
      expect(const DayCycle(23).isNight, isTrue);
      expect(const DayCycle(18.5).lanternOn, isTrue);
      expect(const DayCycle(15).lanternOn, isFalse);
    });

    test('sombra longa de manhã e à tarde, curta ao meio-dia', () {
      expect(
        const DayCycle(7).shadow.length,
        greaterThan(const DayCycle(12).shadow.length),
      );
      expect(
        const DayCycle(17).shadow.length,
        greaterThan(const DayCycle(12).shadow.length),
      );
    });

    test('coruja de noite, ovelha de dia', () {
      expect(const DayCycle(23).activeAt(nocturnal: true), isTrue);
      expect(const DayCycle(23).activeAt(nocturnal: false), isFalse);
    });
  });

  group('cérebro dos seres', () {
    CreatureBrain brain({bool character = false, int seed = 1}) =>
        CreatureBrain(
          rng: math.Random(seed),
          x: 30,
          y: 150,
          isCharacter: character,
        );

    test('na chuva, todos se abrigam', () {
      final b = brain()
        ..raining = true
        ..update(0.1);
      expect(b.activity, Activity.shelter);
    });

    test('à noite, animal diurno dorme', () {
      final b = brain()
        ..night = true
        ..update(5);
      expect(b.activity, Activity.sleep);
    });

    test('toque interrompe e reage', () {
      final b = brain()..tap();
      expect(b.activity, Activity.tapped);
      expect(b.target, isNull);
    });

    test('anda até o destino e chega', () {
      final b = brain()
        ..activity = Activity.walk
        ..target = (x: 60.0, y: 150.0);
      for (var i = 0; i < 200 && b.activity == Activity.walk; i++) {
        b.update(0.1);
      }
      expect(b.x, 60);
      expect(b.activity, isNot(Activity.walk));
      expect(b.facing, anyOf(Facing.right, Facing.up));
    });

    test('anda para a esquerda espelhando a direita', () {
      final b = brain()
        ..activity = Activity.walk
        ..target = (x: 0.0, y: 150.0)
        ..update(0.1);
      expect(b.facing, Facing.left);
      expect(b.mirrored, isTrue);
      expect(b.animationName('A-T'), 'walk_right');
    });

    test('personagem faz a gracinha a cada 2 a 5 minutos', () {
      final b = brain(character: true);
      var signatures = 0;
      for (var t = 0.0; t < 900; t += 0.5) {
        b.update(0.5);
        if (b.activity == Activity.walk) b.target = null;
        if (b.activity == Activity.signature) {
          signatures++;
          b.animationDone();
          expect(b.signatureIn, inInclusiveRange(119, 301));
          b.activity = Activity.idle;
        }
      }
      expect(signatures, inInclusiveRange(3, 7));
    });

    test('toda animação pedida existe na folha de cada modelo', () {
      final byModel = <String, SpriteSheet>{};
      for (final s in manifest.sheets) {
        if (s.model != null && s.model!.startsWith(RegExp('A-|H'))) {
          byModel.putIfAbsent(s.model!, () => s);
        }
      }
      expect(
        byModel.keys,
        containsAll(['A-T', 'A-V', 'A-A', 'A-I', 'A-G', 'H']),
      );
      for (final MapEntry(key: model, value: sheet) in byModel.entries) {
        final isH = model == 'H';
        final b = CreatureBrain(
          rng: math.Random(1),
          x: 0,
          y: 0,
          isCharacter: isH,
        );
        final activities = Activity.values.where(
          (a) =>
              isH ||
              !{
                Activity.sit,
                Activity.pickFruit,
                Activity.washHands,
                Activity.signature,
              }.contains(a),
        );
        for (final a in activities) {
          for (final f in Facing.values) {
            b
              ..activity = a
              ..facing = f;
            for (var k = 0; k < 2; k++) {
              final name = b.animationName(model);
              expect(
                sheet.animations.containsKey(name),
                isTrue,
                reason: '$model: $a/$f → $name',
              );
            }
          }
        }
      }
    });
  });
}
