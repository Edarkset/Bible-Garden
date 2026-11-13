import 'dart:math' as math;
import 'dart:ui';

/// Luz do dia pelo relógio do aparelho.
final class DayCycle {
  const new(this.hour);

  /// Hora local com fração (ex.: 18.5 = 18h30).
  final double hour;

  /// 0 = dia pleno, 1 = noite fechada.
  double get night {
    if (hour >= 7 && hour <= 17) return 0;
    if (hour >= 20 || hour <= 4.5) return 1;
    if (hour < 7) return 1 - (hour - 4.5) / 2.5;
    return (hour - 17) / 3;
  }

  /// Dourado do amanhecer e do fim de tarde (0 a 1).
  double get golden {
    double bump(double c) => math.max(0, 1 - (hour - c).abs() / 1.5);
    return math.max(bump(6.5), bump(17.8));
  }

  bool get isNight => night > 0.6;

  /// Lanterna acende ao anoitecer.
  bool get lanternOn => night > 0.3;

  /// Cor multiplicada sobre o jardim.
  Color get tint {
    const day = Color(0xFFFFFFFF);
    const dusk = Color(0xFFFFD9A8);
    const nightC = Color(0xFF6E7FB8);
    final base = Color.lerp(day, dusk, golden)!;
    return Color.lerp(base, nightC, night)!;
  }

  /// Direção da sombra (radianos) e comprimento relativo: longa de manhã
  /// e no fim da tarde, curta ao meio-dia.
  ({double angle, double length}) get shadow {
    final h = hour.clamp(6, 18);
    final p = (h - 6) / 12; // 0 manhã, 1 tarde
    return (
      angle: math.pi * (0.15 + 0.7 * (1 - p)),
      length: 0.35 + 0.9 * (2 * (p - 0.5)).abs(),
    );
  }

  /// Animais diurnos dormem à noite; coruja e vaga-lumes aparecem.
  bool activeAt({required bool nocturnal}) => nocturnal ? isNight : !isNight;
}
