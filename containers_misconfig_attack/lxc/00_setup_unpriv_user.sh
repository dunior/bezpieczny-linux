#!/usr/bin/env bash
set -euo pipefail
USERNAME="${SUDO_USER:-$USER}"
echo "[*] Konfiguruję subuid/subgid dla nieuprzywilejowanego LXC (jeśli brak)"
if ! grep -q "^$USERNAME:" /etc/subuid; then echo "$USERNAME:100000:65536" | sudo tee -a /etc/subuid; fi
if ! grep -q "^$USERNAME:" /etc/subgid; then echo "$USERNAME:100000:65536" | sudo tee -a /etc/subgid; fi
echo "[OK] subuid/subgid ustawione. Wyloguj i zaloguj się ponownie, jeśli to pierwsza konfiguracja."
