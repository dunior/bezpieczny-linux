#!/usr/bin/env bash
set -euo pipefail
# Tworzymy „ukryte” lokalizacje i pliki testowe
BASE="/tmp/rk_lab_hidden"
mkdir -p "$BASE/.rk" "$BASE/visible"
dd if=/dev/urandom of="$BASE/.rk/secret.bin" bs=1K count=1 status=none
echo "top secret" > "$BASE/secret.txt"
echo "hello" > "$BASE/visible/readme.txt"

echo "[OK] Utworzono katalog testowy: $BASE"
echo "    - $BASE/.rk/secret.bin"
echo "    - $BASE/secret.txt"
echo "    - $BASE/visible/readme.txt"
