# Bible Garden — memória do projeto para o Claude Code

Leia este arquivo inteiro antes de qualquer tarefa. Ele vale para todas as sessões.

## O que é
App de celular (Android e iOS) de leitura bíblica gamificada. Cada livro da Bíblia é um pequeno ecossistema vivo (jardim com árvore, plantas, laguinho, animais e um personagem bíblico). Os jardins se encaixam e formam uma floresta gigante. O jardim cresce com leitura, oração e devocional reais. Público: brasileiros, inclusive crianças, idosos e celulares Android simples.

## Princípios que nunca podem ser quebrados
1. A leitura é o centro. Nenhuma mecânica pode competir com ela.
2. A árvore de cada livro só cresce com leitura validada daquele livro. Dinheiro nunca faz a árvore crescer.
3. Tudo pode ser conseguido de graça. Comprar orvalho é só atalho opcional para itens especiais; personagem só é liberado depois de ler o capítulo da história dele.
4. Sem culpa: nada murcha, morre, zera ou cobra. Sem sequência que zera, sem ranking, sem contagem regressiva, sem loot box, sem notificação que culpa.
5. Privacidade: oração, diário e pedidos ficam criptografados no aparelho; nada disso vai para análise. Sem câmera. Sensor de movimento só com permissão.
6. Interdenominacional: cânon de 66 ou 73 livros configurável; nunca representar o rosto de Deus; Jesus só por símbolos.
7. Texto bíblico só de fontes com licença: hoje apenas a Bíblia Livre (CC BY 4.0, com crédito visível). Nunca copiar ARA, NVI, ARC etc. sem contrato.

## Stack
- Flutter (canal estável) + Dart, com Flame para o motor do jardim.
- Estado: Riverpod. Rotas: go_router. Banco local: drift (SQLite), offline-first; diário e pedidos com SQLCipher.
- Backend (a partir do marco M8): Supabase (Auth, Postgres com RLS, Storage, Edge Functions).
- Compras: RevenueCat ou o plugin oficial in_app_purchase (decidir no M9). Notificações locais: flutter_local_notifications.
- Erros: Sentry sem dados pessoais. Análise de uso: só com consentimento, sem conteúdo de oração ou diário.
- Use sempre as versões estáveis mais recentes dos pacotes e registre a versão escolhida em docs/DECISOES.md.
- Flutter 3.50+: importe `package:material_ui/material_ui.dart` (não `package:flutter/material.dart`). Construtores no estilo novo do Dart 3.14 (`const new(...)`); `dart fix --apply` converte.
- Identificador: `app.biblegarden` (prod) e `app.biblegarden.dev` (dev).

## Estrutura
- `lib/core/` regras puras de domínio (sem Flutter), 100% testadas. Porte fiel de `docs/referencia/core.js` e de seus testes.
- `lib/data/` banco, repositórios, importação da Bíblia.
- `lib/game/` motor Flame: jardim, plantas, animais, personagens, lago, clima, dia e noite, luz.
- `lib/features/<tela>/` telas e widgets: onboarding, garden, reading, prayer, devotional, forest, herbarium, shop, customize, settings, debug.
- `assets/arte/...` caminhos exatamente iguais aos do pacote de arte. `assets/data/sprites_manifest.json` descreve cada folha.
- `assets/bible/blivre/` texto da Bíblia Livre convertido para JSON.

## Regras de trabalho
- Trabalhe um marco por vez (ver docs/ESPECIFICACAO.md, seção 12). Antes de codar, apresente um plano curto e espere aprovação.
- Todo código de regra nasce com teste. `flutter analyze` e `flutter test` precisam passar antes de cada commit.
- Commits pequenos, mensagens em português no imperativo ("Adiciona validação de leitura v2").
- Enquanto a arte real não existir, desenhe placeholders a partir do manifesto (mesmo tamanho de célula, mesmas linhas), para o jogo rodar e a arte encaixar depois sem mudar código.
- Interface em português do Brasil, com textos em arquivos de tradução (ARB), nunca fixos no código.
- Nunca invente texto bíblico, referências ou números de versículo. Se faltar dado, pergunte.
- Atualize docs/DECISOES.md quando tomar uma decisão técnica e este CLAUDE.md quando uma regra do projeto mudar.

## Comandos
- `flutter pub get` · `flutter analyze` · `flutter test` · `flutter run --flavor dev` (versão mod) · `flutter run --flavor prod`
- `dart format lib test tool` (o CI recusa código sem formatar) · `node --test docs/referencia/core.test.js` (gabarito JS)
- Código só da versão mod: fica em `lib/features/debug/` e só entra por `if (isDev)` em `lib/app/router.dart`.
- `dart run tool/import_blivre.dart` (importa a Bíblia Livre) · `dart run tool/check_assets.dart` (confere arte x manifesto)
