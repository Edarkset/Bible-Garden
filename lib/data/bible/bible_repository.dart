import 'dart:collection';

import 'package:bible_garden/data/bible/bible_models.dart';
import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/services.dart';

/// Lê os livros da Bíblia Livre dos assets, sob demanda.
///
/// O JSON grande é decodificado fora da thread da tela (Salmos tem ~400 KB;
/// no navegador, `compute` roda na mesma thread) e os últimos
/// livros abertos ficam em memória.
final class BibleRepository {
  new(
    this.index, {
    AssetBundle? bundle,
    this.cacheSize = 4,
    this.isolateThreshold = 50000,
  }) : _bundle = bundle ?? rootBundle;

  final TranslationIndex index;
  final AssetBundle _bundle;
  final int cacheSize;

  /// Acima deste tamanho (em caracteres) o JSON é lido noutra isolate.
  final int isolateThreshold;
  final LinkedHashMap<String, BookText> _cache = LinkedHashMap();

  static Future<TranslationIndex> loadIndex({AssetBundle? bundle}) async =>
      TranslationIndex.parse(
        await (bundle ?? rootBundle).loadString(
          'assets/bible/blivre/index.json',
        ),
      );

  /// O livro tem texto nesta tradução? (Os deuterocanônicos não têm.)
  bool hasBook(String id) => index.livro(id) != null;

  Future<BookText> book(String id) async {
    final cached = _cache.remove(id);
    if (cached != null) return _cache[id] = cached;
    if (!hasBook(id)) {
      throw StateError('O livro $id não está na Bíblia Livre.');
    }
    final raw = await _bundle.loadString(
      'assets/bible/blivre/$id.json',
      cache: false,
    );
    final book = raw.length > isolateThreshold
        ? await compute(BookText.parse, raw)
        : BookText.parse(raw);
    _cache[id] = book;
    while (_cache.length > cacheSize) {
      _cache.remove(_cache.keys.first);
    }
    return book;
  }

  Future<Chapter> chapter(String book, int n) async =>
      (await this.book(book)).capitulos[n - 1];
}
