# Bible Garden

App de leitura bíblica em que cada livro da Bíblia é um pequeno jardim vivo. O jardim cresce com leitura, oração e devocional; juntos, os jardins formam uma floresta.

- Regras do projeto: [`CLAUDE.md`](CLAUDE.md)
- Especificação e marcos: [`docs/ESPECIFICACAO.md`](docs/ESPECIFICACAO.md)
- Decisões técnicas: [`docs/DECISOES.md`](docs/DECISOES.md)
- Arte: [`docs/arte/`](docs/arte) e [`assets/data/sprites_manifest.json`](assets/data/sprites_manifest.json)
- Protótipo validado: abra [`docs/prototipo/bible-garden-prototipo.html`](docs/prototipo/bible-garden-prototipo.html) no navegador

## Rodar

Requer Flutter 3.50 estável.

```sh
flutter pub get
flutter run --flavor dev    # versão mod (ferramentas de teste)
flutter run --flavor prod   # versão das lojas
flutter analyze
flutter test
node --test docs/referencia/core.test.js   # gabarito das regras do protótipo
dart run tool/check_assets.dart --lista    # arte que falta, por prioridade
```

Texto bíblico: Bíblia Livre (BLIVRE), © Diego Santos, Mario Sérgio e Marco Teles, 2018 — CC BY 4.0 Brasil, via eBible.org.
