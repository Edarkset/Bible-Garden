import 'package:bible_garden/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// Marca procurada no binário de `prod` pelo CI: se aparecer, o código da
/// versão mod vazou para a versão das lojas.
const String debugBuildMarker = 'BG_FERRAMENTAS_MOD_7f3a';

/// Tela de testes da versão mod. Ganha uma ferramenta a cada marco.
class DebugScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.devToolsTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          t.devToolsEmpty,
          semanticsLabel: '${t.devToolsEmpty} ($debugBuildMarker)',
        ),
      ),
    );
  }
}
