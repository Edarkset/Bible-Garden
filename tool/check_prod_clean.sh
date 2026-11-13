#!/usr/bin/env bash
# Confere se o código da versão mod ficou fora do APK prod e dentro do dev.
# Uso: tool/check_prod_clean.sh <apk-prod> <apk-dev>
set -euo pipefail
MARKER="BG_FERRAMENTAS_MOD_7f3a"
check() {
  local apk="$1" dir
  dir="$(mktemp -d)"
  unzip -q -o "$apk" 'lib/arm64-v8a/libapp.so' -d "$dir"
  if grep -aq "$MARKER" "$dir/lib/arm64-v8a/libapp.so"; then echo yes; else echo no; fi
  rm -rf "$dir"
}
prod="$(check "$1")"
dev="$(check "$2")"
echo "marca da versão mod: prod=$prod dev=$dev"
if [[ "$dev" != "yes" ]]; then
  echo "ERRO: a marca não está no APK dev; a verificação não está valendo." >&2
  exit 1
fi
if [[ "$prod" != "no" ]]; then
  echo "ERRO: código da versão mod vazou para o APK prod." >&2
  exit 1
fi
echo "OK: o APK prod não tem o código da versão mod."
