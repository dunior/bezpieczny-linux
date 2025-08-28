#!/usr/bin/env bash
set -euo pipefail
NAME="lma_unpriv_secure"
echo "== Walidacja secure LXC: $NAME =="
echo "[*] Próba odczytu /host/etc/shadow (nie powinno istnieć)"
lxc-attach -n "$NAME" -- sh -lc 'head -n 1 /host/etc/shadow || echo "OK: brak dostępu / brak mountu"'
echo "[*] Sprawdzenie RW rootfs"
lxc-attach -n "$NAME" -- sh -lc 'touch /should_fail 2>/dev/null && echo "RW" || echo "RO (OK)"'
