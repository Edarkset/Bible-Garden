import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bible_garden/app/providers.dart';
import 'package:bible_garden/core/purchases.dart';
import 'package:bible_garden/data/db/app_database.dart';
import 'package:bible_garden/features/reading/reading_prefs.dart';
import 'package:bible_garden/l10n/gen/app_localizations.dart';
import 'package:drift/drift.dart' show TableInfo;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Tema do app: igual ao celular, claro ou escuro.
final Provider<ThemeMode> themeModeProvider = Provider<ThemeMode>((ref) {
  final v = ref.watch(settingProvider('aparencia.tema')).value;
  return ThemeMode.values.firstWhere(
    (m) => m.name == v,
    orElse: () => ThemeMode.system,
  );
});

/// Agenda (ou cancela) o lembrete a partir das preferências salvas.
Future<void> applyReminder(WidgetRef ref, AppLocalizations t) async {
  final repo = ref.read(gardenRepositoryProvider);
  final reminders = ref.read(remindersProvider);
  final v = await repo.setting('lembrete.hora');
  if (v == null || v.isEmpty) {
    await reminders.cancel();
    return;
  }
  final parts = v.split(':');
  await reminders.schedule(
    hour: int.parse(parts[0]),
    minute: int.parse(parts[1]),
    title: t.appTitle,
    body: t.reminderBody,
  );
}

/// Exporta tudo (inclusive o que é cifrado) num JSON que só a pessoa vê.
Future<String> exportAllData(AppDatabase db) async {
  final out = <String, Object?>{
    'app': 'Bible Garden',
    'exportadoEm': DateTime.now().toIso8601String(),
  };
  for (final TableInfo<dynamic, dynamic> t in db.allTables) {
    final rows = await db
        .customSelect('SELECT * FROM ${t.actualTableName}')
        .get();
    out[t.actualTableName] = [for (final r in rows) r.data];
  }
  return const JsonEncoder.withIndent(' ').convert(out);
}

class SettingsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final repo = ref.read(gardenRepositoryProvider);
    final mode = ref.watch(themeModeProvider);
    final prefs = ref.watch(readerPrefsProvider);
    String? v(String k) => ref.watch(settingProvider(k)).value;
    final reminder = v('lembrete.hora');
    final minor = v('compras.menor') == '1';
    final limit =
        int.tryParse(v('compras.limite') ?? '') ??
        PurchasePolicy.defaultMonthlyLimitCents;
    final analytics = v('analise.consentimento') == '1';
    final theme = Theme.of(context);
    Widget header(String s) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 4),
      child: Semantics(
        header: true,
        child: Text(s, style: theme.textTheme.titleSmall),
      ),
    );
    return Scaffold(
      appBar: AppBar(title: Text(t.setTitle)),
      body: ListView(
        children: [
          header(t.setAppearance),
          RadioGroup<ThemeMode>(
            groupValue: mode,
            onChanged: (m) =>
                unawaited(repo.setSetting('aparencia.tema', m!.name)),
            child: Column(
              children: [
                RadioListTile(
                  value: ThemeMode.system,
                  title: Text(t.setThemeSystem),
                ),
                RadioListTile(
                  value: ThemeMode.light,
                  title: Text(t.setThemeLight),
                ),
                RadioListTile(
                  value: ThemeMode.dark,
                  title: Text(t.setThemeDark),
                ),
              ],
            ),
          ),
          header(t.setReminder),
          ListTile(
            title: Text(
              reminder == null || reminder.isEmpty
                  ? t.setReminderOff
                  : t.setReminderAt(reminder),
            ),
            trailing: const Icon(Icons.schedule),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 7, minute: 0),
              );
              final value = picked == null
                  ? ''
                  : '${picked.hour.toString().padLeft(2, '0')}:'
                        '${picked.minute.toString().padLeft(2, '0')}';
              await repo.setSetting('lembrete.hora', value);
              await applyReminder(ref, t);
            },
          ),
          header(t.setCanon),
          SwitchListTile(
            title: Text(t.onbCanon73),
            subtitle: Text(t.onbCanon73Note),
            value: prefs.catholicCanon,
            onChanged: (on) => unawaited(ref.setCatholicCanon(on: on)),
          ),
          SwitchListTile(
            title: Text(t.setSensor),
            subtitle: Text(t.readSensorInfo),
            value: prefs.sensor,
            onChanged: (on) => unawaited(ref.setSensor(on: on)),
          ),
          header(t.setPurchases),
          SwitchListTile(
            title: Text(t.setMinor),
            value: minor,
            onChanged: (on) =>
                unawaited(repo.setSetting('compras.menor', on ? '1' : '0')),
          ),
          ListTile(
            title: Text(t.setMonthlyLimit),
            subtitle: Text(formatBrl(limit)),
            trailing: DropdownButton<int>(
              value: limit,
              items: [
                for (final c in const [1000, 2000, 5000, 10000])
                  DropdownMenuItem(value: c, child: Text(formatBrl(c))),
                if (![1000, 2000, 5000, 10000].contains(limit))
                  DropdownMenuItem(value: limit, child: Text(formatBrl(limit))),
              ],
              onChanged: (c) =>
                  unawaited(repo.setSetting('compras.limite', '$c')),
            ),
          ),
          header(t.setPrivacy),
          SwitchListTile(
            title: Text(t.setAnalytics),
            subtitle: Text(t.setAnalyticsNote),
            value: analytics,
            onChanged: (on) => unawaited(
              repo.setSetting('analise.consentimento', on ? '1' : '0'),
            ),
          ),
          ListTile(
            title: Text(t.readHowValidated),
            onTap: () => context.push('/validacao'),
          ),
          ListTile(
            title: Text(t.setExport),
            leading: const Icon(Icons.download_outlined),
            onTap: () async {
              final messenger = ScaffoldMessenger.of(context);
              final json = await exportAllData(ref.read(databaseProvider));
              final dir = await getTemporaryDirectory();
              final f = File('${dir.path}/bible-garden-dados.json');
              await f.writeAsString(json);
              await SharePlus.instance.share(
                ShareParams(files: [XFile(f.path)]),
              );
              messenger.showSnackBar(SnackBar(content: Text(t.setExportDone)));
            },
          ),
          ListTile(
            title: Text(t.setErase),
            leading: const Icon(Icons.delete_forever_outlined),
            onTap: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (c) => AlertDialog(
                  content: Text(t.setEraseConfirm),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(c, false),
                      child: Text(t.readCancel),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(c, true),
                      child: Text(t.setErase),
                    ),
                  ],
                ),
              );
              if (ok != true) return;
              await ref.read(remindersProvider).cancel();
              await ref.read(databaseProvider).wipe();
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(t.setErased)));
                context.go('/bem-vindo');
              }
            },
          ),
          header(t.setAccount),
          ListTile(
            title: Text(t.setAccountNote),
            subtitle: Text(t.setAccountUnavailable),
          ),
          header(t.setAbout),
          ListTile(
            title: Text(t.setBibleCredit),
            subtitle: Text(ref.read(bibleIndexProvider).credito),
          ),
          ListTile(
            title: Text(t.setLicenses),
            onTap: () =>
                showLicensePage(context: context, applicationName: t.appTitle),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
