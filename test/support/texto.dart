import 'dart:convert';
import 'dart:io';

/// Texto de Gênesis 1 e 2 usado pelos testes do protótipo.
final Map<String, Object?> _texto = jsonDecode(
  File('docs/referencia/texto.json').readAsStringSync(),
) as Map<String, Object?>;

List<String> genChapter(int c) =>
    ((_texto['GEN']! as Map<String, Object?>)['$c']! as List<Object?>)
        .cast<String>();
