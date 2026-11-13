import 'package:drift/drift.dart';

/// Capítulos lidos e validados (um registro por capítulo).
@DataClassName('ChapterReadRow')
class ChapterReads extends Table {
  TextColumn get book => text().withLength(min: 3, max: 3)();
  IntColumn get chapter => integer()();
  DateTimeColumn get firstReadAt => dateTime()();
  IntColumn get timesRead => integer().withDefault(const Constant(1))();

  @override
  Set<Column<Object>> get primaryKey => {book, chapter};
}

/// Cada leitura aceita, com o resumo da validação (tela de transparência).
@DataClassName('ReadingLogRow')
class ReadingLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get book => text()();
  IntColumn get chapter => integer()();
  DateTimeColumn get at => dateTime()();
  RealColumn get minutes => real()();

  /// 'app' (validada na tela) ou 'impressa' (li na minha Bíblia).
  TextColumn get method => text()();

  /// Resumo da validação em JSON (blocos, pausas, toques, mão).
  TextColumn get details => text().withDefault(const Constant('{}'))();
}

/// O que aconteceu em cada dia (para a porção de orvalho e o ritmo).
@DataClassName('DayRow')
class DayActivities extends Table {
  /// Dia ISO local (aaaa-mm-dd).
  TextColumn get day => text()();
  RealColumn get readMin => real().withDefault(const Constant(0))();
  RealColumn get prayMin => real().withDefault(const Constant(0))();
  BoolColumn get devocional => boolean().withDefault(const Constant(false))();

  /// Orvalho já creditado neste dia (a porção é calculada de novo e só a
  /// diferença entra no livro-caixa).
  IntColumn get porcaoCreditada => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {day};
}

/// Livro-caixa do orvalho. O saldo é a soma; nada é apagado.
@DataClassName('LedgerRow')
class OrvalhoLedger extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get at => dateTime()();
  IntColumn get delta => integer()();

  /// porcao | compra | pacote | presente | ajuste_dev
  TextColumn get reason => text()();
  TextColumn get ref => text().nullable()();
}

/// Itens da loja que a pessoa tem.
@DataClassName('OwnedItemRow')
class OwnedItems extends Table {
  TextColumn get itemId => text()();
  DateTimeColumn get acquiredAt => dateTime()();

  /// orvalho | gratis | pacote
  TextColumn get source => text()();

  @override
  Set<Column<Object>> get primaryKey => {itemId};
}

/// Onde cada item está no jardim de um livro (ladrilhos 12 × 12).
@DataClassName('PlacementRow')
class Placements extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get book => text()();
  TextColumn get itemId => text()();
  IntColumn get x => integer()();
  IntColumn get y => integer()();
}

/// Animais que chegaram ao jardim. A idade vem das porções recebidas desde
/// a chegada.
@DataClassName('AnimalRow')
class Animals extends Table {
  TextColumn get animalId => text()();

  /// Livro do jardim, ou 'COMP' para o companheiro.
  TextColumn get garden => text()();
  DateTimeColumn get arrivedAt => dateTime()();
  IntColumn get porcoesAtArrival => integer()();

  @override
  Set<Column<Object>> get primaryKey => {animalId, garden};
}

/// Personagens bíblicos: liberados pela leitura, comprados com orvalho.
@DataClassName('CharacterRow')
class Characters extends Table {
  TextColumn get characterId => text()();
  DateTimeColumn get unlockedAt => dateTime().nullable()();
  DateTimeColumn get boughtAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {characterId};
}

/// Orações concluídas (só o ato, nunca o conteúdo).
@DataClassName('PrayerRow')
class Prayers extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get at => dateTime()();
  IntColumn get minutes => integer()();
  BoolColumn get guided => boolean()();
}

/// Pedidos de oração. "Foi respondida" ergue uma pedra de Ebenézer.
@DataClassName('PrayerRequestRow')
class PrayerRequests extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get body => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get answeredAt => dateTime().nullable()();
  TextColumn get ebenezerNote => text().nullable()();
}

/// Baú do diário: anotações do devocional.
@DataClassName('JournalRow')
class JournalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get day => text()();
  TextColumn get devotionalId => text().nullable()();
  TextColumn get body => text()();
  DateTimeColumn get createdAt => dateTime()();
}

/// Pedras da coroa (marcos de leitura; nunca vendidas).
@DataClassName('CrownStoneRow')
class CrownStones extends Table {
  /// Ex.: 'canteiro:GEN:1', 'livro:RUT', 'bioma:Evangelhos', 'biblia'.
  TextColumn get id => text()();
  IntColumn get count => integer()();
  DateTimeColumn get at => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Compras com dinheiro (pacotes de orvalho e pacotes visuais).
@DataClassName('StorePurchaseRow')
class StorePurchases extends Table {
  TextColumn get transactionId => text()();
  TextColumn get productId => text()();
  IntColumn get priceCents => integer()();
  TextColumn get currency => text()();
  DateTimeColumn get at => dateTime()();

  /// pendente | entregue | reembolsada
  TextColumn get status => text()();

  @override
  Set<Column<Object>> get primaryKey => {transactionId};
}

/// Preferências simples (chave e valor em texto).
@DataClassName('SettingRow')
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}
