#!/bin/bash
# Symulacja rootkita w user-space przez alias ps
alias ps='ps --no-headers -eo pid,cmd | grep -v $(cat hidden_pid.txt 2>/dev/null)'

echo "[INFO] Symulator user-space rootkit uruchomiony."
echo "Alias 'ps' ukrywa proces o PID zapisanym w hidden_pid.txt."
