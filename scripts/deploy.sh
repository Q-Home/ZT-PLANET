#!/usr/bin/env bash
set -euo pipefail

if [ ! -f .env ]; then
  echo "Missing .env. Copy .env.example to .env and edit it."
  exit 1
fi

mkdir -p data/postgres data/zerotier data/caddy data/caddy-config data/public/qbox backups
chmod 700 data/zerotier backups

docker compose pull
docker compose up -d

echo "Deployment started. Check status with: docker compose ps"
