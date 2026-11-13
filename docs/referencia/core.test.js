const test = require("node:test"); const assert = require("node:assert/strict");
const C = require("./core.js"); const T = require("./texto.json");
const gen1 = T.GEN["1"], gen2 = T.GEN["2"];

test("blocos: Gn 1 vira blocos de ~60 palavras sem perder versículos", () => {
  const b = C.makeBlocks(gen1); const n = b.reduce((a, x) => a + x.verses.length, 0);
  assert.equal(n, 31); assert.ok(b.length >= 9 && b.length <= 14, `blocos=${b.length}`);
});
const blocksAt = (verses, wpm) => C.makeBlocks(verses).map(b => ({ words: b.words, visibleMs: b.words / wpm * 60000 }));
const total = (bl) => bl.reduce((a, b) => a + b.visibleMs, 0);
for (const wpm of [120, 230, 300, 400, 480]) {
  test(`validação: leitor honesto a ${wpm} ppm é aprovado`, () => { const bl = blocksAt(gen1, wpm); assert.equal(C.validateChapter(bl, total(bl)).ok, true); });
}
test("validação: rolagem a 2000 ppm é reprovada", () => { const bl = blocksAt(gen1, 2000); assert.equal(C.validateChapter(bl, total(bl)).ok, false); });
test("validação: leitura dinâmica a 700 ppm é reprovada pelo tempo total", () => { const bl = blocksAt(gen1, 700); assert.equal(C.validateChapter(bl, total(bl)).ok, false); });
test("validação: celular parado no 1º bloco (resto nunca visível) é reprovado", () => {
  const bl = C.makeBlocks(gen1).map((b, i) => ({ words: b.words, visibleMs: i === 0 ? 600000 : 0 }));
  assert.equal(C.validateChapter(bl, 600000).ok, false);
});
test("validação: 1 bloco pulado não reprova quem leu o resto com calma (tolerância de 20%)", () => {
  const bl = blocksAt(gen1, 230); bl[3].visibleMs = 100; assert.equal(C.validateChapter(bl, total(bl)).ok, true);
});
test("estágio: o 1º capítulo já faz brotar (vitória rápida)", () => { assert.equal(C.stageFor(1, 50), 1); assert.equal(C.stageFor(0, 50), 0); });
test("estágio: monotônico e só chega a 'plena' ao concluir o livro", () => {
  let prev = 0; for (let n = 0; n <= 50; n++) { const s = C.stageFor(n, 50); assert.ok(s >= prev); prev = s; if (n < 50) assert.ok(s < 6); }
  assert.equal(C.stageFor(50, 50), 6);
});
test("crescimento contínuo nunca regride", () => { let p = -1; for (let n = 0; n <= 50; n++) { const g = C.growthFor(n, 50); assert.ok(g >= p, `n=${n}`); p = g; } });
test("canteiros de Gênesis cobrem 1–50 sem lacunas", () => {
  const s = C.SECTIONS.GEN; assert.equal(s[0].de, 1); assert.equal(s.at(-1).ate, 50);
  for (let i = 1; i < s.length; i++) assert.equal(s[i].de, s[i - 1].ate + 1);
});
test("canteiros dos Salmos seguem os 5 livros do Saltério", () => { assert.deepEqual(C.SECTIONS.PSA.map(s => s.ate), [41, 72, 89, 106, 150]); });
test("porção: ler 10 capítulos não vale mais que ler 1 (sem 'farmar')", () => {
  assert.equal(C.porcaoDoDia({ readMin: 5 }), C.porcaoDoDia({ readMin: 120 }));
});
test("porção: teto diário respeitado", () => { assert.equal(C.porcaoDoDia({ readMin: 60, prayMin: 30, devocional: true }), 40); });
test("porção: quem não leu mas orou também recebe (graça, não cobrança)", () => { assert.ok(C.porcaoDoDia({ prayMin: 3 }) > 0); });
test("porção: dia sem nada dá zero (sem punição, sem negativo)", () => { assert.equal(C.porcaoDoDia({}), 0); });
test("oração: desistir não registra; concluir registra", () => {
  assert.equal(C.prayerCounts(5, 300000, true), false); assert.equal(C.prayerCounts(5, 300000, false), true); assert.equal(C.prayerCounts(5, 120000, false), false);
});
test("loja: comprar nunca altera progresso de leitura", () => {
  const s = { orvalho: 200, itens: [], capitulos: [1, 2] }; const r = C.buy(s, { id: "banco", preco: 120 });
  assert.ok(r.ok); assert.deepEqual(r.state.capitulos, s.capitulos); assert.equal(r.state.orvalho, 80);
  assert.equal(C.buy(r.state, { id: "fonte", preco: 500 }).ok, false);
});
test("calendário: Páscoa 2026 = 5/abr; 2027 = 28/mar", () => {
  assert.equal(C.isoDay(C.easter(2026)), "2026-04-05"); assert.equal(C.isoDay(C.easter(2027)), "2027-03-28");
});
test("calendário: Advento 2026 começa em 29/nov", () => { assert.equal(C.isoDay(C.adventStart(2026)), "2026-11-29"); });
test("calendário: estações de exemplo", () => {
  assert.equal(C.liturgicalSeason(new Date(2026, 9, 31)).id, "comum");
  assert.equal(C.liturgicalSeason(new Date(2026, 11, 1)).id, "advento");
  assert.equal(C.liturgicalSeason(new Date(2026, 11, 25)).id, "natal");
  assert.equal(C.liturgicalSeason(new Date(2027, 2, 1)).id, "quaresma");
  assert.equal(C.liturgicalSeason(new Date(2026, 4, 24)).id, "pentecostes");
});
test("ritmo semanal: 7 posições, nada 'zera'", () => {
  const r = C.weekRhythm(["2026-10-30", "2026-10-31"], new Date(2026, 9, 31)); assert.equal(r.length, 7); assert.deepEqual(r.slice(-2), [true, true]);
});
test("assinatura: luz preferida e semente estável", () => {
  assert.equal(C.preferredLight([6, 7, 7, 22]), "manha"); assert.equal(C.hashSeed("Jardim da Ana"), C.hashSeed("Jardim da Ana"));
  assert.notEqual(C.hashSeed("Jardim da Ana"), C.hashSeed("Jardim do Beto"));
});
test("tamanho da planta segue o livro", () => { assert.equal(C.sizeClass(2), "flor"); assert.equal(C.sizeClass(30), "media"); assert.equal(C.sizeClass(153), "grande"); });

