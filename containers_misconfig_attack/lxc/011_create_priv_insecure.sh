#!/usr/bin/env bash
set -euo pipefail

if ! command -v lxc-create >/dev/null; then
  echo "[ERR] lxc tools not found"; exit 1
fi

NAME="lma_priv_insecure"
echo "[*] Tworzę **uprzywilejowany** kontener z bind-mountem / hosta (ZŁA konfiguracja, tylko do labu)"

sudo lxc-destroy -n "$NAME" >/dev/null 2>&1 || true

# Utwórz z Debiana 12; jeśli nie zadziała, rzuć błąd (u Ciebie działa)
sudo lxc-create -n "$NAME" -t download -- -d debian -r bookworm -a amd64

CFG="/var/lib/lxc/${NAME}/config"

echo "[*] Patchuję konfigurację kontenera (CELOWO niebezpieczne ustawienia)"
# 1) usuń wszelkie lxc.cap.drop z templatu, bo kolidują z keep
sudo sed -i '/^lxc\.cap\.drop\b/d' "$CFG"

# 2) dopisz nasz mount i wyłącz AppArmor
sudo bash -c "cat >> '$CFG' <<'EOF'
# --- UWAGA: tylko do demonstracji podatności ---
# Bind-mount całego / hosta do /host wewnątrz kontenera.
lxc.mount.entry = / host none rbind,create=dir 0 0

# Wyłączenie AppArmor (brak izolacji MAC)
lxc.apparmor.profile = unconfined

# (Celowo NIE ustawiamy lxc.cap.keep, żeby uniknąć konfliktu z drop)
EOF"

echo "[*] Start kontenera: $NAME"
if ! sudo lxc-start -n "$NAME"; then
  echo "[!] Start nieudany, pokazuję diagnostykę:"
  sudo lxc-info -n "$NAME" || true
  sudo journalctl -n 100 --no-pager 2>/dev/null | tail -n 100 || true
  exit 1
fi

# Daj chwilę na podniesienie initu
sleep 3
sudo lxc-info -n "$NAME"

echo "[OK] Kontener uruchomiony: $NAME"
echo "Teraz uruchom ./02_exploit.sh (na maszynie LAB, nie produkcyjnej)."

