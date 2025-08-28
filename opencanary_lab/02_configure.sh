#!/usr/bin/env bash
set -euo pipefail

CONFIG="/opt/opencanary/.opencanary.conf"
sudo -u opencanary cp "$CONFIG" "${CONFIG}.bak"

# Simple jq replacement: sed edit
sudo -u opencanary sed -i 's/"ssh.enabled": false/"ssh.enabled": true/' "$CONFIG"
sudo -u opencanary sed -i 's/"http.enabled": false/"http.enabled": true/' "$CONFIG"
echo "[OK] Enabled SSH and HTTP in OpenCanary config."
