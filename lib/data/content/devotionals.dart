import 'dart:convert';

/// Um devocional: referência bíblica (o texto vem da tradução), tema da
/// ilustração (U06), pergunta e aplicação.
final class Devotional {
  const new({
    required this.id,
    required this.tema,
    required this.livro,
    required this.capitulo,
    required this.de,
    required this.ate,
    required this.pergunta,
    required this.aplicacao,
  });

  factory fromJson(Map<String, Object?> j) => Devotional(
    id: j['id']! as String,
    tema: j['tema']! as String,
    livro: j['livro']! as String,
    capitulo: j['capitulo']! as int,
    de: j['de']! as int,
    ate: j['ate']! as int,
    pergunta: j['pergunta']! as String,
    aplicacao: j['aplicacao']! as String,
  );

  final String id;

  /// luz, semente, caminho, agua, pao, pastor, videira, estrela.
  final String tema;
  final String livro;
  final int capitulo;
  final int de;
  final int ate;
  final String pergunta;
  final String aplicacao;

  static List<Devotional> parseAll(String source) => [
    for (final d
        in (jsonDecode(source) as Map<String, Object?>)['devocionais']!
            as List<Object?>)
      Devotional.fromJson(d! as Map<String, Object?>),
  ];
}

/// O devocional do dia: o mesmo para todos no mesmo dia, girando a lista.
int devotionalIndexFor(DateTime day, int count) {
  final start = DateTime(day.year);
  final doy = DateTime(day.year, day.month, day.day).difference(start).inDays;
  return (day.year * 367 + doy) % count;
}
