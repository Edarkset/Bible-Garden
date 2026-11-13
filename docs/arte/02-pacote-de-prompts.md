# Bible Garden · Pacote de prompts de arte · v6

## Como usar

- Cada prompt = **Bloco de estilo** + **Bloco técnico** + **prompt da folha**. A planilha 04-prompts-montados.csv já traz os três juntos, um por linha.
- **Anexe a folha aprovada** do mesmo personagem, animal ou planta quando pedir referência. Na primeira folha de cada grupo, anexe a folha aprovada do grupo: a ovelha para os animais, a oliveira para as plantas e Noé para os personagens.
- **Prompts em inglês**; explicações em português.
- Campos entre `{chaves}` vêm do anexo de dados (03).
- Se o gerador não aceitar o tamanho exato, gere maior mantendo a grade e reduza depois.

Códigos: **A** animais, **PL** plantas, **H** personagens, **C** cenário, **I** itens, **E** efeitos, **U** interface. A prioridade (P1, P2, P3) vem separada do código.

## 1. O que a auditoria encontrou

| # | Problema visto no jogo | Prova | Prompt que resolve |
| --- | --- | --- | --- |
| 1 | Animais deslizam sem andar e só olham para um lado | Protótipo v0.5 | Todos os A: linhas 2 a 4 (para baixo, para cima, para a direita) |
| 2 | Animais não crescem | Protótipo: o mesmo tamanho do início ao fim | A: linha 8 (filhote e jovem) |
| 3 | Árvores sem vento e sem frutos | Protótipo: copa de círculos parada | PL: linhas 2 e 3 (vento; fruto amadurecendo e caindo) |
| 4 | A muda some na grama | Captura da v0.4 | PL: linha 1 com montinho de terra e contorno |
| 5 | Personagens bíblicos inexistentes | — | H01 a H73 (vida no jardim + gracinha + objetos) |
| 6 | Laguinho é um retângulo | Protótipo | C03, C04 e peixes |
| 7 | Jardins isolados, sem cara de floresta | Protótipo: ilha solta | C05 bordas, C08 e C09 |
| 8 | Menu, oração e devocional sem arte | Protótipo: só interface | U01, U05, U06, U09, U13 |
| 9 | Visual isométrico não combina com a visão desejada | Decisão nova: de cima e de lado | Bloco de estilo e técnico v5 |
| 10 | Personagens e animais repetem o mesmo gesto | Protótipo: um único parado em loop | Linhas de variação de parado (v6) |
| 11 | Tocar no jardim não faz nada | Teste do protótipo | Linhas de reação ao toque (v6) |
| 12 | Seres não interagem entre si | Protótipo | Carinho, ombro, peixe pulando, festa (v6) |
| 13 | Chuva não muda nada além do fundo | Protótipo | Abrigo, sacudir, folhas pingando, poças (v6, E15) |
| 14 | Falta expressão de sentimento | — | E13 Emoções |

## 2. Bloco de estilo (colar em todo prompt)

```
Art style: high-detail painted pixel art for a cozy 2D garden-and-collection game seen from a top-down 3/4 view (the camera is above and slightly in front, so objects show their top and their front face; NOT isometric, NOT side-scrolling), in the spirit of Sea of Stars, Dave the Diver and Stardew Valley, with the glowing atmospheric light of Ori and the Blind Forest and the naturalist charm of Forest Shuffle illustrations: soft warm natural colors from a limited palette (sage greens, warm earth browns, sky blues, ipe gold), gentle painterly shading with soft volumetric light, warm rim light from the top-left, crisp 1-2 px dark outline (very dark brown or plum, never pure black), strong readable silhouette that still reads when scaled down to 24 px tall. Not blocky like Terraria: rounded, lush and detailed.
Theme: each book of the Bible is a tiny living ecosystem garden; together they form a giant forest. Plants, animals and characters of the Bible mixed with Brazilian and world flora and fauna; calm, hopeful and tender, never scary, no violence.
```

## 3. Bloco técnico (colar em todo prompt de folha)

```
Sprite sheet rules: transparent background (PNG with alpha), no floor, no cast shadow, no text, no grid lines, no frame borders. Exact uniform grid of {COLS} columns x {ROWS} rows of square cells, each cell {CELL}x{CELL} px, total image {COLS*CELL}x{ROWS*CELL} px. Every frame stays fully inside its own cell with ~6% empty margin: nothing (tails, wings, leaves, falling fruit, petals, sparks, glow) may cross into a neighbouring cell. Feet (or the base of a floating body, or the base of a plant) sit on the same horizontal line in every frame, at 85% of the cell height. Same scale and same size in every frame and row. Unless a row says otherwise the subject faces RIGHT (the game mirrors it for left); rows marked DOWN face the camera, rows marked UP show the back. Animation rows read left to right; looping rows loop seamlessly (last frame flows into the first). Natural proportions, never stretched or squashed. Animation principles: clear anticipation before every jump or action, gentle squash and stretch on landings, and secondary motion: hair, cloaks, ears, tails, wings and leaves follow the movement 1-2 frames later; idle rows always breathe subtly.
```

Efeitos, ladrilhos e camadas de fundo têm blocos técnicos próprios, já incluídos nos seus prompts.

## 4. Modelos para itens repetidos

### Animais que andam (A-T) · 8 × 8 · célula 128

```
A cute {visual}. Signature detail: {traco}. Natural animal proportions, slightly chibi (bigger head and eyes), friendly.
Row 1: idle breathing, 6 frames + 2 frames blinking.
Row 2: idle variations: stretching, 4 frames + scratching or looking up at the sky, 4 frames.
Row 3: walk cycle DOWN (toward the camera), 8 frames.
Row 4: walk cycle UP (away from the camera), 8 frames.
Row 5: walk cycle facing RIGHT, 8 frames.
Row 6: special action, {acao}, 8 frames: 2 anticipation, 4 action, 2 recovery.
Row 7: personality quirk showing "{jeito}", 4 frames + reaction when tapped (a small hop and a look at the viewer), 4 frames.
Row 8: being petted by someone (hand not drawn), leaning in happily, 4 frames + celebrating with a little jump, 4 frames.
Row 9: rain: hurrying to shelter and sitting tucked in, 4 frames + shaking the water off, 4 frames.
Row 10: drinking from the pond edge, 4 frames + lying down and sleeping with slow breathing, 4 frames.
Row 11: growth (the animal grows as the person reads): baby version idle, 4 frames + young version idle, 4 frames; rows 1 to 10 are the adult.
```

### Aves (A-V) · 8 × 8 · célula 128

```
A cute {visual}. Signature detail: {traco}. Slightly chibi, friendly.
Row 1: perched idle breathing, 6 frames + 2 frames blinking.
Row 2: idle variations: preening, 4 frames + fluffing up feathers, 4 frames.
Row 3: flying DOWN, 8 frames (full wing cycle).
Row 4: flying UP, 8 frames.
Row 5: flying facing RIGHT, 8 frames.
Row 6: special action, {acao}, 8 frames: 2 anticipation, 4 action, 2 recovery.
Row 7: personality quirk showing "{jeito}", 4 frames + reaction when tapped (a startled flutter and a look at the viewer), 4 frames.
Row 8: landing on someone's shoulder or hand (person not drawn), 4 frames + celebrating with a little hop, 4 frames.
Row 9: rain: tucking its head under a wing, 4 frames + shaking the water off, 4 frames.
Row 10: take-off 2 + landing 2 frames, then sleeping on a perch, 4 frames.
Row 11: growth: chick idle, 4 frames + young bird idle, 4 frames; rows 1 to 10 are the adult.
```

### Animais da água e peixes (A-A) · 8 × 8 · célula 128

```
A cute {visual}. Signature detail: {traco}. Show a small round patch of rippling water under the body, kept inside the cell.
Row 1: floating idle, 6 frames + 2 frames blinking.
Row 2: idle variations: slow turn, 4 frames + blowing bubbles, 4 frames.
Row 3: swimming DOWN, 8 frames.
Row 4: swimming UP, 8 frames.
Row 5: swimming facing RIGHT, 8 frames.
Row 6: special action, {acao}, 8 frames: 2 anticipation, 4 action, 2 recovery.
Row 7: personality quirk showing "{jeito}", 4 frames + reaction when tapped (a quick dart and a splash), 4 frames.
Row 8: leaping out of the water when someone washes their hands at the edge, 4 frames + celebrating with a twirl, 4 frames.
Row 9: raindrops on the surface, looking up curiously, 4 frames + gliding calmly, 4 frames.
Row 10: diving under, 4 frames + resurfacing with a small splash, 4 frames.
Row 11: growth: baby idle, 4 frames + young idle, 4 frames.
```

### Insetos (A-I) · 8 × 4 · célula 64

```
A cute {visual}. Signature detail: {traco}. Tiny creature: simple bold silhouette.
Row 1: idle or hovering loop, 8 frames.
Row 2: moving DOWN and UP, 4 + 4 frames.
Row 3: moving facing RIGHT, 8 frames.
Row 4: special action, {acao}, 4 frames + personality quirk showing "{jeito}", 4 frames.
Row 5: reaction when tapped, 4 frames + hiding from the rain under a leaf, 4 frames.
```

### Grupos de animais (A-G) · 8 × 6 · célula 192

```
{visual}, a small group that always stays together inside each cell. Signature detail: {traco}.
Row 1: idle together, 6 frames + 2 frames blinking.
Row 2: walking DOWN together, 8 frames.
Row 3: walking facing RIGHT together, 8 frames.
Row 4: special action, {acao}, 8 frames: 2 anticipation, 4 action, 2 recovery.
Row 5: personality quirk showing "{jeito}", 4 frames + drinking at the pond, 4 frames.
Row 6: reaction when tapped, 4 frames + celebrating together, 4 frames.
Row 7: rain: gathering under a tree, 4 frames + shaking the water off, 4 frames.
Row 8: lying down, 4 frames + sleeping peacefully, 4 frames.
```

### Árvores e palmeiras (PL-G) · 8 × 5 · célula 256

```
{visual}. Signature detail: {traco}. Seen from the top-down 3/4 view: the crown shows its top and its front, the trunk is visible below it. Each cell shows the plant on a small patch of soil.
Row 1: growth stages left to right, 8 frames: {estagios}.
Row 2: full-grown plant in the wind, 8 frames loop: {jeito}; leaves ripple from one side, small leaves drift off.
Row 3: {fruta}
Row 4: growth burst at full size when a chapter is read, 8 frames: 2 anticipation (leaves lift), 4 growth (new leaves and tiny sparkles appear), 2 settle.
Row 5: 2nd-reading variant "florada" (more blossoms, a small bird nest), swaying, 4 frames + 3rd-reading variant "dourada" (warm golden glow on the canopy edges, tiny light motes; colors shift one step toward gold, same species), shimmering, 4 frames.
Row 6: reaction when tapped: the crown shakes, 4 frames, and a leaf (or a ripe fruit, if it bears fruit) drops, 4 frames.
Row 7: rain on the full-grown plant: leaves glistening and dripping, 4 frames loop + after the rain, drops falling from the leaf tips in the sun, 4 frames.
Row 8: nature at work: a bee visits a blossom, 4 frames + a seed falls from the tree and a tiny new sprout appears beside it, 4 frames.
The plant never wilts or dies in any frame.

{fruta} = for fruit trees: fruit life, 8 frames: {fruit}s ripen on the branches from green to ripe color in 4 frames, then one ripe {fruit} falls, bounces once on the ground and rolls to a stop in 4 frames (the fallen {fruit} stays inside the cell).
         otherwise: falling leaves or petals, 8 frames loop: a few leaves or petals detach and drift down to the ground inside the cell.
```

### Plantas menores (PL-P) · 6 × 4 · célula 128

```
{visual}. Signature detail: {traco}. Seen from the top-down 3/4 view. Each cell shows the plant on a small patch of soil or water.
Row 1: growth stages left to right, 6 frames: {estagios}.
Row 2: full-grown plant in the wind, 6 frames loop: {jeito}.
Row 3: {extra3}
Row 4: 2nd-reading variant "florada" (more flowers), 3 frames + 3rd-reading variant "dourada" (soft golden glow, same species), 3 frames.
Row 5: reaction when tapped (a quick shake and one leaf or petal drifting), 3 frames + glistening after rain, 3 frames.
The plant never wilts or dies in any frame.
```

### Personagens bíblicos (H) · 8 × 8 · célula 128 + objetos 4 × 2 · 256

```
{visual}. Chibi proportions (head about one third of the height), warm and respectful, natural Middle Eastern skin tones and features without caricature, calm friendly face, no halo. The character lives in the garden, so it must look natural doing everyday things.
Row 1: idle breathing, 6 frames + 2 frames blinking.
Row 2: idle variations: stretching, 4 frames + looking up at the sky with a smile, 4 frames.
Row 3: walk cycle DOWN (toward the camera), 8 frames.
Row 4: walk cycle UP (away from the camera), 8 frames.
Row 5: walk cycle facing RIGHT, 8 frames.
Row 6: reaching up to pick a fruit from a branch above (branch not drawn), 4 frames + eating it happily, 4 frames.
Row 7: kneeling at the pond edge to wash hands, 4 frames + drinking water from cupped hands, 4 frames.
Row 8: sitting down on the ground to rest, 4 frames + dozing with slow breathing, 4 frames.
Row 9: kneeling to pet a small animal (animal not drawn), 4 frames + reaction when tapped (turns and waves at the viewer), 4 frames.
Row 10: weather: holding a hand over the head and hurrying in the rain, 4 frames + holding a hat or veil against a strong wind, 4 frames.
Row 11: evening: lighting a small lantern held in the hand, 4 frames + celebrating with the animals (clapping and a little jump), 4 frames.
Row 12: signature moment, {gag}, 8 frames: 2 anticipation, 4 action, 2 recovery (personality: {jeito}).

Second sheet (props), when the character has an object: {prop}. 4 columns x 2 rows, cell 256: row 1 the prop appearing, 4 frames; row 2 the prop in use, 4 frames.
```

