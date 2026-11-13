# Conta e sincronização (Supabase)

Opcional. Sincroniza leitura, superfície do jardim e economia entre aparelhos. **Oração, diário, pedidos, horários e ajustes nunca saem do aparelho**: não existe tabela para eles no servidor, e o app só monta o pacote com as tabelas permitidas (`lib/data/sync/sync_payload.dart`, conferido em teste).

## Ligar
1. Criar um projeto no Supabase.
2. Aplicar `supabase/migrations/20261113000000_init.sql` (`supabase db push`).
3. Publicar a função `supabase/functions/validate-receipt` e configurar os segredos (ver `docs/COMPRAS.md`).
4. Compilar o app com:
   `--dart-define=SUPABASE_URL=https://xxxx.supabase.co --dart-define=SUPABASE_ANON_KEY=...`
   Sem esses valores a sincronização fica desligada (`Env.syncEnabled`).

## Segurança
- RLS em todas as tabelas: cada pessoa só lê e escreve o que é dela.
- Amigos com amizade aceita veem só a superfície do jardim (espécie e decoração), nunca a leitura.
- Orvalho de pacote pago só entra pela função `credit_verified_purchase`, chamada pelo servidor depois de validar o recibo; o app não consegue chamá-la.
- Testes: `tool/test_rls.sh` sobe um Postgres local, aplica a migração e confere tudo isso. Roda no CI.

## O que falta para a sincronização completa
A interface de login e o "puxar do servidor" para um aparelho novo (mesclar com o banco local) ainda não têm tela; a infraestrutura (esquema, RLS, envio, validação de recibo) está pronta.
