#!/usr/bin/env bash
set -euo pipefail
if ! command -v podman >/dev/null; then echo "[ERR] podman not found"; exit 1; fi
echo "[*] Starting INSECURE Podman container (alpine) with host root bind and pid=host"
podman rm -f pma_insecure >/dev/null 2>&1 || true
podman run -d --name pma_insecure       --privileged       --pid=host       --net=host       -v /:/host       alpine sh -c 'sleep infinity'
echo "[OK] Insecure container started: pma_insecure"
echo "Now run ./02_exploit.sh"