## 5. Prompts, um por folha

Itens com modelo aparecem em tabela (o prompt completo, já preenchido, está na planilha 04). Itens únicos trazem o prompt aqui.

## Prioridade P1

### Animais (10)

| Código | Nome | Arquivo | Grade | Notas |
| --- | --- | --- | --- | --- |
| A001 | Ovelha | `arte/animais/ovelha__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica · companheira inicial · livros: JDG, AMO, MIC, LUK, 1PE |
| A002 | Capivara | `arte/animais/capivara__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: brasileira · companheira inicial |
| A003 | Beija-flor | `arte/animais/beija-flor__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: brasileira · companheiro inicial · livros: 3JN |
| A007 | Cordeiro | `arte/animais/cordeiro__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica · liberado com orvalho · livros: JHN |
| A009 | Pomba | `arte/animais/pomba__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: bíblica · liberado com orvalho · livros: GEN, 1JN |
| A033 | Peixinhos | `arte/animais/peixinhos__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-A · origem: ambiente · aparece no lago |
| A037 | Pardais | `arte/animais/pardais__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: bíblica · marco · livros: PSA |
| A043 | Galo | `arte/animais/galo__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: bíblica · cena de Pedro · livros: MRK |
| A064 | Peixe-de-são-pedro (tilápia) | `arte/animais/tilapia__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-A · origem: bíblica · animal citado ou associado a um livro · livros: EZK |
| A069 | Galinha e pintinhos | `arte/animais/galinha-pintinhos__anim.png` | 8 × 8 · célula 192 px · 1536 × 1536 | Modelo A-G · origem: bíblica · animal citado ou associado a um livro · livros: MAT |

### Plantas (13)

| Código | Nome | Arquivo | Grade | Notas |
| --- | --- | --- | --- | --- |
| PL001 | Oliveira | `arte/plantas/oliveira__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica · frutífera (fruto caindo) |
| PL003 | Figueira | `arte/plantas/figueira__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica · frutífera (fruto caindo) |
| PL004 | Sicômoro (figueira-brava) | `arte/plantas/sicomoro__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica · frutífera (fruto caindo) |
| PL005 | Videira | `arte/plantas/videira__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: trepadeira · origem: bíblica · frutífera (fruto caindo) |
| PL008 | Romãzeira | `arte/plantas/romazeira__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica · frutífera (fruto caindo) |
| PL009 | Tamareira | `arte/plantas/tamareira__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: palmeira · origem: bíblica · frutífera (fruto caindo) |
| PL022 | Macieira | `arte/plantas/macieira__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica · frutífera (fruto caindo) |
| PL028 | Mostardeira | `arte/plantas/mostardeira__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: arbusto · origem: bíblica |
| PL055 | Ipê-amarelo | `arte/plantas/ipe-amarelo__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: brasileira |
| PL089 | Musgo e trevos | `arte/plantas/musgo__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: erva · origem: chão e água |
| PL090 | Junco e taboa | `arte/plantas/junco__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: aquatica · origem: chão e água |
| PL091 | Ninfeia | `arte/plantas/nenufar__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: aquatica · origem: chão e água |
| PL092 | Cogumelos | `arte/plantas/cogumelos-variados__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: erva · origem: chão e água |

### Personagens bíblicos (6)

| Código | Nome | Arquivo | Grade | Notas |
| --- | --- | --- | --- | --- |
| H01 | Noé | `arte/personagens/noe__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: GEN · libera ao ler Gn 6–8 · preço sugerido: 600 orvalhos · gracinha: constrói a arquinha, sobe nela e solta a pomba. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H19 | Davi (pastor) | `arte/personagens/davi-pastor__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: PSA · libera ao ler Sl 23 · preço sugerido: 600 orvalhos · gracinha: toca harpa e acerta uma pinha com a funda. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H40 | Pedro | `arte/personagens/pedro__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: MAT · libera ao ler Mt 14:29 · preço sugerido: 400 orvalhos · gracinha: anda sobre o laguinho, afunda e volta rindo. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H41 | A viúva das duas moedas | `arte/personagens/viuva__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: MRK · libera ao ler Mc 12:42 · preço sugerido: 600 orvalhos · gracinha: oferta as duas moedinhas que brilham. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H42 | Zaqueu | `arte/personagens/zaqueu__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: LUK · libera ao ler Lc 19 · preço sugerido: 400 orvalhos · gracinha: sobe na figueira-brava e desce correndo. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H43 | O menino dos pães e peixes | `arte/personagens/menino-paes__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: JHN · libera ao ler Jo 6:9 · preço sugerido: 600 orvalhos · gracinha: divide o lanche e a cesta continua cheia. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |

### Cenário (6)

#### C01 · Chão de grama (P1)
- **Arquivo:** `arte/cenario/grama__tiles.png` · **grade:** 8 × 2 · célula 256 px · 2048 × 512

```
[Bloco de estilo]

Tile rules: top-down 3/4 view tiles, square, no text, no grid lines, moderate contrast so the floor never competes with characters, light from the top-left; every tile edge matches its neighbours seamlessly. Exact grid of 8 columns x 2 rows of square 256x256 tiles, total 2048x512.

Row 1: soft grass, 8 subtle variants (tufts, slightly different shades).
Row 2: grass with clover, tiny wildflowers and fallen leaves, 8 variants, low contrast.
```

#### C02 · Terra, areia e caminho (P1)
- **Arquivo:** `arte/cenario/solo__tiles.png` · **grade:** 8 × 2 · célula 256 px · 2048 × 512

```
[Bloco de estilo]

Tile rules: top-down 3/4 view tiles, square, no text, no grid lines, moderate contrast so the floor never competes with characters, light from the top-left; every tile edge matches its neighbours seamlessly. Exact grid of 8 columns x 2 rows of square 256x256 tiles.

Row 1: tilled garden soil 2, fresh dirt mound for a new seed 1, warm desert sand 2 (Pentateuch), smooth river pebbles 1, mossy stone floor 2.
Row 2: stepping-stone path 4 variants (straight, corner, end, crossing), wooden plank path 2, small wooden bridge over water 2.
```

#### C03 · Laguinho (borda e água) (P1)
- **Arquivo:** `arte/cenario/lago__autotile.png` · **grade:** 8 × 4 · célula 256 px · 2048 × 1024

```
[Bloco de estilo]

Tile rules: top-down 3/4 view tiles, square, no text, no grid lines, moderate contrast so the floor never competes with characters, light from the top-left; every tile edge matches its neighbours seamlessly. Exact grid of 8 columns x 4 rows of square 256x256 tiles.

Rows 1-2: a 16-piece autotile set for a small pond shore seen from the top-down 3/4 view (outer corners, inner corners, straight edges, center), with a soft grass rim and a darker water edge showing a little depth.
Row 3: open water center tile animated, 8 frames loop (gentle shimmer and slow ripples).
Row 4: small river tile flowing to the right, 8 frames loop.
```

#### C04 · Vida do laguinho (P1)
- **Arquivo:** `arte/cenario/lago__vida.png` · **grade:** 8 × 3 · célula 128 px · 1024 × 384

```
[Bloco de estilo]

Sprite sheet rules: transparent background (PNG with alpha), no floor, no cast shadow, no text, no grid lines, no frame borders. Exact uniform grid of 8 columns x 3 rows of square cells, each cell 128x128 px, total image 1024x384 px. Every frame stays fully inside its own cell with ~6% empty margin: nothing (tails, wings, leaves, falling fruit, petals, sparks, glow) may cross into a neighbouring cell. Feet (or the base of a floating body, or the base of a plant) sit on the same horizontal line in every frame, at 85% of the cell height. Same scale and same size in every frame and row. Unless a row says otherwise the subject faces RIGHT (the game mirrors it for left); rows marked DOWN face the camera, rows marked UP show the back. Animation rows read left to right; looping rows loop seamlessly (last frame flows into the first). Natural proportions, never stretched or squashed. Animation principles: clear anticipation before every jump or action, gentle squash and stretch on landings, and secondary motion: hair, cloaks, ears, tails, wings and leaves follow the movement 1-2 frames later; idle rows always breathe subtly.

Row 1: lily pads 4 variants + a lily flower opening 4 frames.
Row 2: reeds and cattails swaying 4 frames + mossy rocks at the water 4 variants.
Row 3: ripple rings when a fish rises 4 frames + a small splash 4 frames.
```

#### C05 · Borda do jardim e encontro com a floresta (P1)
- **Arquivo:** `arte/cenario/borda__tiles.png` · **grade:** 8 × 2 · célula 256 px · 2048 × 512
- **Nota:** Cada jardim é um pequeno ecossistema; as bordas permitem que os jardins vizinhos se encaixem e formem a floresta.

```
[Bloco de estilo]

Tile rules: top-down 3/4 view tiles, square, no text, no grid lines, moderate contrast so the floor never competes with characters, light from the top-left; every tile edge matches its neighbours seamlessly. Exact grid of 8 columns x 2 rows of square 256x256 tiles.

Row 1: the soft edge of a garden where it meets the neighbouring garden: tall grass, ferns and small bushes, in pieces for top, bottom, left, right and 4 corners.
Row 2: the same edge turning into dense forest (deeper shade, bigger trunks at the border), same 8 pieces; this is how the small gardens join into one big forest.
```

#### C06 · Cercas, pontes e mureta (P1)
- **Arquivo:** `arte/cenario/estruturas__set.png` · **grade:** 8 × 2 · célula 128 px · 1024 × 256

```
[Bloco de estilo]

Sprite sheet rules: transparent background (PNG with alpha), no floor, no cast shadow, no text, no grid lines, no frame borders. Exact uniform grid of 8 columns x 2 rows of square cells, each cell 128x128 px, total image 1024x256 px. Every frame stays fully inside its own cell with ~6% empty margin: nothing (tails, wings, leaves, falling fruit, petals, sparks, glow) may cross into a neighbouring cell. Feet (or the base of a floating body, or the base of a plant) sit on the same horizontal line in every frame, at 85% of the cell height. Same scale and same size in every frame and row. Unless a row says otherwise the subject faces RIGHT (the game mirrors it for left); rows marked DOWN face the camera, rows marked UP show the back. Animation rows read left to right; looping rows loop seamlessly (last frame flows into the first). Natural proportions, never stretched or squashed. Animation principles: clear anticipation before every jump or action, gentle squash and stretch on landings, and secondary motion: hair, cloaks, ears, tails, wings and leaves follow the movement 1-2 frames later; idle rows always breathe subtly.

Row 1: low wooden fence pieces (straight, corner, gate closed, gate open), low stone wall pieces (straight, corner, end, with moss).
Row 2: small arched wooden bridge 2 views, stepping stones over water 2, garden arch with vines 2, wooden signpost 2.
```

### Itens (9)

#### I01 · Baú do diário (P1)
- **Arquivo:** `arte/itens/bau__anim.png` · **grade:** 8 × 1 · célula 128 px · 1024 × 128

```
[Bloco de estilo]

Sprite sheet rules: transparent background (PNG with alpha), no floor, no cast shadow, no text, no grid lines, no frame borders. Exact uniform grid of 8 columns x 1 rows of square cells, each cell 128x128 px, total image 1024x128 px. Every frame stays fully inside its own cell with ~6% empty margin: nothing (tails, wings, leaves, falling fruit, petals, sparks, glow) may cross into a neighbouring cell. Feet (or the base of a floating body, or the base of a plant) sit on the same horizontal line in every frame, at 85% of the cell height. Same scale and same size in every frame and row. Unless a row says otherwise the subject faces RIGHT (the game mirrors it for left); rows marked DOWN face the camera, rows marked UP show the back. Animation rows read left to right; looping rows loop seamlessly (last frame flows into the first). Natural proportions, never stretched or squashed. Animation principles: clear anticipation before every jump or action, gentle squash and stretch on landings, and secondary motion: hair, cloaks, ears, tails, wings and leaves follow the movement 1-2 frames later; idle rows always breathe subtly.

A small wooden treasure chest half-buried in soil. Frames: closed 1, trembling 2, opening 3, open with a warm light rising, loop 2.
```

#### I02 · Lanterna (P1)
- **Arquivo:** `arte/itens/lanterna__anim.png` · **grade:** 8 × 1 · célula 128 px · 1024 × 128

```
[Bloco de estilo]

Sprite sheet rules: transparent background (PNG with alpha), no floor, no cast shadow, no text, no grid lines, no frame borders. Exact uniform grid of 8 columns x 1 rows of square cells, each cell 128x128 px, total image 1024x128 px. Every frame stays fully inside its own cell with ~6% empty margin: nothing (tails, wings, leaves, falling fruit, petals, sparks, glow) may cross into a neighbouring cell. Feet (or the base of a floating body, or the base of a plant) sit on the same horizontal line in every frame, at 85% of the cell height. Same scale and same size in every frame and row. Unless a row says otherwise the subject faces RIGHT (the game mirrors it for left); rows marked DOWN face the camera, rows marked UP show the back. Animation rows read left to right; looping rows loop seamlessly (last frame flows into the first). Natural proportions, never stretched or squashed. Animation principles: clear anticipation before every jump or action, gentle squash and stretch on landings, and secondary motion: hair, cloaks, ears, tails, wings and leaves follow the movement 1-2 frames later; idle rows always breathe subtly.

A garden lantern on a wooden post. Frames: unlit 1, lighting up 3, lit with a warm flickering glow, loop 4.
```

#### I03 · Semente de presente (P1)
- **Arquivo:** `arte/itens/semente-presente__anim.png` · **grade:** 8 × 1 · célula 128 px · 1024 × 128

