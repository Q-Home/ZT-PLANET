# Deployment

This guide deploys the central stack on Debian/Linux. For Windows clients and
hosting the stack in a Linux VM on Windows, see [Windows deployment](windows-deployment.md).

## 1. Configure environment

```bash
cp .env.example .env
nano .env
```

Set:

```env
ZT_DOMAIN=zt.q-home.be
NEXTAUTH_URL=https://zt.q-home.be
ZT_PUBLIC_ENDPOINT=YOUR_PUBLIC_IPV4/9993
POSTGRES_PASSWORD=long-random-secret
NEXTAUTH_SECRET=long-random-secret
```

Generate secrets:

```bash
openssl rand -base64 48
```

## 2. Deploy

```bash
sudo ./scripts/deploy.sh
```

## 3. Generate Q-Home Moon/private root

```bash
sudo ./scripts/generate-planet.sh
```

> Historical note: the script name remains for backwards compatibility. The script now generates a Moon/private root setup instead of a fully private planet deployment.

Generated files:

```text
data/zerotier/*.moon
```

Example:

```text
0000009445e68ada.moon
```

## 4. Publish Moon file

```bash
mkdir -p data/public/qbox
cp data/zerotier/*.moon data/public/qbox/
```

The file becomes available through:

```text
https://zt.q-home.be/qbox/<moon-file>.moon
```

## 5. Open ZTNET

Visit:

```text
https://zt.q-home.be
```

Register the first user. The first user becomes admin.

## 6. Create network

Create the Q-Box network in ZTNET.

Save the network ID for Q-Box provisioning.

## 7. Provision Q-Boxes

Install the generated Moon file on each Q-Box:

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

Authorize the device in ZTNET.
