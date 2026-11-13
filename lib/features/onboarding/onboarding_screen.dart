import 'dart:async';

import 'package:bible_garden/app/providers.dart';
import 'package:bible_garden/features/reading/reading_prefs.dart';
import 'package:bible_garden/features/settings/settings_screen.dart';
import 'package:bible_garden/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// O cadastro já foi feito?
final FutureProvider<bool> onboardingDoneProvider = FutureProvider<bool>(
  (ref) async =>
      await ref.watch(gardenRepositoryProvider).setting('cadastro.ok') == '1',
);

/// Árvores oferecidas para Gênesis no cadastro.
const List<String> genesisTrees = ['oliveira', 'figueira', 'ipe-amarelo'];

/// Cores das flores.
const Map<String, Color> flowerColors = {
  'ipe': Color(0xFFE8B931),
  'lilas': Color(0xFF9B7BC4),
  'rosa': Color(0xFFE28AA0),
  'branco': Color(0xFFF2EFE6),
};

/// Cadastro em 5 passos. Termina lendo Gênesis 1: vitória no 1º minuto.
class OnboardingScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;
  final TextEditingController _name = TextEditingController();
  bool _catholic = false;
  bool _minor = false;
  String _tree = genesisTrees.first;
  String _companion = 'ovelha';
  String _flowers = 'ipe';
  TimeOfDay? _reminder = const TimeOfDay(hour: 7, minute: 0);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final t = AppLocalizations.of(context);
    final repo = ref.read(gardenRepositoryProvider);
    final name = _name.text.trim();
    await repo.setSetting('jardim.nome', name);
    await ref.setCatholicCanon(on: _catholic);
    await repo.setSetting('compras.menor', _minor ? '1' : '0');
    await repo.setSetting('especie.GEN', _tree);
    await repo.setCompanion(_companion);
    await repo.setSetting('flores.cor', _flowers);
    final r = _reminder;
    await repo.setSetting(
      'lembrete.hora',
      r == null
          ? ''
          : '${r.hour.toString().padLeft(2, '0')}:'
                '${r.minute.toString().padLeft(2, '0')}',
    );
    await repo.setSetting('livro.atual', 'GEN');
    await repo.setSetting('cadastro.ok', '1');
    ref.invalidate(onboardingDoneProvider);
    unawaited(applyReminder(ref, t).catchError((Object _) {}));
    if (mounted) context.go('/ler/GEN/1');
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final content = ref.watch(contentProvider);
    final theme = Theme.of(context);
    final steps = <Widget>[
      // 1. nome
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(t.onbIntro, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 16),
          Text(t.onbName, style: theme.textTheme.titleMedium),
          TextField(
            controller: _name,
            maxLength: 40,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(hintText: t.onbNameHint),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _minor,
            onChanged: (v) => setState(() => _minor = v ?? false),
            title: Text(t.setMinor),
          ),
        ],
      ),
      // 2. tradição e tradução
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(t.onbTradition, style: theme.textTheme.titleMedium),
          RadioGroup<bool>(
            groupValue: _catholic,
            onChanged: (v) => setState(() => _catholic = v ?? false),
            child: Column(
              children: [
                RadioListTile(value: false, title: Text(t.onbCanon66)),
                RadioListTile(value: true, title: Text(t.onbCanon73)),
              ],
            ),
          ),
          if (_catholic) Text(t.onbCanon73Note),
          const SizedBox(height: 8),
          Text('${t.readTranslation}: Bíblia Livre (BLIVRE)'),
        ],
      ),
      // 3. árvore de Gênesis
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(t.onbTree, style: theme.textTheme.titleMedium),
          RadioGroup<String>(
            groupValue: _tree,
            onChanged: (v) => setState(() => _tree = v ?? _tree),
            child: Column(
              children: [
                for (final id in genesisTrees)
                  if (content.planta(id) case final p?)
                    RadioListTile(
                      value: id,
                      title: Text(p.nome),
                      subtitle: p.ref == null ? null : Text(p.ref!),
                    ),
              ],
            ),
          ),
        ],
      ),
      // 4. companheiro e flores
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(t.onbCompanion, style: theme.textTheme.titleMedium),
          RadioGroup<String>(
            groupValue: _companion,
            onChanged: (v) => setState(() => _companion = v ?? _companion),
            child: Column(
              children: [
                for (final a in content.animais.where(
                  (a) => a.companheiroInicial,
                ))
                  RadioListTile(value: a.id, title: Text(a.nome)),
              ],
            ),
          ),
          Text(t.onbFlowers, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            children: [
              for (final e in flowerColors.entries)
                Semantics(
                  button: true,
                  selected: _flowers == e.key,
                  label: e.key,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => setState(() => _flowers = e.key),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: e.value,
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: _flowers == e.key ? 3 : 1,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      // 5. lembrete
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(t.onbReminder, style: theme.textTheme.titleMedium),
          Text(t.onbReminderNote),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () async {
              final p = await showTimePicker(
                context: context,
                initialTime: _reminder ?? const TimeOfDay(hour: 7, minute: 0),
              );
              if (p != null) setState(() => _reminder = p);
            },
            child: Text(
              _reminder == null
                  ? t.onbNoReminder
                  : t.setReminderAt(_reminder!.format(context)),
            ),
          ),
          TextButton(
            onPressed: () => setState(() => _reminder = null),
            child: Text(t.onbNoReminder),
          ),
        ],
      ),
    ];
    final last = _step == steps.length - 1;
    return Scaffold(
      appBar: AppBar(title: Text(t.onbWelcome)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(t.onbStep(_step + 1)),
              LinearProgressIndicator(value: (_step + 1) / steps.length),
              const SizedBox(height: 16),
              Expanded(child: SingleChildScrollView(child: steps[_step])),
              Row(
                children: [
                  if (_step > 0)
                    TextButton(
                      onPressed: () => setState(() => _step--),
                      child: Text(t.onbBack),
                    ),
                  const Spacer(),
                  FilledButton(
                    onPressed: last ? _finish : () => setState(() => _step++),
                    child: Text(last ? t.onbStart : t.onbNext),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
