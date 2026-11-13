/// Faixa do dia em que a pessoa mais lê.
enum LightPreference { madrugada, manha, tarde, noite }

/// Luz preferida a partir das horas das leituras. Empate: a primeira faixa.
LightPreference? preferredLight(List<int> hours) {
  if (hours.isEmpty) return null;
  final bins = {for (final l in LightPreference.values) l: 0};
  for (final h in hours) {
    final l = h < 5
        ? LightPreference.madrugada
        : h < 12
        ? LightPreference.manha
        : h < 18
        ? LightPreference.tarde
        : LightPreference.noite;
    bins[l] = bins[l]! + 1;
  }
  var best = LightPreference.madrugada;
  for (final l in LightPreference.values) {
    if (bins[l]! > bins[best]!) best = l;
  }
  return best;
}

const int _mask32 = 0xFFFFFFFF;

/// Converte para inteiro de 32 bits com sinal (como os operadores do JS).
int _toInt32(int x) {
  final v = x & _mask32;
  return v >= 0x80000000 ? v - 0x100000000 : v;
}

/// Semente estável (FNV-1a de 32 bits sobre os pontos de código).
int hashSeed(String str) {
  var h = 2166136261;
  for (final ch in str.runes) {
    h ^= ch;
    h = (h * 16777619) & _mask32;
  }
  return h;
}

/// Gerador xorshift32 idêntico ao do protótipo; devolve números em [0, 1).
double Function() rng(int seed) {
  var s = seed & _mask32;
  if (s == 0) s = 1;
  return () {
    s = (s ^ (s << 13)) & _mask32;
    s = _toInt32(s) ^ (_toInt32(s) >> 17);
    s = _toInt32(s ^ (s << 5)) & _mask32;
    return s / 4294967296;
  };
}
