import 'dart:io';

import 'package:bible_garden/core/rules.dart';
import 'package:flutter_test/flutter_test.dart';

/// Lê um número do bloco `RULES` de docs/referencia/core.js.
num _ref(String source, String key) {
  final m = RegExp('$key:\\s*([0-9.]+)').firstMatch(source);
  if (m == null) throw StateError('$key não encontrado em core.js');
  return num.parse(m.group(1)!);
}

void main() {
  final core = File('docs/referencia/core.js').readAsStringSync();

  group('Rules é fiel a core.js', () {
    test('limites de leitura', () {
      expect(Rules.blockMaxWpm, _ref(core, 'BLOCK_MAX_WPM'));
      expect(Rules.chapterMaxWpm, _ref(core, 'CHAPTER_MAX_WPM'));
      expect(Rules.blockOkShare, _ref(core, 'BLOCK_OK_SHARE'));
      expect(Rules.idlePause.inMilliseconds, _ref(core, 'IDLE_PAUSE_MS'));
      expect(Rules.readMinForPresence, _ref(core, 'READ_MIN_FOR_PRESENCE'));
    });

    test('oração', () {
      expect(Rules.prayerMinMinutes, _ref(core, 'PRAYER_MIN_MIN'));
      expect(Rules.prayerGrace.inMilliseconds, _ref(core, 'PRAYER_GRACE_MS'));
    });

    test('porção diária', () {
      expect(Rules.porcao.presenca, _ref(core, 'presenca'));
      expect(Rules.porcao.oracao, _ref(core, 'oracao'));
      expect(Rules.porcao.devocional, _ref(core, 'devocional'));
      expect(Rules.porcao.teto, _ref(core, 'teto'));
    });
  });

  test('lib/core não importa Flutter (regras puras)', () {
    final files = Directory('lib/core')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'));
    for (final f in files) {
      expect(
        f.readAsStringSync(),
        isNot(contains('package:flutter')),
        reason: f.path,
      );
    }
  });
}
