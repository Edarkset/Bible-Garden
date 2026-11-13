import 'dart:async';
import 'dart:ui' as ui;

import 'package:bible_garden/data/sprites/sprite_manifest.dart';
import 'package:bible_garden/game/art/frame_source.dart';
import 'package:flutter/services.dart';

/// Carrega as folhas do manifesto. Se o PNG existir em `assets/arte/...`
/// usa a arte; senão, devolve o placeholder. Assim a arte entra sem mudar
/// código: basta colocar o arquivo no caminho certo.
final class SpriteLibrary {
  new({AssetBundle? bundle, Set<String>? knownAssets})
    : _bundle = bundle ?? rootBundle,
      _known = knownAssets;

  final AssetBundle _bundle;
  Set<String>? _known;
  final Map<String, Future<FrameSource>> _cache = {};

  Future<Set<String>> _assets() async {
    final k = _known;
    if (k != null) return k;
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(_bundle);
      return _known = manifest.listAssets().toSet();
    } on Object {
      return _known = <String>{};
    }
  }

  /// [cellPx]: tamanho da célula na tela, em pixels físicos. A imagem é
  /// decodificada já desse tamanho (memória de texturas sob controle).
  Future<FrameSource> load(SpriteSheet sheet, {required double cellPx}) =>
      _cache.putIfAbsent('${sheet.file}@${cellPx.round()}', () async {
        final path = sheet.assetPath;
        if (!sheet.hasGrid || !(await _assets()).contains(path)) {
          return PlaceholderFrameSource(sheet);
        }
        try {
          final data = await _bundle.load(path);
          final target = (sheet.cols! * cellPx).round().clamp(
            sheet.cols!,
            sheet.width!,
          );
          final codec = await ui.instantiateImageCodec(
            data.buffer.asUint8List(),
            targetWidth: target,
          );
          final frame = await codec.getNextFrame();
          codec.dispose();
          return ImageFrameSource(
            frame.image,
            cols: sheet.cols!,
            rows: sheet.rows!,
          );
        } on Object {
          return PlaceholderFrameSource(sheet);
        }
      });

  /// Libera tudo (ao sair do jardim).
  Future<void> clear() async {
    for (final f in _cache.values) {
      final s = await f;
      if (s is ImageFrameSource) s.image.dispose();
    }
    _cache.clear();
  }
}
