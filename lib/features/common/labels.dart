import 'package:bible_garden/core/growth.dart';
import 'package:bible_garden/core/reading.dart';
import 'package:bible_garden/l10n/gen/app_localizations.dart';

/// Textos da interface para valores do domínio.
extension DomainLabels on AppLocalizations {
  String stage(Stage s) => switch (s) {
    Stage.semente => stageSemente,
    Stage.broto => stageBroto,
    Stage.muda => stageMuda,
    Stage.arvore => stageArvore,
    Stage.frutifera => stageFrutifera,
    Stage.florida => stageFlorida,
    Stage.plena => stagePlena,
  };

  String reject(RejectReason r) => switch (r) {
    RejectReason.rapido => readRejectFast,
    RejectReason.tempo => readRejectTime,
    RejectReason.ritmo => readRejectRhythm,
    RejectReason.presenca => readRejectPresence,
  };
}
