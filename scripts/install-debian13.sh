#!/usr/bin/env bash
set -euo pipefail

if [ "${EUID}" -ne 0 ]; then
  echo "Run as root or via sudo"
  exit 1
fi

apt-get update
apt-get install -y ca-certificates curl gnupg ufw git jq openssl unattended-upgrades fail2ban

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

. /etc/os-release
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian ${VERSION_CODENAME} stable" > /etc/apt/sources.list.d/docker.list

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable --now docker
systemctl enable --now fail2ban

ufw default deny incoming
ufw default allow outgoing
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 9993/udp
# SSH remains open by default. Restrict manually to your office/VPN IP if possible.
ufw allow 22/tcp
ufw --force enable

mkdir -p data/postgres data/zerotier data/caddy data/caddy-config data/public/qbox backups
chmod 700 data/zerotier backups

echo "Debian base setup complete. Edit .env, then run scripts/deploy.sh"
