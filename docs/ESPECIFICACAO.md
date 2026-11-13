# Bible Garden — Especificação para desenvolvimento

Documento de referência para o Claude Code. Ele complementa o `CLAUDE.md`, que traz as regras que nunca podem ser quebradas. Os números aqui foram calibrados por simulação e testes no protótipo; não mude sem registrar o motivo em `docs/DECISOES.md`.

## 1. Visão do produto
- Cada livro da Bíblia é um pequeno ecossistema: um jardim quadrado com uma árvore principal, plantas, laguinho, um animal do livro e um personagem bíblico.
- Os jardins se encaixam pelas bordas e formam uma floresta. Ao concluir a Bíblia, um rio que nasce em Gênesis atravessa todos os jardins até a árvore da vida, no Apocalipse.
- O jardim cresce com três práticas: leitura (a copa e a árvore), oração (as raízes) e devocional (gavinhas e flores). As moedas (orvalho) liberam animais, plantas extras, decoração e personagens.
- Inspirações: Forest Shuffle (relações entre espécies e coleção), Photosynthesis (estágios), Wingspan (herbário que ensina), Neko Atsume (animais que vêm visitar), Duolingo (vitória no primeiro minuto, sem culpa) e app Forest (foco na oração).

## 2. Stack e infraestrutura
| Camada | Escolha | Por quê |
| --- | --- | --- |
| App | Flutter (estável) + Dart | Um código para Android e iOS; texto e acessibilidade fortes (leitura bíblica longa, leitor de tela, fonte grande); desempenho bom em Android simples |
| Jogo | Flame | Motor 2D sobre Flutter: sprites, animações por folha, partículas, câmera, ordem por profundidade; permite shaders de fragmento para luz e reflexo |
| Estado e rotas | Riverpod, go_router | Testáveis e previsíveis |
| Banco local | drift (SQLite), offline-first; SQLCipher para diário e pedidos | O app funciona sem internet; dados sensíveis cifrados |
| Conta e sincronização (M8) | Supabase: Auth, Postgres com RLS, Storage, Edge Functions | Sincroniza progresso entre aparelhos, amigos, planos da igreja; RLS impede um usuário de ler dados de outro |
| Compras (M9) | RevenueCat ou in_app_purchase | Pacotes visuais e orvalho, com validação de recibo |
| Notificações | flutter_local_notifications | Um único lembrete diário, escolhido pela pessoa |
| Qualidade | GitHub Actions (analyze, test, build), Sentry sem dados pessoais | |

Alternativas avaliadas e descartadas: Godot (ótimo para 2D, mas fraco em acessibilidade, texto longo e integrações de loja), React Native com Skia, e web com Capacitor e Phaser (mais familiar, mas pesado em Android simples).

Flavors: `dev` é a "versão mod" (moedas liberadas, leitura e oração simuladas, avançar dia, simular volta); `prod` é a versão das lojas. O código de trapaça do `dev` não pode existir no build `prod`.

## 3. Regras de domínio (portar de `docs/referencia/core.js`)
Implementar em `lib/core/` como funções puras e portar os 37 testes de `core.test.js`, mais os novos.

**Validação da leitura (v2):**
- Texto dividido em blocos de cerca de 60 palavras, sem quebrar versículo.
- Um bloco é marcado como "rápido demais" se ficou visível por menos que palavras ÷ 900 ppm.
- O capítulo conta quando ≥ 80% dos blocos estão ok e o tempo ativo total ≥ palavras ÷ 500 ppm.
- Ritmo humano: fração do tempo sem rolar ≥ 0,25 ou variação da velocidade de rolagem (coeficiente) ≥ 0,5.
- Presença: pelo menos 1 toque ou rolagem humana a cada 3 blocos, ou celular na mão em ≥ 30% das janelas de 5 s (acelerômetro, opcional, com permissão).
- Inatividade de 90 s pausa a contagem; app em segundo plano não conta.
- Motivos de recusa e mensagens gentis: `rapido`, `tempo`, `ritmo`, `presenca` (textos do protótipo).
- Tela "Como sua última leitura foi validada" com tempo, ppm, blocos, pausas, toques e mão. Nada sai do aparelho.
- Leitura na Bíblia impressa: botão "li na minha Bíblia", com registro por confiança e limite de ritmo.

