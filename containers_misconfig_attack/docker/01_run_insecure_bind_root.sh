#!/usr/bin/env bash
set -euo pipefail
if ! command -v docker >/dev/null; then echo "[ERR] docker not found"; exit 1; fi
echo "[*] Starting INSECURE Docker container (alpine) with host root bind and pid=host"
docker rm -f dma_insecure >/dev/null 2>&1 || true
docker run -d --name dma_insecure       --privileged       --pid=host       --network host       -v /:/host       alpine sh -c 'sleep infinity'
echo "[OK] Insecure container started: dma_insecure"
echo "Now run ./02_exploit.sh"
