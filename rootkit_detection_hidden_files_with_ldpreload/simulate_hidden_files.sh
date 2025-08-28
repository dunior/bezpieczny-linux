#!/usr/bin/env bash
# UWAGA: ZAŁADUJ PRZEZ `source`, żeby alias/funkcje działały w twojej powłoce:
#   source ./simulate_hidden_files.sh

# Funkcja ls, która pomija nazwy zawierające '.rk' lub zaczynające się od 'secret'
ls() {
  # Prawdziwe ls
  /bin/ls --color=auto "$@" 2>/dev/null | grep -vE '(^|/)\.rk(/|$)|(^|/)(secret[^/]*)(/|$)'
}

echo "[SIM] Funkcja 'ls' została nadpisana w tej powłoce (ukrywa .rk oraz secret*)."
echo "[SIM] Użyj '/bin/ls' lub 'command ls' aby zobaczyć prawdziwą listę."