**Crescimento:**
- Estágios: 0 semente, 1 broto (já no 1º capítulo), 2 muda (< 30%), 3 árvore (< 55%), 4 frutífera (< 80%), 5 florida (< 100%), 6 plena (100%). O crescimento contínuo serve para animar.
- Livros longos têm canteiros (Gênesis: 1–11, 12–25, 26–36, 37–50; Salmos: os 5 livros do Saltério). A forma da planta segue o tamanho do livro (flor ou arbusto < 15 min, árvore média 15–60 min, árvore grande > 60 min).
- Releituras: a 2ª leitura completa ativa a variante "florada"; a 3ª, a "dourada".
- Trocar a espécie da árvore é cosmético e mantém o estágio.

**Orvalho (moeda) e economia:**
- Porção diária de no máximo 40: 20 por presença (≥ 3 min de leitura validada, ou oração ≥ 2 min, ou devocional), +10 por oração, +10 por devocional. Ler mais não multiplica. Dia vazio dá zero, nunca negativo.
- Preços de referência:
    - animais de 80 a 450;
    - melhorias de terreno de 120 a 900;
    - decoração de 60 a 600;
    - personagens 400, ou 600 quando têm objeto grande.
  Ajustar só com a simulação de economia (tool/simular_economia.dart).
- Pedras da coroa (marcos, nunca vendidas): 1 por canteiro; 1, 2 ou 3 por livro conforme o tamanho; 5 por bioma; 12 pela Bíblia completa.
- Venda de orvalho: opcional, só acelera itens especiais. Preço sempre em reais ao lado, sem bônus com contagem regressiva, limite mensal configurável, confirmação extra se a conta for de menor.
- Pacotes visuais: compra única, permanente, com provador gratuito.

**Personagens:**
- Liberados ao ler o capítulo da história (coluna "Libera ao ler" do anexo de dados) e então comprados com orvalho.
- Moram no jardim e têm comportamento próprio (seção 6).

**Animais:**
- O animal do livro e o companheiro crescem de filhote a jovem (10 porções recebidas desde que chegou) e de jovem a adulto (30 porções).

**Oração:**
- Duração escolhida (2, 5, 10, 15 min) e modo guiado opcional (adoração, confissão, gratidão, súplica).
- 15 s de tolerância fora do app; depois disso, pausa e oferece retomar.
- Desistir não registra. A recompensa é do ato, não dos minutos.
- Pedidos de oração com "foi respondida", que ergue uma pedra de Ebenézer.

**Constância sem culpa:**
- Dias acumulados e ritmo da semana (7 pontos), sem sequência que zera.
- Volta acolhedora: se a pessoa ficou 3 dias ou mais sem abrir, chove no jardim e aparece a mensagem "Seu jardim esperou por você. Nada se perdeu."

**Calendário cristão:**
- Advento, Natal, Quaresma, Tempo Pascal, Pentecostes e Tempo Comum, calculados a partir da Páscoa (algoritmo gregoriano).
- Itens sazonais voltam todo ano.

## 4. Bíblia e traduções
- Modelo de dados: versão → livro → capítulo → versículo, com status de licença por versão (`liberada`, `aberta_pendente`, `licenca_necessaria`) e crédito obrigatório.
- MVP: Bíblia Livre (BLIVRE, CC BY 4.0, de eBible.org). Criar `tool/import_blivre.dart` que converte os arquivos oficiais da Bíblia Livre (de preferência USFM) em JSON por livro.
- Antes de usar os livros deuterocanônicos, confirmar se a BLIVRE os inclui.
- Cânon configurável: 66 (protestante) ou 73 (católico), com os deuterocanônicos integrados aos biomas.
- ARA, ARC, NAA, NTLH (Sociedade Bíblica do Brasil), NVI (Biblica), ACF e outras aparecem no seletor como preferência salva, mas o texto só entra com contrato.

## 5. Motor do jardim (Flame)
**Câmera e escala:**
- Visão de cima e de lado (3/4, ortográfica), não isométrica.
- Cada jardim tem 12 × 12 ladrilhos quadrados e o mundo mostra cerca de 220 px de largura.
- A arte é gerada em células grandes (64 a 256 px) e reduzida para os tamanhos-alvo (personagens e animais com 20 a 24 px de altura no mundo).

**Folhas de sprite:**
- Ler tudo de `assets/data/sprites_manifest.json` (colunas, linhas, célula, linha do chão a 85%, animações com linha, quadro inicial, quantidade, fps e loop).
- A arte olha para a direita; espelhar para a esquerda.
- Usar atlas de textura empacotados no build.

