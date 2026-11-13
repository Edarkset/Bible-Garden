import 'dart:async';
import 'dart:io';

import 'package:bible_garden/app/app.dart';
import 'package:bible_garden/app/providers.dart';
import 'package:bible_garden/data/bible/bible_models.dart';
import 'package:bible_garden/data/bible/bible_repository.dart';
import 'package:bible_garden/data/db/app_database.dart';
import 'package:bible_garden/data/db/db_open.dart';
import 'package:bible_garden/data/sprites/sprite_manifest.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'fixtures.dart';

final TranslationIndex _index = TranslationIndex.parse(
  File('assets/bible/blivre/index.json').readAsStringSync(),
);
final SpriteManifest _manifest = SpriteManifest.parse(
  File('assets/data/sprites_manifest.json').readAsStringSync(),
);

/// Sobe o app inteiro com banco em memória. Devolve o banco para conferir.
Future<AppDatabase> pumpApp(
  WidgetTester tester, {
  DateTime Function()? clock,
}) async {
  final db = openMemoryDatabase();
  addTearDown(() async {
    // Desmonta o app (cancela as consultas vivas) e fecha o banco avançando o
    // relógio simulado até o fechamento terminar.
    await tester.pumpWidget(const SizedBox.shrink());
    var closed = false;
    unawaited(db.close().whenComplete(() => closed = true));
    for (var i = 0; i < 100 && !closed; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 5)),
      );
      await tester.pump(const Duration(milliseconds: 50));
    }
  });
  await tester.binding.setSurfaceSize(const Size(400, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        contentProvider.overrideWithValue(testContent),
        bibleIndexProvider.overrideWithValue(_index),
        spriteManifestProvider.overrideWithValue(_manifest),
        bibleRepositoryProvider.overrideWithValue(
          BibleRepository(_index, isolateThreshold: 1 << 30),
        ),
        if (clock != null) clockProvider.overrideWithValue(clock),
      ],
      child: const BibleGardenApp(),
    ),
  );
  await settle(tester);
  return db;
}

/// Espera o banco (assíncrono de verdade) e os quadros.
Future<void> settle(WidgetTester tester, {int rounds = 5}) async {
  for (var i = 0; i < rounds; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump(const Duration(milliseconds: 100));
  }
}
