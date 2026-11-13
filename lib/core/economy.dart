import 'dart:math' as math;

import 'package:bible_garden/core/rules.dart';

/// O que a pessoa fez num dia (para a porção de orvalho).
final class DayActivity {
  const new({this.readMin = 0, this.prayMin = 0, this.devocional = false});

  final double readMin;
  final double prayMin;
  final bool devocional;
}

/// Porção diária (maná): igual para todos que comparecem. Ler mais não
/// multiplica; dia vazio dá zero, nunca negativo.
int porcaoDoDia(DayActivity day) {
  const r = Rules.porcao;
  var p = 0;
  final orou = day.prayMin >= Rules.prayerMinMinutes;
  final presenca =
      day.readMin >= Rules.readMinForPresence || orou || day.devocional;
  if (presenca) p += r.presenca;
  if (orou) p += r.oracao;
  if (day.devocional) p += r.devocional;
  return math.min(p, r.teto);
}

/// Um item da loja ("Cuidar"): só cosmético.
final class ShopItem {
  const new({
    required this.id,
    required this.preco,
    this.nome = '',
    this.tem = false,
  });

  final String id;
  final String nome;
  final int preco;
  final bool tem;
}

/// Carteira de orvalho e itens. Não contém progresso de leitura: comprar
/// nunca altera crescimento.
final class Wallet {
  const new({required this.orvalho, this.itens = const []});

  final int orvalho;
  final List<String> itens;
}

sealed class BuyResult {
  const new();
}

final class BuyOk extends BuyResult {
  const new(this.wallet);
  final Wallet wallet;
}

final class BuyFail extends BuyResult {
  const new(this.motivo);
  final String motivo;
}

BuyResult buy(Wallet w, ShopItem item) {
  if (w.itens.contains(item.id)) return const BuyFail('já tem');
  if (w.orvalho < item.preco) return const BuyFail('orvalho insuficiente');
  return BuyOk(
    Wallet(orvalho: w.orvalho - item.preco, itens: [...w.itens, item.id]),
  );
}

final class NextGoal {
  const new({
    required this.id,
    required this.nome,
    required this.preco,
    required this.falta,
    required this.pct,
  });

  final String id;
  final String nome;
  final int preco;
  final int falta;
  final double pct;
}

/// Próxima conquista: a mais cara que já dá para liberar; senão, a mais
/// barata que falta.
NextGoal? proximaConquista(int orvalho, List<ShopItem> itens) {
  final pend = itens.where((i) => !i.tem).toList()
    ..sort((a, b) => a.preco.compareTo(b.preco));
  if (pend.isEmpty) return null;
  final alc = pend.where((i) => i.preco <= orvalho).toList();
  final alvo = alc.isNotEmpty ? alc.last : pend.first;
  return NextGoal(
    id: alvo.id,
    nome: alvo.nome,
    preco: alvo.preco,
    falta: math.max(0, alvo.preco - orvalho),
    pct: math.min(1, orvalho / alvo.preco),
  );
}

/// Fase de vida dos animais do livro e do companheiro.
enum AnimalAge { filhote, jovem, adulto }

/// Os animais crescem com as porções recebidas desde que chegaram.
AnimalAge animalAgeFor(int porcoesDesdeChegada) =>
    porcoesDesdeChegada >= Rules.animalAdultAt
    ? AnimalAge.adulto
    : porcoesDesdeChegada >= Rules.animalYoungAt
    ? AnimalAge.jovem
    : AnimalAge.filhote;

/// Preço de um personagem bíblico.
int characterPrice({required bool largeProp}) =>
    largeProp ? Rules.characterPriceLargeProp : Rules.characterPrice;