```
[Bloco de estilo]

Sprite sheet rules: transparent background (PNG with alpha), no floor, no cast shadow, no text, no grid lines, no frame borders. Exact uniform grid of 8 columns x 1 rows of square cells, each cell 128x128 px, total image 1024x128 px. Every frame stays fully inside its own cell with ~6% empty margin: nothing (tails, wings, leaves, falling fruit, petals, sparks, glow) may cross into a neighbouring cell. Feet (or the base of a floating body, or the base of a plant) sit on the same horizontal line in every frame, at 85% of the cell height. Same scale and same size in every frame and row. Unless a row says otherwise the subject faces RIGHT (the game mirrors it for left); rows marked DOWN face the camera, rows marked UP show the back. Animation rows read left to right; looping rows loop seamlessly (last frame flows into the first). Natural proportions, never stretched or squashed. Animation principles: clear anticipation before every jump or action, gentle squash and stretch on landings, and secondary motion: hair, cloaks, ears, tails, wings and leaves follow the movement 1-2 frames later; idle rows always breathe subtly.

A small cloth seed pouch tied with twine, a gift for a friend. Frames: wobbling 4, opening 3, glowing seed revealed 1.
```

#### I04 · Pedras de Ebenézer (P1)
- **Arquivo:** `arte/itens/ebenezer__anim.png` · **grade:** 8 × 1 · célula 128 px · 1024 × 128

```
[Bloco de estilo]

Sprite sheet rules: transparent background (PNG with alpha), no floor, no cast shadow, no text, no grid lines, no frame borders. Exact uniform grid of 8 columns x 1 rows of square cells, each cell 128x128 px, total image 1024x128 px. Every frame stays fully inside its own cell with ~6% empty margin: nothing (tails, wings, leaves, falling fruit, petals, sparks, glow) may cross into a neighbouring cell. Feet (or the base of a floating body, or the base of a plant) sit on the same horizontal line in every frame, at 85% of the cell height. Same scale and same size in every frame and row. Unless a row says otherwise the subject faces RIGHT (the game mirrors it for left); rows marked DOWN face the camera, rows marked UP show the back. Animation rows read left to right; looping rows loop seamlessly (last frame flows into the first). Natural proportions, never stretched or squashed. Animation principles: clear anticipation before every jump or action, gentle squash and stretch on landings, and secondary motion: hair, cloaks, ears, tails, wings and leaves follow the movement 1-2 frames later; idle rows always breathe subtly.

Smooth grey memorial stones (1 Samuel 7:12). Frames: 1, 2, 3, 4, 5, 6 stones stacked, then a soft sparkle as a new stone is raised 2.
```

#### I05 · Fonte de pedra (P1)
- **Arquivo:** `arte/itens/fonte__anim.png` · **grade:** 8 × 1 · célula 128 px · 1024 × 128

```
[Bloco de estilo]

Sprite sheet rules: transparent background (PNG with alpha), no floor, no cast shadow, no text, no grid lines, no frame borders. Exact uniform grid of 8 columns x 1 rows of square cells, each cell 128x128 px, total image 1024x128 px. Every frame stays fully inside its own cell with ~6% empty margin: nothing (tails, wings, leaves, falling fruit, petals, sparks, glow) may cross into a neighbouring cell. Feet (or the base of a floating body, or the base of a plant) sit on the same horizontal line in every frame, at 85% of the cell height. Same scale and same size in every frame and row. Unless a row says otherwise the subject faces RIGHT (the game mirrors it for left); rows marked DOWN face the camera, rows marked UP show the back. Animation rows read left to right; looping rows loop seamlessly (last frame flows into the first). Natural proportions, never stretched or squashed. Animation principles: clear anticipation before every jump or action, gentle squash and stretch on landings, and secondary motion: hair, cloaks, ears, tails, wings and leaves follow the movement 1-2 frames later; idle rows always breathe subtly.

A small stone fountain with a thin water jet, 8 frames loop.
```

#### I06 · Poço (P1)
- **Arquivo:** `arte/itens/poco__anim.png` · **grade:** 8 × 1 · célula 128 px · 1024 × 128

```
[Bloco de estilo]

Sprite sheet rules: transparent background (PNG with alpha), no floor, no cast shadow, no text, no grid lines, no frame borders. Exact uniform grid of 8 columns x 1 rows of square cells, each cell 128x128 px, total image 1024x128 px. Every frame stays fully inside its own cell with ~6% empty margin: nothing (tails, wings, leaves, falling fruit, petals, sparks, glow) may cross into a neighbouring cell. Feet (or the base of a floating body, or the base of a plant) sit on the same horizontal line in every frame, at 85% of the cell height. Same scale and same size in every frame and row. Unless a row says otherwise the subject faces RIGHT (the game mirrors it for left); rows marked DOWN face the camera, rows marked UP show the back. Animation rows read left to right; looping rows loop seamlessly (last frame flows into the first). Natural proportions, never stretched or squashed. Animation principles: clear anticipation before every jump or action, gentle squash and stretch on landings, and secondary motion: hair, cloaks, ears, tails, wings and leaves follow the movement 1-2 frames later; idle rows always breathe subtly.

A small stone well with a wooden roof. Frames: bucket going down 4, coming up full 4.
```

#### I07 · Colmeia (P1)
- **Arquivo:** `arte/itens/colmeia__anim.png` · **grade:** 8 × 1 · célula 128 px · 1024 × 128

```
[Bloco de estilo]

Sprite sheet rules: transparent background (PNG with alpha), no floor, no cast shadow, no text, no grid lines, no frame borders. Exact uniform grid of 8 columns x 1 rows of square cells, each cell 128x128 px, total image 1024x128 px. Every frame stays fully inside its own cell with ~6% empty margin: nothing (tails, wings, leaves, falling fruit, petals, sparks, glow) may cross into a neighbouring cell. Feet (or the base of a floating body, or the base of a plant) sit on the same horizontal line in every frame, at 85% of the cell height. Same scale and same size in every frame and row. Unless a row says otherwise the subject faces RIGHT (the game mirrors it for left); rows marked DOWN face the camera, rows marked UP show the back. Animation rows read left to right; looping rows loop seamlessly (last frame flows into the first). Natural proportions, never stretched or squashed. Animation principles: clear anticipation before every jump or action, gentle squash and stretch on landings, and secondary motion: hair, cloaks, ears, tails, wings and leaves follow the movement 1-2 frames later; idle rows always breathe subtly.

A traditional straw beehive. Frames: humming loop with the hive slightly pulsing 4, two bees coming out 4.
```

#### I13 · Decoração estática (P1)
- **Arquivo:** `arte/itens/decoracao__set.png` · **grade:** 8 × 3 · célula 128 px · 1024 × 384

```
[Bloco de estilo]

Sprite sheet rules: transparent background (PNG with alpha), no floor, no cast shadow, no text, no grid lines, no frame borders. Exact uniform grid of 8 columns x 3 rows of square cells, each cell 128x128 px, total image 1024x384 px. Every frame stays fully inside its own cell with ~6% empty margin: nothing (tails, wings, leaves, falling fruit, petals, sparks, glow) may cross into a neighbouring cell. Feet (or the base of a floating body, or the base of a plant) sit on the same horizontal line in every frame, at 85% of the cell height. Same scale and same size in every frame and row. Unless a row says otherwise the subject faces RIGHT (the game mirrors it for left); rows marked DOWN face the camera, rows marked UP show the back. Animation rows read left to right; looping rows loop seamlessly (last frame flows into the first). Natural proportions, never stretched or squashed. Animation principles: clear anticipation before every jump or action, gentle squash and stretch on landings, and secondary motion: hair, cloaks, ears, tails, wings and leaves follow the movement 1-2 frames later; idle rows always breathe subtly.

One object per cell, each on a small patch of soil.
Row 1: wooden bench; three red mushrooms with white dots; mossy rock; round green bush; small flower bed; grapevine pergola; bird nest with eggs; picnic blanket with a basket.
Row 2: clay flower pots 2 sizes; wooden wheelbarrow; harvest basket with fruit; small wooden table with two stools; stone birdbath; scarecrow with a straw hat (friendly); garden tool rack.
Row 3 (seasonal, return every year): advent wreath with four candles (three violet, one pink); tiny straw manger with a soft star above and no people; bundle of palm branches; white Easter lilies in a clay pot; golden star for a tree top; short segment of colorful string lights; Pentecost red ribbons on a pole; small wooden sign marking a real tree planted.
```

#### I14 · Orvalho (moeda) (P1)
- **Arquivo:** `arte/itens/orvalho__anim.png` · **grade:** 8 × 3 · célula 64 px · 512 × 192
- **Nota:** Linha 3: pacotes de orvalho para quem quiser acelerar itens especiais (compra opcional; tudo pode ser conseguido de graça).

```
[Bloco de estilo]

Sprite sheet rules: transparent background (PNG with alpha), no floor, no cast shadow, no text, no grid lines, no frame borders. Exact uniform grid of 8 columns x 3 rows of square cells, each cell 64x64 px, total image 512x192 px. Every frame stays fully inside its own cell with ~6% empty margin: nothing (tails, wings, leaves, falling fruit, petals, sparks, glow) may cross into a neighbouring cell. Feet (or the base of a floating body, or the base of a plant) sit on the same horizontal line in every frame, at 85% of the cell height. Same scale and same size in every frame and row. Unless a row says otherwise the subject faces RIGHT (the game mirrors it for left); rows marked DOWN face the camera, rows marked UP show the back. Animation rows read left to right; looping rows loop seamlessly (last frame flows into the first). Natural proportions, never stretched or squashed. Animation principles: clear anticipation before every jump or action, gentle squash and stretch on landings, and secondary motion: hair, cloaks, ears, tails, wings and leaves follow the movement 1-2 frames later; idle rows always breathe subtly.

A shiny dew drop, the game's coin.
Row 1: idle shimmer, 8 frames loop.
Row 2: being collected: rises, sparkles and flies up, 8 frames.
Row 3: a small pouch of dew drops in 4 sizes (small, medium, large, huge), 2 frames each with a soft sparkle.
```

### Efeitos (9)

#### E01 · Crescimento (recompensa) (P1)
- **Arquivo:** `arte/efeitos/crescimento__anim.png` · **grade:** 8 × 1 · célula 256 px · 2048 × 256

```
[Bloco de estilo]

Effect sheet rules: transparent background, additive-friendly bright core with soft translucent edges, no hard flat white shapes that could cover characters, no text, no grid lines. Exact uniform grid of 8 columns x 1 rows, each cell 256x256 px, total 2048x256 px; every frame centered and fully inside its cell with ~6% margin.

Soft golden burst of light dots and small leaves rising and fading, 8 frames: 2 gathering, 4 burst, 2 fading.
```

#### E02 · Rajada de vento (P1)
- **Arquivo:** `arte/efeitos/vento__anim.png` · **grade:** 8 × 2 · célula 256 px · 2048 × 512

```
[Bloco de estilo]

Effect sheet rules: transparent background, additive-friendly bright core with soft translucent edges, no hard flat white shapes that could cover characters, no text, no grid lines. Exact uniform grid of 8 columns x 2 rows, each cell 256x256 px, total 2048x512 px; every frame centered and fully inside its cell with ~6% margin.

Row 1: a gentle gust of wind shown as soft translucent swirls carrying 3-4 leaves across the cell, 8 frames.
Row 2: the same gust carrying flower petals, 8 frames.
```

#### E03 · Raios de sol e partículas de luz (P1)
- **Arquivo:** `arte/efeitos/raios-sol__anim.png` · **grade:** 8 × 1 · célula 256 px · 2048 × 256

```
[Bloco de estilo]

Effect sheet rules: transparent background, additive-friendly bright core with soft translucent edges, no hard flat white shapes that could cover characters, no text, no grid lines. Exact uniform grid of 8 columns x 1 rows, each cell 256x256 px, total 2048x256 px; every frame centered and fully inside its cell with ~6% margin.

Soft volumetric sun shafts with floating dust motes slowly pulsing, 8 frames loop, in the glowing style of Ori.
```

#### E04 · Vaga-lumes (P1)
- **Arquivo:** `arte/efeitos/vagalumes__anim.png` · **grade:** 8 × 1 · célula 64 px · 512 × 64

```
[Bloco de estilo]

Effect sheet rules: transparent background, additive-friendly bright core with soft translucent edges, no hard flat white shapes that could cover characters, no text, no grid lines. Exact uniform grid of 8 columns x 1 rows, each cell 64x64 px, total 512x64 px; every frame centered and fully inside its cell with ~6% margin.

A firefly glow pulsing from off to bright and back, 8 frames loop.
```

#### E05 · Chuva e gotas (P1)
- **Arquivo:** `arte/efeitos/chuva__anim.png` · **grade:** 8 × 2 · célula 64 px · 512 × 128

```
[Bloco de estilo]

Effect sheet rules: transparent background, additive-friendly bright core with soft translucent edges, no hard flat white shapes that could cover characters, no text, no grid lines. Exact uniform grid of 8 columns x 2 rows, each cell 64x64 px, total 512x128 px; every frame centered and fully inside its cell with ~6% margin.

Row 1: a raindrop splash on grass, 8 frames.
Row 2: a raindrop splash on water with a ripple ring, 8 frames.
```

#### E08 · Chegada de animal ou personagem (P1)
- **Arquivo:** `arte/efeitos/chegada__anim.png` · **grade:** 8 × 1 · célula 192 px · 1536 × 192

```
[Bloco de estilo]

Effect sheet rules: transparent background, additive-friendly bright core with soft translucent edges, no hard flat white shapes that could cover characters, no text, no grid lines. Exact uniform grid of 8 columns x 1 rows, each cell 192x192 px, total 1536x192 px; every frame centered and fully inside its cell with ~6% margin.

A circle of soft sparkles and small leaves gathering on the ground and opening into a warm light, 8 frames: 2 gathering, 4 opening, 2 fading.
```

#### E09 · Luz da oração (P1)
- **Arquivo:** `arte/efeitos/oracao-luz__anim.png` · **grade:** 8 × 1 · célula 256 px · 2048 × 256

```
[Bloco de estilo]

Effect sheet rules: transparent background, additive-friendly bright core with soft translucent edges, no hard flat white shapes that could cover characters, no text, no grid lines. Exact uniform grid of 8 columns x 1 rows, each cell 256x256 px, total 2048x256 px; every frame centered and fully inside its cell with ~6% margin.

A warm quiet light orb on a dark background, slowly breathing and growing, 8 frames loop. Calm and contemplative.
```

