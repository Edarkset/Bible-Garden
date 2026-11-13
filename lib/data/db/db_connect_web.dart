import 'package:bible_garden/data/db/app_database.dart';
import 'package:drift/wasm.dart';

/// Navegador: SQLite em WebAssembly, guardado no próprio navegador (OPFS ou
/// IndexedDB). Serve para a demonstração no GitHub Pages; o navegador não
/// tem um cofre de chaves como o celular, então aqui o banco não é cifrado.
Future<AppDatabase> openPlatformDatabase() async {
  final result = await WasmDatabase.open(
    databaseName: 'bible_garden',
    sqlite3Uri: Uri.parse('sqlite3.wasm'),
    driftWorkerUri: Uri.parse('drift_worker.js'),
  );
  return AppDatabase(result.resolvedExecutor);
}
