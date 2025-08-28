#!/usr/bin/env bash
# Symulacja LKM w userland: filtruje linie z konkretnym PID w outputcie ps(1)
# Użycie: . ./simulate_lkm_rootkit.sh   (kropka + spacja + plik)

set -euo pipefail

# Skąd brać PID do ukrycia:
HIDDEN_FILE="${HIDDEN_FILE:-$(dirname "${BASH_SOURCE[0]}")/hidden_pid.txt}"
export HIDDEN_FILE

# Pełna ścieżka do prawdziwego ps, żeby uniknąć rekursji:
_PS_BIN="${PS_BIN:-/bin/ps}"

ps() {
  local hid
  hid="$(cat "$HIDDEN_FILE" 2>/dev/null || true)"
  # Brak PID -> zachowuj się jak zwykły ps
  if [[ -z "${hid}" ]]; then
    exec "$_PS_BIN" "$@"
  fi
  # Filtr: zachowaj nagłówek, pomijaj wiersze zawierające PID jako osobne pole
  "$_PS_BIN" "$@" | awk -v hid="$hid" '
    NR==1 { print; next }
    {
      for (i=1; i<=NF; i++) if ($i==hid) next
      print
    }'
}

# Eksport funkcji, żeby działała także w subshellach używanych w pipeline’ach
export -f ps

echo "[INFO] Symulator aktywny. Ukrywam PID z: $HIDDEN_FILE"
echo "[TIP] Ustaw PID:    echo \$PID > '$HIDDEN_FILE'"
echo "[TIP] Wyłącz:       unset -f ps"