#### E13 · Emoções (balõezinhos) (P1)
- **Arquivo:** `arte/efeitos/emocoes__anim.png` · **grade:** 8 × 4 · célula 64 px · 512 × 256

```
[Bloco de estilo]

Effect sheet rules: transparent background, additive-friendly bright core with soft translucent edges, no hard flat white shapes that could cover characters, no text, no grid lines. Exact uniform grid of 8 columns x 4 rows, each cell 64x64 px, total 512x256 px; every frame centered and fully inside its cell with ~6% margin.

Small emotion bubbles that float above characters and animals, each 4 frames (pop in, wobble, wobble, fade), two per row: Row 1: heart; musical note. Row 2: sleepy zZz; exclamation spark. Row 3: question curl; sweat drop. Row 4: twinkling stars; small sun of joy. Soft rounded shapes, no letters.
```

#### E12 · Camada de chuva (P1)
- **Arquivo:** `arte/efeitos/chuva__camada.png` · **grade:** 1024 × 1024 (emendável)

```
[Bloco de estilo]

A seamless rain overlay 1024x1024 px, tileable on all 4 sides, thin translucent diagonal streaks, transparent background, no text.
```

### Interface (11)

#### U01 · Tela inicial animada (P1)
- **Arquivo:** `arte/interface/titulo__camadas.png` · **grade:** 5 camadas · 1440 × 2560

```
[Bloco de estilo]

Title screen for a phone in portrait, 1440x2560, delivered as 5 separate transparent layers for parallax: (1) sky glow; (2) far misty forest; (3) middle trees with light shafts; (4) a small garden ecosystem in the center with a young olive tree and a pond; (5) foreground leaves and ferns framing the bottom. Soft dawn light, glowing particles, no text (the logo is added by the app).
```

#### U02 · Botões com estados (P1)
- **Arquivo:** `arte/interface/botoes__estados.png` · **grade:** 4 × 4 · célula 256 px · 1024 × 1024

```
[Bloco de estilo]

Sprite sheet rules: transparent background (PNG with alpha), no floor, no cast shadow, no text, no grid lines, no frame borders. Exact uniform grid of 4 columns x 4 rows of square cells, each cell 256x256 px, total image 1024x1024 px. Every frame stays fully inside its own cell with ~6% empty margin: nothing (tails, wings, leaves, falling fruit, petals, sparks, glow) may cross into a neighbouring cell. Feet (or the base of a floating body, or the base of a plant) sit on the same horizontal line in every frame, at 85% of the cell height. Same scale and same size in every frame and row. Animation rows read left to right; looping rows loop seamlessly (last frame flows into the first). Natural proportions, never stretched or squashed. Animation principles: clear anticipation before every jump or action, gentle squash and stretch on landings, and secondary motion: hair, cloaks, ears, tails, wings and leaves follow the movement 1-2 frames later; idle rows always breathe subtly.

One button style per row, 4 states per row (normal, pressed, disabled, highlighted with a soft shimmer), 9-slice ready with fixed rounded corners and a plain stretchable middle: Row 1 primary leaf-green wooden-edged button; Row 2 secondary sage outline button; Row 3 dew-blue purchase button with a tiny dew drop; Row 4 round icon button with a leaf rim.
```

#### U03 · Painéis, abas e barras (P1)
- **Arquivo:** `arte/interface/paineis__set.png` · **grade:** 4 × 3 · célula 256 px · 1024 × 768

```
[Bloco de estilo]

Sprite sheet rules: transparent background (PNG with alpha), no floor, no cast shadow, no text, no grid lines, no frame borders. Exact uniform grid of 4 columns x 3 rows of square cells, each cell 256x256 px, total image 1024x768 px. Every frame stays fully inside its own cell with ~6% empty margin: nothing (tails, wings, leaves, falling fruit, petals, sparks, glow) may cross into a neighbouring cell. Feet (or the base of a floating body, or the base of a plant) sit on the same horizontal line in every frame, at 85% of the cell height. Same scale and same size in every frame and row. Animation rows read left to right; looping rows loop seamlessly (last frame flows into the first). Natural proportions, never stretched or squashed. Animation principles: clear anticipation before every jump or action, gentle squash and stretch on landings, and secondary motion: hair, cloaks, ears, tails, wings and leaves follow the movement 1-2 frames later; idle rows always breathe subtly.

One UI piece per cell, 9-slice ready: parchment card with tiny corner leaves; sage card; floating toast panel; bottom sheet top with a twig-shaped handle; tab bar background; selected tab leaf marker; toggle switch off and on; slider track with a seed knob; daily portion bar frame; portion bar fill (dew blue to leaf green); progress bar with a sprout tip; notification badge (small dew drop).
```

#### U04 · Ícones da navegação e de ação (P1)
- **Arquivo:** `arte/interface/icones__set.png` · **grade:** 8 × 5 · célula 64 px · 512 × 320

```
[Bloco de estilo]

Sprite sheet rules: transparent background (PNG with alpha), no floor, no cast shadow, no text, no grid lines, no frame borders. Exact uniform grid of 8 columns x 5 rows of square cells, each cell 64x64 px, total image 512x320 px. Every frame stays fully inside its own cell with ~6% empty margin: nothing (tails, wings, leaves, falling fruit, petals, sparks, glow) may cross into a neighbouring cell. Feet (or the base of a floating body, or the base of a plant) sit on the same horizontal line in every frame, at 85% of the cell height. Same scale and same size in every frame and row. Animation rows read left to right; looping rows loop seamlessly (last frame flows into the first). Natural proportions, never stretched or squashed. Animation principles: clear anticipation before every jump or action, gentle squash and stretch on landings, and secondary motion: hair, cloaks, ears, tails, wings and leaves follow the movement 1-2 frames later; idle rows always breathe subtly.

Single ink color #22302A for inactive and leaf green #3F7A45 for active, rounded friendly shapes, same line weight.
Row 1: navigation inactive: garden, read (open book), pray (simple silhouette), forest (three trees), care (dew drop), shop (small basket), map, herbarium.
Row 2: the same navigation icons active.
Rows 3-5: action icons: settings, back, close, check, plus, minus, edit, trash, gift, share, bell, calendar, clock, search, sun, moon, rain, star, heart, bookmark, highlight, note, lock, unlock.
```

#### U05 · Tela de oração (cenário em camadas) (P1)
- **Arquivo:** `arte/interface/oracao__camadas.png` · **grade:** 4 camadas · 1440 × 2560 + folha 8 × 2 · 256

```
[Bloco de estilo]

Prayer screen for a phone in portrait, 1440x2560, as 4 transparent layers: (1) deep night sky with a few stars; (2) far forest silhouette with soft mist; (3) a quiet garden at the bottom with a small pond reflecting the moon; (4) foreground grass. Very calm, low detail, nothing distracting.

Also a separate sprite sheet (transparent, 8 columns x 2 rows, cell 256): Row 1: a single candle flame breathing, 8 frames loop; Row 2: the moon reflection rippling on the pond, 8 frames loop.
```

#### U06 · Ilustrações do devocional (P1)
- **Arquivo:** `arte/interface/devocional__temas.png` · **grade:** 8 imagens · 1280 × 720

```
[Bloco de estilo]

Eight separate header illustrations for daily devotionals, 1280x720 each, top-down 3/4 garden scenes with generous empty space for text, soft painterly light, no text: (1) light breaking at dawn; (2) a seed in open soil; (3) a winding path through the garden; (4) living water flowing from a spring; (5) bread and fish on a cloth; (6) a shepherd's staff resting by sheep; (7) a vine with grape clusters; (8) a bright morning star over the forest.
```

#### U07 · Moldura e fundo da leitura (P1)
- **Arquivo:** `arte/interface/leitura__ornamentos.png` · **grade:** 4 × 2 · célula 256 px · 1024 × 512

```
[Bloco de estilo]

Sprite sheet rules: transparent background (PNG with alpha), no floor, no cast shadow, no text, no grid lines, no frame borders. Exact uniform grid of 4 columns x 2 rows of square cells, each cell 256x256 px, total image 1024x512 px. Every frame stays fully inside its own cell with ~6% empty margin: nothing (tails, wings, leaves, falling fruit, petals, sparks, glow) may cross into a neighbouring cell. Feet (or the base of a floating body, or the base of a plant) sit on the same horizontal line in every frame, at 85% of the cell height. Same scale and same size in every frame and row. Animation rows read left to right; looping rows loop seamlessly (last frame flows into the first). Natural proportions, never stretched or squashed. Animation principles: clear anticipation before every jump or action, gentle squash and stretch on landings, and secondary motion: hair, cloaks, ears, tails, wings and leaves follow the movement 1-2 frames later; idle rows always breathe subtly.

Very subtle reading-screen ornaments, low contrast so they never compete with the text: chapter header vine (left, middle, right pieces), small leaf bookmark, end-of-chapter flower stamp, highlight marker shapes (yellow, green), and a seamless paper texture swatch.
```

#### U08 · Cartões de personagem e de animal (P1)
- **Arquivo:** `arte/interface/cartoes__molduras.png` · **grade:** 4 × 2 · célula 512 px · 2048 × 1024

```
[Bloco de estilo]

Sprite sheet rules: transparent background (PNG with alpha), no floor, no cast shadow, no text, no grid lines, no frame borders. Exact uniform grid of 4 columns x 2 rows of square cells, each cell 512x512 px, total image 2048x1024 px. Every frame stays fully inside its own cell with ~6% empty margin: nothing (tails, wings, leaves, falling fruit, petals, sparks, glow) may cross into a neighbouring cell. Feet (or the base of a floating body, or the base of a plant) sit on the same horizontal line in every frame, at 85% of the cell height. Same scale and same size in every frame and row. Animation rows read left to right; looping rows loop seamlessly (last frame flows into the first). Natural proportions, never stretched or squashed. Animation principles: clear anticipation before every jump or action, gentle squash and stretch on landings, and secondary motion: hair, cloaks, ears, tails, wings and leaves follow the movement 1-2 frames later; idle rows always breathe subtly.

Card frames for the shop and herbarium (each about 384x512 inside its cell), same structure, empty center: Row 1: Old Testament character frame (stone and olive branches), New Testament character frame (fishing net and blue waves), animal frame (leaves and paw prints), plant frame (pressed flowers). Row 2: the same four frames in the locked state (sepia with a soft silhouette slot and a small lock).
```

#### U09 · Tela de personagem liberado (P1)
- **Arquivo:** `arte/interface/liberado__camadas.png` · **grade:** 3 camadas · 1440 × 2560 + E08

```
[Bloco de estilo]

Character unlock screen, 1440x2560, as 3 transparent layers: (1) warm radiant background; (2) a soft spotlight circle on a small patch of garden where the character will stand; (3) floating petals and light motes in the foreground. No character, no text.
```

#### U11 · Ícone do app e símbolo (P1)
- **Arquivo:** `arte/interface/app-icone.png` · **grade:** 3 imagens · 1024 × 1024

```
[Bloco de estilo]

Three separate images, 1024x1024, no text: (1) app icon: a tiny garden ecosystem with a sprouting olive and a pond, soft dawn light, rounded-square safe area; (2) app icon: the same garden fully grown at golden hour; (3) symbol only: a sprout whose two leaves form a gentle open-book shape, transparent background.
```

#### U13 · Ilustrações do cadastro e estados vazios (P1)
- **Arquivo:** `arte/interface/cadastro-estados.png` · **grade:** 10 imagens · 960 × 720

```
[Bloco de estilo]

Ten separate illustrations, 960x720, top-down 3/4 view, soft background, generous empty space for text, no text: (1) a seed resting in soil at dawn; (2) an open book on a mossy stone; (3) three saplings side by side (olive, fig, golden ipe); (4) a sheep, a capybara and a hummingbird looking curious; (5) the same garden in morning mist, golden afternoon and night with fireflies; (6) empty wooden crate with one leaf (empty inventory); (7) unlit candle and folded blank note (no prayer requests yet); (8) open field journal with a pressed leaf (empty herbarium); (9) gentle rain over the garden with a rainbow starting (welcome back); (10) the garden glowing with petals in the air (book completed).
```

## Prioridade P2

### Animais (62)

