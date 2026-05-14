#!/usr/bin/env bash
set -euo pipefail

echo "Manual restore checklist:"
echo "1. docker compose down"
echo "2. restore data/zerotier and data/public from tar archive"
echo "3. docker compose up -d postgres"
echo "4. cat backups/ztnet-db-YYYY.sql | docker compose exec -T postgres psql -U ztnet ztnet"
echo "5. docker compose up -d"
