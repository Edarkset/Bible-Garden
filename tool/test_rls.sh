#!/usr/bin/env bash
# Sobe um Postgres temporário, aplica a migração e roda os testes de RLS.
# Uso: tool/test_rls.sh   (precisa de initdb/pg_ctl/psql do PostgreSQL 15+)
set -euo pipefail
BIN="${PG_BIN:-$(ls -d /usr/lib/postgresql/*/bin 2>/dev/null | sort -V | tail -1)}"
export PATH="$BIN:$PATH"
DIR="$(mktemp -d)"
PORT="${PG_PORT:-55432}"
cleanup() { pg_ctl -D "$DIR/data" -m immediate stop >/dev/null 2>&1 || true; rm -rf "$DIR"; }
trap cleanup EXIT
RUN=""
if [ "$(id -u)" = "0" ]; then
  id bgtest >/dev/null 2>&1 || useradd -M bgtest
  chown -R bgtest "$DIR"
  RUN="runuser -u bgtest --"
fi
$RUN initdb -D "$DIR/data" -A trust -U postgres >/dev/null
$RUN pg_ctl -D "$DIR/data" -o "-p $PORT -k $DIR -c listen_addresses=''" -w start >/dev/null
PSQL=(psql -h "$DIR" -p "$PORT" -U postgres -v ON_ERROR_STOP=1 -q)
"${PSQL[@]}" -c 'create database bg;'
"${PSQL[@]}" -d bg -f supabase/tests/auth_stub.sql
"${PSQL[@]}" -d bg -f supabase/migrations/20261113000000_init.sql
"${PSQL[@]}" -d bg -f supabase/tests/rls_test.sql
