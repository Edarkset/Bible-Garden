import 'dart:io';

import 'package:bible_garden/data/sprites/sprite_manifest.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final manifest = SpriteManifest.parse(
    File('assets/data/sprites_manifest.json').readAsStringSync(),
  );
  final sheets = manifest.sheets;

  test('362 folhas: P1 64, P2 154, P3 144', () {
    expect(manifest.version, 6);
    expect(sheets, hasLength(362));
    int count(String p) => sheets.where((s) => s.priority == p).length;
    expect(count('P1'), 64);
    expect(count('P2'), 154);
    expect(count('P3'), 144);
  });

  test('códigos e arquivos são únicos', () {
    expect(sheets.map((s) => s.code).toSet(), hasLength(sheets.length));
    expect(sheets.map((s) => s.file).toSet(), hasLength(sheets.length));
  });

  test('regras técnicas: chão a 85% e virado para a direita', () {
    for (final s in sheets.where((s) => s.hasGrid)) {
      expect(s.baseline, 0.85, reason: s.code);
      expect(s.facing, 'right', reason: s.code);
      expect(s.file, startsWith('arte/'), reason: s.code);
    }
  });

  test('toda animação cabe na grade da folha', () {
    for (final s in sheets.where((s) => s.hasGrid)) {
      for (final a in s.animations.values) {
        expect(a.row, lessThan(s.rows!), reason: '${s.code} ${a.name}');
        expect(
          a.from + a.count,
          lessThanOrEqualTo(s.cols!),
          reason: '${s.code} ${a.name}',
        );
      }
    }
  });

  test('grades por modelo seguem o pedido de sprites', () {
    const grids = {
      'H': (8, 12, 128),
      'A-T': (8, 11, 128),
      'A-V': (8, 11, 128),
      'A-A': (8, 11, 128),
      'A-I': (8, 5, 64),
      'A-G': (8, 8, 192),
      'PL-G': (8, 8, 256),
      'PL-P': (6, 5, 128),
    };
    for (final s in sheets.where((s) => s.model != null)) {
      expect(
        (s.cols, s.rows, s.cell),
        grids[s.model],
        reason: '${s.code} (${s.model})',
      );
    }
  });

  test('busca por código', () {
    expect(manifest.byCode('A001')?.id, 'ovelha');
    expect(manifest.byCode('H01')?.id, 'noe');
    expect(manifest.byCode('ZZZ'), isNull);
  });
}
