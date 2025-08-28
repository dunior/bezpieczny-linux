#!/usr/bin/env bash
set -euo pipefail
if ! command -v docker >/dev/null; then echo "[ERR] docker not found"; exit 1; fi
echo "[*] Starting SECURE Docker container (nginx)"
docker rm -f dma_insecure >/dev/null 2>&1 || true
docker rm -f dma_secure >/dev/null 2>&1 || true
 
docker run -d --name dma_secure \
  --read-only \
  --tmpfs /run:rw,noexec,nosuid,size=8m \
  --tmpfs /var/run:rw,noexec,nosuid,size=8m \
  --tmpfs /var/cache/nginx:rw,noexec,nosuid,size=64m \
  --tmpfs /var/log/nginx:rw,noexec,nosuid,size=16m \
  --pids-limit=100 \
  --cpus=0.5 \
  --memory=256m \
  --cap-drop=ALL \
  --cap-add=NET_BIND_SERVICE \
  --security-opt no-new-privileges=true \
  --security-opt apparmor=docker-default \
   alpine sh -c 'sleep infinity'

echo "[*] Validating secure container"
docker exec dma_secure sh -lc 'touch /should_fail 2>/dev/null && echo "RW" || echo "RO (OK)"'
#echo "[OK] Secure container running on http://localhost:18080"
