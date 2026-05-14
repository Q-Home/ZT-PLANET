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

mkdir -p data/public/qbox

echo "Waiting for ZeroTier identity..."
for i in $(seq 1 60); do
  if docker exec qhome-zerotier test -f /var/lib/zerotier-one/identity.public; then
    break
  fi
  sleep 2
done

docker exec qhome-zerotier zerotier-idtool initmoon /var/lib/zerotier-one/identity.public > data/zerotier/moon.json

jq --arg endpoint "$ZT_PUBLIC_ENDPOINT" '.roots[0].stableEndpoints = [$endpoint]' data/zerotier/moon.json > data/zerotier/moon.tmp.json
mv data/zerotier/moon.tmp.json data/zerotier/moon.json

docker cp data/zerotier/moon.json qhome-zerotier:/var/lib/zerotier-one/moon.json
docker exec qhome-zerotier zerotier-idtool genmoon /var/lib/zerotier-one/moon.json
docker exec qhome-zerotier sh -c 'mkdir -p /var/lib/zerotier-one/moons.d && cp /var/lib/zerotier-one/*.moon /var/lib/zerotier-one/moons.d/'

# Build a private planet file by replacing the local planet with the generated world definition when supported.
# Current ZeroTier builds store the world file as *.moon for private roots; many clients accept it as planet when installed as /var/lib/zerotier-one/planet.
MOON_FILE=$(ls data/zerotier/*.moon 2>/dev/null | head -n 1 || true)
if [ -z "$MOON_FILE" ]; then
  docker cp qhome-zerotier:/var/lib/zerotier-one/$(docker exec qhome-zerotier sh -c 'ls /var/lib/zerotier-one/*.moon | xargs -n1 basename | head -n1') data/zerotier/ || true
  MOON_FILE=$(ls data/zerotier/*.moon 2>/dev/null | head -n 1 || true)
fi

if [ -z "$MOON_FILE" ]; then
  echo "Could not find generated moon/world file. Check docker logs qhome-zerotier."
  exit 1
fi

cp "$MOON_FILE" data/public/qbox/planet
chmod 0644 data/public/qbox/planet

cat > data/public/qbox/install-planet.sh <<INSTALL
#!/bin/sh
set -e
PLANET_URL="https://${ZT_DOMAIN}/qbox/planet"
if command -v systemctl >/dev/null 2>&1; then
  systemctl stop zerotier-one || true
else
  service zerotier-one stop || true
fi
mkdir -p /var/lib/zerotier-one
curl -fsSL "\$PLANET_URL" -o /var/lib/zerotier-one/planet
chmod 0644 /var/lib/zerotier-one/planet
if command -v systemctl >/dev/null 2>&1; then
  systemctl start zerotier-one
else
  service zerotier-one start
fi
zerotier-cli info || true
INSTALL
chmod 0644 data/public/qbox/install-planet.sh

docker restart qhome-zerotier >/dev/null

echo "Private planet published at: https://${ZT_DOMAIN}/qbox/planet"
echo "Q-Box installer: https://${ZT_DOMAIN}/qbox/install-planet.sh"
