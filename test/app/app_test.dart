import 'package:bible_garden/app/app.dart';
import 'package:bible_garden/app/flavor.dart';
import 'package:bible_garden/features/debug/debug_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/app_harness.dart';

void main() {
  test('sem --flavor o app é prod (build esquecido nunca vira mod)', () {
    expect(currentFlavor, Flavor.prod);
    expect(isDev, isFalse);
  });

  testWidgets('o app abre no jardim, em português, com o crédito da Bíblia', (
    tester,
  ) async {
    await pumpApp(tester);
    expect(find.text('Meu jardim'), findsOneWidget);
    expect(find.textContaining('Bíblia Livre'), findsWidgets);
    expect(find.textContaining('Ler Gênesis 1'), findsOneWidget);
    // Em prod não há selo nem botão da versão mod.
    expect(find.byType(Banner), findsNothing);
    expect(find.text('Abrir ferramentas de teste'), findsNothing);
  });

  testWidgets('tela da versão mod renderiza', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('pt', 'BR'),
        localizationsDelegates: appLocalizationsDelegates,
        supportedLocales: appSupportedLocales,
        home: DebugScreen(),
      ),
    );
    expect(find.text('Ferramentas da versão mod'), findsOneWidget);
  });
}
