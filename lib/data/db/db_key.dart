import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Chave do banco cifrado: 32 bytes aleatórios, criada uma vez e guardada no
/// Keychain (iOS) ou no Keystore (Android). Nunca sai do aparelho.
final class DbKeyStore {
  new({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _name = 'bg_db_key_v1';
  final FlutterSecureStorage _storage;

  Future<String> readOrCreate() async {
    final existing = await _storage.read(key: _name);
    if (existing != null && existing.length == 64) return existing;
    final key = generateHexKey();
    await _storage.write(key: _name, value: key);
    return key;
  }

  /// Apaga a chave: o banco antigo fica ilegível (usado ao apagar os dados).
  Future<void> destroy() => _storage.delete(key: _name);

  /// 32 bytes de um gerador criptográfico, em hexadecimal.
  static String generateHexKey([Random? random]) {
    final r = random ?? Random.secure();
    return [
      for (var i = 0; i < 32; i++)
        r.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ].join();
  }
}
