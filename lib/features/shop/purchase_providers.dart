import 'dart:async';

import 'package:bible_garden/app/flavor.dart';
import 'package:bible_garden/app/providers.dart';
import 'package:bible_garden/core/purchases.dart';
import 'package:bible_garden/data/purchases/in_app_purchase_gateway.dart';
import 'package:bible_garden/data/purchases/purchase_service.dart';
import 'package:bible_garden/data/purchases/store_gateway.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Loja do celular. Na versão mod, uma loja falsa que não cobra.
/// No navegador não há loja de celular: a compra com dinheiro aparece como
/// indisponível (o orvalho continua funcionando).
final Provider<StoreGateway> storeGatewayProvider = Provider<StoreGateway>(
  (ref) => isDev
      ? FakeStoreGateway()
      : kIsWeb
      ? FakeStoreGateway(isAvailable: false)
      : InAppPurchaseGateway(),
);

final Provider<PurchaseService> purchaseServiceProvider =
    Provider<PurchaseService>((ref) {
      final s = PurchaseService(
        db: ref.watch(databaseProvider),
        store: ref.watch(storeGatewayProvider),
        clock: ref.watch(clockProvider),
      )..start();
      ref.onDispose(() => unawaited(s.dispose()));
      return s;
    });

/// Proteção da conta (menor de idade e limite mensal).
final FutureProvider<PurchasePolicy> purchasePolicyProvider =
    FutureProvider<PurchasePolicy>((ref) async {
      String? v(String k) => ref.watch(settingProvider(k)).value;
      final service = ref.watch(purchaseServiceProvider);
      return PurchasePolicy(
        isMinor: v('compras.menor') == '1',
        guardianApproved: v('compras.responsavel') == '1',
        monthlyLimitCents:
            int.tryParse(v('compras.limite') ?? '') ??
            PurchasePolicy.defaultMonthlyLimitCents,
        spentThisMonthCents: await service.spentThisMonthCents(),
      );
    });

/// Preços reais da loja (localizados), quando ela estiver disponível.
final FutureProvider<Map<String, String>> storePricesProvider =
    FutureProvider<Map<String, String>>((ref) async {
      final store = ref.watch(storeGatewayProvider);
      final content = ref.watch(contentProvider);
      try {
        if (!await store.available()) return const {};
        final ids = {
          for (final p in orvalhoProducts) p.id,
          for (final p in content.pacotes) packProductId(p.id),
        };
        return {for (final p in await store.products(ids)) p.id: p.price};
      } on Object {
        return const {};
      }
    });

/// Pacote em teste no provador (só aparência, só agora).
final class PackPreview extends Notifier<String?> {
  @override
  String? build() => null;

  void show(String packId) {
    if (state != packId) state = packId;
  }

  void hide() {
    state = null;
  }
}

final NotifierProvider<PackPreview, String?> packPreviewProvider =
    NotifierProvider<PackPreview, String?>(PackPreview.new);
