import 'package:bible_garden/core/calendar.dart';
import 'package:bible_garden/data/bible/bible_models.dart';
import 'package:bible_garden/data/bible/bible_repository.dart';
import 'package:bible_garden/data/content/content.dart';
import 'package:bible_garden/data/db/app_database.dart';
import 'package:bible_garden/data/repositories/garden_repository.dart';
import 'package:bible_garden/data/sprites/sprite_manifest.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show StreamProviderFamily;

/// Dependências abertas no início (ver bootstrap.dart). Nos testes, são
/// substituídas com `overrides`.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('databaseProvider sem override'),
);
final contentProvider = Provider<GameContent>(
  (ref) => throw UnimplementedError('contentProvider sem override'),
);
final bibleIndexProvider = Provider<TranslationIndex>(
  (ref) => throw UnimplementedError('bibleIndexProvider sem override'),
);
final spriteManifestProvider = Provider<SpriteManifest>(
  (ref) => throw UnimplementedError('spriteManifestProvider sem override'),
);

/// Relógio do app (a versão mod pode adiantar dias).
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final bibleRepositoryProvider = Provider<BibleRepository>(
  (ref) => BibleRepository(ref.watch(bibleIndexProvider)),
);

final gardenRepositoryProvider = Provider<GardenRepository>(
  (ref) => GardenRepository(
    ref.watch(databaseProvider),
    ref.watch(contentProvider),
    clock: ref.watch(clockProvider),
  ),
);

final balanceProvider = StreamProvider<int>(
  (ref) => ref.watch(gardenRepositoryProvider).watchBalance(),
);

final StreamProviderFamily<Set<int>, String> readChaptersProvider =
    StreamProvider.family<Set<int>, String>(
      (ref, book) =>
          ref.watch(gardenRepositoryProvider).watchReadChapters(book),
    );

final StreamProviderFamily<String?, String> settingProvider =
    StreamProvider.family<String?, String>(
      (ref, key) => ref.watch(gardenRepositoryProvider).watchSetting(key),
    );

/// Hoje, pelo relógio do app.
final todayProvider = Provider<String>(
  (ref) => isoDay(ref.watch(clockProvider)()),
);
