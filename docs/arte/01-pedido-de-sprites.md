# Bible Garden · Pedido de sprites (briefing) · v6

Estrutura do Elementar aplicada ao Bible Garden, com as decisões novas: visão de cima e de lado, cada livro como um pequeno ecossistema, personagens vivos no jardim e catálogo ampliado de plantas e animais.

## 1. Sobre o jogo (contexto para os prompts)

- **Conceito:** cada livro da Bíblia é um pequeno ecossistema vivo, um jardim com árvores, flores, laguinho, animais e um personagem bíblico. Os jardins se encaixam pelas bordas e, juntos, formam uma floresta gigante. A ideia do terrário fica só na estrutura (cuidar de um ecossistema pequeno), não no visual: não há vidro nem pote.
- **Gênero e referências:** jogo tranquilo de jardim e coleção, sem combate e sem derrota. As referências visuais:
    - **Sea of Stars:** pixel art rica com luz moderna.
    - **Dave the Diver:** sprites 2D com profundidade e iluminação 3D.
    - **Stardew Valley:** a câmera e o aconchego.
    - **Ori and the Blind Forest:** luz atmosférica, brilho e névoa.
    - **Forest Shuffle:** o charme naturalista das ilustrações, ideal para o herbário.
    - **O que evitar:** o visual em blocos de Terraria.
- **Câmera:** de cima e de lado, como em Sea of Stars e Stardew Valley: a câmera fica no alto e um pouco à frente, então cada coisa mostra o topo e a frente. Não é isométrico (sem losango) e não é jogo de lado. Personagens e animais andam em 4 direções: para baixo (de frente), para cima (de costas) e para os lados (o jogo espelha a direita para fazer a esquerda).
- **Estilo visual:** pixel art pintada de alto detalhe, com luz volumétrica suave, contorno escuro de 1 a 2 px (marrom ou ameixa, nunca preto) e paleta natural quente.
- **Plataforma e tamanho na tela:** celular em pé. O jardim ocupa a largura da tela, cerca de 360 px, mostrando um mundo de 200 a 240 px. Tamanhos propostos no mundo:
    - personagens e animais: 20 a 24 px de altura;
    - árvore plena: até 80 px;
    - arbustos e flores: 10 a 16 px;
    - objetos: 12 a 20 px.
- **Legibilidade:** em tamanho real, nada pode ficar abaixo de 24 px na tela. Por isso as folhas são geradas grandes (células de 64 a 256 px) e reduzidas depois.

## 2. Regras técnicas para TODAS as folhas

1. **Fundo transparente** (PNG com alfa). Sem chão, moldura, grade desenhada ou texto.
2. **Grade exata e uniforme:** C colunas × L linhas de células quadradas iguais.
3. **Nada sai da célula:** cerca de 6% de margem. Frutos que caem, pétalas, rabos e brilhos ficam dentro do quadro.
4. **Linha do chão fixa** a 85% da altura da célula, em todos os quadros.
5. **Mesma escala** em todos os quadros e linhas.
6. **Direção:** virado para a direita, exceto nas linhas marcadas PARA BAIXO (de frente) e PARA CIMA (de costas). O jogo espelha a direita para fazer a esquerda.
7. **Sem sombra no chão** (o jogo desenha). Brilho próprio pode.
8. **Proporção natural**, sem esticar nem achatar.
9. **Linhas de ciclo emendam:** o último quadro flui para o primeiro.
10. **Luz de cima à esquerda; contorno escuro de 1 a 2 px** (marrom ou ameixa, nunca preto puro).
11. **Entrega:** PNG grande, reduzido depois mantendo a proporção. Nome de arquivo e pasta definidos em cada item.

Regras próprias do Bible Garden:
- Nenhuma planta murcha ou morre em quadro nenhum.
- Nada assusta ou machuca: leões, corvos, o grande peixe e a carruagem de fogo são sempre simpáticos.
- Nunca o rosto de Deus. Jesus só aparece por símbolos.

**Células por tipo:**

| Tipo | Grade | Célula |
| --- | --- | --- |
| Personagens bíblicos | 8 × 12 (+ folha de objetos 4 × 2) | 128 (objetos 256) |
| Animais que andam, voam ou nadam | 8 × 11 | 128 |
| Grupos de animais grandes | 8 × 8 | 192 |
| Insetos e bichinhos | 8 × 5 | 64 |
| Árvores e palmeiras | 8 × 8 | 256 |
| Arbustos, flores, ervas, trepadeiras, aquáticas | 6 × 5 | 128 |
| Objetos com estados | 8 × 1 | 128 |
| Ladrilhos do chão | 8 × 2 a 8 × 4 | 256 |
| Efeitos | variável | 64 a 256 |
| Ícones e moeda | 8 × N | 64 |

