import 'package:bible_garden/data/db/app_database.dart';
import 'package:drift/drift.dart';

/// Tabelas do banco local que podem ir para o servidor. Qualquer outra
/// (orações, pedidos, diário, registro de leitura com horários, ajustes)
/// nunca sai do aparelho.
const Set<String> syncableTables = {
  'chapter_reads',
  'owned_items',
  'orvalho_ledger',
  'placements',
};

/// Tabelas que jamais podem ser sincronizadas (conferido em teste).
const Set<String> privateTables = {
  'prayers',
  'prayer_requests',
  'journal_entries',
  'reading_log',
  'day_activities',
  'settings',
  'store_purchases',
};

/// O que sobe na sincronização: leitura, superfície do jardim e economia.
final class SyncPayload {
  const new({
    required this.chapterReads,
    required this.gardenSurface,
    required this.ownedItems,
    required this.ledger,
  });

  final List<Map<String, Object?>> chapterReads;
  final List<Map<String, Object?>> gardenSurface;
  final List<Map<String, Object?>> ownedItems;
  final List<Map<String, Object?>> ledger;
}

/// Monta o pacote só com o permitido. A espécie da árvore de cada livro vem
/// das preferências `especie.<LIVRO>`, sem levar nenhuma outra preferência.
Future<SyncPayload> buildSyncPayload(AppDatabase db) async {
  final reads = await db.select(db.chapterReads).get();
  final placements = await db.select(db.placements).get();
  final species = await (db.select(
    db.settings,
  )..where((t) => t.key.like('especie.%'))).get();
  final owned = await db.select(db.ownedItems).get();
  final ledger = await db.select(db.orvalhoLedger).get();
  final books = {
    for (final p in placements) p.book,
    for (final s in species) s.key.substring(8),
  };
  return SyncPayload(
    chapterReads: [
      for (final r in reads)
        {
          'book': r.book,
          'chapter': r.chapter,
          'first_read_at': r.firstReadAt.toUtc().toIso8601String(),
          'times_read': r.timesRead,
        },
    ],
    gardenSurface: [
      for (final b in books)
        {
          'book': b,
          'species': [
            for (final s in species)
              if (s.key == 'especie.$b') s.value,
          ].firstOrNull,
          'placements': [
            for (final p in placements)
              if (p.book == b) {'item': p.itemId, 'x': p.x, 'y': p.y},
          ],
        },
    ],
    ownedItems: [
      for (final o in owned)
        if (o.source != 'pacote')
          {
            'item_id': o.itemId,
            'source': o.source,
            'acquired_at': o.acquiredAt.toUtc().toIso8601String(),
          },
    ],
    ledger: [
      for (final l in ledger)
        // Pacote pago só o servidor credita; ajuste da versão mod não sobe.
        if (l.reason != 'pacote' && l.reason != 'ajuste_dev')
          {
            'device_entry_id': l.id,
            'at': l.at.toUtc().toIso8601String(),
            'delta': l.delta,
            'reason': l.reason,
            'ref': l.ref,
          },
    ],
  );
}
