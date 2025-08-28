#!/usr/bin/env bash
set -euo pipefail
BASE="/tmp/rk_lab_hidden"
rm -rf "$BASE"
# Przywróć prawdziwe ls w bieżącej powłoce: od-aliowanie
unalias ls 2>/dev/null || true
unset -f ls 2>/dev/null || true
echo "[OK] Posprzątane. Jeśli ładowałeś symulator przez 'source', otwórz nową powłokę lub wywołaj 'unset -f ls'."
