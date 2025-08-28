#!/usr/bin/env bash
set -euo pipefail
IP=$(hostname -I | awk '{print $1}')
LOG="/opt/opencanary/opencanary.log"

echo "[*] Testing HTTP access to $IP"
curl -s http://$IP || true

echo "[*] Testing SSH access to $IP"
ssh -o StrictHostKeyChecking=no test@$IP || true

echo "[*] Recent log entries:"
tail -n 20 "$LOG" || true
