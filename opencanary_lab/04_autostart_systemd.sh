#!/usr/bin/env bash
set -euo pipefail

SERVICE_FILE="/etc/systemd/system/opencanary.service"
sudo tee "$SERVICE_FILE" > /dev/null <<'EOF'
[Unit]
Description=OpenCanary Honeypot
After=network.target

[Service]
User=opencanary
WorkingDirectory=/opt/opencanary
ExecStart=/opt/opencanary/venv/bin/opencanaryd --start
ExecStop=/opt/opencanary/venv/bin/opencanaryd --stop
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reexec
sudo systemctl enable --now opencanary
echo "[OK] OpenCanary service enabled and started."