**Ordem de desenho:**
- Ordenar pelo "pé" de cada objeto (linha do chão), para quem está mais embaixo na tela ficar na frente.

**Comportamento dos seres (máquina de estados):**
- Parado com variações sorteadas.
- Andar até pontos de interesse: árvore (colher e comer), lago (beber, lavar as mãos), lugares para sentar.
- Reações:
    - ao toque;
    - interação personagem e animal (carinho, pássaro no ombro, peixe pulando quando alguém lava as mãos);
    - emoções em balão (folha E13).
- Gracinha do personagem a cada 2 a 5 minutos, com a folha de objetos quando houver.

**Ecossistema:**
- A abelha visita a flor, a flor vira fruto (efeito E14).
- O fruto maduro cai, quica e pode ser comido por um pássaro.
- Uma semente cai e nasce uma mudinha decorativa, com limite por jardim.

**Clima e tempo:**
- O vento global define a velocidade das linhas de vento.
- Na chuva, os animais se abrigam e se sacodem, os personagens protegem a cabeça, aparecem poças (E15) e as folhas pingam.
- O arco-íris aparece depois da chuva.

**Dia e noite:**
- Pelo relógio do aparelho: correção de cor por hora, sombras que giram com o sol, animais diurnos e noturnos, vaga-lumes, lanterna acesa ao anoitecer.

**Luz e beleza:**
- Luz dinâmica com mapas de relevo (normal maps) gerados a partir de cada sprite aprovado, por ferramenta (não pela IA de imagem).
- Reflexo no lago: sprite espelhado com shader de ondulação.
- Partículas: pólen, pétalas, chuva, vaga-lumes.
- Raios de sol no estilo de Ori.

**Momentos especiais:**
- Animação de crescimento ao concluir um capítulo.
- Festa de todos os seres ao concluir um livro.
- Procissão dos personagens ao concluir um bioma.
- Chegada de personagem ou animal novo (efeito E08).

**Edição:**
- Modo "Editar jardim" com bandeja fixa embaixo; o jardim continua visível.
- Tocar num espaço livre para colocar; tocar num item para guardar.
- Espaços reservados: árvore, lago, caminho e pedras de Ebenézer.

**Placeholders:** até a arte chegar, gerar formas coloridas nas mesmas células e linhas do manifesto. `tool/check_assets.dart` lista o que falta.

**Orçamento de desempenho (Android de entrada):**
- 60 qps como alvo e 30 qps como mínimo.
- No máximo 40 seres animados por jardim.
- Memória de texturas abaixo de 150 MB.
- O jogo pausa quando a tela não está visível.
- Menos qps nas telas sem jardim.
- Respeitar "reduzir movimento".

## 6. Telas
1. **Cadastro em 5 passos:**
    1. nome do jardim;
    2. tradição e tradução;
    3. árvore de Gênesis;
    4. companheiro e cor das flores;
    5. horário do lembrete.

   Termina lendo Gênesis 1: vitória no primeiro minuto.
2. **Jardim:**
    - cabeçalho com estação, orvalho e ritmo da semana;
    - jardim vivo;
    - estágio com "próximo estágio em N capítulos";
    - botão principal "Ler [livro] [capítulo] · ~N min";
    - cartão "Hoje no jardim" (Ler, Orar, Devocional e barra da porção);
    - "Próxima conquista" com barra;
    - Editar jardim;
    - cartão da assinatura do jardim.
3. **Leitura:**
    - seletor de tradução;
    - tamanho de letra e temas claro, sépia e noturno;
    - blocos com aviso gentil e botão de concluir;
    - sensor de movimento opcional;
    - crédito da tradução.
4. **Oração:**
    - escolha do tempo e modo guiado;
    - tela em camadas com vela e lua no lago (U05);
    - pedidos de oração.
5. **Devocional do dia:** ilustração do tema (U06), texto, aplicação e anotação que vai para o baú (cifrada).
6. **Floresta:**
    - mapa dos biomas e jardins, com a forma da planta segundo o tamanho do livro e o rio;
    - Herbário com fichas no estilo de Forest Shuffle (retratos e molduras U08 e U10).
7. **Loja ("Cuidar"):**
    - melhorias, animais, decoração e personagens (todos com orvalho);
    - pacotes visuais com provador;
    - pacotes de orvalho, opcionais e por último.
