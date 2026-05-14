# Debian 13 cloud setup

## Server requirements

- Debian 13
- 1 public static IPv4 address
- 2 vCPU minimum
- 2 GB RAM minimum, 4 GB recommended
- 20 GB disk minimum
- DNS record pointing to the server

## Base installation

```bash
sudo apt-get update
sudo apt-get install -y git curl
```

Clone the repository and run:

```bash
cp .env.example .env
nano .env
sudo ./scripts/install-debian13.sh
```

## DNS

Create:

```text
zt.example.com A your.server.ip.address
```

## Firewall

The setup script opens:

- 80/tcp
- 443/tcp
- 9993/udp
- 22/tcp

For production, restrict SSH to fixed admin IPs.
