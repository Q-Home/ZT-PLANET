#!/bin/sh
set -e

ZT_DOMAIN="zt.q-home.be"
NETWORK_ID="REPLACE_WITH_QBOX_NETWORK_ID"

if ! command -v zerotier-cli >/dev/null 2>&1; then
  curl -s https://install.zerotier.com | bash
fi

systemctl stop zerotier-one || true
mkdir -p /var/lib/zerotier-one
curl -fsSL "https://${ZT_DOMAIN}/qbox/planet" -o /var/lib/zerotier-one/planet
chmod 0644 /var/lib/zerotier-one/planet
systemctl enable zerotier-one
systemctl start zerotier-one
sleep 3
zerotier-cli join "$NETWORK_ID"
zerotier-cli info
