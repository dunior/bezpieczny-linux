    #!/usr/bin/env bash
    set -euo pipefail
    if ! command -v lxc-create >/dev/null; then echo "[ERR] lxc tools not found"; exit 1; fi
    NAME="lma_priv_insecure"
    echo "[*] Tworzę **uprzywilejowany** kontener z bind-mountem / hosta (ZŁA konfiguracja)"
    sudo lxc-create -n "$NAME" -t download -- -d debian -r stable -a amd64
    CFG="/var/lib/lxc/${NAME}/config"
    sudo bash -c "cat >> '$CFG' <<'EOF'
# NIEBEZPIECZNE — tylko do labu!
lxc.mount.entry = / host none rbind 0 0
lxc.apparmor.profile = unconfined
lxc.cap.keep = sys_admin sys_chroot sys_module sys_time sys_rawio
EOF"
    sudo lxc-start -n "$NAME"
    sleep 3
    echo "[OK] Kontener uruchomiony: $NAME"
    echo "Teraz uruchom ./02_exploit.sh"
