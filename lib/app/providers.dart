import 'package:bible_garden/core/calendar.dart';
import 'package:bible_garden/data/bible/bible_models.dart';
import 'package:bible_garden/data/bible/bible_repository.dart';
import 'package:bible_garden/data/content/content.dart';
import 'package:bible_garden/data/content/devotionals.dart';
import 'package:bible_garden/data/db/app_database.dart';
import 'package:bible_garden/data/repositories/garden_repository.dart';
import 'package:bible_garden/data/sprites/sprite_manifest.dart';
import 'package:bible_garden/services/reminders.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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
final devotionalsProvider = Provider<List<Devotional>>(
  (ref) => throw UnimplementedError('devotionalsProvider sem override'),
);
final spriteManifestProvider = Provider<SpriteManifest>(
  (ref) => throw UnimplementedError('spriteManifestProvider sem override'),
);

/// Dias adiantados no relógio do app. Sempre 0 na versão das lojas: só a
/// tela da versão mod muda este valor.
final class ClockOffset extends Notifier<int> {
  @override
  int build() => 0;

  void advance(int days) => state += days;
}

final NotifierProvider<ClockOffset, int> clockOffsetProvider =
    NotifierProvider<ClockOffset, int>(ClockOffset.new);

/// Relógio do app.
final Provider<DateTime Function()> clockProvider =
    Provider<DateTime Function()>((ref) {
      final offset = ref.watch(clockOffsetProvider);
      if (offset == 0) return DateTime.now;
      return () => DateTime.now().add(Duration(days: offset));
    });

/// Lembrete diário (substituído nos testes).
final Provider<Reminders> remindersProvider = Provider<Reminders>(
  (ref) => kIsWeb ? const NoReminders() : LocalReminders(),
);

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
