import 'dart:io';

import 'package:bible_garden/data/db/app_database.dart';
import 'package:bible_garden/data/db/db_key.dart';
import 'package:bible_garden/data/db/db_open.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  late Directory dir;
  setUp(() => dir = Directory.systemTemp.createTempSync('bg_db_'));
  tearDown(() => dir.deleteSync(recursive: true));

  test('chave nova tem 32 bytes em hexadecimal', () {
    final k = DbKeyStore.generateHexKey();
    expect(k, matches(RegExp(r'^[0-9a-f]{64}$')));
    expect(DbKeyStore.generateHexKey(), isNot(k));
  });

  test('o arquivo do banco fica cifrado e só abre com a chave certa', () async {
    final file = File('${dir.path}/t.db');
    final key = DbKeyStore.generateHexKey();
    final db = AppDatabase(
      NativeDatabase(file, setup: (d) => applyCipherKey(d, key)),
    );
    await db
        .into(db.prayerRequests)
        .insert(
          PrayerRequestsCompanion.insert(
            body: 'pedido secreto',
            createdAt: DateTime(2026),
          ),
        );
    await db.close();

    final bytes = file.readAsBytesSync();
    expect(String.fromCharCodes(bytes), isNot(contains('pedido secreto')));
    expect(String.fromCharCodes(bytes.take(15)), isNot('SQLite format 3'));

    // sem chave
    final plain = sqlite3.open(file.path);
    expect(
      () => plain.select('SELECT count(*) FROM sqlite_master'),
      throwsA(isA<SqliteException>()),
    );
    plain.close();

    // chave errada
    final wrong = sqlite3.open(file.path);
    expect(
      () => applyCipherKey(wrong, DbKeyStore.generateHexKey()),
      throwsA(isA<SqliteException>()),
    );
    wrong.close();

    // chave certa
    final ok = AppDatabase(
      NativeDatabase(file, setup: (d) => applyCipherKey(d, key)),
    );
    final rows = await ok.select(ok.prayerRequests).get();
    expect(rows.single.body, 'pedido secreto');
    await ok.wipe();
    expect(await ok.select(ok.prayerRequests).get(), isEmpty);
    await ok.close();
  });
}
