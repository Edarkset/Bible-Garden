import 'package:bible_garden/app/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ReaderTheme { claro, sepia, noturno }

/// Preferências de leitura (salvas no banco).
final class ReaderPrefs {
  const new({
    this.fontSize = 18,
    this.theme = ReaderTheme.claro,
    this.translationId = 'blivre',
    this.sensor = false,
    this.catholicCanon = false,
  });

  static const double minFont = 14;
  static const double maxFont = 32;

  final double fontSize;
  final ReaderTheme theme;
  final String translationId;
  final bool sensor;
  final bool catholicCanon;
}

const _kFont = 'leitura.fonte';
const _kTheme = 'leitura.tema';
const _kTranslation = 'leitura.traducao';
const _kSensor = 'leitura.sensor';
const _kCanon = 'canone';

final readerPrefsProvider = Provider<ReaderPrefs>((ref) {
  String? v(String k) => ref.watch(settingProvider(k)).value;
  return ReaderPrefs(
    fontSize: double.tryParse(v(_kFont) ?? '') ?? 18,
    theme: ReaderTheme.values.firstWhere(
      (t) => t.name == v(_kTheme),
      orElse: () => ReaderTheme.claro,
    ),
    translationId: v(_kTranslation) ?? 'blivre',
    sensor: v(_kSensor) == '1',
    catholicCanon: v(_kCanon) == '73',
  );
});

/// Ações sobre as preferências.
extension ReaderPrefsActions on WidgetRef {
  Future<void> setFont(double size) => read(gardenRepositoryProvider)
      .setSetting(
        _kFont,
        size.clamp(ReaderPrefs.minFont, ReaderPrefs.maxFont).toString(),
      );
  Future<void> setReaderTheme(ReaderTheme t) =>
      read(gardenRepositoryProvider).setSetting(_kTheme, t.name);
  Future<void> setTranslation(String id) =>
      read(gardenRepositoryProvider).setSetting(_kTranslation, id);
  Future<void> setSensor({required bool on}) =>
      read(gardenRepositoryProvider).setSetting(_kSensor, on ? '1' : '0');
  Future<void> setCatholicCanon({required bool on}) =>
      read(gardenRepositoryProvider).setSetting(_kCanon, on ? '73' : '66');
}
