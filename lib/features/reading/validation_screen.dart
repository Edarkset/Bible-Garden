import 'package:bible_garden/app/providers.dart';
import 'package:bible_garden/core/reading_tracker.dart';
import 'package:bible_garden/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

final FutureProvider<ValidationSummary?> lastValidationProvider =
    FutureProvider<ValidationSummary?>(
      (ref) => ref.watch(gardenRepositoryProvider).lastValidation(),
    );

/// "Como sua última leitura foi validada": só números, só no aparelho.
class ValidationScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final v = ref.watch(lastValidationProvider);
    return Scaffold(
      appBar: AppBar(title: Text(t.readHowValidated)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: v.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Text(t.commonError),
          data: (s) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (s == null)
                Text(t.readValidationNone)
              else ...[
                Text(
                  t.readValidationBody(
                    s.minutos.toStringAsFixed(1),
                    s.ppm,
                    s.blocosOk,
                    s.blocos,
                    s.pausasPct,
                    s.toques,
                  ),
                ),
                if (s.maoPct != null) Text(t.readValidationHand(s.maoPct!)),
              ],
              const SizedBox(height: 16),
              Text(t.readValidationPrivacy),
            ],
          ),
        ),
      ),
    );
  }
}
