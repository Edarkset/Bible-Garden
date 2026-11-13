// Confere a arte em assets/ contra assets/data/sprites_manifest.json.
//
// Uso: dart run tool/check_assets.dart [--prioridade P1] [--lista]
//
// Para cada folha do manifesto: diz se o PNG existe e, se existe, se o
// tamanho bate com colunas × célula por linhas × célula. Sai com código 1
// se alguma folha existente estiver fora do padrão (a arte deve ser refeita,
// não compensada no código).
import 'dart:io';
import 'dart:typed_data';

import 'package:bible_garden/data/sprites/sprite_manifest.dart';

void main(List<String> args) {
  final pIndex = args.indexOf('--prioridade');
  final onlyPriority = pIndex >= 0 && pIndex + 1 < args.length
      ? args[pIndex + 1].toUpperCase()
      : null;
  final listMissing = args.contains('--lista');

  final manifest = SpriteManifest.parse(
    File('assets/data/sprites_manifest.json').readAsStringSync(),
  );
  final sheets = manifest.sheets
      .where((s) => onlyPriority == null || s.priority == onlyPriority)
      .toList();

  final missing = <SpriteSheet>[];
  final wrong = <String>[];
  var ok = 0;
  for (final s in sheets) {
    final file = File(s.assetPath);
    if (!file.existsSync()) {
      missing.add(s);
      continue;
    }
    final size = _pngSize(file.readAsBytesSync());
    if (size == null) {
      wrong.add('${s.code} ${s.assetPath}: não é um PNG válido');
    } else if (s.hasGrid && (size.$1 != s.width || size.$2 != s.height)) {
      wrong.add(
        '${s.code} ${s.assetPath}: ${size.$1}×${size.$2}, '
        'esperado ${s.width}×${s.height}',
      );
    } else {
      ok++;
    }
  }

  final scope = onlyPriority ?? 'todas as prioridades';
  stdout
    ..writeln('Arte ($scope): ${sheets.length} folhas no manifesto')
    ..writeln('  prontas: $ok')
    ..writeln('  faltando: ${missing.length}')
    ..writeln('  fora do padrão: ${wrong.length}');
  final byPriority = <String, int>{};
  for (final s in missing) {
    byPriority[s.priority] = (byPriority[s.priority] ?? 0) + 1;
  }
  for (final e
      in byPriority.entries.toList()..sort((a, b) => a.key.compareTo(b.key))) {
    stdout.writeln('    ${e.key}: ${e.value} faltando');
  }
  if (listMissing) {
    for (final s in missing) {
      stdout.writeln('  - ${s.priority} ${s.code} ${s.assetPath}');
    }
  }
  for (final w in wrong) {
    stderr.writeln('  ! $w');
  }
  if (wrong.isNotEmpty) exitCode = 1;
}

/// Lê largura e altura do cabeçalho IHDR de um PNG.
(int, int)? _pngSize(Uint8List bytes) {
  const signature = [137, 80, 78, 71, 13, 10, 26, 10];
  if (bytes.length < 24) return null;
  for (var i = 0; i < signature.length; i++) {
    if (bytes[i] != signature[i]) return null;
  }
  final data = ByteData.sublistView(bytes);
  return (data.getUint32(16), data.getUint32(20));
}
