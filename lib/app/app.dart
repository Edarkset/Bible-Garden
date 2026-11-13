import 'package:bible_garden/app/flavor.dart';
import 'package:bible_garden/app/router.dart';
import 'package:bible_garden/app/theme.dart';
import 'package:bible_garden/l10n/gen/app_localizations.dart';
import 'package:cupertino_ui/cupertino_ui.dart'
    show GlobalCupertinoLocalizations;
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Traduções do app. As de Material e Cupertino vêm de material_ui e
/// cupertino_ui (as de flutter_localizations não servem a esses pacotes).
const List<LocalizationsDelegate<Object?>> appLocalizationsDelegates = [
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

const List<Locale> appSupportedLocales = [Locale('pt', 'BR'), Locale('pt')];

class BibleGardenApp extends StatefulWidget {
  const new({super.key});

  @override
  State<BibleGardenApp> createState() => _BibleGardenAppState();
}

class _BibleGardenAppState extends State<BibleGardenApp> {
  late final GoRouter _router = buildRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      locale: const Locale('pt', 'BR'),
      supportedLocales: appSupportedLocales,
      localizationsDelegates: appLocalizationsDelegates,
      routerConfig: _router,
    );
    if (!isDev) return app;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Banner(
        message: 'MOD',
        location: BannerLocation.topEnd,
        color: BgColors.jabuticaba,
        child: app,
      ),
    );
  }
}
