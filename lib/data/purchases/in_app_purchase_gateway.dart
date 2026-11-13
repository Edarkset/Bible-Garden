import 'package:bible_garden/data/purchases/store_gateway.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// Google Play e App Store pelo plugin oficial `in_app_purchase`.
///
/// Os produtos precisam existir no Play Console e no App Store Connect com
/// os mesmos ids (ver docs/COMPRAS.md).
final class InAppPurchaseGateway implements StoreGateway {
  new({InAppPurchase? iap}) : _iap = iap ?? InAppPurchase.instance;

  final InAppPurchase _iap;
  final Map<String, ProductDetails> _details = {};

  @override
  Future<bool> available() => _iap.isAvailable();

  @override
  Future<List<StoreProduct>> products(Set<String> ids) async {
    final r = await _iap.queryProductDetails(ids);
    for (final d in r.productDetails) {
      _details[d.id] = d;
    }
    return [
      for (final d in r.productDetails)
        StoreProduct(id: d.id, price: d.price, rawPrice: d.rawPrice),
    ];
  }

  @override
  Future<void> buy(String productId, {required bool consumable}) async {
    var d = _details[productId];
    if (d == null) {
      await products({productId});
      d = _details[productId];
    }
    if (d == null) throw StateError('Produto $productId não encontrado.');
    final param = PurchaseParam(productDetails: d);
    if (consumable) {
      await _iap.buyConsumable(purchaseParam: param);
    } else {
      await _iap.buyNonConsumable(purchaseParam: param);
    }
  }

  @override
  Future<void> restore() => _iap.restorePurchases();

  @override
  Stream<StorePurchaseUpdate> get updates => _iap.purchaseStream.expand(
    (list) => [
      for (final p in list)
        StorePurchaseUpdate(
          productId: p.productID,
          status: switch (p.status) {
            PurchaseStatus.pending => StorePurchaseStatus.pending,
            PurchaseStatus.purchased => StorePurchaseStatus.purchased,
            PurchaseStatus.restored => StorePurchaseStatus.restored,
            PurchaseStatus.canceled => StorePurchaseStatus.canceled,
            PurchaseStatus.error => StorePurchaseStatus.error,
          },
          transactionId: p.purchaseID,
          verificationData: p.verificationData.serverVerificationData,
          source: p.verificationData.source,
          complete: p.pendingCompletePurchase
              ? () => _iap.completePurchase(p)
              : null,
        ),
    ],
  );
}
