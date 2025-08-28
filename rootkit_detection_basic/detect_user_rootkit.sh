#!/bin/bash
# Wykrywanie rootkita user-space
echo "[INFO] Wykrywanie różnic między ps a /proc"
echo "Procesy w ps:"
ps aux | grep sleep | grep -v grep
echo "Procesy w /proc:"
PID_FILE=hidden_pid.txt
if [ -f "$PID_FILE" ]; then
  ls /proc | grep $(cat $PID_FILE) || echo "PID nie znaleziony w /proc"
else
  echo "Brak pliku z PID"
fi
