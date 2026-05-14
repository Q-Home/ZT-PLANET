# Q-Box provisioning

## Manual provisioning

```bash
curl -fsSL https://zt.q-home.be/qbox/install-planet.sh | sudo sh
sudo zerotier-cli join <NETWORK_ID>
```

Authorize the member in ZTNET.

## Image provisioning

Bake this into the Q-Box image:

```bash
apt-get update
apt-get install -y curl gnupg
curl -s https://install.zerotier.com | bash
curl -fsSL https://zt.q-home.be/qbox/planet -o /var/lib/zerotier-one/planet
systemctl enable zerotier-one
systemctl restart zerotier-one
zerotier-cli join <NETWORK_ID>
```

## Recommended Q-Box first boot flow

```text
1. Boot Q-Box
2. Ensure ZeroTier One is installed
3. Install Q-Home planet
4. Restart ZeroTier One
5. Join Q-Box network
6. Send serial/customer/project metadata to Q-Box Central
7. Backend authorizes member through controller/ZTNET API
```
