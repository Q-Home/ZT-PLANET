#!/usr/bin/env bash
set -euo pipefail

DATE=$(date +%F-%H%M)
BACKUP_DIR="./backups"
mkdir -p "$BACKUP_DIR"

docker compose exec -T postgres pg_dump -U "${POSTGRES_USER:-ztnet}" "${POSTGRES_DB:-ztnet}" > "$BACKUP_DIR/ztnet-db-$DATE.sql"
tar -czf "$BACKUP_DIR/qhome-zt-data-$DATE.tar.gz" data/zerotier data/public Caddyfile docker-compose.yml .env
find "$BACKUP_DIR" -type f -mtime +30 -delete

echo "Backup written to $BACKUP_DIR"
