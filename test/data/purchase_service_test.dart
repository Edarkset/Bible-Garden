import 'package:bible_garden/data/db/db_open.dart';
import 'package:bible_garden/data/purchases/purchase_service.dart';
import 'package:bible_garden/data/purchases/store_gateway.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeStoreGateway store;
  late PurchaseService service;

  setUp(() {
    store = FakeStoreGateway();
    service = PurchaseService(
      db: openMemoryDatabase(),
      store: store,
      clock: () => DateTime(2026, 11, 13),
    );
  });
  tearDown(() => service.db.close());

  Future<int> balance() async =>
      (await service.db.select(service.db.orvalhoLedger).get()).fold<int>(
        0,
        (a, r) => a + r.delta,
      );

  StorePurchaseUpdate purchase(String id, String tx, {List<String>? log}) =>
      StorePurchaseUpdate(
        productId: id,
        status: StorePurchaseStatus.purchased,
        transactionId: tx,
        verificationData: 'x',
        complete: () async => log?.add(tx),
      );

  test(
    'pacote de orvalho entra uma vez só, mesmo se a loja reenviar',
    () async {
      final log = <String>[];
      expect(
        await service.handle(purchase('orvalho_700', 't1', log: log)),
        DeliveryResult.delivered,
      );
      expect(
        await service.handle(purchase('orvalho_700', 't1', log: log)),
        DeliveryResult.duplicate,
      );
      expect(await balance(), 700);
      expect(log, ['t1', 't1']); // a loja é sempre avisada
      expect(await service.spentThisMonthCents(), 990);
    },
  );

  test('pacote visual vira item da pessoa', () async {
    await service.handle(purchase('pacote_noite_estrelada', 't2'));
    final owned = await service.db.select(service.db.ownedItems).get();
    expect(owned.single.itemId, 'pacote:noite-estrelada');
    expect(owned.single.source, 'pacote');
    expect(await balance(), 0);
  });

  test('sem transação, recusado; produto desconhecido não entrega', () async {
    expect(
      await service.handle(
        const StorePurchaseUpdate(
          productId: 'orvalho_300',
          status: StorePurchaseStatus.purchased,
        ),
      ),
      DeliveryResult.rejected,
    );
    expect(
      await service.handle(purchase('arvore_cresce', 't3')),
      DeliveryResult.unknownProduct,
    );
    expect(await balance(), 0);
  });

  test('compra pendente ou cancelada não entrega nada', () async {
    expect(
      await service.handle(
        const StorePurchaseUpdate(
          productId: 'orvalho_300',
          status: StorePurchaseStatus.pending,
          transactionId: 't4',
        ),
      ),
      DeliveryResult.ignored,
    );
    expect(await balance(), 0);
  });

  test('fluxo pela loja falsa, ouvindo o stream', () async {
    service.start();
    final got = service.results.first;
    await store.buy('orvalho_300', consumable: true);
    final (_, r) = await got;
    expect(r, DeliveryResult.delivered);
    expect(store.completed, hasLength(1));
    expect(await balance(), 300);
  });
}
