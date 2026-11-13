import 'package:bible_garden/core/growth.dart';

/// Um personagem é liberado quando todos os capítulos da história dele foram
/// lidos. Dinheiro nunca libera antes disso.
bool characterUnlocked({
  required Set<int> readInBook,
  required List<int> requiredChapters,
}) => requiredChapters.isNotEmpty && readInBook.containsAll(requiredChapters);

/// O animal do livro chega sozinho, de graça, quando a árvore do livro vira
/// "Árvore" (como a pomba do protótipo, que vem quando a árvore dá fruto).
bool bookAnimalArrives(Stage stage) => stage.index >= Stage.arvore.index;

/// Pedras da coroa por tamanho do livro: 1, 2 ou 3.
int crownStonesForBook(int chapters) => chapters >= 40
    ? 3
    : chapters >= 10
    ? 2
    : 1;

/// Pedras da coroa: 1 por canteiro, 5 por bioma e 12 pela Bíblia completa.
const int crownStonesPerSection = 1;
const int crownStonesPerBiome = 5;
const int crownStonesBible = 12;
