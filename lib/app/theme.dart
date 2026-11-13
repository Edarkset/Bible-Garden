import 'package:material_ui/material_ui.dart';

/// Cores do protótipo (tokens `--bg`, `--surface`, `--ink`...).
abstract final class BgColors {
  static const ipe = Color(0xFFC98F12);
  static const ipeDark = Color(0xFFF0C24E);
  static const orvalho = Color(0xFF3E8FA6);
  static const orvalhoDark = Color(0xFF7CC3D2);
  static const folha = Color(0xFF3F7A45);
  static const folhaDark = Color(0xFF8BBF5E);
  static const jabuticaba = Color(0xFF4B2A45);
}

ThemeData buildTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme = ColorScheme(
    brightness: brightness,
    primary: dark ? BgColors.orvalhoDark : const Color(0xFF2F7488),
    onPrimary: dark ? const Color(0xFF0F1719) : Colors.white,
    secondary: dark ? BgColors.folhaDark : BgColors.folha,
    onSecondary: dark ? const Color(0xFF0F1719) : Colors.white,
    tertiary: dark ? BgColors.ipeDark : BgColors.ipe,
    onTertiary: const Color(0xFF22302A),
    error: const Color(0xFFB3261E),
    onError: Colors.white,
    surface: dark ? const Color(0xFF172126) : const Color(0xFFF5F7F1),
    onSurface: dark ? const Color(0xFFE5ECE4) : const Color(0xFF22302A),
    onSurfaceVariant: dark ? const Color(0xFF9BAAA2) : const Color(0xFF5B6B62),
    outline: dark ? const Color(0xFF2B3A40) : const Color(0xFFCAD5C6),
  );
  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: dark
        ? const Color(0xFF0F1719)
        : const Color(0xFFE6EDE2),
    // Áreas de toque de no mínimo 44 px (especificação, seção 8).
    materialTapTargetSize: MaterialTapTargetSize.padded,
    visualDensity: VisualDensity.standard,
  );
}
