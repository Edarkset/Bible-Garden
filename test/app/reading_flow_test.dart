import 'package:bible_garden/data/db/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/app_harness.dart';

Future<int> balance(WidgetTester tester, AppDatabase db) async =>
    (await tester.runAsync(() async {
      final rows = await db.select(db.orvalhoLedger).get();
      return rows.fold<int>(0, (a, r) => a + r.delta);
    }))!;

/// Arrasta o leitor até [target] aparecer inteiro na tela.
Future<void> scrollTo(WidgetTester tester, Finder target) async {
  for (var i = 0; i < 40; i++) {
    if (target.evaluate().isNotEmpty) {
      final r = tester.getRect(target);
      if (r.top > 60 && r.bottom < 880) return;
    }
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -400));
    await tester.pump(const Duration(milliseconds: 200));
  }
}

void main() {
  testWidgets(
    'leitura rápida é recusada com gentileza; Bíblia impressa conta',
    (tester) async {
      final db = await pumpApp(tester);

      await tester.tap(find.textContaining('Ler Gênesis 1'));
      await settle(tester);
      expect(find.text('Gênesis 1'), findsOneWidget);
      expect(find.textContaining('No princípio criou Deus'), findsOneWidget);

      // concluir sem ler
      await scrollTo(tester, find.text('Concluir capítulo'));
      await tester.tap(find.text('Concluir capítulo'));
      await tester.pump();
      expect(
        find.textContaining('passou rápido por alguns trechos'),
        findsOneWidget,
      );
      expect(await balance(tester, db), 0);

      // li na minha Bíblia
      await scrollTo(tester, find.text('Li na minha Bíblia'));
      await tester.tap(find.text('Li na minha Bíblia'));
      await settle(tester);
      await tester.tap(find.text('Confirmar'));
      await settle(tester, rounds: 8);

      expect(find.text('Meu jardim'), findsOneWidget);
      expect(find.textContaining('Gênesis 1 lido com calma.'), findsOneWidget);
      expect(find.textContaining('Sua semente brotou'), findsOneWidget);
      expect(await balance(tester, db), 20);
      expect(find.textContaining('Ler Gênesis 2'), findsOneWidget);
    },
  );

  testWidgets('lista de livros mostra 66 livros por bioma e abre capítulos', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.text('Ler').last);
    await settle(tester);
    expect(find.text('Ler a Bíblia'), findsOneWidget);
    expect(find.text('Pentateuco'), findsOneWidget);
    await tester.tap(find.text('Gênesis'));
    await settle(tester);
    expect(find.text('Canteiro Origens'), findsOneWidget);
    expect(find.text('Canteiro José'), findsOneWidget);
  });
}
