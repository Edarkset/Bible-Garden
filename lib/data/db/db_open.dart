import 'dart:io';

import 'package:bible_garden/data/db/app_database.dart';
import 'package:bible_garden/data/db/db_key.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

/// Aplica a chave e confirma que a biblioteca nativa cifra de verdade.
/// Falha alto em vez de gravar dados pessoais sem cifra.
void applyCipherKey(Database db, String hexKey) {
  final cipher = db.select('PRAGMA cipher').firstOrNull;
  if (cipher == null) {
    throw StateError('SQLite sem suporte a cifra: dados não seriam cifrados.');
  }
  db
    ..execute('PRAGMA cipher = chacha20')
    ..execute("PRAGMA key = \"x'$hexKey'\"")
    // Lê o esquema: com chave errada isto falha (arquivo ilegível).
    ..select('SELECT count(*) FROM sqlite_master');
}

/// Abre o banco do app, cifrado, numa isolate de fundo (não trava a tela).
Future<AppDatabase> openAppDatabase({DbKeyStore? keys}) async {
  final key = await (keys ?? DbKeyStore()).readOrCreate();
  final dir = await getApplicationSupportDirectory();
  final file = File(p.join(dir.path, 'bible_garden.db'));
  return AppDatabase(
    NativeDatabase.createInBackground(
      file,
      setup: (db) => applyCipherKey(db, key),
    ),
  );
}

/// Banco em memória para testes e para a versão mod.
AppDatabase openMemoryDatabase() => AppDatabase(NativeDatabase.memory());
