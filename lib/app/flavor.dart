import 'package:flutter/services.dart' show appFlavor;

/// Ambiente de compilação do app.
///
/// * [Flavor.dev] é a "versão mod": moedas liberadas, leitura e oração
///   simuladas, avançar dia, simular volta.
/// * [Flavor.prod] é a versão das lojas.
enum Flavor { dev, prod }

/// Flavor decidido na compilação (`flutter run --flavor dev`).
///
/// É uma constante: em `prod`, todo código protegido por `if (isDev)` é
/// removido do binário pelo compilador. Sem `--flavor`, vale `prod`, para que
/// um build esquecido nunca saia com as ferramentas de teste.
const Flavor currentFlavor = appFlavor == 'dev' ? Flavor.dev : Flavor.prod;

/// Atalho para o teste mais comum.
const bool isDev = currentFlavor == Flavor.dev;