## 3. O que existe hoje e o que está com defeito

Ainda não existe nenhum arquivo de arte; tudo no protótipo v0.5 é desenhado por código, em visão isométrica. Com a mudança para a visão de cima e de lado, o protótipo também vai precisar trocar o desenho do chão e da ilha.

| Grupo | Hoje | Defeitos encontrados |
| --- | --- | --- |
| Árvores | 3 espécies por código | Copa feita de círculos; sem vento de verdade; sem fruto caindo; a muda sumia na grama |
| Animais | 15 formas geométricas | Deslizam sem andar; uma direção só; não crescem; difíceis de reconhecer |
| Personagens bíblicos | inexistentes | — |
| Laguinho e rio | retângulos com brilho | Sem borda, sem peixes, sem plantas aquáticas |
| Decoração | 9 itens simples | Sem estados (lanterna só troca de cor) |
| Menu, oração, devocional | só interface em código | Sem ilustração, sem camadas, sem animação de fundo |

## 4. Conferência da variedade

A pedido, conferi a variedade do catálogo e ampliei onde estava fraco. Antes havia só 4 árvores do mundo, poucas frutíferas brasileiras e nenhum animal ligado a cada livro.

### Plantas por origem e forma

| Origem | Árvores | Palmeiras | Arbustos | Flores | Ervas | Trepadeiras | Aquáticas | Total |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| bíblica | 29 | 2 | 8 | 7 | 9 | 1 | 0 | 56 |
| temática | 0 | 0 | 3 | 9 | 1 | 1 | 0 | 14 |
| brasileira | 20 | 4 | 7 | 4 | 1 | 3 | 1 | 40 |
| mundo | 14 | 0 | 5 | 2 | 0 | 0 | 1 | 22 |
| chão e água | 0 | 0 | 0 | 0 | 2 | 0 | 2 | 4 |
| **Total** | 63 | 6 | 23 | 22 | 13 | 5 | 4 | **136** |

**Frutíferas com fruto caindo da árvore: 38.** Bíblicas: Oliveira, Oliveira-brava, Figueira, Sicômoro (figueira-brava), Videira, Romãzeira, Tamareira, Amendoeira, Macieira, Árvore da vida, Árvore dos nove frutos, Palmeira da vitória, Pomar com açude, Alfarrobeira, Pistacheira, Nogueira, Carvalho de Basã. Brasileiras: Jabuticabeira, Cajueiro, Pitangueira, Cafeeiro, Buriti, Coqueiro, Lobeira, Bananeira, Maracujá, Mangueira, Jaqueira, Goiabeira, Aceroleira, Pequizeiro, Açaizeiro, Cupuaçuzeiro, Cacaueiro. Do mundo: Limoeiro, Laranjeira, Abacateiro, Pessegueiro.

### Animais por origem

| Origem | Quantidade | Exemplos |
| --- | --- | --- |
| bíblica | 56 | Ovelha, Borboletas, Abelhas, Cordeiro, Pomba, Águia, Corça, Pardais, Leões sonolentos, Corvos … |
| brasileira | 35 | Capivara, Beija-flor, Sanhaço, Tatu-bola, Coruja-buraqueira, Garça, Tucano, Raposinha-do-campo, Sabiá-laranjeira, Bem-te-vi … |
| ambiente | 8 | Vaga-lume, Libélula, Joaninha, Caracol, Sapinho, Formigas, Peixinhos, Patinhos |
| mundo | 1 | Carpa koi |
| temático | 1 | Toupeira |

- **Animais do livro:** cada livro tem um animal citado nele (por exemplo, a jumenta de Balaão em Números ou as codornizes no Êxodo). Quando o livro não cita nenhum, há um animal temático da região (por exemplo, a gaivota em Atos, pelas viagens por mar). A lista está no anexo.
- **Extras brasileiros:** 14 animais a mais, como onça-pintada, quati, jabuti, anta, ariranha, arara-vermelha e tucunaré, entram como catálogo comprável com moedas, além dos brasileiros que já existiam.
- **Peixes do laguinho:** peixe-de-são-pedro, peixinhos coloridos, lambari, tucunaré, acará-disco e carpa koi.

## 5. Regras de progressão (base para as folhas)

