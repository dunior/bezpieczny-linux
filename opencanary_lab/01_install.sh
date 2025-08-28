#!/usr/bin/env bash
set -euo pipefail

sudo dnf install -y epel-release
sudo dnf install -y python3 python3-pip git

sudo useradd -r -m -d /opt/opencanary -s /bin/bash opencanary || true

sudo -u opencanary bash -c "
cd /opt/opencanary
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install opencanary
opencanaryd --copyconfig
"
echo "[OK] Installation complete. Config in /opt/opencanary/.opencanary.conf"
