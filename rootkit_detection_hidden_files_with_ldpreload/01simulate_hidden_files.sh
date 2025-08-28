#!/usr/bin/env bash
# ŁADUJ PRZEZ:  source ./01simulate_hidden_files.sh

# upewnij się, że nie ma aliasu ls
unalias ls 2>/dev/null || true

LS_BIN="${LS_BIN:-/bin/ls}"

ls() {
  local rc
  # -1 wymusza 1 wpis na linię (nawet jeśli ktoś dodał -C); nie psuje -l
  # --color=auto wyłączy kolory, bo idzie przez potok (nie TTY)
  "$LS_BIN" -1 --color=auto "$@" 2>/dev/null | \
  awk '
    # Jeśli to długie wyjście (linia zaczyna się od atrybutów pliku), nazwę bierzemy z końca,
    # a jeśli to symlink, z pola przed "->".
    function getname() {
      name=$0
      if ($1 ~ /^[-dlcbps]/) {         # długi format (ls -l)
        name=$NF
        for (i=1;i<NF;i++) if ($i=="->") { name=$(i-1); break }
      }
      return name
    }
    {
      n=getname()
      # ukryj .rk* i secret*
      if (n ~ /^\.rk/ || n ~ /^secret/) next
      print
    }'
  rc=${PIPESTATUS[0]}
  return $rc
}

export -f ls

echo "[SIM] Nadpisano funkcję 'ls' (ukrywa .rk* oraz secret*)."
echo "[SIM] Prawdziwe ls: /bin/ls lub 'command ls'. Wyłącz: 'unset -f ls'."