| Código | Nome | Arquivo | Grade | Notas |
| --- | --- | --- | --- | --- |
| A004 | Borboletas | `arte/animais/borboletas__anim.png` | 8 × 5 · célula 64 px · 512 × 320 | Modelo A-I · origem: bíblica · liberado com orvalho · livros: 2CO |
| A005 | Abelhas | `arte/animais/abelhas__anim.png` | 8 × 5 · célula 64 px · 512 × 320 | Modelo A-I · origem: bíblica · liberado com orvalho · livros: SIR |
| A006 | Sanhaço | `arte/animais/sanhaco__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: brasileira · liberado com orvalho |
| A008 | Tatu-bola | `arte/animais/tatu-bola__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: brasileira · liberado com orvalho · livros: JUD |
| A010 | Coruja-buraqueira | `arte/animais/coruja__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: brasileira · liberado com orvalho |
| A011 | Garça | `arte/animais/garca__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: brasileira · liberado com orvalho · livros: JOS |
| A012 | Tucano | `arte/animais/tucano__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: brasileira · liberado com orvalho |
| A014 | Sabiá-laranjeira | `arte/animais/sabia__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: brasileira · liberado com orvalho |
| A015 | Bem-te-vi | `arte/animais/bem-te-vi__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: brasileira · liberado com orvalho |
| A016 | João-de-barro | `arte/animais/joao-de-barro__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: brasileira · liberado com orvalho · livros: HAG |
| A017 | Saíra-sete-cores | `arte/animais/saira__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: brasileira · liberado com orvalho |
| A018 | Arara-azul | `arte/animais/arara-azul__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: brasileira · liberado com orvalho |
| A022 | Tamanduá-bandeira | `arte/animais/tamandua__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: brasileira · liberado com orvalho |
| A023 | Preguiça | `arte/animais/preguica__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: brasileira · liberado com orvalho |
| A027 | Vaga-lume | `arte/animais/vaga-lume__anim.png` | 8 × 5 · célula 64 px · 512 × 320 | Modelo A-I · origem: ambiente · aparece à noite · livros: 2PE |
| A030 | Caracol | `arte/animais/caracol__anim.png` | 8 × 5 · célula 64 px · 512 × 320 | Modelo A-I · origem: ambiente · aparece depois da chuva · livros: 2TH |
| A032 | Formigas | `arte/animais/formiga__anim.png` | 8 × 5 · célula 64 px · 512 × 320 | Modelo A-I · origem: ambiente · aparece no terrário de Provérbios · livros: PRO |
| A034 | Patinhos | `arte/animais/patinhos__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-A · origem: ambiente · aparece no lago · livros: 2JN |
| A035 | Águia | `arte/animais/aguia__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: bíblica · marco: concluir um bioma · livros: DEU, OBA |
| A036 | Corça | `arte/animais/corca__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica · marco · livros: HAB |
| A038 | Leões sonolentos | `arte/animais/leoes__anim.png` | 8 × 8 · célula 192 px · 1536 × 1536 | Modelo A-G · origem: bíblica · cena de Daniel · livros: DAN |
| A040 | Grande peixe | `arte/animais/grande-peixe__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-A · origem: bíblica · cena de Jonas · livros: JON |
| A041 | Camelos | `arte/animais/camelos__anim.png` | 8 × 8 · célula 192 px · 1536 × 1536 | Modelo A-G · origem: bíblica · cena de Rebeca · livros: EZR |
| A042 | Jumentinho | `arte/animais/jumentinho__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica · cena de Ramos · livros: ZEC |
| A045 | Bezerro saltitante | `arte/animais/bezerro__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica · cena de Malaquias · livros: MAL |
| A047 | Codorniz | `arte/animais/codorniz__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica · animal citado ou associado a um livro · livros: EXO |
| A048 | Rolinha | `arte/animais/rolinha__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: bíblica · animal citado ou associado a um livro · livros: LEV, LAM, 2MA |
| A049 | Jumenta | `arte/animais/jumenta__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica · animal citado ou associado a um livro · livros: NUM |
| A050 | Ratinho-do-campo | `arte/animais/ratinho__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica (temático) · animal citado ou associado a um livro · livros: RUT |
| A051 | Perdiz | `arte/animais/perdiz__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica · animal citado ou associado a um livro · livros: 1SA |
| A052 | Mula | `arte/animais/mula__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica · animal citado ou associado a um livro · livros: 2SA |
| A053 | Pavão | `arte/animais/pavao__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica · animal citado ou associado a um livro · livros: 1KI |
| A054 | Cavalo | `arte/animais/cavalo__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica · animal citado ou associado a um livro · livros: 2KI, JAS |
| A055 | Gazela | `arte/animais/gazela__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica · animal citado ou associado a um livro · livros: 1CH |
| A056 | Macaquinho | `arte/animais/macaco__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica · animal citado ou associado a um livro · livros: 2CH |
| A057 | Raposa | `arte/animais/raposa__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica · animal citado ou associado a um livro · livros: NEH, SNG |
| A058 | Dromedário | `arte/animais/dromedario__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica · animal citado ou associado a um livro · livros: EST |
| A059 | Avestruz | `arte/animais/avestruz__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica · animal citado ou associado a um livro · livros: JOB |
| A060 | Cabra-montês | `arte/animais/cabra-montes__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica · animal citado ou associado a um livro · livros: JDT |
| A062 | Cão | `arte/animais/cao__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica · animal citado ou associado a um livro · livros: ECC, TOB |
| A063 | Cegonha | `arte/animais/cegonha__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: bíblica · animal citado ou associado a um livro · livros: JER |
| A065 | Novilha | `arte/animais/novilha__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica · animal citado ou associado a um livro · livros: HOS |
| A066 | Gafanhoto | `arte/animais/gafanhoto__anim.png` | 8 × 5 · célula 64 px · 512 × 320 | Modelo A-I · origem: bíblica · animal citado ou associado a um livro · livros: JOL |
| A067 | Leoa e filhotes | `arte/animais/leoa-filhotes__anim.png` | 8 × 8 · célula 192 px · 1536 × 1536 | Modelo A-G · origem: bíblica · animal citado ou associado a um livro · livros: NAM |
| A068 | Pelicano | `arte/animais/pelicano__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-A · origem: bíblica · animal citado ou associado a um livro · livros: ZEP |
| A070 | Gaivota | `arte/animais/gaivota__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: bíblica (temático) · animal citado ou associado a um livro · livros: ACT |
| A071 | Pombo-correio | `arte/animais/pombo-correio__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: bíblica (temático) · animal citado ou associado a um livro · livros: ROM |
| A072 | Cabra | `arte/animais/cabra__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica · animal citado ou associado a um livro · livros: 1CO |
| A073 | Cotovia | `arte/animais/cotovia__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: bíblica (temático) · animal citado ou associado a um livro · livros: GAL |
| A074 | Tartaruga-grega | `arte/animais/tartaruga__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica (temático) · animal citado ou associado a um livro · livros: EPH |
| A075 | Pintassilgo | `arte/animais/pintassilgo__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: bíblica (temático) · animal citado ou associado a um livro · livros: PHP |
| A076 | Toupeira | `arte/animais/toupeira__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: temático · animal citado ou associado a um livro · livros: COL |
| A077 | Coruja-das-torres | `arte/animais/coruja-torres__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: bíblica · animal citado ou associado a um livro · livros: 1TH, WIS |
| A078 | Lebre | `arte/animais/lebre__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica (temático) · animal citado ou associado a um livro · livros: 2TI |
| A079 | Cabra-de-creta (kri-kri) | `arte/animais/cabra-creta__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica (temático) · animal citado ou associado a um livro · livros: TIT |
| A080 | Andorinha | `arte/animais/andorinha__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: bíblica · animal citado ou associado a um livro · livros: PHM |
| A081 | Carneiro | `arte/animais/carneiro__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica · animal citado ou associado a um livro · livros: HEB |
| A082 | Boi | `arte/animais/boi__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica · animal citado ou associado a um livro · livros: 1TI |
| A083 | Leão e cordeiro | `arte/animais/leao-cordeiro__anim.png` | 8 × 8 · célula 192 px · 1536 × 1536 | Modelo A-G · origem: bíblica · animal citado ou associado a um livro · livros: REV |
| A084 | Leopardo e cabrito | `arte/animais/leopardo-cabrito__anim.png` | 8 × 8 · célula 192 px · 1536 × 1536 | Modelo A-G · origem: bíblica · animal citado ou associado a um livro · livros: ISA |
| A085 | Elefante | `arte/animais/elefante__anim.png` | 8 × 8 · célula 192 px · 1536 × 1536 | Modelo A-G · origem: bíblica · animal citado ou associado a um livro · livros: 1MA |
| A086 | Gato | `arte/animais/gato__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica · animal citado ou associado a um livro · livros: BAR |

### Plantas (64)

| Código | Nome | Arquivo | Grade | Notas |
| --- | --- | --- | --- | --- |
| PL002 | Oliveira-brava | `arte/plantas/oliveira-brava__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica · frutífera (fruto caindo) |
| PL006 | Cedro do Líbano | `arte/plantas/cedro-libano__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica |
| PL007 | Acácia | `arte/plantas/acacia__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica |
| PL010 | Amendoeira | `arte/plantas/amendoeira__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica · frutífera (fruto caindo) |
| PL011 | Aloés (agar) | `arte/plantas/aloes__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica |
| PL012 | Salgueiro de ribeiro | `arte/plantas/salgueiro__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica |
| PL013 | Terebinto | `arte/plantas/terebinto__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica |
| PL014 | Carvalho que rebrota | `arte/plantas/carvalho-toco__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica |
| PL015 | Espinheiro florido | `arte/plantas/espinheiro__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: arbusto · origem: bíblica |
| PL016 | Tamargueira | `arte/plantas/tamargueira__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica |
| PL017 | Balsameira (amoreira) | `arte/plantas/balsameira__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica |
| PL018 | Zimbro (giesta) | `arte/plantas/zimbro__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: arbusto · origem: bíblica |
| PL019 | Sândalo vermelho (algumim) | `arte/plantas/sandalo__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica |
| PL021 | Murta | `arte/plantas/murta__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: arbusto · origem: bíblica |
| PL023 | Lírio dos vales | `arte/plantas/lirio-vales__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: flor · origem: bíblica |
| PL024 | Lírios e anêmonas do campo | `arte/plantas/lirios-campo__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: flor · origem: bíblica |
| PL025 | Cipreste | `arte/plantas/cipreste__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica |
| PL026 | Cevada | `arte/plantas/cevada__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: erva · origem: bíblica |
| PL027 | Trigo | `arte/plantas/trigo__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: erva · origem: bíblica |
| PL029 | Planta de Jonas (mamoneira) | `arte/plantas/mamoneira__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: arbusto · origem: bíblica |
| PL031 | Árvore da vida | `arte/plantas/arvore-vida__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica · frutífera (fruto caindo) |
| PL032 | Árvore dos nove frutos | `arte/plantas/arvore-frutos-espirito__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica · frutífera (fruto caindo) |
| PL033 | Grande árvore frondosa | `arte/plantas/arvore-grande-daniel__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica |
| PL034 | Cedro plantado no monte | `arte/plantas/cedro-monte__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica |
| PL035 | Roseira de Jericó | `arte/plantas/roseira-jerico__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: arbusto · origem: bíblica |
| PL036 | Palmeira da vitória | `arte/plantas/palmeira-vitoria__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: palmeira · origem: bíblica · frutífera (fruto caindo) |
| PL037 | Árvore aromática (caneleira) | `arte/plantas/arvore-aromatica__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica |
| PL038 | Pomar com açude | `arte/plantas/pomar-variado__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica · frutífera (fruto caindo) |
| PL039 | Ipomeia (glória-da-manhã) | `arte/plantas/ipomeia__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: trepadeira · origem: temática |
| PL040 | Flor-da-rocha | `arte/plantas/flor-rocha__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: flor · origem: temática |
| PL041 | Flor do Carmelo | `arte/plantas/flor-carmelo__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: flor · origem: temática |
| PL042 | Girassol | `arte/plantas/girassol__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: flor · origem: temática |
| PL043 | Margarida | `arte/plantas/margarida__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: flor · origem: temática |
| PL044 | Calêndula | `arte/plantas/calendula__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: flor · origem: temática |
| PL045 | Jasmim | `arte/plantas/jasmim__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: arbusto · origem: temática |
| PL046 | Lavanda | `arte/plantas/lavanda__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: flor · origem: temática |
| PL047 | Lírio de Páscoa | `arte/plantas/lirio-pascoa__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: flor · origem: temática |
| PL048 | Hortelã | `arte/plantas/hortela__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: erva · origem: temática |
| PL049 | Violeta | `arte/plantas/violeta__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: flor · origem: temática |
| PL050 | Dama-da-noite | `arte/plantas/dama-da-noite__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: arbusto · origem: temática |
| PL051 | Rosa-de-Sarom (hibisco) | `arte/plantas/hibisco__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: arbusto · origem: temática |
| PL052 | Sempre-viva | `arte/plantas/sempre-viva__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: flor · origem: temática |
| PL053 | Espigas sob a chuva | `arte/plantas/espigas-chuva__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: erva · origem: bíblica |
| PL054 | Flor-do-campo | `arte/plantas/flor-campo__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: flor · origem: bíblica |
| PL058 | Jabuticabeira | `arte/plantas/jabuticabeira__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: brasileira · frutífera (fruto caindo) |
| PL060 | Araucária | `arte/plantas/araucaria__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: brasileira |
| PL063 | Cajueiro | `arte/plantas/cajueiro__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: brasileira · frutífera (fruto caindo) |
| PL064 | Pitangueira | `arte/plantas/pitangueira__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: brasileira · frutífera (fruto caindo) |
| PL065 | Cafeeiro | `arte/plantas/cafeeiro__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: arbusto · origem: brasileira · frutífera (fruto caindo) |
| PL066 | Pau-ferro | `arte/plantas/pau-ferro__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: brasileira |
| PL067 | Buriti | `arte/plantas/buriti__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: palmeira · origem: brasileira · frutífera (fruto caindo) |
| PL068 | Coqueiro | `arte/plantas/coqueiro__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: palmeira · origem: brasileira · frutífera (fruto caindo) |
| PL078 | Lobeira | `arte/plantas/lobeira__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: arbusto · origem: brasileira · frutífera (fruto caindo) |
| PL079 | Feijoeiro trepador | `arte/plantas/feijao-trepador__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: trepadeira · origem: brasileira |
| PL080 | Bananeira | `arte/plantas/bananeira__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: palmeira · origem: brasileira · frutífera (fruto caindo) |
| PL081 | Maracujá | `arte/plantas/maracuja__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: trepadeira · origem: brasileira · frutífera (fruto caindo) |
| PL109 | Mangueira | `arte/plantas/mangueira__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: brasileira · frutífera (fruto caindo) |
| PL110 | Jaqueira | `arte/plantas/jaqueira__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: brasileira · frutífera (fruto caindo) |
| PL111 | Goiabeira | `arte/plantas/goiabeira__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: brasileira · frutífera (fruto caindo) |
| PL112 | Aceroleira | `arte/plantas/aceroleira__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: arbusto · origem: brasileira · frutífera (fruto caindo) |
| PL113 | Pequizeiro | `arte/plantas/pequizeiro__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: brasileira · frutífera (fruto caindo) |
| PL114 | Açaizeiro | `arte/plantas/acaizeiro__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: palmeira · origem: brasileira · frutífera (fruto caindo) |
| PL115 | Cupuaçuzeiro | `arte/plantas/cupuacuzeiro__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: brasileira · frutífera (fruto caindo) |
| PL116 | Cacaueiro | `arte/plantas/cacaueiro__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: brasileira · frutífera (fruto caindo) |

