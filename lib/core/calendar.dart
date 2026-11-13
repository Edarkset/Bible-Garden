/// Datas sempre em dia civil local (sem hora).
DateTime _d(int y, int m, int d) => DateTime(y, m, d);

DateTime addDays(DateTime d, int n) => DateTime(d.year, d.month, d.day + n);

String isoDay(DateTime d) {
  String z(int n) => n.toString().padLeft(2, '0');
  return '${d.year}-${z(d.month)}-${z(d.day)}';
}

/// Páscoa pelo algoritmo gregoriano anônimo.
DateTime easter(int y) {
  final a = y % 19;
  final b = y ~/ 100;
  final c = y % 100;
  final d = b ~/ 4;
  final e = b % 4;
  final f = (b + 8) ~/ 25;
  final g = (b - f + 1) ~/ 3;
  final h = (19 * a + b - d - g + 15) % 30;
  final i = c ~/ 4;
  final k = c % 4;
  final l = (32 + 2 * e + 2 * i - h - k) % 7;
  final m = (a + 11 * h + 22 * l) ~/ 451;
  final month = (h + l - 7 * m + 114) ~/ 31;
  final day = ((h + l - 7 * m + 114) % 31) + 1;
  return _d(y, month, day);
}

/// 1º domingo do Advento: 4 domingos antes do Natal.
DateTime adventStart(int y) {
  final xmas = _d(y, 12, 25);
  final dow = xmas.weekday % 7; // 0 = domingo, como no JavaScript
  final lastSun = _d(y, 12, 25 - (dow == 0 ? 7 : dow));
  return _d(y, 12, lastSun.day - 21);
}

enum SeasonId { advento, natal, quaresma, pascoa, pentecostes, comum }

final class LiturgicalSeason {
  const new(this.id, this.nome, this.cor);

  final SeasonId id;
  final String nome;

  /// Cor ARGB.
  final int cor;
}

LiturgicalSeason liturgicalSeason(DateTime date) {
  final d = _d(date.year, date.month, date.day);
  final y = d.year;
  final e = easter(y);
  final ash = addDays(e, -46);
  final pent = addDays(e, 49);
  final adv = adventStart(y);
  final xmas = _d(y, 12, 25);
  if (!d.isBefore(adv) && d.isBefore(xmas)) {
    return const LiturgicalSeason(SeasonId.advento, 'Advento', 0xFF6B4C8A);
  }
  if (!d.isBefore(xmas) || !d.isAfter(_d(y, 1, 6))) {
    return const LiturgicalSeason(SeasonId.natal, 'Natal', 0xFFD9B44A);
  }
  if (!d.isBefore(ash) && d.isBefore(e)) {
    return const LiturgicalSeason(SeasonId.quaresma, 'Quaresma', 0xFF7A5C8E);
  }
  if (!d.isBefore(e) && !d.isAfter(pent)) {
    return d == pent
        ? const LiturgicalSeason(
            SeasonId.pentecostes,
            'Pentecostes',
            0xFFC8452E,
          )
        : const LiturgicalSeason(SeasonId.pascoa, 'Tempo Pascal', 0xFFE8D9A8);
  }
  return const LiturgicalSeason(SeasonId.comum, 'Tempo Comum', 0xFF5E8A4E);
}

/// Ritmo dos últimos 7 dias (hoje por último). Não é sequência: nada zera.
List<bool> weekRhythm(Iterable<String> activeDates, DateTime today) {
  final set = activeDates.toSet();
  return [
    for (var i = 6; i >= 0; i--) set.contains(isoDay(addDays(today, -i))),
  ];
}

/// Dias inteiros entre duas datas ISO (nulo se nunca visitou).
int? diasDesde(String? ultimo, String hoje) {
  if (ultimo == null) return null;
  final a = DateTime.parse('${ultimo}T12:00:00');
  final b = DateTime.parse('${hoje}T12:00:00');
  return (b.difference(a).inHours / 24).round();
}
