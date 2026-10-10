# Q-Home ZT Planet

Hardened single-server ZeroTier setup for Q-Box Central using:

- ZTNET web UI
- Self-hosted ZeroTier controller
- Q-Home Moon / private root
- PostgreSQL database
- Caddy reverse proxy with automatic HTTPS
- Q-Box provisioning scripts
- Backup and operations documentation

> Target OS: Debian 13 cloud VPS with a public static IPv4 address.

## Current production architecture

This project intentionally uses a **Moon/private root** architecture, not a fully private ZeroTier planet.

Why:

- ordinary ZeroTier One clients continue to work;
- no custom ZeroTier client build is needed;
- Q-Boxes only need a `.moon` file in `moons.d`;
- public ZeroTier planet servers remain available as bootstrap/fallback;
- the setup is much more stable and maintainable for production.

```text
Internet
  |
  | 443/tcp HTTPS
  v
Caddy
  |-- ZTNET UI/API
  |-- /qbox/<moon-id>.moon
  |-- /qbox/install-moon.sh

Internet
  |
  | 9993/udp
  v
ZeroTier controller + Q-Home Moon/private root

ZTNET -> ZeroTier local controller API
ZTNET -> PostgreSQL
Q-Box -> downloads Q-Home .moon file -> joins Q-Home ZeroTier network
```

## Important notes

This repository no longer recommends replacing the ZeroTier `planet` file on clients.

The supported Q-Box approach is:

1. install the ordinary ZeroTier One client;
2. place the Q-Home `.moon` file in `/var/lib/zerotier-one/moons.d/`;
3. restart ZeroTier One;
4. join the Q-Home network;
5. authorize the member in ZTNET.

A fully private planet was evaluated, but rejected for production because it is more fragile, harder to maintain, and requires replacing client planet files. Moon/private root deployment gives Q-Home control over its own root/discovery infrastructure while keeping standard client compatibility.

For production, use at least two Moon/root servers in different locations. This repository starts with a single-server setup because it is simpler for the first cloud deployment.

## Quick start without Git on the server

```bash
cd /opt
mkdir -p ZT-PLANET
cd ZT-PLANET

curl -L https://github.com/Q-Home/ZT-PLANET/archive/refs/heads/main.tar.gz \
  | tar -xz --strip-components=1

cp .env.example .env
nano .env
chmod +x scripts/*.sh
sudo ./scripts/install-debian13.sh
sudo ./scripts/deploy.sh
sudo ./scripts/generate-planet.sh
```

> Historical note: `generate-planet.sh` currently generates the Moon/private root world file. The filename remains for backwards compatibility and should be renamed in a future cleanup.

Then open:

```text
https://zt.q-home.be
```

Create the first ZTNET user. The first user becomes admin.

## Required DNS

```text
zt.q-home.be -> your server public IPv4
```

## Required firewall ports

```text
80/tcp    Caddy / ACME
443/tcp   ZTNET and provisioning
9993/udp  ZeroTier transport / Moon
22/tcp    SSH, preferably IP restricted
```

## Q-Box provisioning

Example using the generated Moon file:

```bash
sudo mkdir -p /var/lib/zerotier-one/moons.d

sudo curl -fsSL \
  https://zt.q-home.be/qbox/0000009445e68ada.moon \
  -o /var/lib/zerotier-one/moons.d/0000009445e68ada.moon

sudo chmod 0644 /var/lib/zerotier-one/moons.d/0000009445e68ada.moon
sudo systemctl restart zerotier-one
sleep 20
sudo zerotier-cli join <NETWORK_ID>
```

Then authorize the Q-Box in ZTNET.

## Documentation

- [Debian 13 setup](docs/debian-13-setup.md)
- [Deployment guide](docs/deployment.md)
- [Moon/private root details](docs/private-planet.md)
- [Q-Box provisioning](docs/qbox-provisioning.md)
- [Windows client installation](docs/windows-deployment.md)
- [Backup and restore](docs/backup-restore.md)
- [Security hardening](docs/security.md)
- [Operations](docs/operations.md)

## License

Internal Q-Home project. Add your preferred license before publishing publicly.