### Personagens bíblicos (11)

| Código | Nome | Arquivo | Grade | Notas |
| --- | --- | --- | --- | --- |
| H02 | Moisés | `arte/personagens/moises__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: EXO · libera ao ler Êx 14 · preço sugerido: 600 orvalhos · gracinha: ergue o cajado e o laguinho se abre. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H03 | Arão | `arte/personagens/arao__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: LEV · libera ao ler Lv 8 · preço sugerido: 600 orvalhos · gracinha: acende o incenso e a fumaça vira folhinhas. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H04 | Balaão e a jumenta | `arte/personagens/balaao__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: NUM · libera ao ler Nm 22 · preço sugerido: 400 orvalhos · gracinha: a jumenta para e 'conversa' com ele. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H05 | Moisés (idoso) | `arte/personagens/moises-idoso__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: DEU · libera ao ler Dt 34 · preço sugerido: 600 orvalhos · gracinha: sobe na pedra e contempla a terra prometida. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H06 | Josué | `arte/personagens/josue__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: JOS · libera ao ler Js 6 · preço sugerido: 600 orvalhos · gracinha: marcha com a trombeta e a muralhinha cai. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H09 | Samuel (menino) | `arte/personagens/samuel__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: 1SA · libera ao ler 1 Sm 3 · preço sugerido: 600 orvalhos · gracinha: acorda três vezes e por fim escuta. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H12 | Elias | `arte/personagens/elias__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: 2KI · libera ao ler 2 Rs 2 · preço sugerido: 600 orvalhos · gracinha: a carruagem de fogo dá uma volta no jardim. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H27 | Daniel | `arte/personagens/daniel__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: DAN · libera ao ler Dn 6 · preço sugerido: 600 orvalhos · gracinha: ora na janela e o leão deita no colo. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H32 | Jonas | `arte/personagens/jonas__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: JON · libera ao ler Jn 2–4 · preço sugerido: 400 orvalhos · gracinha: sai do peixe encharcado e se abana na sombra. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H44 | Lídia | `arte/personagens/lidia__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: ACT · libera ao ler At 16:14 · preço sugerido: 600 orvalhos · gracinha: estende os tecidos roxos ao vento. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H66 | João em Patmos | `arte/personagens/joao-patmos__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: REV · libera ao ler Ap 1:9 · 21 · preço sugerido: 600 orvalhos · gracinha: escreve e contempla a cidade de luz. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |

### Cenário (3)

#### C07 · Fundo distante e névoa (2 camadas) (P2)
- **Arquivo:** `arte/cenario/fundo__camadas.png` · **grade:** 2 faixas · 2048 × 512 cada
- **Nota:** O céu e a cor do horário são desenhados pelo app.

```
[Bloco de estilo]

Background layer rules: two horizontal layers, each 2048x512 px, seamless horizontally, transparent where empty, no text.

Layer 1 (far): soft silhouettes of distant forest and hills with atmospheric haze.
Layer 2 (middle): drifting mist and soft light shafts with partial transparency, in the glowing style of Ori.
```

#### C08 · Mapa da floresta (biomas) (P2)
- **Arquivo:** `arte/cenario/mapa__biomas.png` · **grade:** 5 × 2 · célula 256 px · 1280 × 512

```
[Bloco de estilo]

Sprite sheet rules: transparent background (PNG with alpha), no floor, no cast shadow, no text, no grid lines, no frame borders. Exact uniform grid of 5 columns x 2 rows of square cells, each cell 256x256 px, total image 1280x512 px. Every frame stays fully inside its own cell with ~6% empty margin: nothing (tails, wings, leaves, falling fruit, petals, sparks, glow) may cross into a neighbouring cell. Feet (or the base of a floating body, or the base of a plant) sit on the same horizontal line in every frame, at 85% of the cell height. Same scale and same size in every frame and row. Unless a row says otherwise the subject faces RIGHT (the game mirrors it for left); rows marked DOWN face the camera, rows marked UP show the back. Animation rows read left to right; looping rows loop seamlessly (last frame flows into the first). Natural proportions, never stretched or squashed. Animation principles: clear anticipation before every jump or action, gentle squash and stretch on landings, and secondary motion: hair, cloaks, ears, tails, wings and leaves follow the movement 1-2 frames later; idle rows always breathe subtly.

Ten small garden ecosystems seen from the same top-down 3/4 view, one per cell, each with its biome look: desert oasis with palms; Canaan hills with olives; poetic garden with lilies and a harp; rocky valley with cedars; orchard of twelve small fruit trees; Galilee lakeshore with a boat; harbor road; mediterranean courtyard; humble stone garden with a well; crystal river of life with a radiant tree.
```

#### C09 · A floresta completa (P2)
- **Arquivo:** `arte/cenario/floresta__completa.png` · **grade:** 1 imagem · 2048 × 2048
- **Nota:** Usada na tela de conclusão da Bíblia e no pôster.

```
[Bloco de estilo]

One large illustration, 2048x2048, top-down 3/4 view: dozens of small garden ecosystems joined by paths and one shining river into a single giant forest, from a spring at one corner to a radiant tree of life, soft golden light and mist, no text.
```

### Itens (6)

#### I08 · Fogueira (P2)
- **Arquivo:** `arte/itens/fogueira__anim.png` · **grade:** 8 × 1 · célula 128 px · 1024 × 128

```
[Bloco de estilo]

Sprite sheet rules: transparent background (PNG with alpha), no floor, no cast shadow, no text, no grid lines, no frame borders. Exact uniform grid of 8 columns x 1 rows of square cells, each cell 128x128 px, total image 1024x128 px. Every frame stays fully inside its own cell with ~6% empty margin: nothing (tails, wings, leaves, falling fruit, petals, sparks, glow) may cross into a neighbouring cell. Feet (or the base of a floating body, or the base of a plant) sit on the same horizontal line in every frame, at 85% of the cell height. Same scale and same size in every frame and row. Unless a row says otherwise the subject faces RIGHT (the game mirrors it for left); rows marked DOWN face the camera, rows marked UP show the back. Animation rows read left to right; looping rows loop seamlessly (last frame flows into the first). Natural proportions, never stretched or squashed. Animation principles: clear anticipation before every jump or action, gentle squash and stretch on landings, and secondary motion: hair, cloaks, ears, tails, wings and leaves follow the movement 1-2 frames later; idle rows always breathe subtly.

A small cozy campfire with stones around it. Frames: lighting 2, burning loop 6 (warm, never dangerous).
```

#### I09 · Rede de descanso (P2)
- **Arquivo:** `arte/itens/rede__anim.png` · **grade:** 8 × 1 · célula 128 px · 1024 × 128

```
[Bloco de estilo]

Sprite sheet rules: transparent background (PNG with alpha), no floor, no cast shadow, no text, no grid lines, no frame borders. Exact uniform grid of 8 columns x 1 rows of square cells, each cell 128x128 px, total image 1024x128 px. Every frame stays fully inside its own cell with ~6% empty margin: nothing (tails, wings, leaves, falling fruit, petals, sparks, glow) may cross into a neighbouring cell. Feet (or the base of a floating body, or the base of a plant) sit on the same horizontal line in every frame, at 85% of the cell height. Same scale and same size in every frame and row. Unless a row says otherwise the subject faces RIGHT (the game mirrors it for left); rows marked DOWN face the camera, rows marked UP show the back. Animation rows read left to right; looping rows loop seamlessly (last frame flows into the first). Natural proportions, never stretched or squashed. Animation principles: clear anticipation before every jump or action, gentle squash and stretch on landings, and secondary motion: hair, cloaks, ears, tails, wings and leaves follow the movement 1-2 frames later; idle rows always breathe subtly.

A colorful Brazilian hammock between two short posts. Frames: still 2, swaying loop 6.
```

#### I10 · Regador (P2)
- **Arquivo:** `arte/itens/regador__anim.png` · **grade:** 8 × 1 · célula 128 px · 1024 × 128

```
[Bloco de estilo]

Sprite sheet rules: transparent background (PNG with alpha), no floor, no cast shadow, no text, no grid lines, no frame borders. Exact uniform grid of 8 columns x 1 rows of square cells, each cell 128x128 px, total image 1024x128 px. Every frame stays fully inside its own cell with ~6% empty margin: nothing (tails, wings, leaves, falling fruit, petals, sparks, glow) may cross into a neighbouring cell. Feet (or the base of a floating body, or the base of a plant) sit on the same horizontal line in every frame, at 85% of the cell height. Same scale and same size in every frame and row. Unless a row says otherwise the subject faces RIGHT (the game mirrors it for left); rows marked DOWN face the camera, rows marked UP show the back. Animation rows read left to right; looping rows loop seamlessly (last frame flows into the first). Natural proportions, never stretched or squashed. Animation principles: clear anticipation before every jump or action, gentle squash and stretch on landings, and secondary motion: hair, cloaks, ears, tails, wings and leaves follow the movement 1-2 frames later; idle rows always breathe subtly.

A metal watering can. Frames: tilting 2, pouring water loop 4, back 2.
```

#### I11 · Balanço (P2)
- **Arquivo:** `arte/itens/balanco__anim.png` · **grade:** 8 × 1 · célula 128 px · 1024 × 128

```
[Bloco de estilo]

Sprite sheet rules: transparent background (PNG with alpha), no floor, no cast shadow, no text, no grid lines, no frame borders. Exact uniform grid of 8 columns x 1 rows of square cells, each cell 128x128 px, total image 1024x128 px. Every frame stays fully inside its own cell with ~6% empty margin: nothing (tails, wings, leaves, falling fruit, petals, sparks, glow) may cross into a neighbouring cell. Feet (or the base of a floating body, or the base of a plant) sit on the same horizontal line in every frame, at 85% of the cell height. Same scale and same size in every frame and row. Unless a row says otherwise the subject faces RIGHT (the game mirrors it for left); rows marked DOWN face the camera, rows marked UP show the back. Animation rows read left to right; looping rows loop seamlessly (last frame flows into the first). Natural proportions, never stretched or squashed. Animation principles: clear anticipation before every jump or action, gentle squash and stretch on landings, and secondary motion: hair, cloaks, ears, tails, wings and leaves follow the movement 1-2 frames later; idle rows always breathe subtly.

A wooden swing hanging from a short frame. Frames: still 2, swinging loop 6.
```

#### I12 · Comedouro e casinha de passarinho (P2)
- **Arquivo:** `arte/itens/casinha__anim.png` · **grade:** 8 × 1 · célula 128 px · 1024 × 128

```
[Bloco de estilo]

Sprite sheet rules: transparent background (PNG with alpha), no floor, no cast shadow, no text, no grid lines, no frame borders. Exact uniform grid of 8 columns x 1 rows of square cells, each cell 128x128 px, total image 1024x128 px. Every frame stays fully inside its own cell with ~6% empty margin: nothing (tails, wings, leaves, falling fruit, petals, sparks, glow) may cross into a neighbouring cell. Feet (or the base of a floating body, or the base of a plant) sit on the same horizontal line in every frame, at 85% of the cell height. Same scale and same size in every frame and row. Unless a row says otherwise the subject faces RIGHT (the game mirrors it for left); rows marked DOWN face the camera, rows marked UP show the back. Animation rows read left to right; looping rows loop seamlessly (last frame flows into the first). Natural proportions, never stretched or squashed. Animation principles: clear anticipation before every jump or action, gentle squash and stretch on landings, and secondary motion: hair, cloaks, ears, tails, wings and leaves follow the movement 1-2 frames later; idle rows always breathe subtly.

A small birdhouse on a post with a seed feeder. Frames: still 2, seeds spilling 2, birdhouse door swinging 4.
```

#### I15 · Pedras da coroa (Ap 21:19-20) (P2)
- **Arquivo:** `arte/itens/pedras-coroa__set.png` · **grade:** 4 × 3 · célula 64 px · 256 × 192

```
[Bloco de estilo]

Sprite sheet rules: transparent background (PNG with alpha), no floor, no cast shadow, no text, no grid lines, no frame borders. Exact uniform grid of 4 columns x 3 rows of square cells, each cell 64x64 px, total image 256x192 px. Every frame stays fully inside its own cell with ~6% empty margin: nothing (tails, wings, leaves, falling fruit, petals, sparks, glow) may cross into a neighbouring cell. Feet (or the base of a floating body, or the base of a plant) sit on the same horizontal line in every frame, at 85% of the cell height. Same scale and same size in every frame and row. Unless a row says otherwise the subject faces RIGHT (the game mirrors it for left); rows marked DOWN face the camera, rows marked UP show the back. Animation rows read left to right; looping rows loop seamlessly (last frame flows into the first). Natural proportions, never stretched or squashed. Animation principles: clear anticipation before every jump or action, gentle squash and stretch on landings, and secondary motion: hair, cloaks, ears, tails, wings and leaves follow the movement 1-2 frames later; idle rows always breathe subtly.

Twelve small faceted gemstones, one per cell, true colors and a tiny sparkle: jasper, sapphire, chalcedony, emerald, sardonyx, carnelian, chrysolite, beryl, topaz, chrysoprase, jacinth, amethyst.
```

### Efeitos (6)

#### E06 · Pétalas caindo (P2)
- **Arquivo:** `arte/efeitos/petalas__anim.png` · **grade:** 8 × 3 · célula 64 px · 512 × 192

```
[Bloco de estilo]

Effect sheet rules: transparent background, additive-friendly bright core with soft translucent edges, no hard flat white shapes that could cover characters, no text, no grid lines. Exact uniform grid of 8 columns x 3 rows, each cell 64x64 px, total 512x192 px; every frame centered and fully inside its cell with ~6% margin.

Falling petals turning in the air, 8 frames loop per row. Row 1: pink; Row 2: white; Row 3: golden ipe.
```

#### E07 · Fruto colhido (P2)
- **Arquivo:** `arte/efeitos/fruto-pop__anim.png` · **grade:** 8 × 1 · célula 128 px · 1024 × 128

```
[Bloco de estilo]

