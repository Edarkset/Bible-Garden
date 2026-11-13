import 'package:bible_garden/app/providers.dart';
import 'package:bible_garden/data/bible/bible_models.dart';
import 'package:bible_garden/data/bible/bible_repository.dart';
import 'package:bible_garden/data/content/content.dart';
import 'package:bible_garden/data/content/devotionals.dart';
import 'package:bible_garden/data/db/app_database.dart';
import 'package:bible_garden/data/db/db_open.dart';
import 'package:bible_garden/data/sprites/sprite_manifest.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

/// Abre o banco cifrado e carrega os dados fixos antes da primeira tela.
Future<List<Override>> bootstrap({
  AssetBundle? bundle,
  Future<AppDatabase> Function()? openDb,
}) async {
  final b = bundle ?? rootBundle;
  final results = await Future.wait<Object>([
    (openDb ?? openAppDatabase)(),
    b.loadString('assets/data/conteudo.json'),
    BibleRepository.loadIndex(bundle: b),
    b.loadString('assets/data/sprites_manifest.json'),
    b.loadString('assets/data/devocionais.json'),
  ]);
  return [
    databaseProvider.overrideWithValue(results[0] as AppDatabase),
    contentProvider.overrideWithValue(GameContent.parse(results[1] as String)),
    bibleIndexProvider.overrideWithValue(results[2] as TranslationIndex),
    spriteManifestProvider.overrideWithValue(
      SpriteManifest.parse(results[3] as String),
    ),
    devotionalsProvider.overrideWithValue(
      Devotional.parseAll(results[4] as String),
    ),
  ];
}
