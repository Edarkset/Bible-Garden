import 'dart:async';

/// Produto como a loja do celular informa (preço já localizado).
final class StoreProduct {
  const new({required this.id, required this.price, required this.rawPrice});

  final String id;

  /// Preço formatado pela loja (ex.: "R$ 9,90").
  final String price;
  final double rawPrice;
}

enum StorePurchaseStatus { pending, purchased, restored, canceled, error }

/// Uma atualização de compra vinda da loja.
final class StorePurchaseUpdate {
  const new({
    required this.productId,
    required this.status,
    this.transactionId,
    this.verificationData,
    this.source,
    this.complete,
  });

  final String productId;
  final StorePurchaseStatus status;
  final String? transactionId;

  /// Recibo para validar no servidor.
  final String? verificationData;

  /// 'google_play' ou 'app_store'.
  final String? source;

  /// Avisa a loja que a entrega foi feita (obrigatório).
  final Future<void> Function()? complete;
}

/// Ponte com a loja do celular. Implementações: `InAppPurchaseGateway`
/// (Google Play e App Store) e [FakeStoreGateway] (testes e versão mod).
abstract interface class StoreGateway {
  Future<bool> available();
  Future<List<StoreProduct>> products(Set<String> ids);
  Future<void> buy(String productId, {required bool consumable});
  Future<void> restore();
  Stream<StorePurchaseUpdate> get updates;
}

/// Loja falsa: compra na hora, sem cobrar. Só para testes e versão mod.
final class FakeStoreGateway implements StoreGateway {
  new({this.isAvailable = true});

  final bool isAvailable;
  final StreamController<StorePurchaseUpdate> _ctrl =
      StreamController.broadcast();
  int _n = 0;
  final List<String> completed = [];

  @override
  Future<bool> available() async => isAvailable;

  @override
  Future<List<StoreProduct>> products(Set<String> ids) async => [
    for (final id in ids) StoreProduct(id: id, price: r'R$ 0,00', rawPrice: 0),
  ];

  @override
  Future<void> buy(String productId, {required bool consumable}) async {
    final tx = 'fake-${++_n}';
    _ctrl.add(
      StorePurchaseUpdate(
        productId: productId,
        status: StorePurchaseStatus.purchased,
        transactionId: tx,
        verificationData: 'fake',
        source: 'fake',
        complete: () async => completed.add(tx),
      ),
    );
  }

  /// Simula a loja reenviando a mesma compra (acontece de verdade).
  void redeliver(String productId, String tx) => _ctrl.add(
    StorePurchaseUpdate(
      productId: productId,
      status: StorePurchaseStatus.purchased,
      transactionId: tx,
      verificationData: 'fake',
      source: 'fake',
      complete: () async => completed.add(tx),
    ),
  );

  @override
  Future<void> restore() async {}

  @override
  Stream<StorePurchaseUpdate> get updates => _ctrl.stream;
}
