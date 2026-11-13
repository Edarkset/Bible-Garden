import 'package:bible_garden/data/db/db_open.dart';
import 'package:bible_garden/data/repositories/garden_repository.dart';
import 'package:bible_garden/data/sync/sync_payload.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fixtures.dart';

void main() {
  test('nenhuma tabela privada está entre as sincronizáveis', () {
    expect(syncableTables.intersection(privateTables), isEmpty);
    final db = openMemoryDatabase();
    addTearDown(db.close);
    final all = {for (final t in db.allTables) t.actualTableName};
    // toda tabela do banco foi classificada: ou sobe, ou é privada
    expect(all.difference(syncableTables.union(privateTables)), {
      'animals',
      'characters',
      'crown_stones',
    });
  });

  test(
    'o pacote leva leitura e jardim; nunca oração, pedido ou diário',
    () async {
      final clock = FakeClock(DateTime(2026, 11, 13, 8));
      final repo = GardenRepository(
        openMemoryDatabase(),
        testContent,
        clock: clock.call,
      );
      addTearDown(repo.db.close);
      await repo.completeChapter(
        book: 'GEN',
        chapter: 1,
        chaptersInBook: 50,
        minutes: 4,
        method: 'app',
      );
      await repo.recordPrayer(minutes: 5, guided: false);
      await repo.addPrayerRequest('saúde da vovó');
      await repo.recordDevotional(note: 'segredo do meu coração');
      await repo.setSetting('especie.GEN', 'figueira');
      await repo.setSetting('lembrete.hora', '07:00');
      await repo.credit(300, reason: 'ajuste_dev');

      final p = await buildSyncPayload(repo.db);
      final all = [
        ...p.chapterReads,
        ...p.gardenSurface,
        ...p.ownedItems,
        ...p.ledger,
      ].toString();
      expect(all, isNot(contains('vovó')));
      expect(all, isNot(contains('segredo')));
      expect(all, isNot(contains('07:00')));
      expect(p.chapterReads.single['chapter'], 1);
      expect(p.gardenSurface.single['species'], 'figueira');
      expect(p.ledger.map((l) => l['reason']), isNot(contains('ajuste_dev')));
      expect(p.ledger.map((l) => l['reason']), contains('porcao'));
    },
  );
}
