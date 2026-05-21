#!/usr/bin/env bash
set -euo pipefail

if [ ! -f .env ]; then
  echo "Missing .env"
  exit 1
fi

set -a
. ./.env
set +a

if [ -z "${ZT_PUBLIC_ENDPOINT:-}" ]; then
  echo "ZT_PUBLIC_ENDPOINT is missing in .env, for example 203.0.113.10/9993"
  exit 1
fi

if [ -z "${ZT_DOMAIN:-}" ]; then
  echo "ZT_DOMAIN is missing in .env, for example zt.q-home.be"
  exit 1
fi

mkdir -p data/zerotier data/public/qbox

echo "Waiting for ZeroTier identity..."
for i in $(seq 1 60); do
  if docker exec qhome-zerotier test -f /var/lib/zerotier-one/identity.public; then
    break
  fi
  sleep 2
done

if ! docker exec qhome-zerotier test -f /var/lib/zerotier-one/identity.public; then
  echo "ZeroTier identity.public was not created. Is qhome-zerotier running?"
  exit 1
fi

echo "Generating Q-Home Moon/private root definition..."
docker exec qhome-zerotier zerotier-idtool initmoon /var/lib/zerotier-one/identity.public > data/zerotier/moon.json

jq --arg endpoint "$ZT_PUBLIC_ENDPOINT" '.roots[0].stableEndpoints = [$endpoint]' \
  data/zerotier/moon.json > data/zerotier/moon.tmp.json

mv data/zerotier/moon.tmp.json data/zerotier/moon.json

docker cp data/zerotier/moon.json qhome-zerotier:/var/lib/zerotier-one/moon.json

echo "Generating .moon world file..."
docker exec qhome-zerotier sh -c '
  cd /var/lib/zerotier-one
  rm -f ./*.moon
  zerotier-idtool genmoon moon.json
  mkdir -p moons.d
  cp ./*.moon moons.d/
'

echo "Copying generated Moon file to host..."
MOON_NAME="$(docker exec qhome-zerotier sh -c 'cd /var/lib/zerotier-one && ls *.moon | head -n1')"

if [ -z "$MOON_NAME" ]; then
  echo "Could not find generated .moon file in container."
  exit 1
fi

docker cp "qhome-zerotier:/var/lib/zerotier-one/${MOON_NAME}" "data/zerotier/${MOON_NAME}"
cp "data/zerotier/${MOON_NAME}" "data/public/qbox/${MOON_NAME}"
chmod 0644 "data/public/qbox/${MOON_NAME}"

cat > data/public/qbox/install-moon.sh <<INSTALL
#!/bin/sh
set -eu

MOON_FILE="${MOON_NAME}"
MOON_URL="https://${ZT_DOMAIN}/qbox/${MOON_NAME}"
NETWORK_ID="${QBOX_NETWORK_ID:-}"
PROVISIONING_URL="${QBOX_PROVISIONING_URL:-}"

if [ ! -r /sys/class/net/eth0/address ]; then
  echo "Could not read eth0 MAC address from /sys/class/net/eth0/address"
  exit 1
fi

ETH0_MAC="\$(cat /sys/class/net/eth0/address | tr '[:upper:]' '[:lower:]')"
QBOX_SERIAL="\$(echo "\$ETH0_MAC" | tr -d ':')"
QBOX_NAME="qbox-\$QBOX_SERIAL"

if command -v hostnamectl >/dev/null 2>&1; then
  hostnamectl set-hostname "\$QBOX_NAME" || true
fi

mkdir -p /var/lib/zerotier-one/moons.d
curl -fsSL "\$MOON_URL" -o "/var/lib/zerotier-one/moons.d/\$MOON_FILE"
chmod 0644 "/var/lib/zerotier-one/moons.d/\$MOON_FILE"

if command -v systemctl >/dev/null 2>&1; then
  systemctl restart zerotier-one
else
  service zerotier-one restart
fi

sleep 20

NODE_ID="\$(zerotier-cli info | awk '{print \$3}')"

if [ -n "\$NETWORK_ID" ]; then
  zerotier-cli join "\$NETWORK_ID" || true
fi

if [ -n "\$PROVISIONING_URL" ]; then
  curl -fsSL -X POST "\$PROVISIONING_URL" \
    -H "Content-Type: application/json" \
    -d "{\"serial\":\"\$QBOX_SERIAL\",\"mac_eth0\":\"\$ETH0_MAC\",\"hostname\":\"\$QBOX_NAME\",\"node_id\":\"\$NODE_ID\",\"network_id\":\"\$NETWORK_ID\"}" \
    || true
fi

echo "Q-Box serial: \$QBOX_SERIAL"
echo "Q-Box hostname: \$QBOX_NAME"
echo "ZeroTier node ID: \$NODE_ID"
echo "Installed Moon: \$MOON_FILE"
zerotier-cli info || true
zerotier-cli listpeers || true
INSTALL

chmod 0644 data/public/qbox/install-moon.sh

docker restart qhome-zerotier >/dev/null

echo "Q-Home Moon published at: https://${ZT_DOMAIN}/qbox/${MOON_NAME}"
echo "Q-Box installer: https://${ZT_DOMAIN}/qbox/install-moon.sh"
echo "Generated Moon file: ${MOON_NAME}"