- **A árvore principal de cada livro cresce só com a leitura** daquele livro. Ela pode ser trocada por outra espécie desbloqueada, mantendo o estágio de crescimento.
- **O animal do livro e o companheiro começam filhotes e crescem** conforme a pessoa lê, ora e faz o devocional. Cada folha de animal tem uma linha de filhote e outra de jovem.
- **Personagem bíblico:** é liberado ao ler o capítulo da história dele (por exemplo, Jonas ao ler Jonas 2) e depois comprado com moedas: 400, ou 600 quando tem objeto grande, como a arca ou a carruagem.
- **Moedas (orvalho):** ganhas com leitura, oração e devocional, e usadas para animais, plantas extras, decoração e personagens.
- **Venda de moedas (decisão confirmada):** comprar orvalho é opcional e serve só para quem quer um item especial mais rápido.
    - Todos os itens podem ser conseguidos de graça, com leitura, oração e devocional.
    - Dinheiro nunca faz a árvore crescer e nunca libera um personagem antes do capítulo da história dele.
    - Trocar a espécie da árvore é só cosmético e mantém o estágio de crescimento.
    - Boas práticas recomendadas: preço sempre em reais ao lado do pacote, sem bônus com contagem regressiva e um limite mensal de compra, porque crianças usam o app.
  A folha I14 inclui os pacotes de orvalho.

## 6. Animação e beleza: o que vem da arte e o que vem do código

**Nas folhas de arte (v6):**
- **Princípios de animação** no bloco técnico de todas as folhas: antecipação, achatar e esticar nos pulos, e movimento secundário (cabelo, manto, orelhas, rabo, asas e folhas seguem 1 a 2 quadros depois).
- **Variações de parado:** espreguiçar, coçar, olhar o céu. O app sorteia entre elas para ninguém repetir o mesmo gesto.
- **Reação ao toque** em animais, personagens e plantas. A árvore balança e solta uma folha ou um fruto.
- **Interação entre seres:**
    - o personagem faz carinho e o animal se inclina;
    - o pássaro pousa no ombro;
    - o peixe pula quando alguém lava as mãos no laguinho;
    - a festa quando o livro é concluído.
- **Clima:** na chuva, os animais se abrigam e se sacodem, o personagem protege a cabeça e as folhas pingam; no vento forte, o personagem segura o chapéu.
- **Noite:** o personagem acende a lanterna.
- **Ecossistema em ação:** a abelha poliniza a flor, a flor vira fruto, a semente cai e nasce uma mudinha (folha das árvores e efeito E14).
- **Emoções:** uma folha compartilhada de balõezinhos (E13) com coração, nota musical, zZz, exclamação, interrogação, gota de suor e estrelinhas.

**No código do app (sem folha nova):**
- **Reflexos no laguinho:** o próprio sprite espelhado e ondulando.
- **Sombras que giram com o sol:** mais longas de manhã e no fim da tarde.
- **Luz dinâmica com mapas de relevo (normal maps).** Não gere esses mapas na IA de imagem, que não os faz com precisão. Gere a partir de cada sprite aprovado com uma ferramenta própria para isso, como o Laigter, que é gratuito.
- **Comportamento por horário:** animais diurnos de dia; coruja e vaga-lumes à noite; personagem com lanterna ao anoitecer.
- **Procissão:** ao concluir um bioma, os personagens daquele bioma atravessam a floresta, usando as linhas de andar que já existem.
- **Parallax e câmera suave:** nas telas de menu, oração e na floresta.

## 7. O que gerar, por prioridade

| Prioridade | Animais | Plantas | Personagens bíblicos | Cenário | Itens | Efeitos | Interface | Total |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| P1 | 10 | 13 | 6 | 6 | 9 | 9 | 11 | 64 |
| P2 | 62 | 64 | 11 | 3 | 6 | 6 | 2 | 154 |
| P3 | 29 | 59 | 56 | 0 | 0 | 0 | 0 | 144 |
| **Total** | 101 | 136 | 73 | 9 | 15 | 15 | 13 | **362** |

Além das folhas, há 174 retratos de busto (herbário e loja) e 43 folhas de objetos dos personagens.

**P1 (MVP):**
- os jardins de Gênesis, Salmos e dos quatro Evangelhos: árvores, animais e personagens (Noé, Davi pastor, Pedro, a viúva, Zaqueu e o menino dos pães);
- os três companheiros e os peixes do lago;
- o chão, o laguinho e as bordas entre os jardins;
- as animações de vento e de crescimento;
- o menu, a tela de oração e as ilustrações do devocional.

**Ordem sugerida:** primeiro poucas folhas de muito impacto (companheiros, oliveira, chão, laguinho e Noé); depois o volume, um grupo por vez; por fim efeitos, cenário extra e o restante da interface.

## 8. O que pedir para a próxima etapa

> Com base neste documento, monte um pacote de prompts de geração de imagem, um prompt por folha, seguindo as regras técnicas da seção 2 em todos. Para itens repetidos, faça um modelo com as partes que mudam marcadas entre chaves e a lista de valores de cada um. Organize por P1, P2, P3 e indique arquivo e pasta de cada folha.

Esse pacote já está pronto nos arquivos 02, 03 e 04.
