import 'package:bible_garden/data/db/tables.dart';
import 'package:drift/drift.dart';

part 'app_database.g.dart';

/// Banco local do app. No aparelho ele é aberto cifrado (ver db_open.dart).
@DriftDatabase(
  tables: [
    ChapterReads,
    ReadingLog,
    DayActivities,
    OrvalhoLedger,
    OwnedItems,
    Placements,
    Animals,
    Characters,
    Prayers,
    PrayerRequests,
    JournalEntries,
    CrownStones,
    StorePurchases,
    Settings,
  ],
)
class AppDatabase extends _$AppDatabase {
  new(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Apaga todos os dados (Ajustes → apagar meus dados).
  Future<void> wipe() => transaction(() async {
    for (final t in allTables) {
      await delete(t).go();
    }
  });
}
