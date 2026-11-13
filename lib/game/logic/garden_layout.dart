import 'dart:math' as math;

/// Um ladrilho do jardim (coluna x, linha y), de 0 a 11.
typedef Tile = ({int x, int y});

/// O jardim de cada livro: 12 × 12 ladrilhos quadrados, visto de cima e de
/// lado. Alguns lugares são reservados (árvore, lago, caminho e pedras de
/// Ebenézer) e não aceitam decoração.
final class GardenLayout {
  const new();

  static const int size = 12;

  /// Pixels do mundo por ladrilho (12 × 18 = 216, no mundo de ~220 px).
  static const double tilePx = 18;
  static const double worldPx = size * tilePx;

  /// A árvore principal ocupa um bloco 4 × 3 no alto, ao centro.
  static const Tile treeBase = (x: 6, y: 4);
  static bool isTree(Tile t) => t.x >= 4 && t.x <= 7 && t.y >= 2 && t.y <= 4;

  /// O laguinho fica embaixo à direita (4 × 3).
  static bool isPond(Tile t) => t.x >= 7 && t.x <= 10 && t.y >= 8 && t.y <= 10;

  /// Caminho de pedras da borda de baixo até a árvore.
  static bool isPath(Tile t) => t.x == 5 && t.y >= 5;

  /// Pedras de Ebenézer, à esquerda da árvore.
  static bool isEbenezer(Tile t) => t.x == 2 && t.y >= 3 && t.y <= 5;

  static bool isReserved(Tile t) =>
      isTree(t) || isPond(t) || isPath(t) || isEbenezer(t);

  static bool inside(Tile t) =>
      t.x >= 0 && t.y >= 0 && t.x < size && t.y < size;

  /// Pode colocar um item aqui?
  static bool canPlace(Tile t, Set<Tile> occupied) =>
      inside(t) && !isReserved(t) && !occupied.contains(t);

  /// Centro do pé do ladrilho, em pixels do mundo.
  static ({double x, double y}) footOf(Tile t) =>
      (x: (t.x + 0.5) * tilePx, y: (t.y + 0.85) * tilePx);

  static Tile tileAt(double x, double y) => (
    x: (x / tilePx).floor().clamp(0, size - 1),
    y: (y / tilePx).floor().clamp(0, size - 1),
  );

  /// Pontos onde os seres andam (sem árvore e sem lago).
  static List<Tile> walkable() => [
    for (var y = 0; y < size; y++)
      for (var x = 0; x < size; x++)
        if (!isTree((x: x, y: y)) && !isPond((x: x, y: y))) (x: x, y: y),
  ];

  /// Ladrilho na beira do lago, para beber ou lavar as mãos.
  static Tile pondEdge(math.Random r) =>
      [(x: 6, y: 9), (x: 8, y: 7), (x: 9, y: 7), (x: 11, y: 9)][r.nextInt(4)];
}
