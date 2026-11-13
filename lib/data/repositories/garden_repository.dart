import 'dart:convert';

import 'package:bible_garden/core/calendar.dart';
import 'package:bible_garden/core/economy.dart';
import 'package:bible_garden/core/growth.dart';
import 'package:bible_garden/core/reading_tracker.dart';
import 'package:bible_garden/core/unlocks.dart';
import 'package:bible_garden/data/content/content.dart';
import 'package:bible_garden/data/db/app_database.dart';
import 'package:drift/drift.dart';

/// O que mudou no jardim depois de uma leitura (para a animação e a mensagem).
final class ChapterOutcome {
  const new({
    required this.book,
    required this.chapter,
    required this.stageBefore,
    required this.stageAfter,
    required this.growthBefore,
    required this.growthAfter,
    required this.firstTime,
    required this.orvalhoGanho,
    this.newCharacters = const [],
    this.newAnimals = const [],
    this.newCrownStones = const [],
    this.bookCompleted = false,
  });

  final String book;
  final int chapter;
  final Stage stageBefore;
  final Stage stageAfter;
  final double growthBefore;
  final double growthAfter;
  final bool firstTime;
  final int orvalhoGanho;
  final List<String> newCharacters;
  final List<String> newAnimals;
  final List<String> newCrownStones;
  final bool bookCompleted;
}

