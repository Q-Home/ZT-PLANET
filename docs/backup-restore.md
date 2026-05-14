# Backup and restore

## Backup

```bash
./scripts/backup.sh
```

Back up at minimum:

- `data/zerotier`
- PostgreSQL dump
- `.env`
- `Caddyfile`
- `docker-compose.yml`
- `data/public/qbox/planet`

## Cron example

```cron
15 2 * * * cd /opt/qhome-zt-planet && ./scripts/backup.sh
```

## Restore

1. Restore repository folder.
2. Restore `.env`.
3. Restore `data/zerotier` and `data/public`.
4. Start Postgres.
5. Restore SQL dump.
6. Start full stack.