Effect sheet rules: transparent background, additive-friendly bright core with soft translucent edges, no hard flat white shapes that could cover characters, no text, no grid lines. Exact uniform grid of 8 columns x 1 rows, each cell 128x128 px, total 1024x128 px; every frame centered and fully inside its cell with ~6% margin.

A small soft pop of light and leaves when a fruit is picked or lands, 8 frames.
```

#### E10 · Névoa da manhã (P2)
- **Arquivo:** `arte/efeitos/nevoa__anim.png` · **grade:** 8 × 1 · célula 256 px · 2048 × 256

```
[Bloco de estilo]

Effect sheet rules: transparent background, additive-friendly bright core with soft translucent edges, no hard flat white shapes that could cover characters, no text, no grid lines. Exact uniform grid of 8 columns x 1 rows, each cell 256x256 px, total 2048x256 px; every frame centered and fully inside its cell with ~6% margin.

A soft low morning mist drifting across the ground, 8 frames loop, very translucent.
```

#### E11 · Arco-íris na névoa (P2)
- **Arquivo:** `arte/efeitos/arco-iris__anim.png` · **grade:** 4 × 1 · célula 256 px · 1024 × 256

```
[Bloco de estilo]

Effect sheet rules: transparent background, additive-friendly bright core with soft translucent edges, no hard flat white shapes that could cover characters, no text, no grid lines. Exact uniform grid of 4 columns x 1 rows, each cell 256x256 px, total 1024x256 px; every frame centered and fully inside its cell with ~6% margin.

A soft pastel rainbow appearing in waterfall mist, 4 frames fading in.
```

#### E14 · Ecossistema: polinização e semente (P2)
- **Arquivo:** `arte/efeitos/ecossistema__anim.png` · **grade:** 8 × 2 · célula 128 px · 1024 × 256

```
[Bloco de estilo]

Effect sheet rules: transparent background, additive-friendly bright core with soft translucent edges, no hard flat white shapes that could cover characters, no text, no grid lines. Exact uniform grid of 8 columns x 2 rows, each cell 128x128 px, total 1024x256 px; every frame centered and fully inside its cell with ~6% margin.

Row 1: a small glowing trail of pollen from a flower to a branch, and the flower slowly swelling into a tiny fruit, 8 frames.
Row 2: a seed drifting down on a little wing, landing, and a tiny sprout popping out with a sparkle, 8 frames.
```

#### E15 · Reflexo e poças (P2)
- **Arquivo:** `arte/efeitos/poca__anim.png` · **grade:** 8 × 2 · célula 128 px · 1024 × 256
- **Nota:** O reflexo da árvore e dos personagens no lago é feito pelo app, espelhando o próprio sprite.

```
[Bloco de estilo]

Effect sheet rules: transparent background, additive-friendly bright core with soft translucent edges, no hard flat white shapes that could cover characters, no text, no grid lines. Exact uniform grid of 8 columns x 2 rows, each cell 128x128 px, total 1024x256 px; every frame centered and fully inside its cell with ~6% margin.

Row 1: a shallow rain puddle forming on the grass and slowly shrinking in the sun, 8 frames.
Row 2: a small puddle with a soft sky reflection rippling when a drop falls, 8 frames loop.
```

### Interface (2)

#### U10 · Molduras do herbário por bioma (P2)
- **Arquivo:** `arte/interface/herbario__molduras.png` · **grade:** 5 × 2 · célula 512 px · 2560 × 1024

```
[Bloco de estilo]

Sprite sheet rules: transparent background (PNG with alpha), no floor, no cast shadow, no text, no grid lines, no frame borders. Exact uniform grid of 5 columns x 2 rows of square cells, each cell 512x512 px, total image 2560x1024 px. Every frame stays fully inside its own cell with ~6% empty margin: nothing (tails, wings, leaves, falling fruit, petals, sparks, glow) may cross into a neighbouring cell. Feet (or the base of a floating body, or the base of a plant) sit on the same horizontal line in every frame, at 85% of the cell height. Same scale and same size in every frame and row. Animation rows read left to right; looping rows loop seamlessly (last frame flows into the first). Natural proportions, never stretched or squashed. Animation principles: clear anticipation before every jump or action, gentle squash and stretch on landings, and secondary motion: hair, cloaks, ears, tails, wings and leaves follow the movement 1-2 frames later; idle rows always breathe subtly.

Ten portrait card frames (384x512 inside each cell), one per biome, EXACTLY the same structure and corner size; only the corner ornaments and accent color change: Pentateuch (sand, palm fronds, spring); Historical books (stone blocks, olive branches); Wisdom and Poetry (harp strings, lilies); Major Prophets (cedar, almond blossoms); The Twelve (garland of twelve tiny fruits); Gospels (fishing net, mustard flowers); Acts (rope, small sail); Paul's letters (rolled letters, grapevine); General letters (herbs, well rope); Revelation (crystal river, twelve tiny gems).
```

#### U12 · Transição entre telas (P2)
- **Arquivo:** `arte/interface/transicao__folhas.png` · **grade:** 8 × 1 · célula 256 px · 2048 × 256

```
[Bloco de estilo]

Effect sheet rules: transparent background, additive-friendly bright core with soft translucent edges, no hard flat white shapes that could cover characters, no text, no grid lines. Exact uniform grid of 8 columns x 1 rows, each cell 256x256 px, total 2048x256 px; every frame centered and fully inside its cell with ~6% margin.

A screen transition: a sweep of leaves and petals crossing the cell from left to right, 8 frames, covering the middle frames and clearing at the end.
```

## Prioridade P3

### Animais (29)

| Código | Nome | Arquivo | Grade | Notas |
| --- | --- | --- | --- | --- |
| A013 | Raposinha-do-campo | `arte/animais/raposinha__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: brasileira · pacote Companheiros Novos |
| A019 | Mico-leão-dourado | `arte/animais/mico-leao__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: brasileira · pacote Mata Atlântica |
| A020 | Lobo-guará | `arte/animais/lobo-guara__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: brasileira · pacote Cerrado |
| A021 | Seriema | `arte/animais/seriema__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: brasileira · pacote Cerrado |
| A024 | Boto-cor-de-rosa | `arte/animais/boto__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-A · origem: brasileira · pacote Amazônia |
| A025 | Borboleta-azul (morfo) | `arte/animais/borboleta-azul__anim.png` | 8 × 5 · célula 64 px · 512 × 320 | Modelo A-I · origem: brasileira · pacote Amazônia |
| A026 | Peixe-boi | `arte/animais/peixe-boi__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-A · origem: brasileira · pacote Amazônia |
| A028 | Libélula | `arte/animais/libelula__anim.png` | 8 × 5 · célula 64 px · 512 × 320 | Modelo A-I · origem: ambiente · aparece no lago |
| A029 | Joaninha | `arte/animais/joaninha__anim.png` | 8 × 5 · célula 64 px · 512 × 320 | Modelo A-I · origem: ambiente · aparece nas flores |
| A031 | Sapinho | `arte/animais/sapinho__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-A · origem: ambiente · aparece no lago |
| A039 | Corvos | `arte/animais/corvos__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: bíblica · cena de Elias |
| A044 | Pares da arca | `arte/animais/pares-arca__anim.png` | 8 × 8 · célula 192 px · 1536 × 1536 | Modelo A-G · origem: bíblica · cena de Noé |
| A046 | Cabritinhos | `arte/animais/cabritinhos__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica · fauna bíblica |
| A061 | Damão (arganaz) | `arte/animais/damao__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: bíblica · animal citado ou associado a um livro |
| A087 | Carpa koi | `arte/animais/carpa__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-A · origem: mundo · animal citado ou associado a um livro |
| A088 | Onça-pintada | `arte/animais/onca__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: brasileira · extra brasileiro (catálogo) |
| A089 | Quati | `arte/animais/quati__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: brasileira · extra brasileiro (catálogo) |
| A090 | Cutia | `arte/animais/cutia__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: brasileira · extra brasileiro (catálogo) |
| A091 | Jabuti | `arte/animais/jabuti__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: brasileira · extra brasileiro (catálogo) |
| A092 | Sagui | `arte/animais/sagui__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: brasileira · extra brasileiro (catálogo) |
| A093 | Anta | `arte/animais/anta__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: brasileira · extra brasileiro (catálogo) |
| A094 | Ariranha | `arte/animais/ariranha__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-A · origem: brasileira · extra brasileiro (catálogo) |
| A095 | Arara-vermelha | `arte/animais/arara-vermelha__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: brasileira · extra brasileiro (catálogo) |
| A096 | Papagaio-verdadeiro | `arte/animais/papagaio__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: brasileira · extra brasileiro (catálogo) |
| A097 | Quero-quero | `arte/animais/quero-quero__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-T · origem: brasileira · extra brasileiro (catálogo) |
| A098 | Pica-pau-de-cabeça-amarela | `arte/animais/pica-pau__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-V · origem: brasileira · extra brasileiro (catálogo) |
| A099 | Lambari | `arte/animais/lambari__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-A · origem: brasileira · extra brasileiro (catálogo) |
| A100 | Tucunaré | `arte/animais/tucunare__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-A · origem: brasileira · extra brasileiro (catálogo) |
| A101 | Acará-disco | `arte/animais/acara-disco__anim.png` | 8 × 11 · célula 128 px · 1024 × 1408 | Modelo A-A · origem: brasileira · extra brasileiro (catálogo) |

### Plantas (59)

| Código | Nome | Arquivo | Grade | Notas |
| --- | --- | --- | --- | --- |
| PL020 | Pinheiro-de-alepo | `arte/plantas/pinheiro-alepo__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica |
| PL030 | Hissopo | `arte/plantas/hissopo__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: erva · origem: bíblica |
| PL056 | Ipê-roxo | `arte/plantas/ipe-roxo__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: brasileira |
| PL057 | Ipê-branco | `arte/plantas/ipe-branco__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: brasileira |
| PL059 | Pau-brasil | `arte/plantas/pau-brasil__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: brasileira |
| PL061 | Quaresmeira | `arte/plantas/quaresmeira__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: brasileira |
| PL062 | Jacarandá-mimoso | `arte/plantas/jacaranda__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: brasileira |
| PL069 | Mandacaru | `arte/plantas/mandacaru__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: arbusto · origem: brasileira |
| PL070 | Xique-xique | `arte/plantas/xique-xique__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: arbusto · origem: brasileira |
| PL071 | Bromélia | `arte/plantas/bromelia__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: flor · origem: brasileira |
| PL072 | Samambaia | `arte/plantas/samambaia__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: arbusto · origem: brasileira |
| PL073 | Orquídea | `arte/plantas/orquidea__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: flor · origem: brasileira |
| PL074 | Vitória-régia | `arte/plantas/vitoria-regia__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: aquatica · origem: brasileira |
| PL075 | Sumaúma | `arte/plantas/sumauma__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: brasileira |
| PL076 | Canela-de-ema | `arte/plantas/canela-de-ema__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: flor · origem: brasileira |
| PL077 | Capim-dourado | `arte/plantas/capim-dourado__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: erva · origem: brasileira |
| PL082 | Cerejeira | `arte/plantas/cerejeira__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: mundo |
| PL083 | Baobá | `arte/plantas/baoba__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: mundo |
| PL084 | Bordo | `arte/plantas/bordo__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: mundo |
| PL085 | Limoeiro | `arte/plantas/limoeiro__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: mundo · frutífera (fruto caindo) |
| PL086 | Campo de lavanda | `arte/plantas/lavanda-campo__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: flor · origem: mundo |
| PL087 | Tulipas | `arte/plantas/tulipa__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: flor · origem: mundo |
| PL088 | Bambu | `arte/plantas/bambu__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: arbusto · origem: mundo |
| PL093 | Alfarrobeira | `arte/plantas/alfarrobeira__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica · frutífera (fruto caindo) |
| PL094 | Pistacheira | `arte/plantas/pistacheira__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica · frutífera (fruto caindo) |
| PL095 | Nogueira | `arte/plantas/nogueira__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica · frutífera (fruto caindo) |
| PL096 | Plátano-oriental | `arte/plantas/platano__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica |
| PL097 | Carvalho de Basã | `arte/plantas/carvalho-basa__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: bíblica · frutífera (fruto caindo) |
| PL098 | Sarça | `arte/plantas/sarca__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: arbusto · origem: bíblica |
| PL099 | Hena | `arte/plantas/hena__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: arbusto · origem: bíblica |
| PL100 | Linho | `arte/plantas/linho__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: erva · origem: bíblica |
| PL101 | Açafrão | `arte/plantas/acafrao__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: flor · origem: bíblica |
| PL102 | Nardo | `arte/plantas/nardo__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: flor · origem: bíblica |
| PL103 | Papoula do campo | `arte/plantas/papoula__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: flor · origem: bíblica |
| PL104 | Narciso (rosa de Sarom) | `arte/plantas/narciso__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: flor · origem: bíblica |
| PL105 | Endro | `arte/plantas/endro__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: erva · origem: bíblica |
| PL106 | Cominho | `arte/plantas/cominho__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: erva · origem: bíblica |
| PL107 | Arruda | `arte/plantas/arruda__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: erva · origem: bíblica |
| PL108 | Coentro | `arte/plantas/coentro__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: erva · origem: bíblica |
| PL117 | Paineira | `arte/plantas/paineira__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: brasileira |
| PL118 | Embaúba | `arte/plantas/embauba__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: brasileira |
| PL119 | Manacá-da-serra | `arte/plantas/manaca__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: arbusto · origem: brasileira |
| PL120 | Helicônia | `arte/plantas/heliconia__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: flor · origem: brasileira |
| PL121 | Primavera (buganvília) | `arte/plantas/primavera__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: trepadeira · origem: brasileira |
| PL122 | Laranjeira | `arte/plantas/laranjeira__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: mundo · frutífera (fruto caindo) |
| PL123 | Abacateiro | `arte/plantas/abacateiro__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: mundo · frutífera (fruto caindo) |
| PL124 | Pessegueiro | `arte/plantas/pessegueiro__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: mundo · frutífera (fruto caindo) |
| PL125 | Figueira-de-bengala | `arte/plantas/figueira-bengala__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: mundo |
| PL126 | Sequoia | `arte/plantas/sequoia__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: mundo |
| PL127 | Bétula | `arte/plantas/betula__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: mundo |
| PL128 | Magnólia | `arte/plantas/magnolia__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: mundo |
| PL129 | Abeto | `arte/plantas/abeto__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: mundo |
| PL130 | Eucalipto | `arte/plantas/eucalipto__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: mundo |
| PL131 | Flamboyant | `arte/plantas/flamboyant__anim.png` | 8 × 8 · célula 256 px · 2048 × 2048 | Forma: arvore · origem: mundo |
| PL132 | Hortênsia | `arte/plantas/hortensia__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: arbusto · origem: mundo |
| PL133 | Azaleia | `arte/plantas/azaleia__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: arbusto · origem: mundo |
| PL134 | Camélia | `arte/plantas/camelia__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: arbusto · origem: mundo |
| PL135 | Alecrim | `arte/plantas/alecrim__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: arbusto · origem: mundo |
| PL136 | Lótus | `arte/plantas/lotus__anim.png` | 6 × 5 · célula 128 px · 768 × 640 | Forma: aquatica · origem: mundo |

