import 'dart:async';

import 'package:bible_garden/app/providers.dart';
import 'package:bible_garden/core/economy.dart';
import 'package:bible_garden/core/purchases.dart';
import 'package:bible_garden/data/content/content.dart';
import 'package:bible_garden/features/common/orvalho_badge.dart';
import 'package:bible_garden/features/garden/garden_screen.dart';
import 'package:bible_garden/features/shop/purchase_providers.dart';
import 'package:bible_garden/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

final FutureProvider<Set<String>> ownedProvider = FutureProvider<Set<String>>((
  ref,
) {
  ref.watch(balanceProvider); // recarrega depois de cada compra
  return ref.watch(gardenRepositoryProvider).ownedItems();
});

final FutureProvider<(Set<String>, Set<String>)> charactersStateProvider =
    FutureProvider<(Set<String>, Set<String>)>((ref) async {
      ref.watch(balanceProvider);
      final repo = ref.watch(gardenRepositoryProvider);
      return (await repo.unlockedCharacters(), await repo.boughtCharacters());
    });

/// "Cuidar": tudo com orvalho; dinheiro só para pacotes e atalhos opcionais.
class ShopScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final c = ref.watch(contentProvider);
    final balance = ref.watch(balanceProvider).value ?? 0;
    final owned = ref.watch(ownedProvider).value ?? const {};
    final chars = ref.watch(charactersStateProvider).value;
    final book = ref.watch(currentBookProvider);
    final bookName = c.livro(book)?.nome ?? book;
    final theme = Theme.of(context);
    Widget section(String title, List<Widget> children) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Semantics(
            header: true,
            child: Text(title, style: theme.textTheme.titleMedium),
          ),
        ),
        ...children,
      ],
    );

    Future<void> buyOrvalho(
      String name,
      Future<BuyResult> Function() action,
      int price,
    ) async {
      final messenger = ScaffoldMessenger.of(context);
      final r = await action();
      ref
        ..invalidate(ownedProvider)
        ..invalidate(charactersStateProvider);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            r is BuyOk
                ? t.shopBought(name)
                : (r as BuyFail).motivo == 'orvalho insuficiente'
                ? t.shopNotEnough(price - balance)
                : r.motivo,
          ),
        ),
      );
    }

    final repo = ref.read(gardenRepositoryProvider);
    Widget item(
      String id,
      String name,
      int price,
      Future<BuyResult> Function() buy, {
      String? note,
    }) {
      final has = owned.contains(id);
      return ListTile(
        title: Text(name),
        subtitle: note == null ? null : Text(note),
        trailing: has
            ? Text(t.shopOwned)
            : FilledButton.tonal(
                onPressed: () => buyOrvalho(name, buy, price),
                child: Text(t.shopBuy(price)),
              ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t.shopTitle),
        actions: [Center(child: OrvalhoBadge(balance: balance))],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(t.shopIntro),
          ),
          section(t.shopUpgrades, [
            for (final m in c.melhorias)
              item(
                m.id,
                m.nome,
                m.preco,
                () => repo.buyWithOrvalho(m.id, m.preco),
                note: m.nota,
              ),
          ]),
          section(t.shopAnimals, [
            for (final a in c.animais.where((a) => a.preco != null))
              item(
                'animal:${a.id}',
                a.nome,
                a.preco!,
                () => repo.buyAnimal(a.id, a.preco!, book),
                note: t.shopArrivesIn(bookName),
              ),
          ]),
          section(t.shopDecor, [
            for (final d in c.decoracao)
              item(
                d.id,
                d.nome,
                d.preco,
                () => repo.buyWithOrvalho(d.id, d.preco),
                note: d.nota,
              ),
          ]),
          section(t.shopPlants, [
            for (final p in c.plantas.where((p) => p.preco != null).take(40))
              item(
                'planta:${p.id}',
                p.nome,
                p.preco!,
                () => repo.buyWithOrvalho('planta:${p.id}', p.preco!),
                note: p.ref,
              ),
          ]),
          section(t.shopCharacters, [
            for (final ch in c.personagens)
              if (!(c.livro(ch.livro)?.deuterocanonico ?? false))
                _CharacterTile(
                  character: ch,
                  unlocked: chars?.$1.contains(ch.id) ?? false,
                  bought: chars?.$2.contains(ch.id) ?? false,
                  onBuy: () => buyOrvalho(
                    ch.nome,
                    () => repo.buyCharacter(ch.id),
                    ch.preco,
                  ),
                ),
          ]),
          section(t.shopPacks, [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(t.shopPacksIntro),
            ),
            for (final p in c.pacotes)
              _PackTile(
                pack: p,
                owned: owned.contains('pacote:${p.id}'),
                onOrvalho: () => buyOrvalho(
                  p.nome,
                  () => repo.unlockPackWithOrvalho(p.id, p.orvalho),
                  p.orvalho,
                ),
              ),
          ]),
          section(t.shopOrvalhoPacks, [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(t.shopOrvalhoIntro),
            ),
            for (final p in orvalhoProducts)
              _MoneyTile(
                productId: p.id,
                name: t.gardenOrvalho(p.orvalho),
                referenceCents: p.referenceCents,
                consumable: true,
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () =>
                    unawaited(ref.read(storeGatewayProvider).restore()),
                child: Text(t.shopRestore),
              ),
            ),
          ]),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _CharacterTile extends StatelessWidget {
  const new({
    required this.character,
    required this.unlocked,
    required this.bought,
    required this.onBuy,
  });

  final BibleCharacter character;
  final bool unlocked;
  final bool bought;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return ListTile(
      title: Text(character.nome),
      subtitle: Text(
        unlocked ? character.gracinha : t.shopLockedRead(character.libera),
      ),
      trailing: bought
          ? Text(t.shopOwned)
          : unlocked
          ? FilledButton.tonal(
              onPressed: onBuy,
              child: Text(t.shopBuy(character.preco)),
            )
          : const Icon(Icons.lock_outline),
    );
  }
}

