-- Testes de RLS. Rodam num Postgres local (tool/test_rls.sh) com um
-- esquema "auth" mínimo que imita o do Supabase.
\set ON_ERROR_STOP on
begin;

insert into auth.users (id) values
  ('00000000-0000-0000-0000-00000000000a'),
  ('00000000-0000-0000-0000-00000000000b'),
  ('00000000-0000-0000-0000-00000000000c');

-- Ana grava a leitura e o jardim dela.
select set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-00000000000a', true);
set local role authenticated;
insert into chapter_reads (user_id, book, chapter, first_read_at)
  values ('00000000-0000-0000-0000-00000000000a', 'GEN', 1, now());
insert into garden_surface (user_id, book, species)
  values ('00000000-0000-0000-0000-00000000000a', 'GEN', 'oliveira');
insert into friendships (user_id, friend_id)
  values ('00000000-0000-0000-0000-00000000000a', '00000000-0000-0000-0000-00000000000b');

-- Ana não consegue gravar no nome de outra pessoa.
do $$ begin
  insert into chapter_reads (user_id, book, chapter, first_read_at)
    values ('00000000-0000-0000-0000-00000000000b', 'GEN', 1, now());
  raise exception 'FALHOU: gravou leitura de outra pessoa';
exception when insufficient_privilege then null; end $$;

-- Ana não consegue se dar orvalho de "pacote" (só o servidor).
do $$ begin
  insert into orvalho_ledger (user_id, device_entry_id, at, delta, reason)
    values ('00000000-0000-0000-0000-00000000000a', 1, now(), 9999, 'pacote');
  raise exception 'FALHOU: criou orvalho de pacote pelo app';
exception when insufficient_privilege then null; end $$;

-- Ana não consegue registrar compra.
do $$ begin
  insert into store_purchases (transaction_id, user_id, product_id, platform, status)
    values ('x', '00000000-0000-0000-0000-00000000000a', 'orvalho_300', 'google_play', 'valida');
  raise exception 'FALHOU: registrou compra pelo app';
exception when insufficient_privilege then null; end $$;

-- Beto, antes de aceitar a amizade, não vê nada da Ana.
select set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-00000000000b', true);
do $$ begin
  if (select count(*) from chapter_reads) <> 0 then raise exception 'FALHOU: Beto viu leitura da Ana'; end if;
  if (select count(*) from garden_surface) <> 0 then raise exception 'FALHOU: Beto viu jardim antes da amizade'; end if;
end $$;

-- Beto aceita; agora vê só a superfície do jardim, nunca a leitura.
update friendships set status = 'aceita'
  where user_id = '00000000-0000-0000-0000-00000000000a';
do $$ begin
  if (select count(*) from garden_surface) <> 1 then raise exception 'FALHOU: Beto não vê o jardim da amiga'; end if;
  if (select count(*) from chapter_reads) <> 0 then raise exception 'FALHOU: amigo viu a leitura'; end if;
end $$;

-- Carla, que não é amiga, não vê nada.
select set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-00000000000c', true);
do $$ begin
  if (select count(*) from garden_surface) <> 0 then raise exception 'FALHOU: estranha viu o jardim'; end if;
  if (select count(*) from friendships) <> 0 then raise exception 'FALHOU: estranha viu amizade'; end if;
end $$;

-- O app não consegue chamar a função de crédito (só o servidor).
do $$ begin
  perform credit_verified_purchase('00000000-0000-0000-0000-00000000000c', 't', 'orvalho_300', 'google_play', 300);
  raise exception 'FALHOU: app chamou a função de crédito';
exception when insufficient_privilege then null; end $$;

-- O servidor credita uma vez só por transação.
reset role;
select credit_verified_purchase('00000000-0000-0000-0000-00000000000a', 'tx1', 'orvalho_300', 'google_play', 300);
select credit_verified_purchase('00000000-0000-0000-0000-00000000000a', 'tx1', 'orvalho_300', 'google_play', 300);
do $$ begin
  if (select coalesce(sum(delta),0) from orvalho_ledger where reason = 'pacote') <> 300 then
    raise exception 'FALHOU: crédito duplicado';
  end if;
end $$;

-- Não existe tabela para oração, diário ou pedidos.
do $$ begin
  if exists (select 1 from information_schema.tables where table_schema = 'public'
      and table_name ~ '(prayer|oracao|journal|diario|pedido|request)') then
    raise exception 'FALHOU: tabela de conteúdo privado no servidor';
  end if;
end $$;

select 'RLS: todos os testes passaram' as resultado;
rollback;
