# Q-Box provisioning

## Recommended provisioning approach

Q-Home uses:

- ordinary ZeroTier One clients;
- a self-hosted controller;
- Q-Home Moon/private roots;
- ZTNET for authorization and network management.

Q-Boxes should NOT replace the standard ZeroTier `planet` file.

## Manual provisioning

Install ZeroTier One:

```bash
curl -s https://install.zerotier.com | sudo bash
```

Install the Q-Home Moon/private root:

```bash
sudo mkdir -p /var/lib/zerotier-one/moons.d

sudo curl -fsSL \
  https://zt.q-home.be/qbox/0000009445e68ada.moon \
  -o /var/lib/zerotier-one/moons.d/0000009445e68ada.moon

sudo chmod 0644 /var/lib/zerotier-one/moons.d/0000009445e68ada.moon

sudo systemctl restart zerotier-one
sleep 20
```

Join the Q-Home network:

```bash
sudo zerotier-cli join <NETWORK_ID>
```

Authorize the member in ZTNET.

## Validation

```bash
sudo zerotier-cli info
sudo zerotier-cli listpeers
```

The Q-Home Moon/root should eventually appear.

## Image provisioning

Bake this into the Q-Box image:

```bash
apt-get update
apt-get install -y curl gnupg
curl -s https://install.zerotier.com | bash

mkdir -p /var/lib/zerotier-one/moons.d

curl -fsSL \
  https://zt.q-home.be/qbox/0000009445e68ada.moon \
  -o /var/lib/zerotier-one/moons.d/0000009445e68ada.moon

chmod 0644 /var/lib/zerotier-one/moons.d/0000009445e68ada.moon

systemctl enable zerotier-one
systemctl restart zerotier-one
sleep 20

zerotier-cli join <NETWORK_ID>
```

## Recommended Q-Box first boot flow

```text
1. Boot Q-Box
2. Ensure ZeroTier One is installed
3. Install Q-Home Moon/private root
4. Restart ZeroTier One
5. Join Q-Home network
6. Send serial/customer/project metadata to Q-Box Central
7. Backend authorizes member through controller/ZTNET API
```

## Important note

The Q-Home Moon/private root architecture intentionally keeps the public ZeroTier bootstrap infrastructure available as fallback.

This is the recommended production approach for stability and maintainability.
