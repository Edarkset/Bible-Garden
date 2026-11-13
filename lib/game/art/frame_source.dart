import 'dart:math' as math;
import 'dart:ui';

import 'package:bible_garden/data/sprites/sprite_manifest.dart';
import 'package:flutter/painting.dart' show HSVColor;

/// Desenha um quadro (linha, coluna) de uma folha num retângulo de destino.
/// O destino é a célula inteira: o pé fica a 85% da altura, como na arte.
abstract interface class FrameSource {
  void draw(
    Canvas canvas,
    int row,
    int col,
    Rect dst, {
    bool mirror = false,
    Paint? paint,
  });

  /// Arte real (true) ou placeholder (false).
  bool get isArt;
}

/// Quadros recortados de um PNG da folha (já reduzido ao carregar).
final class ImageFrameSource implements FrameSource {
  new(this.image, {required this.cols, required this.rows});

  final Image image;
  final int cols;
  final int rows;

  @override
  bool get isArt => true;

  static final Paint _pixel = Paint()..filterQuality = FilterQuality.medium;

  @override
  void draw(
    Canvas canvas,
    int row,
    int col,
    Rect dst, {
    bool mirror = false,
    Paint? paint,
  }) {
    final cw = image.width / cols;
    final ch = image.height / rows;
    final src = Rect.fromLTWH(col * cw, row * ch, cw, ch);
    if (!mirror) {
      canvas.drawImageRect(image, src, dst, paint ?? _pixel);
      return;
    }
    canvas
      ..save()
      ..translate(dst.center.dx, 0)
      ..scale(-1, 1)
      ..translate(-dst.center.dx, 0)
      ..drawImageRect(image, src, dst, paint ?? _pixel)
      ..restore();
  }
}

/// Placeholder desenhado por código a partir do manifesto: mesma célula,
/// mesmas linhas e quadros, linha do chão a 85%. Cada linha anima de um
/// jeito reconhecível, para testar o jogo antes da arte chegar.
final class PlaceholderFrameSource implements FrameSource {
  new(this.sheet) : _color = _colorFor(sheet.id);

  final SpriteSheet sheet;
  final Color _color;

  @override
  bool get isArt => false;

  static Color _colorFor(String id) {
    var h = 0;
    for (final c in id.codeUnits) {
      h = (h * 31 + c) & 0xFFFFFF;
    }
    final hue = (h % 360).toDouble();
    return HSVColor.fromAHSV(1, hue, 0.45, 0.85).toColor();
  }

  static const Color _outline = Color(0xFF3B2A2E); // ameixa escura, nunca preto

  @override
  void draw(
    Canvas canvas,
    int row,
    int col,
    Rect dst, {
    bool mirror = false,
    Paint? paint,
  }) {
    canvas.save();
    if (mirror) {
      canvas
        ..translate(dst.center.dx, 0)
        ..scale(-1, 1)
        ..translate(-dst.center.dx, 0);
    }
    final group = sheet.group;
    if (group == 'Plantas') {
      _plant(canvas, row, col, dst);
    } else if (group == 'Personagens bíblicos') {
      _person(canvas, row, col, dst);
    } else if (group == 'Animais') {
      _animal(canvas, row, col, dst);
    } else {
      _thing(canvas, row, col, dst);
    }
    canvas.restore();
  }

  Paint _fill(Color c) => Paint()..color = c;
  Paint get _stroke => Paint()
    ..color = _outline
    ..style = PaintingStyle.stroke
    ..strokeWidth = math.max(1, sheetStroke);

  double get sheetStroke => 1;

