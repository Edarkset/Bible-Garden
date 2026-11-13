import 'package:bible_garden/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// Saldo de orvalho compacto (gota + número), com o texto completo para
/// leitores de tela. Cabe em telas estreitas.
class OrvalhoBadge extends StatelessWidget {
  const new({required this.balance, super.key});

  final int balance;

  @override
  Widget build(BuildContext context) => Semantics(
    label: AppLocalizations.of(context).gardenOrvalho(balance),
    excludeSemantics: true,
    child: Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.water_drop,
            size: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text('$balance'),
        ],
      ),
    ),
  );
}
