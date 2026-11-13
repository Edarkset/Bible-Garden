/// Regras de compra com dinheiro (orvalho e pacotes visuais).
///
/// Comprar é sempre opcional: tudo pode ser conseguido de graça. Dinheiro
/// nunca faz árvore crescer nem libera personagem antes da leitura (essas
/// regras nem passam por aqui: a loja só entrega orvalho e itens visuais).
library;

enum ProductKind { orvalho, pacote }

/// Produto vendido nas lojas (Google Play e App Store).
final class StoreProductInfo {
  const new({
    required this.id,
    required this.kind,
    required this.referenceCents,
    this.orvalho = 0,
    this.packId,
  });

  /// Id igual nas duas lojas.
  final String id;
  final ProductKind kind;

  /// Preço de referência em centavos de real (a loja mostra o preço real).
  final int referenceCents;

  /// Quanto orvalho entrega (pacotes de orvalho).
  final int orvalho;

  /// Pacote visual que libera.
  final String? packId;
}

/// Pacotes de orvalho. Sem bônus por tempo limitado, sem contagem
/// regressiva, preço sempre em reais ao lado.
const List<StoreProductInfo> orvalhoProducts = [
  StoreProductInfo(
    id: 'orvalho_300',
    kind: ProductKind.orvalho,
    referenceCents: 490,
    orvalho: 300,
  ),
  StoreProductInfo(
    id: 'orvalho_700',
    kind: ProductKind.orvalho,
    referenceCents: 990,
    orvalho: 700,
  ),
  StoreProductInfo(
    id: 'orvalho_1500',
    kind: ProductKind.orvalho,
    referenceCents: 1990,
    orvalho: 1500,
  ),
];

/// Id na loja de um pacote visual.
String packProductId(String packId) => 'pacote_${packId.replaceAll('-', '_')}';

/// Configuração de proteção da conta.
final class PurchasePolicy {
  const new({
    required this.isMinor,
    required this.monthlyLimitCents,
    required this.spentThisMonthCents,
    this.guardianApproved = false,
  });

  /// Contas de menor começam com compras bloqueadas.
  final bool isMinor;

  /// Um responsável liberou as compras desta conta de menor.
  final bool guardianApproved;
  final int monthlyLimitCents;
  final int spentThisMonthCents;

  /// Limite padrão: R$ 50 por mês (configurável em Ajustes).
  static const int defaultMonthlyLimitCents = 5000;
}

enum PurchaseCheck { ok, minorBlocked, overMonthlyLimit }

PurchaseCheck checkPurchase(PurchasePolicy p, int priceCents) {
  if (p.isMinor && !p.guardianApproved) return PurchaseCheck.minorBlocked;
  if (p.spentThisMonthCents + priceCents > p.monthlyLimitCents) {
    return PurchaseCheck.overMonthlyLimit;
  }
  return PurchaseCheck.ok;
}

/// "R$ 9,90".
String formatBrl(int cents) {
  final r = cents ~/ 100;
  final c = (cents % 100).toString().padLeft(2, '0');
  return 'R\$ $r,$c';
}
