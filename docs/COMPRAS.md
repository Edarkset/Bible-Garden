# Compras: como ligar

Comprar é sempre opcional. Tudo pode ser conseguido de graça; dinheiro nunca faz a árvore crescer nem libera personagem antes da leitura (a loja só entrega orvalho e pacotes visuais).

## Produtos (mesmos ids no Play Console e no App Store Connect)

| Id | Tipo | Entrega | Preço de referência |
| --- | --- | --- | --- |
| `orvalho_300` | consumível | 300 de orvalho | R$ 4,90 |
| `orvalho_700` | consumível | 700 de orvalho | R$ 9,90 |
| `orvalho_1500` | consumível | 1.500 de orvalho | R$ 19,90 |
| `pacote_noite_estrelada` | não consumível | pacote visual | R$ 9,90 |
| `pacote_cerrado` | não consumível | pacote visual | R$ 9,90 |
| `pacote_cascata` | não consumível | pacote visual | R$ 7,90 |
| `pacote_natal` | não consumível | pacote visual | R$ 4,90 |
| `pacote_animais_amazonia` etc. | não consumível | animais | R$ 9,90 |

O app mostra o preço real que a loja informar; os valores acima são só referência (`lib/core/purchases.dart`, `assets/data/conteudo.json`).

## Proteções já no app
- Conta de menor: compras com dinheiro bloqueadas por padrão (cadastro e Ajustes).
- Limite mensal (padrão R$ 50, ajustável em Ajustes).
- Confirmação com preço em reais antes de cada compra. Sem bônus com contagem regressiva.
- Entrega única por transação, mesmo que a loja reenvie; a loja só é avisada depois de gravar.
- Todo pacote pago também pode ser liberado com orvalho.

## Passos para publicar
1. **Google Play:** criar os produtos acima; criar uma conta de serviço com acesso à Android Publisher API.
2. **App Store:** criar os produtos; gerar a chave da App Store Server API (Issuer ID, Key ID, arquivo .p8).
3. **Validação no servidor** (recomendado antes de lançar): publicar `supabase/functions/validate-receipt` e configurar os segredos listados no topo do arquivo. Depois, trocar no app o `TrustStoreVerifier` pelo `SupabaseReceiptVerifier` (`lib/data/sync/sync_service.dart`).
4. Testar com contas de teste das duas lojas.
