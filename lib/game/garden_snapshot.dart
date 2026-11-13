import 'package:bible_garden/core/economy.dart';
import 'package:bible_garden/core/growth.dart';
import 'package:bible_garden/game/logic/garden_layout.dart';

/// Um ser que mora no jardim.
final class BeingSpec {
  const new({
    required this.code,
    required this.id,
    this.age = AnimalAge.adulto,
    this.nocturnal = false,
  });

  /// Código da folha no manifesto (A001, H01...).
  final String code;
  final String id;
  final AnimalAge age;
  final bool nocturnal;
}

/// Um item colocado num ladrilho.
final class PlacedItem {
  const new({required this.id, required this.itemId, required this.tile});

  final int id;
  final String itemId;
  final Tile tile;
}

/// Tudo o que o jogo precisa para desenhar o jardim de um livro. Vem do
/// banco; o jogo nunca grava nada sozinho.
final class GardenSnapshot {
  const new({
    required this.book,
    required this.plantCode,
    required this.growth,
    this.variant = ReadVariant.normal,
    this.beings = const [],
    this.placements = const [],
    this.raining = false,
    this.ebenezerStones = 0,
    this.hasPond = true,
    this.packs = const {},
  });

  final String book;

  /// Código da folha da planta principal (PL001...).
  final String plantCode;

  /// Crescimento contínuo 0 a 6.
  final double growth;
  final ReadVariant variant;
  final List<BeingSpec> beings;
  final List<PlacedItem> placements;
  final bool raining;
  final int ebenezerStones;
  final bool hasPond;

  /// Pacotes visuais ativos (comprados ou no provador).
  final Set<String> packs;

  Stage get stage => Stage.values[growth.floor().clamp(0, 6)];
}