8. **Personalizar:** espécie da árvore, companheiro, acessório, cores, lema e nome.
9. **Ajustes:**
    - aparência, lembrete, sensor e privacidade (exportar e apagar dados);
    - no flavor `dev`, o modo de teste completo do protótipo.
10. **Tela inicial animada** em camadas (U01) e transições de folhas (U12).

## 7. Arte
- Os documentos em `docs/arte/` são a fonte da verdade: 362 folhas, prioridades P1, P2, P3, caminhos de arquivo e grades.
- A arte chega em `assets/arte/` com os mesmos caminhos.
- Ao integrar uma folha, conferir as 11 regras técnicas: grade exata, margem de 6%, linha do chão a 85%, virada para a direita e sem sombra.
- Se uma folha vier fora do padrão, registrar o defeito e pedir uma nova versão em vez de compensar no código.

## 8. Acessibilidade
- Fonte da leitura ajustável até 26 px ou mais, respeitando a fonte do sistema.
- Rótulos para leitor de tela em tudo.
- Contraste AA (4,5:1).
- Áreas de toque de 44 px ou mais.
- Respeitar "reduzir movimento".
- Áudio da Bíblia no roadmap.

## 9. Privacidade e LGPD
- Local-first. Diário, pedidos e notas de Ebenézer cifrados no aparelho e nunca enviados para análise.
- Sem câmera. Acelerômetro só com permissão e apenas para a validação de leitura.
- Consentimento para análise de uso.
- Exportar e apagar todos os dados.
- Contas de menores com compras bloqueadas por padrão.
- Na visita de amigos, eles só veem a superfície do jardim (copa, decoração), nunca raízes, baú ou horários.

## 10. Testes
- Unitários: todas as regras de `lib/core` (portar os 37 testes e acrescentar os de economia, crescimento de animais, liberação de personagens e venda de orvalho).
- Widgets e telas com testes de imagem de referência (golden tests) nos tamanhos 320, 390 e 768 px, claro e escuro.
- Integração, refazendo os fluxos já validados no protótipo:
    - leitura honesta aprovada;
    - celular parado recusado;
    - rolagem automática recusada;
    - oração com saída e retomada;
    - devocional;
    - compra;
    - edição do jardim;
    - volta após 4 dias.
- Desempenho: perfil num Android de entrada, com os números da seção 5.
- Auditoria de acessibilidade a cada marco.

## 11. Dados de conteúdo
`docs/arte/03-anexo-de-dados.md` traz, para cada livro:
- a árvore principal;
- o animal bíblico e a referência;
- o personagem e a gracinha;
- o capítulo que o libera e o preço.

O mesmo anexo descreve todos os animais e plantas. Converter tudo em `assets/data/conteudo.json` com um script, sem digitar à mão.

## 12. Marcos (um por vez, com critério de pronto)
| Marco | Entrega | Pronto quando |
| --- | --- | --- |
| M0 | Projeto Flutter, flavors dev e prod, CI, pastas, CLAUDE.md seguido | CI verde; app abre no Android e no iOS |
| M1 | `lib/core` com todas as regras e testes portados | Os 37 testes antigos e os novos passando |
| M2 | Importação da BLIVRE; leitura com validação v2, temas e seletor de tradução | Fluxos de leitura dos testes de integração passando |
| M3 | Jardim no Flame com placeholders guiados pelo manifesto: crescimento, vento, ordem por profundidade, edição | Gênesis cresce de semente a plena no modo dev |
| M4 | Oração, devocional, "Hoje no jardim", volta acolhedora, calendário | Fluxos de oração e volta passando |
| M5 | Economia, loja, animais com crescimento, personagens com máquina de estados e gracinha | Simulação de economia aprovada; personagem liberado no capítulo certo |
| M6 | Arte P1 integrada: luz, reflexo, sombras, partículas, emoções, ecossistema | Teste em Android de entrada dentro do orçamento |
| M7 | Floresta, herbário, cânon 66 e 73 | Mapa completo navegável |
| M8 | Conta e sincronização (Supabase), amigos, jardim da igreja | Dois aparelhos sincronizam; RLS testado |
| M9 | Compras (pacotes visuais e orvalho), notificações, publicação em teste fechado | Teste com 20 voluntários por 4 semanas, medindo a métrica norte |

**Métrica norte:** minutos de leitura validada por usuário ativo por semana.

**Antimétrica:** tempo no jardim e na loja dividido pelo tempo de leitura e oração. Acima de 0,3, é sinal de alerta.
