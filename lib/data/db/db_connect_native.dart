import 'package:bible_garden/data/db/app_database.dart';
import 'package:bible_garden/data/db/db_open.dart';

/// Celular: banco inteiro cifrado, chave no Keychain/Keystore.
Future<AppDatabase> openPlatformDatabase() => openAppDatabase();