class _PackTile extends ConsumerWidget {
  const new({required this.pack, required this.owned, required this.onOrvalho});

  final VisualPack pack;
  final bool owned;
  final VoidCallback onOrvalho;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final trying = ref.watch(packPreviewProvider) == pack.id;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(pack.nome, style: Theme.of(context).textTheme.titleSmall),
            Text(pack.desc),
            const SizedBox(height: 8),
            if (owned)
              Text(t.shopOwned)
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      final n = ref.read(packPreviewProvider.notifier);
                      trying ? n.hide() : n.show(pack.id);
                    },
                    child: Text(trying ? t.shopTrying : t.shopTry),
                  ),
                  _MoneyButton(
                    productId: packProductId(pack.id),
                    name: pack.nome,
                    referenceCents: pack.precoReaisCentavos,
                    consumable: false,
                  ),
                  TextButton(
                    onPressed: onOrvalho,
                    child: Text(t.shopOrUseOrvalho(pack.orvalho)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _MoneyTile extends StatelessWidget {
  const new({
    required this.productId,
    required this.name,
    required this.referenceCents,
    required this.consumable,
  });

  final String productId;
  final String name;
  final int referenceCents;
  final bool consumable;

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(name),
    trailing: _MoneyButton(
      productId: productId,
      name: name,
      referenceCents: referenceCents,
      consumable: consumable,
    ),
  );
}

/// Botão de compra com dinheiro: confere menor de idade e limite mensal,
/// mostra o preço em reais e pede confirmação.
class _MoneyButton extends ConsumerWidget {
  const new({
    required this.productId,
    required this.name,
    required this.referenceCents,
    required this.consumable,
  });

  final String productId;
  final String name;
  final int referenceCents;
  final bool consumable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final prices = ref.watch(storePricesProvider).value ?? const {};
    final price = prices[productId] ?? formatBrl(referenceCents);
    return FilledButton(
      onPressed: () async {
        final messenger = ScaffoldMessenger.of(context);
        final policy = await ref.read(purchasePolicyProvider.future);
        final check = checkPurchase(policy, referenceCents);
        if (check != PurchaseCheck.ok) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                check == PurchaseCheck.minorBlocked
                    ? t.shopMinorBlocked
                    : t.shopMonthlyLimit,
              ),
            ),
          );
          return;
        }
        if (!context.mounted) return;
        final ok = await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: Text(t.shopConfirmTitle),
            content: Text(t.shopConfirmBody(name, price)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(c, false),
                child: Text(t.readCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(c, true),
                child: Text(t.readConfirm),
              ),
            ],
          ),
        );
        if (ok != true) return;
        final store = ref.read(storeGatewayProvider);
        ref.read(purchaseServiceProvider); // garante que a entrega está ouvindo
        try {
          if (!await store.available()) {
            messenger.showSnackBar(
              SnackBar(content: Text(t.shopStoreUnavailable)),
            );
            return;
          }
          await store.buy(productId, consumable: consumable);
          messenger.showSnackBar(
            SnackBar(content: Text(t.shopPurchasePending)),
          );
        } on Object {
          messenger.showSnackBar(
            SnackBar(content: Text(t.shopStoreUnavailable)),
          );
        }
      },
      child: Text(t.shopBuyMoney(price)),
    );
  }
}
