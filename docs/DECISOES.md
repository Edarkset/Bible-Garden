# Decisões técnicas

Registre aqui cada decisão (data, decisão, motivo, alternativas).

- nov/2026 · Stack: Flutter + Flame (ver ESPECIFICACAO.md, seção 2).
- nov/2026 · Câmera de cima e de lado, não isométrica; arte em folhas com linha do chão a 85%.
- nov/2026 · Venda de orvalho opcional; árvore só cresce com leitura.
- 13/nov/2026 · Linguagem reavaliada a pedido: Dart/Flutter + Flame mantido. TypeScript (React Native + Skia, ou web + Capacitor + Phaser) reaproveitaria o core.js direto, mas o jardim animado roda pior em Android de entrada, que é o público principal. O core.js tem cerca de 150 linhas e é portado com os 37 testes como gabarito (`node --test docs/referencia/core.test.js` roda no CI).
- 13/nov/2026 · Identificador do app: `app.biblegarden` (prod) e `app.biblegarden.dev` (dev), em Android e iOS. Não muda depois de publicado.
- 13/nov/2026 · Versões (M0): Flutter 3.50.0 estável (Dart 3.14.0); flame ^1.38.2; flutter_riverpod ^3.5.0; go_router ^18.1.4; intl ^0.20.3; material_ui ^1.11.0; cupertino_ui ^1.1.6; very_good_analysis ^11.0.0 (análise estrita).
- 13/nov/2026 · No Flutter 3.50 o Material e o Cupertino saíram do SDK para os pacotes `material_ui` e `cupertino_ui`. Importar `package:material_ui/material_ui.dart`, e não `package:flutter/material.dart`. As traduções de Material e Cupertino precisam vir desses pacotes (as de `flutter_localizations` não servem); a lista oficial é `appLocalizationsDelegates` em `lib/app/app.dart`.
- 13/nov/2026 · Flavor decidido pela constante `appFlavor` (`flutter run --flavor dev`), sem entrypoints separados. Sem `--flavor` vale `prod`. Código da versão mod só é alcançável por `if (isDev)`, que o compilador remove do build prod. Três travas: teste do grafo de imports (`test/app/prod_clean_test.dart`), teste de que o padrão é prod, e o CI procura a marca `BG_FERRAMENTAS_MOD_7f3a` no `libapp.so` do APK prod (tem que faltar) e do dev (tem que estar).
- 13/nov/2026 · iOS: configurações `Debug/Profile/Release-dev` e `-prod` com schemes `dev` e `prod`, criadas com a gem xcodeproj. O projeto usa Swift Package Manager (sem Podfile). Se um plugin futuro exigir CocoaPods, mapear as seis configurações no Podfile. Nome no ícone: `FLAVOR_APP_NAME`.
- 13/nov/2026 · Manifesto de sprites: a chave única é `code`. O campo `id` se repete de propósito em C03/C04 (`lago`) e E05/E12 (`chuva`).
- 13/nov/2026 · Fontes Literata e Pixelify Sans (do protótipo) entram como asset empacotado no M2, nunca baixadas em tempo de execução (offline e privacidade).
