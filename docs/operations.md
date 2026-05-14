# Operations

## Status

```bash
docker compose ps
docker compose logs -f ztnet
docker compose logs -f zerotier
docker compose logs -f caddy
```

## Update

```bash
docker compose pull
docker compose up -d
```

## Regenerate planet

Only do this if the root identity or public endpoint changes.

```bash
./scripts/generate-planet.sh
```

After changing the planet, existing Q-Boxes may need the new `planet` file and a ZeroTier restart.

## Check ZeroTier peers

```bash
docker exec qhome-zerotier zerotier-cli listpeers
```

## Check controller

```bash
docker exec qhome-zerotier zerotier-cli info
```
