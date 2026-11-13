/// Abre o banco do jeito certo para cada plataforma: SQLite cifrado no
/// celular; SQLite em WebAssembly no navegador (versão de demonstração).
library;

export 'db_connect_native.dart'
    if (dart.library.js_interop) 'db_connect_web.dart';
