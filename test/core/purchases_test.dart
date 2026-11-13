import 'package:bible_garden/core/purchases.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const adult = PurchasePolicy(
    isMinor: false,
    monthlyLimitCents: 5000,
    spentThisMonthCents: 0,
  );

  test('adulto dentro do limite pode comprar', () {
    expect(checkPurchase(adult, 990), PurchaseCheck.ok);
  });

  test('conta de menor começa bloqueada; responsável pode liberar', () {
    const minor = PurchasePolicy(
      isMinor: true,
      monthlyLimitCents: 5000,
      spentThisMonthCents: 0,
    );
    expect(checkPurchase(minor, 490), PurchaseCheck.minorBlocked);
    const ok = PurchasePolicy(
      isMinor: true,
      guardianApproved: true,
      monthlyLimitCents: 5000,
      spentThisMonthCents: 0,
    );
    expect(checkPurchase(ok, 490), PurchaseCheck.ok);
  });

  test('limite mensal respeitado', () {
    const p = PurchasePolicy(
      isMinor: false,
      monthlyLimitCents: 5000,
      spentThisMonthCents: 4500,
    );
    expect(checkPurchase(p, 490), PurchaseCheck.ok);
    expect(checkPurchase(p, 990), PurchaseCheck.overMonthlyLimit);
  });

  test('preço em reais com vírgula', () {
    expect(formatBrl(990), r'R$ 9,90');
    expect(formatBrl(1990), r'R$ 19,90');
    expect(formatBrl(5), r'R$ 0,05');
  });

  test('pacotes de orvalho: só valores fixos, nada de bônus por tempo', () {
    for (final p in orvalhoProducts) {
      expect(p.kind, ProductKind.orvalho);
      expect(p.orvalho, greaterThan(0));
      expect(p.id, startsWith('orvalho_'));
    }
    expect(packProductId('noite-estrelada'), 'pacote_noite_estrelada');
  });
}
