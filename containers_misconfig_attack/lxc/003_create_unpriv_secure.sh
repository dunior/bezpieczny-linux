#!/usr/bin/env bash
set -euo pipefail

NAME="lma_unpriv_secure"

# 0) Ten skrypt ma być uruchomiony jako zwykły użytkownik (UNPRIV)
if [ "${EUID:-$(id -u)}" -eq 0 ]; then
  echo "[ERR] Uruchom jako zwykły użytkownik (nie root). Unpriv LXC musi działać per-user."
  exit 1
fi

need() { command -v "$1" >/dev/null 2>&1 || { echo "[ERR] Brak polecenia: $1"; exit 1; }; }

need lxc-create
need lxc-start
need lxc-ls

echo "[*] Sprawdzam subuid/subgid dla $(whoami)"
if ! grep -q "^$(whoami):" /etc/subuid || ! grep -q "^$(whoami):" /etc/subgid; then
  cat <<EOF
[ERR] Brak zakresów subuid/subgid. Jako root wykonaj raz:
  sudo usermod -v 100000-165536 -w 100000-165536 $(whoami)
(Albo inny niekolidujący zakres). Potem wyloguj/zaloguj się ponownie.
EOF
  exit 1
fi

# 1) Usuń ewentualny stary kontener o tej nazwie
if lxc-ls -1 | grep -qx "$NAME"; then
  echo "[i] Usuwam istniejący kontener $NAME"
  lxc-stop -n "$NAME" 2>/dev/null || true
  lxc-destroy -n "$NAME"
fi

# 2) Spróbuj pobrać obraz (Debian bookworm -> Ubuntu noble)
create_try() {
  local dist="$1" rel="$2" arch="$3"
  echo "[*] Tworzę kontener: ${dist} ${rel} ${arch}"
  lxc-create -n "$NAME" -t download -- -d "$dist" -r "$rel" -a "$arch"
}
if ! create_try debian bookworm amd64; then
  echo "[i] Fallback: Ubuntu noble"
  create_try ubuntu noble amd64
fi

CFG="${HOME}/.local/share/lxc/${NAME}/config"

# 3) Hardening config (dla UNPRIV, bez AppArmor=unconfined!)
echo "[*] Aktualizuję konfigurację: $CFG"
# Usuń ewentualne stare linie, by uniknąć duplikatów
sed -i '/^lxc\.cap\.drop\b/d;
        /^lxc\.mount\.auto\b/d;
        /^lxc\.apparmor\.profile\b/d;
        /^lxc\.rootfs\.options\b/d;
        /^lxc\.readonly\b/d;
        /^lxc\.seccomp\.profile\b/d;
        /^lxc\.mount\.entry\b/d' "$CFG" || true

cat >> "$CFG" <<'EOF'
# --- Hardening (UNPRIV) ---
# Minimalizacja capabilities
lxc.cap.drop = sys_admin sys_module mac_admin mac_override sys_time sys_rawio sys_boot

# Automatyczne bezpieczne mounty
lxc.mount.auto = proc:mixed sys:ro cgroup:ro

# Domyślny profil AppArmor LXC
lxc.apparmor.profile = lxc-container-default

# Rootfs tylko do odczytu
lxc.rootfs.options = ro
lxc.readonly = 1

# Seccomp – wspólny profil
lxc.seccomp.profile = /usr/share/lxc/config/common.seccomp

# Miejsca do zapisu jako tmpfs (w read-only rootfs trzeba zapewnić /run i /tmp)
lxc.mount.entry = tmpfs run tmpfs rw,create=dir,mode=755 0 0
lxc.mount.entry = tmpfs tmp tmpfs rw,create=dir,mode=1777 0 0
EOF

# 4) Start + prosta diagnostyka
echo "[*] Start kontenera: $NAME"
if ! lxc-start -n "$NAME"; then
  echo "[!] Start nieudany. Próba z logiem w pierwszym planie:"
  lxc-start -n "$NAME" -F -l DEBUG -o /tmp/${NAME}.log || true
  echo "[!] Zajrzyj do /tmp/${NAME}.log"
  exit 1
fi

# Daj initowi chwilę
sleep 3

state="$(lxc-info -n "$NAME" -sH || true)"
echo "[*] Stan: $state"
if [ "$state" != "RUNNING" ]; then
  echo "[!] Kontener nie jest RUNNING. Log debug w /tmp/${NAME}.log:"
  lxc-start -n "$NAME" -F -l DEBUG -o /tmp/${NAME}.log || true
  exit 1
fi

echo "[OK] Unpriv container: $NAME started."
echo "INFO: Wejście do środka:   lxc-attach -n $NAME"

