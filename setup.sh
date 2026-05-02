#!/usr/bin/env bash
set -euo pipefail
set -x

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BASE_DIR="/opt/pihole"
PIHOLE_DATA_DIR="$BASE_DIR/etc-pihole"
UNBOUND_BUILD_DIR="$BASE_DIR/unbound-build"
UNBOUND_DIR="$BASE_DIR/unbound"
QUADLET_DIR="/etc/containers/systemd"

sudo install -d -m 0755 "$QUADLET_DIR"
sudo install -d -m 0755 "$PIHOLE_DATA_DIR"
sudo install -d -m 0755 "$UNBOUND_BUILD_DIR"
sudo install -d -m 0755 "$UNBOUND_BUILD_DIR/data"
sudo install -d -m 0755 "$UNBOUND_DIR"

sudo install -m 0644 "$ROOT_DIR/quadlets/pihole.container" "$QUADLET_DIR/pihole.container"
sudo install -m 0644 "$ROOT_DIR/quadlets/unbound.container" "$QUADLET_DIR/unbound.container"
sudo install -m 0644 "$ROOT_DIR/quadlets/unbound.build" "$QUADLET_DIR/unbound.build"

sudo install -m 0644 "$ROOT_DIR/unbound/Dockerfile" "$UNBOUND_BUILD_DIR/Dockerfile"
sudo install -m 0755 "$ROOT_DIR/unbound/data/unbound.sh" "$UNBOUND_BUILD_DIR/data/unbound."
sudo install -m 0644 "$ROOT_DIR/etc-pihole/pihole.toml" "$PIHOLE_DATA_DIR/pihole.toml"
sudo install -m 0644 "$ROOT_DIR/unbound/unbound.conf" "$UNBOUND_DIR/unbound.conf"

sudo systemctl daemon-reload

sudo systemctl enable --now unbound.service
sudo systemctl enable --now pihole.service

echo "Started Pi-hole + Unbound."
echo
echo "Status:"
echo "  systemctl status unbound.service"
echo "  systemctl status pihole.service"
echo
echo "Logs:"
echo "  journalctl -u pihole.service -f"
echo "  journalctl -u unbound.service -f"
echo
echo "Password, if auto-generated:"
echo "  journalctl -u pihole.service | grep -i password"
echo
echo "Verify:"
echo "  dig @127.0.0.1 -p 5335 google.com"
echo "  dig @127.0.0.1 google.com"
