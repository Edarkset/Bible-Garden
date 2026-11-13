import 'package:sentry_flutter/sentry_flutter.dart';

/// DSN do Sentry (`--dart-define=SENTRY_DSN=...`). Vazio = desligado.
const String sentryDsn = String.fromEnvironment('SENTRY_DSN');

/// Liga o relatório de erros sem nenhum dado pessoal: sem usuário, sem IP,
/// sem textos da tela, sem trilhas de navegação com conteúdo. Nunca envia
/// oração, diário, pedidos ou texto lido.
Future<void> runWithTelemetry(Future<void> Function() app) async {
  if (sentryDsn.isEmpty) {
    await app();
    return;
  }
  await SentryFlutter.init((o) {
    o
      ..dsn = sentryDsn
      ..sendDefaultPii = false
      ..attachScreenshot = false
      ..attachViewHierarchy = false
      ..maxBreadcrumbs = 0
      ..tracesSampleRate = 0
      ..beforeSend = scrub;
  }, appRunner: app);
}

/// Remove tudo que possa identificar a pessoa ou revelar conteúdo.
SentryEvent? scrub(SentryEvent e, Hint hint) => e
  ..user = null
  ..request = null
  ..breadcrumbs = <Breadcrumb>[]
  ..message = e.message == null ? null : SentryMessage('[removido]');
