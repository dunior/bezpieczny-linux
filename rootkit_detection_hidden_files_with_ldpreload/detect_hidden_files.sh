#!/usr/bin/env bash
set -euo pipefail
BASE="/tmp/rk_lab_hidden"

echo "== 1) Porównanie 'ls' (oszukane) vs '/bin/ls' (prawdziwe) =="
echo "-- ls $BASE"
ls "$BASE" || true
echo "-- /bin/ls $BASE"
/bin/ls "$BASE" || true

echo
echo "== 2) 'ls -la' w katalogu bazowym (oszukane) vs prawdziwe =="
echo "-- ls -la $BASE"
ls -la "$BASE" || true
echo "-- command ls -la $BASE"
command ls -la "$BASE" || true

echo
echo "== 3) Szukanie plików ukrytych find'em =="
echo "-- find $BASE -maxdepth 2 -name '.rk' -o -name 'secret*'"
find "$BASE" -maxdepth 2 \( -name '.rk' -o -name 'secret*' \) -print 2>/dev/null || true

echo
echo "== 4) Bezpośredni 'stat' po znanej ścieżce =="
echo "-- stat $BASE/.rk/secret.bin"
stat "$BASE/.rk/secret.bin" || echo "(brak pliku?)"

echo
echo "== 5) Hash pliku (sha256sum) – działa nawet jeśli 'ls' go nie pokazuje =="
if [ -f "$BASE/.rk/secret.bin" ]; then
  sha256sum "$BASE/.rk/secret.bin" || true
else
  echo "(plik nie istnieje)"
fi

echo
echo "== 6) Przeskanuj nietypowe lokalizacje (demo) =="
for d in /dev /var/tmp /tmp; do
  echo "-- Szukam w $d katalogów zaczynających się od kropki (maxdepth=1)"
  find "$d" -maxdepth 1 -type d -name ".*" -print 2>/dev/null | head -n 10 || true
done

echo
echo "[WNIOSKI]"
echo "- Narzędzia user-space mogą ukrywać wpisy (alias/funkcja, trojanowane binaria)."
echo "- Niskopoziomowe polecenia i pełne ścieżki (np. /bin/ls, command ls) pomagają to wykryć."
echo "- 'find', 'stat', 'sha256sum' i skan nietypowych lokacji ujawniają ukryte pliki."
