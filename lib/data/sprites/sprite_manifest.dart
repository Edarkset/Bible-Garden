import 'dart:convert';

/// Uma animação dentro de uma folha: linha, quadro inicial e quantidade
/// (base 0, como no manifesto).
final class SpriteAnimation {
  const new({
    required this.name,
    required this.row,
    required this.from,
    required this.count,
    this.fps,
    this.loop = false,
    this.isStatic = false,
  });

  factory fromJson(String name, Map<String, Object?> json) => SpriteAnimation(
    name: name,
    row: json['row']! as int,
    from: json['from']! as int,
    count: json['count']! as int,
    fps: (json['fps'] as num?)?.toDouble(),
    loop: json['loop'] as bool? ?? false,
    isStatic: json['static'] as bool? ?? false,
  );

  final String name;
  final int row;
  final int from;
  final int count;
  final double? fps;
  final bool loop;

  /// Quadros que não animam sozinhos (ex.: estágios de crescimento).
  final bool isStatic;
}

/// Folha de objetos de um personagem: aparecer e em uso.
final class PropSheet {
  const new({
    required this.file,
    required this.cols,
    required this.rows,
    required this.cell,
    required this.animations,
  });

  factory fromJson(Map<String, Object?> json) => PropSheet(
    file: json['file']! as String,
    cols: json['cols']! as int,
    rows: json['rows']! as int,
    cell: json['cell']! as int,
    animations: {
      for (final k in const ['appear', 'in_use'])
        if (json[k] != null)
          k: SpriteAnimation.fromJson(k, json[k]! as Map<String, Object?>),
    },
  );

  final String file;
  final int cols;
  final int rows;
  final int cell;
  final Map<String, SpriteAnimation> animations;
}

/// Uma folha de sprite descrita em `assets/data/sprites_manifest.json`.
///
/// A chave única é [code] (A001, PL001, H01...). O campo [id] se repete em
/// folhas da mesma coisa (ex.: `lago` em C03 e C04).
final class SpriteSheet {
  const new({
    required this.code,
    required this.id,
    required this.group,
    required this.name,
    required this.file,
    required this.priority,
    this.model,
    this.cols,
    this.rows,
    this.cell,
    this.baseline,
    this.facing,
    this.animations = const {},
    this.hasFruit = false,
    this.props,
    this.portrait,
  });

  factory fromJson(Map<String, Object?> json) {
    final anims = (json['animations'] as Map<String, Object?>?) ?? const {};
    return SpriteSheet(
      code: json['code']! as String,
      id: json['id']! as String,
      group: json['group']! as String,
      name: json['name']! as String,
      file: json['file']! as String,
      priority: json['priority']! as String,
      model: json['model'] as String?,
      cols: json['cols'] as int?,
      rows: json['rows'] as int?,
      cell: json['cell'] as int?,
      baseline: (json['baseline'] as num?)?.toDouble(),
      facing: json['facing'] as String?,
      animations: {
        for (final e in anims.entries)
          e.key: SpriteAnimation.fromJson(
            e.key,
            e.value! as Map<String, Object?>,
          ),
      },
      hasFruit: json['fruit'] as bool? ?? false,
      props: json['props'] == null
          ? null
          : PropSheet.fromJson(json['props']! as Map<String, Object?>),
      portrait: json['portrait'] as String?,
    );
  }

  final String code;
  final String id;
  final String group;
  final String name;

  /// Caminho relativo a `assets/` (ex.: `arte/animais/ovelha__anim.png`).
  final String file;

  /// P1, P2 ou P3.
  final String priority;

  /// Modelo de folha (A-T, A-V, A-A, A-I, A-G, PL-G, PL-P, H) ou nulo.
  final String? model;
  final int? cols;
  final int? rows;
  final int? cell;

  /// Linha do chão como fração da altura da célula (0,85).
  final double? baseline;
  final String? facing;
  final Map<String, SpriteAnimation> animations;
  final bool hasFruit;

  /// Folha de objetos do personagem (a arca de Noé, o cajado...).
  final PropSheet? props;

  /// Retrato de busto (herbário e loja), relativo a `assets/`.
  final String? portrait;

  /// Caminho do asset dentro do app.
  String get assetPath => 'assets/$file';

  /// Folha com grade definida (as camadas de cenário C07–C09 não têm).
  bool get hasGrid => cols != null && rows != null && cell != null;

  int? get width => hasGrid ? cols! * cell! : null;
  int? get height => hasGrid ? rows! * cell! : null;
}

/// O manifesto inteiro.
final class SpriteManifest {
  const new({required this.version, required this.sheets});

  factory parse(String source) {
    final json = jsonDecode(source) as Map<String, Object?>;
    final list = json['sprites']! as List<Object?>;
    return SpriteManifest(
      version: json['version']! as int,
      sheets: [
        for (final s in list) SpriteSheet.fromJson(s! as Map<String, Object?>),
      ],
    );
  }

  final int version;
  final List<SpriteSheet> sheets;

  SpriteSheet? byCode(String code) {
    for (final s in sheets) {
      if (s.code == code) return s;
    }
    return null;
  }
}
