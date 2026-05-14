# Deployment

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

## 3. Generate private planet

```bash
sudo ./scripts/generate-planet.sh
```

## 4. Open ZTNET

Visit:

```text
https://zt.q-home.be
```

Register the first user. The first user becomes admin.

## 5. Create network

Create the Q-Box network in ZTNET. Save the network ID for provisioning.