/// Regras do jardim sobre o banco: leitura, orvalho, liberações.
///
/// Toda escrita acontece numa transação. O relógio é injetável para testes.
final class GardenRepository {
  new(this.db, this.content, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AppDatabase db;
  final GameContent content;
  final DateTime Function() _clock;

  DateTime get now => _clock();
  String get today => isoDay(now);

  // ---------------------------------------------------------------- leitura

  Future<Set<int>> readChapters(String book) async {
    final rows = await (db.select(
      db.chapterReads,
    )..where((t) => t.book.equals(book))).get();
    return {for (final r in rows) r.chapter};
  }

  Stream<Set<int>> watchReadChapters(String book) =>
      (db.select(db.chapterReads)..where((t) => t.book.equals(book)))
          .watch()
          .map((rows) => {for (final r in rows) r.chapter});

  /// Quantas vezes o livro inteiro foi lido (o mínimo entre os capítulos).
  Future<int> completions(String book, int chapters) async {
    final rows = await (db.select(
      db.chapterReads,
    )..where((t) => t.book.equals(book))).get();
    if (rows.length < chapters) return 0;
    return rows.map((r) => r.timesRead).reduce((a, b) => a < b ? a : b);
  }

  Future<DateTime?> lastPrintedReadingAt() async {
    final q = db.select(db.readingLog)
      ..where((t) => t.method.equals('impressa'))
      ..orderBy([(t) => OrderingTerm.desc(t.at)])
      ..limit(1);
    return (await q.getSingleOrNull())?.at;
  }

  Future<ValidationSummary?> lastValidation() async {
    final q = db.select(db.readingLog)
      ..where((t) => t.method.equals('app'))
      ..orderBy([(t) => OrderingTerm.desc(t.at)])
      ..limit(1);
    final r = await q.getSingleOrNull();
    if (r == null) return null;
    return ValidationSummary.fromJson(
      jsonDecode(r.details) as Map<String, Object?>,
    );
  }

  /// Registra um capítulo lido e aplica tudo o que decorre dele.
  Future<ChapterOutcome> completeChapter({
    required String book,
    required int chapter,
    required int chaptersInBook,
    required double minutes,
    required String method,
    ValidationSummary? summary,
  }) => db.transaction(() async {
    final at = now;
    final before = await readChapters(book);
    final stageBefore = stageFor(before.length, chaptersInBook);
    final growthBefore = growthFor(before.length, chaptersInBook);
    final firstTime = !before.contains(chapter);

    if (firstTime) {
      await db
          .into(db.chapterReads)
          .insert(
            ChapterReadsCompanion.insert(
              book: book,
              chapter: chapter,
              firstReadAt: at,
            ),
          );
    } else {
      await db.customUpdate(
        'UPDATE chapter_reads SET times_read = times_read + 1 '
        'WHERE book = ? AND chapter = ?',
        variables: [Variable(book), Variable(chapter)],
        updates: {db.chapterReads},
      );
    }
    await db
        .into(db.readingLog)
        .insert(
          ReadingLogCompanion.insert(
            book: book,
            chapter: chapter,
            at: at,
            minutes: minutes,
            method: method,
            details: Value(jsonEncode(summary?.toJson() ?? const {})),
          ),
        );

    final after = {...before, chapter};
    final orvalho = await _addDay(readMin: minutes);
    final newCharacters = await _unlockCharacters(book);
    final stageAfter = stageFor(after.length, chaptersInBook);
    final newAnimals = <String>[];
    if (bookAnimalArrives(stageAfter) && !bookAnimalArrives(stageBefore)) {
      final g = content.livro(book);
      if (g != null && await _addAnimal(g.animal, book)) {
        newAnimals.add(g.animal);
      }
    }
    final stones = await _crownStones(book, after, chaptersInBook);
    return ChapterOutcome(
      book: book,
      chapter: chapter,
      stageBefore: stageBefore,
      stageAfter: stageAfter,
      growthBefore: growthBefore,
      growthAfter: growthFor(after.length, chaptersInBook),
      firstTime: firstTime,
      orvalhoGanho: orvalho,
      newCharacters: newCharacters,
      newAnimals: newAnimals,
      newCrownStones: stones,
      bookCompleted: after.length >= chaptersInBook && firstTime,
    );
  });

  // ------------------------------------------------------------- dia e orvalho

  Future<DayActivity> dayActivity([String? day]) async {
    final r = await (db.select(
      db.dayActivities,
    )..where((t) => t.day.equals(day ?? today))).getSingleOrNull();
    return r == null
        ? const DayActivity()
        : DayActivity(
            readMin: r.readMin,
            prayMin: r.prayMin,
            devocional: r.devocional,
          );
  }

  /// Soma atividade ao dia de hoje e credita só a diferença da porção.
  /// Devolve o orvalho creditado agora.
  Future<int> _addDay({
    double readMin = 0,
    double prayMin = 0,
    bool devocional = false,
  }) async {
    final d = today;
    final cur = await (db.select(
      db.dayActivities,
    )..where((t) => t.day.equals(d))).getSingleOrNull();
    final act = DayActivity(
      readMin: (cur?.readMin ?? 0) + readMin,
      prayMin: (cur?.prayMin ?? 0) + prayMin,
      devocional: (cur?.devocional ?? false) || devocional,
    );
    final porcao = porcaoDoDia(act);
    final credited = cur?.porcaoCreditada ?? 0;
    final delta = porcao - credited;
    await db
        .into(db.dayActivities)
        .insertOnConflictUpdate(
          DayActivitiesCompanion.insert(
            day: d,
            readMin: Value(act.readMin),
            prayMin: Value(act.prayMin),
            devocional: Value(act.devocional),
            porcaoCreditada: Value(porcao),
          ),
        );
    if (delta > 0) {
      await db
          .into(db.orvalhoLedger)
          .insert(
            OrvalhoLedgerCompanion.insert(
              at: now,
              delta: delta,
              reason: 'porcao',
              ref: Value(d),
            ),
          );
    }
    return delta > 0 ? delta : 0;
  }

  Future<int> recordPrayer({required int minutes, required bool guided}) =>
      db.transaction(() async {
        await db
            .into(db.prayers)
            .insert(
              PrayersCompanion.insert(
                at: now,
                minutes: minutes,
                guided: guided,
              ),
            );
        return await _addDay(prayMin: minutes.toDouble());
      });

  Future<int> recordDevotional({String? note, String? devotionalId}) =>
      db.transaction(() async {
        if (note != null && note.trim().isNotEmpty) {
          await db
              .into(db.journalEntries)
              .insert(
                JournalEntriesCompanion.insert(
                  day: today,
                  devotionalId: Value(devotionalId),
                  body: note.trim(),
                  createdAt: now,
                ),
              );
        }
        return await _addDay(devocional: true);
      });

  Future<int> balance() async {
    final sum = db.orvalhoLedger.delta.sum();
    final q = db.selectOnly(db.orvalhoLedger)..addColumns([sum]);
    return (await q.map((r) => r.read(sum)).getSingle()) ?? 0;
  }

  Stream<int> watchBalance() {
    final sum = db.orvalhoLedger.delta.sum();
    final q = db.selectOnly(db.orvalhoLedger)..addColumns([sum]);
    return q.map((r) => r.read(sum) ?? 0).watchSingle();
  }

  /// Dias em que a pessoa recebeu porção (base do crescimento dos animais).
  Future<int> porcoesRecebidas() async {
    final c = db.dayActivities.day.count();
    final q = db.selectOnly(db.dayActivities)
      ..addColumns([c])
      ..where(db.dayActivities.porcaoCreditada.isBiggerThanValue(0));
    return (await q.map((r) => r.read(c)).getSingle()) ?? 0;
  }

  Future<List<String>> activeDays({int last = 7}) async {
    final from = isoDay(addDays(now, -(last - 1)));
    final rows =
        await (db.select(db.dayActivities)
              ..where((t) => t.day.isBiggerOrEqualValue(from))
              ..where(
                (t) =>
                    t.readMin.isBiggerThanValue(0) |
                    t.prayMin.isBiggerThanValue(0) |
                    t.devocional.equals(true),
              ))
            .get();
    return [for (final r in rows) r.day];
  }

  // ---------------------------------------------------------------- loja

  Future<Set<String>> ownedItems() async => {
    for (final r in await db.select(db.ownedItems).get()) r.itemId,
  };

  /// Compra com orvalho. Nunca toca em leitura nem crescimento.
  Future<BuyResult> buyWithOrvalho(String itemId, int price) =>
      db.transaction(() async {
        final wallet = Wallet(
          orvalho: await balance(),
          itens: [...await ownedItems()],
        );
        final r = buy(wallet, ShopItem(id: itemId, preco: price));
        if (r is BuyOk) {
          await db
              .into(db.orvalhoLedger)
              .insert(
                OrvalhoLedgerCompanion.insert(
                  at: now,
                  delta: -price,
                  reason: 'compra',
                  ref: Value(itemId),
                ),
              );
          await db
              .into(db.ownedItems)
              .insert(
                OwnedItemsCompanion.insert(
                  itemId: itemId,
                  acquiredAt: now,
                  source: 'orvalho',
                ),
              );
        }
        return r;
      });

  /// Compra de personagem: só depois de liberado pela leitura.
  Future<BuyResult> buyCharacter(String characterId) =>
      db.transaction(() async {
        final c = content.personagem(characterId);
        if (c == null) return const BuyFail('personagem desconhecido');
        final row = await (db.select(
          db.characters,
        )..where((t) => t.characterId.equals(characterId))).getSingleOrNull();
        if (row?.unlockedAt == null) {
          return BuyFail('leia ${c.libera} para liberar');
        }
        if (row!.boughtAt != null) return const BuyFail('já tem');
        final r = await buyWithOrvalho('personagem:$characterId', c.preco);
        if (r is BuyOk) {
          await (db.update(db.characters)
                ..where((t) => t.characterId.equals(characterId)))
              .write(CharactersCompanion(boughtAt: Value(now)));
        }
        return r;
      });

  /// Créditos manuais (versão mod) ou entrega de pacote comprado.
  Future<void> credit(int amount, {required String reason, String? ref}) => db
      .into(db.orvalhoLedger)
      .insert(
        OrvalhoLedgerCompanion.insert(
          at: now,
          delta: amount,
          reason: reason,
          ref: Value(ref),
        ),
      );

  // ------------------------------------------------- animais e personagens

  Future<bool> _addAnimal(String animalId, String garden) async {
    final exists =
        await (db.select(db.animals)..where(
              (t) => t.animalId.equals(animalId) & t.garden.equals(garden),
            ))
            .getSingleOrNull();
    if (exists != null) return false;
    await db
        .into(db.animals)
        .insert(
          AnimalsCompanion.insert(
            animalId: animalId,
            garden: garden,
            arrivedAt: now,
            porcoesAtArrival: await porcoesRecebidas(),
          ),
        );
    return true;
  }

  /// Companheiro escolhido no cadastro (chega filhote).
  Future<void> setCompanion(String animalId) async {
    await (db.delete(db.animals)..where((t) => t.garden.equals('COMP'))).go();
    await _addAnimal(animalId, 'COMP');
  }

  Future<AnimalAge> animalAge(String animalId, String garden) async {
    final r =
        await (db.select(db.animals)..where(
              (t) => t.animalId.equals(animalId) & t.garden.equals(garden),
            ))
            .getSingleOrNull();
    if (r == null) return AnimalAge.filhote;
    return animalAgeFor(await porcoesRecebidas() - r.porcoesAtArrival);
  }

  Future<List<String>> _unlockCharacters(String book) async {
    final read = await readChapters(book);
    final out = <String>[];
    for (final c in content.personagens.where((c) => c.liberaLivro == book)) {
      if (!characterUnlocked(
        readInBook: read,
        requiredChapters: c.liberaCapitulos,
      )) {
        continue;
      }
      final row = await (db.select(
        db.characters,
      )..where((t) => t.characterId.equals(c.id))).getSingleOrNull();
      if (row?.unlockedAt != null) continue;
      await db
          .into(db.characters)
          .insertOnConflictUpdate(
            CharactersCompanion.insert(
              characterId: c.id,
              unlockedAt: Value(now),
            ),
          );
      out.add(c.id);
    }
    return out;
  }

  Future<Set<String>> unlockedCharacters() async => {
    for (final r in await (db.select(
      db.characters,
    )..where((t) => t.unlockedAt.isNotNull())).get())
      r.characterId,
  };

  // --------------------------------------------------------- pedras da coroa

  Future<List<String>> _crownStones(
    String book,
    Set<int> read,
    int chapters,
  ) async {
    final out = <String>[];
    Future<void> give(String id, int count) async {
      final ok = await db
          .into(db.crownStones)
          .insert(
            CrownStonesCompanion.insert(id: id, count: count, at: now),
            mode: InsertMode.insertOrIgnore,
          );
      if (ok > 0) out.add(id);
    }

    final done = sectionsDone(book, read);
    for (var i = 0; i < done.length; i++) {
      if (done[i]) await give('canteiro:$book:${i + 1}', crownStonesPerSection);
    }
    if (read.length >= chapters) {
      await give('livro:$book', crownStonesForBook(chapters));
    }
    return out;
  }

  /// Chamado pela camada de cima, que conhece os tamanhos dos livros.
  Future<String?> grantBiomeStone(String bioma) async {
    final ok = await db
        .into(db.crownStones)
        .insert(
          CrownStonesCompanion.insert(
            id: 'bioma:$bioma',
            count: crownStonesPerBiome,
            at: now,
          ),
          mode: InsertMode.insertOrIgnore,
        );
    return ok > 0 ? 'bioma:$bioma' : null;
  }

  Future<int> crownStoneCount() async {
    final s = db.crownStones.count.sum();
    final q = db.selectOnly(db.crownStones)..addColumns([s]);
    return (await q.map((r) => r.read(s)).getSingle()) ?? 0;
  }

  // ------------------------------------------------------- jardim e edição

  Future<List<PlacementRow>> placements(String book) =>
      (db.select(db.placements)..where((t) => t.book.equals(book))).get();

  /// Coloca um item que a pessoa tem num ladrilho livre.
  Future<bool> place(String book, String itemId, int x, int y) =>
      db.transaction(() async {
        if (!(await ownedItems()).contains(itemId)) return false;
        final taken =
            await (db.select(db.placements)..where(
                  (t) => t.book.equals(book) & t.x.equals(x) & t.y.equals(y),
                ))
                .getSingleOrNull();
        if (taken != null) return false;
        await db
            .into(db.placements)
            .insert(
              PlacementsCompanion.insert(
                book: book,
                itemId: itemId,
                x: x,
                y: y,
              ),
            );
        return true;
      });

  /// Guarda o item que está no ladrilho (volta para a bandeja).
  Future<bool> unplaceAt(String book, int x, int y) async =>
      await (db.delete(db.placements)
            ..where((t) => t.book.equals(book) & t.x.equals(x) & t.y.equals(y)))
          .go() >
      0;

  /// Animais do jardim do livro e o companheiro (que visita todos).
  Future<List<AnimalRow>> animalsFor(String book) => (db.select(
    db.animals,
  )..where((t) => t.garden.equals(book) | t.garden.equals('COMP'))).get();

  Future<Set<String>> boughtCharacters() async => {
    for (final r in await (db.select(
      db.characters,
    )..where((t) => t.boughtAt.isNotNull())).get())
      r.characterId,
  };

  // ---------------------------------------------------------- pedidos

  Future<int> addPrayerRequest(String body) => db
      .into(db.prayerRequests)
      .insert(
        PrayerRequestsCompanion.insert(body: body.trim(), createdAt: now),
      );

  Stream<List<PrayerRequestRow>> watchPrayerRequests() => (db.select(
    db.prayerRequests,
  )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();

  /// "Foi respondida": ergue uma pedra de Ebenézer (1 Sm 7:12).
  Future<void> answerPrayerRequest(int id, {String? note}) =>
      (db.update(db.prayerRequests)..where((t) => t.id.equals(id))).write(
        PrayerRequestsCompanion(
          answeredAt: Value(now),
          ebenezerNote: Value(note),
        ),
      );

  Future<void> deletePrayerRequest(int id) =>
      (db.delete(db.prayerRequests)..where((t) => t.id.equals(id))).go();

  Future<int> ebenezerCount() async {
    final c = db.prayerRequests.id.count();
    final q = db.selectOnly(db.prayerRequests)
      ..addColumns([c])
      ..where(db.prayerRequests.answeredAt.isNotNull());
    return (await q.map((r) => r.read(c)).getSingle()) ?? 0;
  }

  Stream<List<JournalRow>> watchJournal() => (db.select(
    db.journalEntries,
  )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();

  // ---------------------------------------------------------- volta

  /// Registra a visita de hoje e devolve quantos dias a pessoa ficou longe
  /// (nulo na primeira vez).
  Future<int?> registerVisit() async {
    final last = await setting('visita.ultima');
    await setSetting('visita.ultima', today);
    return diasDesde(last, today);
  }

  /// Avisa quando algo muda no banco (para o jardim se redesenhar).
  Stream<void> get changes => db.tableUpdates();

  // ------------------------------------------------------------ preferências

  Future<String?> setting(String key) async => (await (db.select(
    db.settings,
  )..where((t) => t.key.equals(key))).getSingleOrNull())?.value;

  Future<void> setSetting(String key, String value) => db
      .into(db.settings)
      .insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));

  Stream<String?> watchSetting(String key) => (db.select(
    db.settings,
  )..where((t) => t.key.equals(key))).watchSingleOrNull().map((r) => r?.value);
}
