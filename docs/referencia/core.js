/* Bible Garden — regras puras (testáveis). Usado pelo protótipo e pelos testes. */
(function (root) {
  const RULES = {
    BLOCK_MAX_WPM: 900,      // acima disso o bloco "passou voando" (rolagem)
    CHAPTER_MAX_WPM: 500,    // teto do tempo total do capítulo
    BLOCK_OK_SHARE: 0.8,     // ≥80% dos blocos com tempo plausível
    IDLE_PAUSE_MS: 90000,    // sem toque/rolagem por 90 s → pausa a contagem
    PRAYER_MIN_MIN: 2,       // oração conta a partir de 2 min
    PRAYER_GRACE_MS: 15000,  // pode sair do app por até 15 s (ex.: tela bloqueou)
    PORCAO: { presenca: 20, oracao: 10, devocional: 10, teto: 40 },
    READ_MIN_FOR_PRESENCE: 3 // minutos de leitura validada para a porção de presença
  };

  function wordsOf(s) { return (s.trim().match(/\S+/g) || []).length; }

  // agrupa versículos em blocos de ~60 palavras sem quebrar versículo
  function makeBlocks(verses, target = 60) {
    const blocks = []; let cur = { from: 1, verses: [], words: 0 };
    verses.forEach((v, i) => {
      cur.verses.push({ n: i + 1, t: v }); cur.words += wordsOf(v);
      if (cur.words >= target) { blocks.push(cur); cur = { from: i + 2, verses: [], words: 0 }; }
    });
    if (cur.verses.length) {
      if (cur.words < target / 3 && blocks.length) { const last = blocks[blocks.length - 1]; last.verses.push(...cur.verses); last.words += cur.words; }
      else blocks.push(cur);
    }
    return blocks;
  }

  function minBlockMs(words) { return (words / RULES.BLOCK_MAX_WPM) * 60000; }
  function minChapterMs(words) { return (words / RULES.CHAPTER_MAX_WPM) * 60000; }

  // blocks: [{words, visibleMs}] ; activeMs: tempo ativo total no capítulo
  function validateChapter(blocks, activeMs) {
    const total = blocks.reduce((a, b) => a + b.words, 0);
    const flagged = [];
    blocks.forEach((b, i) => { if (b.visibleMs < minBlockMs(b.words)) flagged.push(i); });
    const okShare = 1 - flagged.length / Math.max(1, blocks.length);
    const needMs = minChapterMs(total);
    const ok = okShare >= RULES.BLOCK_OK_SHARE && activeMs >= needMs;
    return { ok, flagged, okShare, needMs, remainingMs: Math.max(0, needMs - activeMs) };
  }

  // estágios: 0 semente · 1 broto · 2 muda · 3 árvore · 4 frutífera · 5 florida · 6 plena
  const STAGES = ["Semente", "Broto", "Muda", "Árvore", "Árvore frutífera", "Árvore florida", "Árvore plena"];
  function stageFor(done, caps) {
    if (done <= 0) return 0;
    if (done >= caps) return 6;
    const f = done / caps;                 // vitória rápida: o 1º capítulo já brota
    if (f < 0.12) return 1; if (f < 0.30) return 2; if (f < 0.55) return 3; if (f < 0.80) return 4; return 5;
  }
  // progresso contínuo (0–6) para animação suave entre estágios
  function growthFor(done, caps) {
    const s = stageFor(done, caps); if (s === 0 || s === 6) return s;
    const cuts = [0, 1 / caps, 0.12, 0.30, 0.55, 0.80, 1];
    const f = done / caps; const a = cuts[s], b = cuts[s + 1];
    return s + Math.min(0.99, (f - a) / (b - a));
  }

  // Gênesis em 4 canteiros (unidades literárias)
  const SECTIONS = {
    GEN: [{ nome: "Origens", de: 1, ate: 11 }, { nome: "Abraão", de: 12, ate: 25 }, { nome: "Isaque e Jacó", de: 26, ate: 36 }, { nome: "José", de: 37, ate: 50 }],
    PSA: [{ nome: "Livro I", de: 1, ate: 41 }, { nome: "Livro II", de: 42, ate: 72 }, { nome: "Livro III", de: 73, ate: 89 }, { nome: "Livro IV", de: 90, ate: 106 }, { nome: "Livro V", de: 107, ate: 150 }]
  };
  function sectionsDone(book, readSet) {
    return (SECTIONS[book] || []).map(s => { for (let c = s.de; c <= s.ate; c++) if (!readSet.has(c)) return false; return true; });
  }

  // tamanho da planta segue o tamanho do livro (minutos a 230 ppm)
  function sizeClass(minutes) { return minutes < 15 ? "flor" : minutes < 60 ? "media" : "grande"; }

  // porção diária (maná): o mesmo para todos que comparecem — ler mais não multiplica
  function porcaoDoDia(day) {
    let p = 0;
    const presenca = (day.readMin || 0) >= RULES.READ_MIN_FOR_PRESENCE || (day.prayMin || 0) >= RULES.PRAYER_MIN_MIN || !!day.devocional;
    if (presenca) p += RULES.PORCAO.presenca;
    if ((day.prayMin || 0) >= RULES.PRAYER_MIN_MIN) p += RULES.PORCAO.oracao;
    if (day.devocional) p += RULES.PORCAO.devocional;
    return Math.min(p, RULES.PORCAO.teto);
  }

  // oração: recompensa o ato, não os minutos
  function prayerCounts(plannedMin, elapsedMs, abandoned) {
    if (abandoned) return false;
    return elapsedMs >= Math.min(plannedMin, RULES.PRAYER_MIN_MIN) * 60000 - 500 && elapsedMs >= plannedMin * 60000 - 500;
  }

  // calendário cristão (Páscoa: algoritmo gregoriano anônimo)
  function easter(y) {
    const a = y % 19, b = Math.floor(y / 100), c = y % 100, d = Math.floor(b / 4), e = b % 4, f = Math.floor((b + 8) / 25),
      g = Math.floor((b - f + 1) / 3), h = (19 * a + b - d - g + 15) % 30, i = Math.floor(c / 4), k = c % 4,
      l = (32 + 2 * e + 2 * i - h - k) % 7, m = Math.floor((a + 11 * h + 22 * l) / 451),
      month = Math.floor((h + l - 7 * m + 114) / 31), day = ((h + l - 7 * m + 114) % 31) + 1;
    return new Date(y, month - 1, day);
  }
  function adventStart(y) { const xmas = new Date(y, 11, 25); const dow = xmas.getDay(); const lastSun = new Date(y, 11, 25 - (dow === 0 ? 7 : dow)); return new Date(y, 11, lastSun.getDate() - 21); }
  function addDays(d, n) { const x = new Date(d); x.setDate(x.getDate() + n); return x; }
  function liturgicalSeason(date) {
    const d = new Date(date.getFullYear(), date.getMonth(), date.getDate()); const y = d.getFullYear();
    const E = easter(y), ash = addDays(E, -46), pent = addDays(E, 49), adv = adventStart(y);
    if (d >= adv && d < new Date(y, 11, 25)) return { id: "advento", nome: "Advento", cor: "#6B4C8A" };
    if (d >= new Date(y, 11, 25) || d <= new Date(y, 0, 6)) return { id: "natal", nome: "Natal", cor: "#D9B44A" };
    if (d >= ash && d < E) return { id: "quaresma", nome: "Quaresma", cor: "#7A5C8E" };
    if (d >= E && d <= pent) return { id: d.getTime() === pent.getTime() ? "pentecostes" : "pascoa", nome: d.getTime() === pent.getTime() ? "Pentecostes" : "Tempo Pascal", cor: d.getTime() === pent.getTime() ? "#C8452E" : "#E8D9A8" };
    return { id: "comum", nome: "Tempo Comum", cor: "#5E8A4E" };
  }

  // assinatura: luz preferida a partir dos horários em que a pessoa lê
  function preferredLight(hours) {
    if (!hours || !hours.length) return null;
    const bins = { madrugada: 0, manha: 0, tarde: 0, noite: 0 };
    hours.forEach(h => { if (h < 5) bins.madrugada++; else if (h < 12) bins.manha++; else if (h < 18) bins.tarde++; else bins.noite++; });
    return Object.entries(bins).sort((a, b) => b[1] - a[1])[0][0];
  }

  // ritmo semanal (não é sequência: nada "zera")
  function weekRhythm(activeDates, today) {
    const set = new Set(activeDates); const out = [];
    for (let i = 6; i >= 0; i--) { const d = addDays(today, -i); out.push(set.has(isoDay(d))); }
    return out;
  }
  function isoDay(d) { const z = n => String(n).padStart(2, "0"); return `${d.getFullYear()}-${z(d.getMonth() + 1)}-${z(d.getDate())}`; }

  // semente procedural estável a partir do nome do jardim
  function hashSeed(str) { let h = 2166136261; for (const ch of String(str)) { h ^= ch.codePointAt(0); h = Math.imul(h, 16777619); } return h >>> 0; }
  function rng(seed) { let s = seed >>> 0 || 1; return () => { s ^= s << 13; s >>>= 0; s ^= s >> 17; s ^= s << 5; s >>>= 0; return s / 4294967296; }; }

  // loja: só cosmético. Comprar nunca altera crescimento.
  function buy(state, item) {
    if (state.orvalho < item.preco) return { ok: false, motivo: "orvalho insuficiente" };
    const next = JSON.parse(JSON.stringify(state)); next.orvalho -= item.preco; next.itens.push(item.id); return { ok: true, state: next };
  }

  // v2: sinais de leitura — ritmo de rolagem ("leitura da tela") e presença (toques ou mão)
  // still: fração do tempo ativo sem rolar; velCV: variação da velocidade quando rola;
  // inputs: toques/rolagens humanas; blocks: nº de blocos; handShare: fração de janelas com celular na mão (null = sem sensor)
  function readingSignals({ still = 0, velCV = 0, inputs = 0, blocks = 1, handShare = null }) {
    const ritmo = still >= 0.25 || velCV >= 0.5;
    const presencaToque = inputs >= Math.max(1, Math.ceil(blocks / 3));
    const presencaMao = handShare !== null && handShare >= 0.3;
    return { ritmo, presenca: presencaToque || presencaMao, presencaToque, presencaMao, sensor: handShare !== null };
  }
  function validateChapterV2(blocks, activeMs, sig) {
    const v = validateChapter(blocks, activeMs); const s = readingSignals(Object.assign({ blocks: blocks.length }, sig));
    let motivo = null; if (!v.ok) motivo = v.flagged.length ? 'rapido' : 'tempo'; else if (!s.ritmo) motivo = 'ritmo'; else if (!s.presenca) motivo = 'presenca';
    return Object.assign({}, v, { ok: v.ok && s.ritmo && s.presenca, sinais: s, motivo });
  }
  function nextStageIn(done, caps) { const s = stageFor(done, caps); if (s >= 6) return null; for (let n = done + 1; n <= caps; n++) if (stageFor(n, caps) > s) return { estagio: STAGES[s + 1], faltam: n - done }; return null; }

  // aderência: dias desde a última visita (volta acolhedora) e próxima conquista (efeito de proximidade da meta)
  function diasDesde(ultimo, hoje) { if (!ultimo) return null; const a = new Date(ultimo + 'T12:00:00'), b = new Date(hoje + 'T12:00:00'); return Math.round((b - a) / 86400000); }
  function proximaConquista(orvalho, itens) { const pend = itens.filter(i => !i.tem).sort((a, b) => a.preco - b.preco); if (!pend.length) return null;
    const alc = pend.filter(i => i.preco <= orvalho); const alvo = alc.length ? alc[alc.length - 1] : pend[0];
    return { id: alvo.id, nome: alvo.nome, preco: alvo.preco, falta: Math.max(0, alvo.preco - orvalho), pct: Math.min(1, orvalho / alvo.preco) }; }
  function minutosCapitulo(palavras, ppm = 230) { return Math.max(1, Math.round(palavras / ppm)); }
  const api = { diasDesde, proximaConquista, minutosCapitulo, readingSignals, validateChapterV2, nextStageIn, RULES, wordsOf, makeBlocks, minBlockMs, minChapterMs, validateChapter, STAGES, stageFor, growthFor, SECTIONS, sectionsDone, sizeClass, porcaoDoDia, prayerCounts, easter, adventStart, liturgicalSeason, preferredLight, weekRhythm, isoDay, addDays, hashSeed, rng, buy };
  if (typeof module !== "undefined" && module.exports) module.exports = api; else root.BGCore = api;
})(typeof window !== "undefined" ? window : globalThis);
