# Prompt inicial para colar no Claude Code

Cole o texto abaixo na primeira sessão, com a pasta do kit aberta como projeto.

---

Você vai desenvolver o Bible Garden, um app de celular de leitura bíblica gamificada, do zero até a publicação nas lojas.

Antes de escrever qualquer código:
1. Leia `CLAUDE.md` (regras do projeto) e `docs/ESPECIFICACAO.md` (especificação completa).
2. Leia os documentos de arte em `docs/arte/` (pedido de sprites, pacote de prompts e anexo de dados) e o manifesto `assets/data/sprites_manifest.json`.
3. Abra os protótipos em `docs/prototipo/` para entender a experiência que já foi validada, e leia `docs/referencia/core.js` e `core.test.js`: são as regras de domínio e os testes que precisam ser portados para Dart sem perder nenhum comportamento.

Depois disso, me entregue:
- um resumo de uma página do que você entendeu, com as dúvidas que tiver;
- a confirmação da stack (Flutter + Flame) ou uma objeção fundamentada;
- o plano do marco M0 (estrutura do projeto, flavors dev/prod, CI com análise e testes, primeiros testes rodando), com a lista de arquivos que vai criar.

Só comece a codar depois que eu aprovar o plano. Trabalhe um marco por vez, seguindo a seção 12 da especificação, e ao fim de cada marco me mostre: o que foi feito, como testar no celular e o resultado dos testes.
