#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="/opt/stream-server"

sudo mkdir -p "$INSTALL_DIR"
sudo cp -a . "$INSTALL_DIR"
sudo chmod +x "$INSTALL_DIR"/scripts/*.sh
sudo ln -sf "$INSTALL_DIR/scripts/stream.sh" /usr/local/bin/stream
sudo cp "$INSTALL_DIR/systemd/livestream.service" /etc/systemd/system/livestream.service
sudo systemctl daemon-reload

echo "Installed to $INSTALL_DIR"
echo "Edit $INSTALL_DIR/config/stream.conf, then run: stream start high"
