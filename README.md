# Q-Home ZT Planet

Hardened single-server ZeroTier private planet setup for Q-Box Central.

This project deploys:

- ZeroTier One controller/root service
- ZTNET web UI
- PostgreSQL database
- Caddy reverse proxy with automatic HTTPS
- Private planet generator
- Static endpoint for Q-Box planet download
- Backup and provisioning scripts

> Target OS: Debian 13 cloud VPS with a public static IPv4 address.

## Architecture

```text
Internet
  |
  | 443/tcp HTTPS
  v
Caddy
  |-- ZTNET UI/API
  |-- /qbox/planet
  |-- /qbox/install-planet.sh

Internet
  |
  | 9993/udp
  v
ZeroTier private root/controller

ZTNET -> ZeroTier local controller API
ZTNET -> PostgreSQL
Q-Box -> downloads custom planet -> joins Q-Home network
```

## Important notes

A fully private planet requires every Q-Box/client to use the custom `planet` file. Standard ZeroTier clients remain usable, but they must be provisioned with the Q-Home planet file.

For production, use at least two root servers in different locations. This repository starts with a single-server setup because it is simpler for the first cloud deployment.

## Quick start

```bash
git clone https://github.com/q-home/qhome-zt-planet.git
cd qhome-zt-planet
cp .env.example .env
nano .env
sudo ./scripts/install-debian13.sh
sudo ./scripts/deploy.sh
sudo ./scripts/generate-planet.sh
```

Then open:

```text
https://zt.example.com
```

Create the first ZTNET user. The first user becomes admin.

## Required DNS

```text
zt.example.com -> your server public IPv4
```

## Required firewall ports

```text
80/tcp    Caddy / ACME
443/tcp   ZTNET and provisioning
9993/udp  ZeroTier private planet/root
22/tcp    SSH, preferably IP restricted
```

## Q-Box provisioning

On the Q-Box:

```bash
curl -fsSL https://zt.example.com/qbox/install-planet.sh | sudo sh
sudo zerotier-cli join <NETWORK_ID>
```

Then authorize the Q-Box in ZTNET.

## Documentation

- [Debian 13 setup](docs/debian-13-setup.md)
- [Deployment guide](docs/deployment.md)
- [Private planet details](docs/private-planet.md)
- [Q-Box provisioning](docs/qbox-provisioning.md)
- [Backup and restore](docs/backup-restore.md)
- [Security hardening](docs/security.md)
- [Operations](docs/operations.md)

## License

Internal Q-Home project. Add your preferred license before publishing publicly.
