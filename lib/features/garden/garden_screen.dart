import 'package:bible_garden/app/flavor.dart';
import 'package:bible_garden/l10n/gen/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Tela do jardim. No M0 é só um esqueleto; o jardim vivo chega no M3.
class GardenScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.gardenTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(t.gardenPlaceholder, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 24),
              if (isDev)
                FilledButton(
                  onPressed: () => context.push('/dev'),
                  child: Text(t.devToolsOpen),
                ),
              const Spacer(),
              Text(
                t.bibleCredit,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
