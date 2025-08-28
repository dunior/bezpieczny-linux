    #!/usr/bin/env bash
    set -euo pipefail
    NAME="lma_unpriv_secure"
    echo "[*] Tworzę **nieuprzywilejowany** LXC (bezpieczniej)"
    lxc-create -n "$NAME" -t download -- -d debian -r stable -a amd64
    CFG="${HOME}/.local/share/lxc/${NAME}/config"
    cat >> "$CFG" <<'EOF'
# Hardening
lxc.cap.drop = sys_admin sys_module mac_admin mac_override sys_time sys_rawio sys_boot
lxc.mount.auto = proc:mixed sys:ro cgroup:ro
lxc.apparmor.profile = lxc-container-default
lxc.rootfs.options = ro
lxc.readonly = 1
lxc.seccomp.profile = /usr/share/lxc/config/common.seccomp
EOF
    lxc-start -n "$NAME"
    sleep 3
    echo "[OK] Unpriv container: $NAME started."
