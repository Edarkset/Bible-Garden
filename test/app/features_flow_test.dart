import 'package:bible_garden/data/db/app_database.dart';
import 'package:bible_garden/services/telemetry.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../support/app_harness.dart';

Future<int> balance(WidgetTester tester, AppDatabase db) async =>
    (await tester.runAsync(() async {
      final rows = await db.select(db.orvalhoLedger).get();
      return rows.fold<int>(0, (a, r) => a + r.delta);
    }))!;

Future<String?> setting(WidgetTester tester, AppDatabase db, String k) =>
    tester.runAsync<String?>(() async {
      final r = await (db.select(
        db.settings,
      )..where((t) => t.key.equals(k))).getSingleOrNull();
      return r?.value;
    });

void main() {
  testWidgets('cadastro em 5 passos termina lendo Gênesis 1', (tester) async {
    final db = await pumpApp(tester, onboarded: false);
    expect(find.text('Bem-vindo ao Bible Garden'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Jardim da Ana');
    for (var i = 0; i < 4; i++) {
      await tester.tap(find.text('Continuar'));
      await tester.pump();
    }
    await tester.tap(find.text('Ler Gênesis 1'));
    await settle(tester, rounds: 8);
    expect(find.text('Gênesis 1'), findsOneWidget);
    expect(await setting(tester, db, 'cadastro.ok'), '1');
    expect(await setting(tester, db, 'jardim.nome'), 'Jardim da Ana');
    expect(await setting(tester, db, 'especie.GEN'), 'oliveira');
    final animals = await tester.runAsync(() => db.select(db.animals).get());
    expect(animals!.single.animalId, 'ovelha');
  });

  testWidgets('devocional do dia mostra o texto da Bíblia Livre e credita', (
    tester,
  ) async {
    final db = await pumpApp(tester);
    await tester.tap(find.text('Devocional'));
    await settle(tester, rounds: 8);
    expect(find.text('Devocional do dia'), findsOneWidget);
    expect(find.textContaining('BLIVRE'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'gratidão');
    await tester.scrollUntilVisible(
      find.text('Concluir devocional'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Concluir devocional'));
    await settle(tester, rounds: 6);
    // presença (20) + devocional (10)
    expect(await balance(tester, db), 30);
    final notes = await tester.runAsync(
      () => db.select(db.journalEntries).get(),
    );
    expect(notes!.single.body, 'gratidão');
  });

  testWidgets('loja: compra decoração com orvalho, nunca mexe na leitura', (
    tester,
  ) async {
    final db = await pumpApp(tester);
    await tester.runAsync(
      () => db
          .into(db.orvalhoLedger)
          .insert(
            OrvalhoLedgerCompanion.insert(
              at: DateTime(2026),
              delta: 100,
              reason: 'teste',
              ref: const Value(null),
            ),
          ),
    );
    await tester.tap(find.text('Cuidar'));
    await settle(tester, rounds: 6);
    expect(find.text('Cuidar do jardim'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Cogumelos'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    final row = find.ancestor(
      of: find.text('Cogumelos'),
      matching: find.byType(ListTile),
    );
    await tester.tap(
      find.descendant(of: row, matching: find.text('Liberar · 60')),
    );
    await settle(tester, rounds: 6);
    expect(await balance(tester, db), 40);
    final owned = await tester.runAsync(() => db.select(db.ownedItems).get());
    expect(owned!.single.itemId, 'cogumelos');
    final reads = await tester.runAsync(() => db.select(db.chapterReads).get());
    expect(reads, isEmpty);
  });

  testWidgets('pedido de oração respondido ergue Ebenézer', (tester) async {
    final db = await pumpApp(tester);
    await tester.tap(find.text('Orar').last);
    await settle(tester);
    await tester.tap(find.byTooltip('Novo pedido'));
    await settle(tester);
    await tester.enterText(find.byType(TextField).last, 'saúde da vovó');
    await tester.tap(find.text('Guardar'));
    await settle(tester, rounds: 6);
    expect(find.text('saúde da vovó'), findsOneWidget);
    await tester.tap(find.byType(PopupMenuButton<String>));
    await settle(tester);
    await tester.tap(find.text('Foi respondida'));
    await settle(tester, rounds: 6);
    final rows = await tester.runAsync(
      () => db.select(db.prayerRequests).get(),
    );
    expect(rows!.single.answeredAt, isNotNull);
  });

  test('erro enviado ao Sentry sai sem usuário, conteúdo nem trilha', () {
    final e = SentryEvent(
      user: SentryUser(id: '1', email: 'a@b.c'),
      message: SentryMessage('pedido: saúde da vovó'),
      breadcrumbs: [Breadcrumb(message: 'leu Gn 1')],
    );
    final out = scrub(e, Hint())!;
    expect(out.user, isNull);
    expect(out.breadcrumbs, isEmpty);
    expect(out.message!.formatted, '[removido]');
  });
}
