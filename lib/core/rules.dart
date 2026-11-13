/// Números calibrados das regras de domínio.
///
/// Porte fiel de `RULES` em `docs/referencia/core.js`. Não mude sem registrar
/// o motivo em `docs/DECISOES.md`. Esta pasta não importa Flutter.
abstract final class Rules {
  /// Acima disso o bloco "passou voando" (rolagem), em palavras por minuto.
  static const int blockMaxWpm = 900;

  /// Teto do tempo total do capítulo, em palavras por minuto.
  static const int chapterMaxWpm = 500;

  /// Fração mínima de blocos com tempo plausível.
  static const double blockOkShare = 0.8;

  /// Sem toque ou rolagem por 90 s, a contagem pausa.
  static const Duration idlePause = Duration(seconds: 90);

  /// A oração conta a partir de 2 minutos.
  static const int prayerMinMinutes = 2;

  /// Pode sair do app por até 15 s durante a oração (ex.: tela bloqueou).
  static const Duration prayerGrace = Duration(seconds: 15);

  /// Porção diária de orvalho.
  static const PorcaoRules porcao = PorcaoRules();

  /// Minutos de leitura validada que valem a porção de presença.
  static const int readMinForPresence = 3;
}

/// Valores da porção diária (maná): o mesmo para todos que comparecem.
final class PorcaoRules {
  const new();

  int get presenca => 20;
  int get oracao => 10;
  int get devocional => 10;
  int get teto => 40;
}
