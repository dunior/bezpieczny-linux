#!/bin/bash
# Symulacja działania rootkita LKM – filtr w ps
alias ps='ps --no-headers -eo pid,cmd | grep -v $(cat hidden_pid.txt 2>/dev/null)'

echo "[INFO] Symulator LKM rootkit uruchomiony."
echo "Alias 'ps' ukrywa proces o PID zapisanym w hidden_pid.txt."