### Personagens bíblicos (56)

| Código | Nome | Arquivo | Grade | Notas |
| --- | --- | --- | --- | --- |
| H07 | Gideão | `arte/personagens/gideao__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: JDG · libera ao ler Jz 6 · preço sugerido: 600 orvalhos · gracinha: o velo de lã amanhece cheio de orvalho. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H08 | Rute | `arte/personagens/rute__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: RUT · libera ao ler Rt 2 · preço sugerido: 400 orvalhos · gracinha: respiga e divide com um passarinho. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H10 | Davi (rei) | `arte/personagens/davi-rei__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: 2SA · libera ao ler 2 Sm 6 · preço sugerido: 400 orvalhos · gracinha: dança com todas as forças. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H11 | Salomão | `arte/personagens/salomao__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: 1KI · libera ao ler 1 Rs 10 · preço sugerido: 600 orvalhos · gracinha: estuda a natureza e o pavão abre a cauda. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H13 | Jabez | `arte/personagens/jabez__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: 1CH · libera ao ler 1 Cr 4:10 · preço sugerido: 600 orvalhos · gracinha: ora e a cerquinha do terreno aumenta. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H14 | Josafá | `arte/personagens/josafa__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: 2CH · libera ao ler 2 Cr 20:21 · preço sugerido: 600 orvalhos · gracinha: rege um coralzinho e as flores se abrem. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H15 | Esdras | `arte/personagens/esdras__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: EZR · libera ao ler Ed 7 · preço sugerido: 600 orvalhos · gracinha: desenrola um pergaminho comprido. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H16 | Neemias | `arte/personagens/neemias__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: NEH · libera ao ler Ne 2–4 · preço sugerido: 600 orvalhos · gracinha: assenta tijolos e ergue um murinho. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H17 | Ester | `arte/personagens/ester__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: EST · libera ao ler Et 5 · preço sugerido: 400 orvalhos · gracinha: põe a coroa e faz uma reverência. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H18 | Jó | `arte/personagens/jo__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: JOB · libera ao ler Jó 42 · preço sugerido: 400 orvalhos · gracinha: recebe tudo em dobro e abraça um cordeiro. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H20 | Salomão (Provérbios) | `arte/personagens/salomao-pv__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: PRO · libera ao ler Pv 6:6 · preço sugerido: 600 orvalhos · gracinha: observa as formigas. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H21 | O Pregador | `arte/personagens/pregador__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: ECC · libera ao ler Ec 3 · preço sugerido: 600 orvalhos · gracinha: vira a ampulheta: tudo tem seu tempo. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H22 | A Sulamita | `arte/personagens/sulamita__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: SNG · libera ao ler Ct 2 · preço sugerido: 400 orvalhos · gracinha: colhe flores e gira feliz. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H23 | Isaías | `arte/personagens/isaias__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: ISA · libera ao ler Is 6:8 · preço sugerido: 400 orvalhos · gracinha: levanta a mão: eis-me aqui. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H24 | Jeremias | `arte/personagens/jeremias__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: JER · libera ao ler Jr 18 · preço sugerido: 600 orvalhos · gracinha: modela e refaz um vaso no torno. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H25 | Jeremias (Lamentações) | `arte/personagens/jeremias-lm__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: LAM · libera ao ler Lm 3:22-23 · preço sugerido: 600 orvalhos · gracinha: abre a janela ao nascer do sol. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H26 | Ezequiel | `arte/personagens/ezequiel__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: EZK · libera ao ler Ez 47 · preço sugerido: 600 orvalhos · gracinha: entra no rio: tornozelos, joelhos, cintura. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H28 | Oseias | `arte/personagens/oseias__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: HOS · libera ao ler Os 10:12 · preço sugerido: 400 orvalhos · gracinha: semeia e os brotos nascem atrás dele. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H29 | Joel | `arte/personagens/joel__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: JOL · libera ao ler Jl 2:1 · preço sugerido: 600 orvalhos · gracinha: toca o shofar e o vento ondula a grama. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H30 | Amós | `arte/personagens/amos__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: AMO · libera ao ler Am 8:1 · preço sugerido: 400 orvalhos · gracinha: colhe figos e oferece um. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H31 | Obadias | `arte/personagens/obadias__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: OBA · libera ao ler Ob 1:4 · preço sugerido: 400 orvalhos · gracinha: aponta o ninho e a águia pousa no cajado. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H33 | Miqueias | `arte/personagens/miqueias__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: MIC · libera ao ler Mq 4:3 · preço sugerido: 600 orvalhos · gracinha: transforma a espada em arado. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H34 | Naum | `arte/personagens/naum__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: NAM · libera ao ler Na 1:15 · preço sugerido: 400 orvalhos · gracinha: corre no monte com boas notícias. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H35 | Habacuque | `arte/personagens/habacuque__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: HAB · libera ao ler Hc 2:1-2 · preço sugerido: 600 orvalhos · gracinha: sobe na torre e escreve na tábua. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H36 | Sofonias | `arte/personagens/sofonias__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: ZEP · libera ao ler Sf 3:17 · preço sugerido: 400 orvalhos · gracinha: canta e os passarinhos acompanham. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H37 | Ageu | `arte/personagens/ageu__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: HAG · libera ao ler Ag 1:8 · preço sugerido: 600 orvalhos · gracinha: traz madeira e monta uma estrutura. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H38 | Zacarias | `arte/personagens/zacarias__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: ZEC · libera ao ler Zc 4 · preço sugerido: 600 orvalhos · gracinha: acende o candelabro entre as oliveiras. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H39 | Malaquias | `arte/personagens/malaquias__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: MAL · libera ao ler Ml 3:10 · preço sugerido: 600 orvalhos · gracinha: leva o dízimo e caem bênçãos do céu. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H45 | Febe | `arte/personagens/febe__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: ROM · libera ao ler Rm 16:1 · preço sugerido: 400 orvalhos · gracinha: leva a carta de Paulo. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H46 | Paulo e Apolo | `arte/personagens/paulo-apolo__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: 1CO · libera ao ler 1 Co 3:6 · preço sugerido: 600 orvalhos · gracinha: um planta, o outro rega e o broto cresce. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H47 | Paulo (no cesto) | `arte/personagens/paulo-cesto__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: 2CO · libera ao ler 2 Co 11:33 · preço sugerido: 600 orvalhos · gracinha: desce o muro num cesto. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H48 | Paulo (letras grandes) | `arte/personagens/paulo-letras__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: GAL · libera ao ler Gl 6:11 · preço sugerido: 600 orvalhos · gracinha: escreve com letras enormes. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H49 | O menino da armadura | `arte/personagens/menino-armadura__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: EPH · libera ao ler Ef 6:13-17 · preço sugerido: 400 orvalhos · gracinha: veste a armadura grande demais e faz pose. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H50 | Paulo e Silas | `arte/personagens/paulo-silas__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: PHP · libera ao ler At 16:25 · Fp · preço sugerido: 400 orvalhos · gracinha: cantam e as correntes caem. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H51 | Epafras | `arte/personagens/epafras__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: COL · libera ao ler Cl 4:12 · preço sugerido: 400 orvalhos · gracinha: ora e luzinhas vão para os jardins vizinhos. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H52 | Timóteo (mensageiro) | `arte/personagens/timoteo-carta__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: 1TH · libera ao ler 1 Ts 3:6 · preço sugerido: 400 orvalhos · gracinha: chega correndo com boas notícias. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H53 | Paulo (fazedor de tendas) | `arte/personagens/paulo-tendas__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: 2TH · libera ao ler 2 Ts 3:8 · At 18:3 · preço sugerido: 600 orvalhos · gracinha: costura e arma uma tenda. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H54 | Timóteo (jovem pastor) | `arte/personagens/timoteo__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: 1TI · libera ao ler 1 Tm 4:12 · preço sugerido: 400 orvalhos · gracinha: lê para os animais que se sentam para ouvir. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H55 | Lóide e Eunice | `arte/personagens/loide-eunice__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: 2TI · libera ao ler 2 Tm 1:5 · preço sugerido: 400 orvalhos · gracinha: avó e mãe ensinam o menino. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H56 | Tito | `arte/personagens/tito__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: TIT · libera ao ler Tt 1:5 · preço sugerido: 400 orvalhos · gracinha: planta mudas em fila perfeita. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H57 | Onésimo | `arte/personagens/onesimo__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: PHM · libera ao ler Fm 1:10-16 · preço sugerido: 600 orvalhos · gracinha: bate à porta e é recebido com um abraço. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H58 | Abel | `arte/personagens/abel__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: HEB · libera ao ler Hb 11:4 · preço sugerido: 400 orvalhos · gracinha: escolhe o melhor cordeirinho e o abraça. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H59 | O lavrador paciente | `arte/personagens/lavrador__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: JAS · libera ao ler Tg 5:7 · preço sugerido: 400 orvalhos · gracinha: espera a chuva e o campo fica verde. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H60 | Pedro (rede cheia) | `arte/personagens/pedro-rede__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: 1PE · libera ao ler Jo 21:6 · 1 Pe · preço sugerido: 600 orvalhos · gracinha: puxa a rede cheia e solta os peixinhos. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H61 | Pedro (idoso) | `arte/personagens/pedro-idoso__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: 2PE · libera ao ler 2 Pe 1:19 · preço sugerido: 400 orvalhos · gracinha: aponta a estrela da manhã. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H62 | João (idoso) | `arte/personagens/joao-idoso__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: 1JN · libera ao ler 1 Jo 3:1 · preço sugerido: 600 orvalhos · gracinha: abraça as criancinhas. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H63 | A senhora eleita | `arte/personagens/senhora-eleita__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: 2JN · libera ao ler 2 Jo 1:4 · preço sugerido: 400 orvalhos · gracinha: caminha de mãos dadas com os filhos. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H64 | Gaio | `arte/personagens/gaio__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: 3JN · libera ao ler 3 Jo 1:5 · preço sugerido: 600 orvalhos · gracinha: põe a mesa e recebe um viajante. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H65 | Enoque | `arte/personagens/enoque__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: JUD · libera ao ler Jd 14 · Hb 11:5 · preço sugerido: 400 orvalhos · gracinha: caminha e some numa luz suave. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H67 | Tobias | `arte/personagens/tobias__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: TOB · libera ao ler Tb 6 · preço sugerido: 400 orvalhos · gracinha: pega um peixe com o cachorro latindo. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H68 | Judite | `arte/personagens/judite__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: JDT · libera ao ler Jt 8 · preço sugerido: 600 orvalhos · gracinha: ora e caminha confiante. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H69 | Judas Macabeu | `arte/personagens/judas-macabeu__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: 1MA · libera ao ler 1 Mc 4:50 · preço sugerido: 600 orvalhos · gracinha: reacende o candelabro do templo. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H70 | Neemias (o fogo escondido) | `arte/personagens/neemias-fogo__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: 2MA · libera ao ler 2 Mc 1:19-22 · preço sugerido: 600 orvalhos · gracinha: tira do poço o líquido que acende ao sol. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H71 | Salomão (Sabedoria) | `arte/personagens/salomao-sb__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 | Livro: WIS · libera ao ler Sb 9 · preço sugerido: 400 orvalhos · gracinha: pede sabedoria e uma luz desce. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H72 | Ben Sira | `arte/personagens/ben-sira__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: SIR · libera ao ler Eclo 51 · preço sugerido: 600 orvalhos · gracinha: ensina jovens debaixo da árvore. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |
| H73 | Baruc | `arte/personagens/baruc__anim.png` | 8 × 12 · célula 128 px · 1024 × 1536 + props 4 × 2 · 256 | Livro: BAR · libera ao ler Jr 36:4 · Br 1 · preço sugerido: 600 orvalhos · gracinha: escreve tão rápido que a tinta acaba. Revisar com 2–3 tradições cristãs. Nunca o rosto de Deus; Jesus só por símbolos. |

## 6. Ordem de produção em levas

1. **Poucas folhas, muito impacto:** A001 ovelha, A002 capivara, A003 beija-flor, PL001 oliveira, C01 grama, C03 laguinho, H01 Noé, I14 orvalho, E01 crescimento, E02 vento, U01 tela inicial.
2. **Volume, um grupo por vez:** o resto do P1 (animais, plantas e personagens dos livros do MVP), depois os animais e plantas P2 por bioma.
3. **Personagens, efeitos grandes e cenário:** os personagens P2, junto com C05, C07 a C09, E03, E09 a E11 e U05, U06, U09.
4. **O resto:** P3, molduras do herbário e transições.

Antes de cada leva, gere uma folha só, confira as 11 regras e só então produza o resto do grupo, sempre anexando a folha aprovada como referência.
