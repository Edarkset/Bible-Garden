import 'dart:async';

import 'package:bible_garden/app/providers.dart';
import 'package:bible_garden/features/garden/garden_screen.dart';
import 'package:bible_garden/features/herbarium/herbarium_screen.dart';
import 'package:bible_garden/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Espécie da árvore (cosmético: o estágio não muda), nome e lema.
class CustomizeScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends ConsumerState<CustomizeScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _motto = TextEditingController();

  @override
  void initState() {
    super.initState();
    final repo = ref.read(gardenRepositoryProvider);
    unawaited(repo.setting('jardim.nome').then((v) => _name.text = v ?? ''));
    unawaited(repo.setting('jardim.lema').then((v) => _motto.text = v ?? ''));
  }

  @override
  void dispose() {
    _name.dispose();
    _motto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final book = ref.watch(currentBookProvider);
    final content = ref.watch(contentProvider);
    final found = ref.watch(discoveredProvider).value ?? const {};
    final current =
        ref.watch(settingProvider('especie.$book')).value ??
        content.livro(book)?.arvore;
    final options = {
      ?content.livro(book)?.arvore,
      for (final p in content.plantas)
        if (found.contains('planta:${p.id}')) p.id,
    };
    final repo = ref.read(gardenRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: Text(t.custTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            t.custSpecies(content.livro(book)?.nome ?? book),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(t.custSpeciesNote),
          RadioGroup<String>(
            groupValue: current,
            onChanged: (v) {
              if (v != null) unawaited(repo.setSetting('especie.$book', v));
            },
            child: Column(
              children: [
                for (final id in options)
                  RadioListTile<String>(
                    value: id,
                    title: Text(content.planta(id)?.nome ?? id),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _name,
            maxLength: 40,
            decoration: InputDecoration(labelText: t.custName),
          ),
          TextField(
            controller: _motto,
            maxLength: 80,
            decoration: InputDecoration(labelText: t.custMotto),
          ),
          FilledButton(
            onPressed: () async {
              await repo.setSetting('jardim.nome', _name.text.trim());
              await repo.setSetting('jardim.lema', _motto.text.trim());
              if (context.mounted) Navigator.of(context).maybePop();
            },
            child: Text(t.custSave),
          ),
        ],
      ),
    );
  }
}
