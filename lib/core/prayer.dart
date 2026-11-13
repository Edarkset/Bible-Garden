import 'dart:math' as math;

import 'package:bible_garden/core/rules.dart';

/// A oração conta quando foi até o fim do tempo escolhido (com meio segundo
/// de folga). Desistir não registra. A recompensa é do ato, não dos minutos.
bool prayerCounts(num plannedMin, num elapsedMs, {required bool abandoned}) {
  if (abandoned) return false;
  final minMs = math.min(plannedMin, Rules.prayerMinMinutes) * 60000 - 500;
  return elapsedMs >= minMs && elapsedMs >= plannedMin * 60000 - 500;
}

/// Durações oferecidas, em minutos.
const List<int> prayerDurations = [2, 5, 10, 15];

/// Etapas do modo guiado.
enum PrayerStep { adoracao, confissao, gratidao, suplica }
