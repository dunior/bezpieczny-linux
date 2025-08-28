#!/usr/bin/env bash
set -euo pipefail
if ! command -v podman >/dev/null; then echo "[ERR] podman not found"; exit 1; fi
echo "[*] Starting SECURE Podman container (nginx) (rootless if possible)"
podman rm -f pma_secure >/dev/null 2>&1 || true
podman rm -f pma_insecure >/dev/null 2>&1 || true

podman run -d --name pma_secure  --read-only  --pids-limit=100  --memory=256m  --cpus=0.5   --cap-drop=ALL  --security-opt no-new-privileges -u 65534:65534   alpine sh -c 'sleep infinity'
echo "[*] Validating secure container"
podman exec pma_secure sh -lc 'touch /should_fail 2>/dev/null && echo "RW" || echo "RO (OK)"'

