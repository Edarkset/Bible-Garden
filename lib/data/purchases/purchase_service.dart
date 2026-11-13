import 'dart:async';

import 'package:bible_garden/core/purchases.dart';
import 'package:bible_garden/data/db/app_database.dart';
import 'package:bible_garden/data/purchases/store_gateway.dart';
import 'package:drift/drift.dart';

/// Confere o recibo antes de entregar. Em produção deve chamar o servidor
/// (Edge Function `validate-receipt`, ver supabase/functions). Sem servidor
/// configurado, confia na loja do celular (que já assina a compra).
abstract interface class ReceiptVerifier {
  Future<bool> verify(StorePurchaseUpdate purchase);
}

final class TrustStoreVerifier implements ReceiptVerifier {
  const new();

  @override
  Future<bool> verify(StorePurchaseUpdate purchase) async =>
      purchase.transactionId != null;
}

enum DeliveryResult { delivered, duplicate, rejected, unknownProduct, ignored }

/// Recebe as compras da loja e entrega uma única vez por transação:
/// orvalho entra no livro-caixa; pacote vira item da pessoa.
final class PurchaseService {
  new({
    required this.db,
    required this.store,
    this.verifier = const TrustStoreVerifier(),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final AppDatabase db;
  final StoreGateway store;
  final ReceiptVerifier verifier;
  final DateTime Function() _clock;
  StreamSubscription<StorePurchaseUpdate>? _sub;
  final StreamController<(StorePurchaseUpdate, DeliveryResult)> _results =
      StreamController.broadcast();

  /// Resultado de cada entrega (para a tela avisar a pessoa).
  Stream<(StorePurchaseUpdate, DeliveryResult)> get results => _results.stream;

  void start() {
    _sub ??= store.updates.listen((u) async {
      final r = await handle(u);
      _results.add((u, r));
    });
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    await _results.close();
  }

  StoreProductInfo? productInfo(String productId) {
    for (final p in orvalhoProducts) {
      if (p.id == productId) return p;
    }
    if (productId.startsWith('pacote_')) {
      return StoreProductInfo(
        id: productId,
        kind: ProductKind.pacote,
        referenceCents: 0,
        packId: productId.substring(7).replaceAll('_', '-'),
      );
    }
    return null;
  }

  /// Quanto já foi gasto neste mês (para o limite mensal).
  Future<int> spentThisMonthCents() async {
    final now = _clock();
    final from = DateTime(now.year, now.month);
    final rows =
        await (db.select(db.storePurchases)
              ..where((t) => t.at.isBiggerOrEqualValue(from))
              ..where((t) => t.status.equals('entregue')))
            .get();
    return rows.fold<int>(0, (a, r) => a + r.priceCents);
  }

  Future<DeliveryResult> handle(StorePurchaseUpdate u) async {
    if (u.status != StorePurchaseStatus.purchased &&
        u.status != StorePurchaseStatus.restored) {
      if (u.status == StorePurchaseStatus.error ||
          u.status == StorePurchaseStatus.canceled) {
        await u.complete?.call();
      }
      return DeliveryResult.ignored;
    }
    final tx = u.transactionId;
    if (tx == null || !await verifier.verify(u)) {
      return DeliveryResult.rejected;
    }
    final info = productInfo(u.productId);
    if (info == null) return DeliveryResult.unknownProduct;
    final result = await db.transaction(() async {
      final seen = await (db.select(
        db.storePurchases,
      )..where((t) => t.transactionId.equals(tx))).getSingleOrNull();
      if (seen != null) return DeliveryResult.duplicate;
      final at = _clock();
      await db
          .into(db.storePurchases)
          .insert(
            StorePurchasesCompanion.insert(
              transactionId: tx,
              productId: u.productId,
              priceCents: info.referenceCents,
              currency: 'BRL',
              at: at,
              status: 'entregue',
            ),
          );
      if (info.kind == ProductKind.orvalho) {
        await db
            .into(db.orvalhoLedger)
            .insert(
              OrvalhoLedgerCompanion.insert(
                at: at,
                delta: info.orvalho,
                reason: 'pacote',
                ref: Value(tx),
              ),
            );
      } else {
        await db
            .into(db.ownedItems)
            .insert(
              OwnedItemsCompanion.insert(
                itemId: 'pacote:${info.packId}',
                acquiredAt: at,
                source: 'pacote',
              ),
              mode: InsertMode.insertOrIgnore,
            );
      }
      return DeliveryResult.delivered;
    });
    // Só confirma à loja depois de gravar (se o app fechar no meio, a loja
    // reenvia e a transação não é entregue duas vezes).
    await u.complete?.call();
    return result;
  }
}