  /// Planta: a linha 0 cresce quadro a quadro; as outras balançam.
  void _plant(Canvas canvas, int row, int col, Rect d) {
    final ground = d.top + d.height * 0.85;
    final frames = sheet.cols ?? 8;
    final growth = row == 0 ? (col + 1) / frames : 1.0;
    final sway = row == 0 ? 0.0 : math.sin(col / frames * 2 * math.pi) * 0.05;
    final isTree = sheet.model == 'PL-G';
    // montinho de terra (a muda nunca some na grama)
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(d.center.dx, ground),
        width: d.width * 0.32,
        height: d.height * 0.07,
      ),
      _fill(const Color(0xFF8A6A48)),
    );
    if (row == 0 && col == 0) {
      canvas.drawCircle(
        Offset(d.center.dx, ground - d.height * 0.03),
        d.width * 0.035,
        _fill(const Color(0xFF6B4A2A)),
      );
      return;
    }
    final h = d.height * (isTree ? 0.75 : 0.55) * growth;
    final trunkTop = Offset(d.center.dx + sway * d.width, ground - h * 0.55);
    canvas.drawLine(
      Offset(d.center.dx, ground),
      trunkTop,
      Paint()
        ..color = const Color(0xFF6B4A2A)
        ..strokeWidth = math.max(1.5, d.width * 0.05 * growth),
    );
    final crown = Rect.fromCenter(
      center: trunkTop.translate(0, -h * 0.2),
      width: d.width * (isTree ? 0.7 : 0.45) * growth,
      height: h * 0.75,
    );
    final golden = row == 4 && col >= 4;
    final leaf = golden
        ? Color.lerp(_color, const Color(0xFFE8B931), 0.6)!
        : Color.lerp(_color, const Color(0xFF4F8A3F), 0.6)!;
    canvas
      ..drawOval(crown, _fill(leaf))
      ..drawOval(crown, _stroke);
    if (sheet.hasFruit && (row == 2 || (row == 0 && col >= 4))) {
      final fruit = Color.lerp(_color, const Color(0xFFB4413A), 0.7)!;
      for (var i = 0; i < 3; i++) {
        canvas.drawCircle(
          crown.center.translate(
            (i - 1) * crown.width * 0.25,
            crown.height * 0.15,
          ),
          math.max(1, d.width * 0.025),
          _fill(fruit),
        );
      }
    }
  }

  /// Animal: corpo, cabeça, olhos; pernas alternam nas linhas de andar.
  void _animal(Canvas canvas, int row, int col, Rect d) {
    final ground = d.top + d.height * 0.85;
    final model = sheet.model;
    final baby =
        model != 'A-I' && model != 'A-G' && row == (sheet.rows ?? 1) - 1;
    final s = baby ? (col < 4 ? 0.6 : 0.8) : 1.0;
    final bob = math.sin(col / 8 * 2 * math.pi) * d.height * 0.02;
    final flying = model == 'A-V' && row >= 2 && row <= 4;
    final lift = flying ? d.height * 0.18 : 0.0;
    final bw = d.width * 0.42 * s;
    final bh = d.height * 0.26 * s;
    final body = Rect.fromCenter(
      center: Offset(d.center.dx, ground - bh * 0.7 - lift + bob),
      width: bw,
      height: bh,
    );
    if (!flying && model != 'A-A') {
      final step = (col.isEven ? 1 : -1) * (row >= 2 && row <= 4 ? 1 : 0);
      for (final dx in [-0.3, 0.3]) {
        canvas.drawLine(
          Offset(body.center.dx + dx * bw, body.bottom - 1),
          Offset(body.center.dx + dx * bw + step * 1.5, ground),
          Paint()
            ..color = _outline
            ..strokeWidth = math.max(1, d.width * 0.03),
        );
      }
    }
    if (model == 'A-A') {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(d.center.dx, ground),
          width: bw * 1.4,
          height: bh * 0.4,
        ),
        _fill(const Color(0x664FA3C7)),
      );
    }
    canvas
      ..drawOval(body, _fill(_color))
      ..drawOval(body, _stroke);
    final head = Offset(body.right - bw * 0.05, body.top + bh * 0.1);
    final hr = bh * 0.45;
    canvas
      ..drawCircle(head, hr, _fill(_color))
      ..drawCircle(head, hr, _stroke)
      ..drawCircle(
        head.translate(hr * 0.35, -hr * 0.1),
        math.max(0.8, hr * 0.15),
        _fill(_outline),
      );
    if (flying || model == 'A-V') {
      final wingUp = col.isEven ? -1.0 : 0.4;
      final path = Path()
        ..moveTo(body.center.dx, body.top + bh * 0.2)
        ..lineTo(body.center.dx - bw * 0.4, body.top + bh * wingUp)
        ..lineTo(body.center.dx + bw * 0.1, body.top + bh * 0.3)
        ..close();
      canvas
        ..drawPath(
          path,
          _fill(Color.lerp(_color, const Color(0xFFFFFFFF), 0.3)!),
        )
        ..drawPath(path, _stroke);
    }
  }

  /// Personagem: cápsula do manto e cabeça, sem rosto detalhado.
  void _person(Canvas canvas, int row, int col, Rect d) {
    final ground = d.top + d.height * 0.85;
    final walking = row >= 2 && row <= 4;
    final sitting = row == 7;
    final bob = walking ? (col.isEven ? -1.0 : 0.0) : 0.0;
    final h = d.height * (sitting ? 0.42 : 0.6);
    final w = d.width * 0.3;
    final robe = RRect.fromRectAndRadius(
      Rect.fromLTWH(d.center.dx - w / 2, ground - h * 0.68 + bob, w, h * 0.68),
      Radius.circular(w * 0.4),
    );
    canvas
      ..drawRRect(robe, _fill(_color))
      ..drawRRect(robe, _stroke);
    final head = Offset(d.center.dx, ground - h * 0.82 + bob);
    final hr = h * 0.17;
    canvas
      ..drawCircle(head, hr, _fill(const Color(0xFFC79A74)))
      ..drawCircle(head, hr, _stroke);
    if (row == 10 && col < 4) {
      // lanterna acesa
      canvas.drawCircle(
        Offset(d.center.dx + w * 0.7, ground - h * 0.4),
        math.max(1.5, d.width * 0.04),
        _fill(const Color(0xFFFFD36B)),
      );
    }
    if (row == 11) {
      // gracinha: brilho girando em volta
      final a = col / 8 * 2 * math.pi;
      canvas.drawCircle(
        head.translate(math.cos(a) * hr * 2.2, math.sin(a) * hr * 1.2),
        math.max(1, d.width * 0.03),
        _fill(const Color(0xFFF0C24E)),
      );
    }
  }

  /// Itens, cenário e efeitos: um bloco por estado (coluna).
  void _thing(Canvas canvas, int row, int col, Rect d) {
    final ground = d.top + d.height * 0.85;
    final w = d.width * 0.55;
    final h = d.height * 0.45;
    final r = RRect.fromRectAndRadius(
      Rect.fromLTWH(d.center.dx - w / 2, ground - h, w, h),
      Radius.circular(w * 0.15),
    );
    final c = Color.lerp(_color, const Color(0xFFFFFFFF), (col % 4) * 0.08)!;
    canvas
      ..drawRRect(r, _fill(c))
      ..drawRRect(r, _stroke);
  }
}