test("v2: ritmo humano (pausas entre rolagens) aprova; rolagem automática constante reprova", () => {
  assert.equal(C.readingSignals({ still: .7, velCV: .3, inputs: 8, blocks: 12 }).ritmo, true);
  assert.equal(C.readingSignals({ still: 0, velCV: .02, inputs: 0, blocks: 12 }).ritmo, false);
});
test("v2: quem arrasta o dedo devagar (sem pausas, velocidade irregular) passa no ritmo", () => {
  assert.equal(C.readingSignals({ still: .1, velCV: .9, inputs: 30, blocks: 12 }).ritmo, true);
});
test("v2: sem sensor de movimento, toques bastam (sensor nunca é obrigatório)", () => {
  const s = C.readingSignals({ still: .6, velCV: .3, inputs: 6, blocks: 12, handShare: null }); assert.equal(s.presenca, true); assert.equal(s.sensor, false);
});
test("v2: celular na mão conta como presença mesmo com poucos toques", () => {
  assert.equal(C.readingSignals({ still: .6, velCV: .3, inputs: 1, blocks: 12, handShare: .8 }).presenca, true);
});
test("v2: robô sem toques e celular parado na mesa reprova por presença", () => {
  const g1 = T.GEN["1"]; const bl = C.makeBlocks(g1).map(b => ({ words: b.words, visibleMs: b.words / 400 * 60000 }));
  const r = C.validateChapterV2(bl, bl.reduce((a, b) => a + b.visibleMs, 0), { still: .8, velCV: .2, inputs: 0, handShare: .0 });
  assert.equal(r.ok, false); assert.equal(r.motivo, "presenca");
});
test("v2: leitor honesto na mão é aprovado e o motivo fica vazio", () => {
  const g1 = T.GEN["1"]; const bl = C.makeBlocks(g1).map(b => ({ words: b.words, visibleMs: b.words / 230 * 60000 }));
  const r = C.validateChapterV2(bl, bl.reduce((a, b) => a + b.visibleMs, 0), { still: .7, velCV: .4, inputs: 9, handShare: .9 });
  assert.equal(r.ok, true); assert.equal(r.motivo, null);
});
test("antecipação: diz quantos capítulos faltam para o próximo estágio", () => {
  assert.deepEqual(C.nextStageIn(0, 50), { estagio: "Broto", faltam: 1 }); assert.equal(C.nextStageIn(50, 50), null);
  const n = C.nextStageIn(1, 50); assert.equal(n.estagio, "Muda"); assert.ok(n.faltam > 0);
});

test("aderência: dias desde a última visita", () => {
  assert.equal(C.diasDesde("2026-10-28", "2026-10-31"), 3); assert.equal(C.diasDesde(null, "2026-10-31"), null); assert.equal(C.diasDesde("2026-10-31", "2026-10-31"), 0);
});
test("aderência: próxima conquista mira a mais cara que já dá para liberar; senão, a mais barata que falta", () => {
  const it = [{ id: "a", nome: "A", preco: 80, tem: true }, { id: "b", nome: "B", preco: 180 }, { id: "c", nome: "C", preco: 300 }];
  assert.equal(C.proximaConquista(200, it).id, "b"); assert.equal(C.proximaConquista(200, it).falta, 0);
  const r = C.proximaConquista(100, it); assert.equal(r.id, "b"); assert.equal(r.falta, 80); assert.ok(r.pct > 0.5 && r.pct < 0.6);
  assert.equal(C.proximaConquista(100, [{ id: "x", preco: 10, tem: true }]), null);
});
test("aderência: estimativa de minutos por capítulo (Gn 1 ≈ 3 min)", () => {
  const w = T.GEN["1"].reduce((a, v) => a + C.wordsOf(v), 0); assert.equal(C.minutosCapitulo(w), 3); assert.equal(C.minutosCapitulo(10), 1);
});
