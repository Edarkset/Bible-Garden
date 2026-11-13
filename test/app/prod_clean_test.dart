import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// O código da versão mod não pode chegar ao build prod (especificação,
/// seção 2). Ele só pode ser alcançado por `router.dart`, atrás de `isDev`,
/// que é constante e some na compilação. O CI ainda confere o binário.
void main() {
  final libFiles = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .where((f) => !f.path.contains('/l10n/gen/'));

  test('só lib/app/router.dart importa lib/features/debug', () {
    final importers = [
      for (final f in libFiles)
        if (!f.path.contains('lib/features/debug/') &&
            f.readAsStringSync().contains('features/debug/'))
          f.path,
    ];
    expect(importers, ['lib/app/router.dart']);
  });

  test('o uso das rotas de teste está protegido por isDev', () {
    final router = File('lib/app/router.dart').readAsStringSync();
    expect(router, contains('if (isDev) ...debugRoutes'));
  });
}
