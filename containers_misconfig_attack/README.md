# Lab: containers_misconfig_attack — kontrolowane „ucieczki” z powodu złej konfiguracji + hardening

**Cel:** Uczestnik uruchamia złą konfigurację kontenera (Docker/Podman/LXC), wykonuje nadużycie (np. odczyt `/etc/shadow` hosta),
a następnie uruchamia wariant twardy (hardening) i potwierdza, że nadużycie już nie jest możliwe.

## Zawartość
- `docker/` — bind `/` + `--pid=host`, exploit (odczyt `/etc/shadow`, podgląd/ubijanie procesów hosta), hardening
- `podman/` — analogicznie do Dockera
- `lxc/` — *uprzywilejowany* kontener z bind-mountem `/` hosta (zła konfiguracja) vs kontener *nieuprzywilejowany* z cap-drop, RO, seccomp

> Używaj **tylko w środowisku labowym**. Skrypty demonstrują konsekwencje świadomie złych ustawień (bez exploitów).

## Szybki start
```bash
unzip containers_misconfig_attack.zip -d containers_misconfig_attack
cd containers_misconfig_attack

# Docker
cd docker
./01_run_insecure_bind_root.sh
./02_exploit.sh
./03_run_secure.sh

# Podman
cd ../podman
./01_run_insecure_bind_root.sh
./02_exploit.sh
./03_run_secure.sh

# LXC
cd ../lxc
./00_setup_unpriv_user.sh   # jednorazowo, może wymagać ponownego logowania
./01_create_priv_insecure.sh
./02_exploit.sh
./03_create_unpriv_secure.sh
./04_validate_secure.sh
```

## Co należy zaobserwować
- **Insecure (Docker/Podman):**
  - `cat /host/etc/shadow` działa → nadużycie
  - `--pid=host`: `ps aux` pokazuje procesy hosta; można spróbować `kill <PID>` (ostrożnie!)
- **Secure (Docker/Podman):**
  - rootfs RO, brak bindu `/`, mniej capabilities, `no-new-privileges`, nie-root
  - `touch /should_fail` → błąd (RO), brak dostępu do hosta
- **LXC:**
  - *Privileged + bind `/`* → odczyt `/host/etc/shadow`
  - *Unprivileged + cap.drop + RO + seccomp* → brak możliwości takich nadużyć
