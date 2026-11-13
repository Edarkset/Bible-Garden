-- Bible Garden · esquema da sincronização (M8)
--
-- Só sobe o que a pessoa escolhe sincronizar: leitura, jardim visível e
-- economia. Oração, diário, pedidos e horários NUNCA vêm para o servidor:
-- não existe tabela para eles.
--
-- Toda tabela tem RLS: cada pessoa só lê e escreve o que é dela. Amigos
-- veem só a superfície do jardim (copa e decoração).

create extension if not exists pgcrypto;

-- Perfil -------------------------------------------------------------------
create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  garden_name text check (char_length(garden_name) <= 40),
  canon smallint not null default 66 check (canon in (66, 73)),
  is_minor boolean not null default false,
  created_at timestamptz not null default now()
);

-- Leitura (capítulos validados) --------------------------------------------
create table public.chapter_reads (
  user_id uuid not null references auth.users (id) on delete cascade,
  book char(3) not null,
  chapter smallint not null check (chapter between 1 and 150),
  first_read_at timestamptz not null,
  times_read smallint not null default 1 check (times_read >= 1),
  updated_at timestamptz not null default now(),
  primary key (user_id, book, chapter)
);

-- Superfície do jardim (o que amigos podem ver) ----------------------------
create table public.garden_surface (
  user_id uuid not null references auth.users (id) on delete cascade,
  book char(3) not null,
  species text,
  placements jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (user_id, book)
);

-- Economia -----------------------------------------------------------------
create table public.owned_items (
  user_id uuid not null references auth.users (id) on delete cascade,
  item_id text not null,
  source text not null check (source in ('orvalho', 'gratis', 'pacote')),
  acquired_at timestamptz not null,
  primary key (user_id, item_id)
);

-- Livro-caixa de orvalho: só cresce (nada é apagado ou alterado).
create table public.orvalho_ledger (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  device_entry_id bigint not null,
  at timestamptz not null,
  delta integer not null,
  reason text not null,
  ref text,
  unique (user_id, device_entry_id)
);

-- Compras validadas no servidor (só a Edge Function escreve aqui).
create table public.store_purchases (
  transaction_id text primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  product_id text not null,
  platform text not null check (platform in ('google_play', 'app_store')),
  status text not null check (status in ('valida', 'reembolsada')),
  verified_at timestamptz not null default now()
);

-- Amizades (visita ao jardim) ----------------------------------------------
create table public.friendships (
  user_id uuid not null references auth.users (id) on delete cascade,
  friend_id uuid not null references auth.users (id) on delete cascade,
  status text not null default 'pendente'
    check (status in ('pendente', 'aceita')),
  created_at timestamptz not null default now(),
  primary key (user_id, friend_id),
  check (user_id <> friend_id)
);

-- RLS ----------------------------------------------------------------------
alter table public.profiles enable row level security;
alter table public.chapter_reads enable row level security;
alter table public.garden_surface enable row level security;
alter table public.owned_items enable row level security;
alter table public.orvalho_ledger enable row level security;
alter table public.store_purchases enable row level security;
alter table public.friendships enable row level security;

create policy "perfil: dono" on public.profiles
  for all to authenticated
  using (id = auth.uid()) with check (id = auth.uid());

create policy "leitura: dono" on public.chapter_reads
  for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy "jardim: dono" on public.garden_surface
  for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

-- Amigos (amizade aceita nos dois sentidos) só leem a superfície.
create policy "jardim: amigos leem" on public.garden_surface
  for select to authenticated
  using (
    exists (
      select 1 from public.friendships f
      where f.status = 'aceita'
        and ((f.user_id = auth.uid() and f.friend_id = garden_surface.user_id)
          or (f.friend_id = auth.uid() and f.user_id = garden_surface.user_id))
    )
  );

create policy "itens: dono" on public.owned_items
  for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

-- Livro-caixa: dono lê e acrescenta; nunca altera nem apaga.
create policy "orvalho: dono lê" on public.orvalho_ledger
  for select to authenticated using (user_id = auth.uid());
create policy "orvalho: dono acrescenta" on public.orvalho_ledger
  for insert to authenticated
  with check (user_id = auth.uid() and reason <> 'pacote');

-- Compras: dono só lê. Quem grava é a Edge Function (service_role).
create policy "compras: dono lê" on public.store_purchases
  for select to authenticated using (user_id = auth.uid());

create policy "amizade: participantes leem" on public.friendships
  for select to authenticated
  using (user_id = auth.uid() or friend_id = auth.uid());
create policy "amizade: pedir" on public.friendships
  for insert to authenticated
  with check (user_id = auth.uid() and status = 'pendente');
create policy "amizade: aceitar" on public.friendships
  for update to authenticated
  using (friend_id = auth.uid()) with check (friend_id = auth.uid());
create policy "amizade: desfazer" on public.friendships
  for delete to authenticated
  using (user_id = auth.uid() or friend_id = auth.uid());

-- Pacotes de orvalho comprados só entram pelo servidor, depois de validar.
create function public.credit_verified_purchase(
  p_user uuid, p_tx text, p_product text, p_platform text, p_amount integer
) returns void
language plpgsql security definer set search_path = public as $$
begin
  insert into store_purchases (transaction_id, user_id, product_id, platform, status)
  values (p_tx, p_user, p_product, p_platform, 'valida')
  on conflict (transaction_id) do nothing;
  if found and p_amount > 0 then
    insert into orvalho_ledger (user_id, device_entry_id, at, delta, reason, ref)
    values (p_user, -abs(hashtext(p_tx)), now(), p_amount, 'pacote', p_tx);
  end if;
end $$;
revoke all on function public.credit_verified_purchase from public, anon, authenticated;
