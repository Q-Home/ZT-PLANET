# Security hardening

## Server

- Use SSH keys only.
- Restrict SSH to known admin IP addresses.
- Enable unattended security upgrades.
- Enable fail2ban.
- Use a cloud firewall in addition to UFW.

## Ports

Public:

- 80/tcp
- 443/tcp
- 9993/udp

Private only:

- PostgreSQL
- ZTNET internal port 3000
- ZeroTier controller local API

## Secrets

Never commit `.env`.

Generate strong values:

```bash
openssl rand -base64 48
```

## Docker

- No Docker socket mounted into containers.
- `no-new-privileges` enabled.
- Database is not exposed publicly.
- ZTNET only reachable through Caddy HTTPS.
