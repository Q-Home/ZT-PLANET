# Moon / private root architecture

Q-Home uses a ZeroTier Moon/private root deployment instead of a fully private planet.

## Why this architecture was selected

Advantages:

- ordinary ZeroTier One clients continue to work;
- no custom ZeroTier build is needed;
- no replacement of the client `planet` file;
- much more stable and maintainable for production;
- public ZeroTier planet servers remain available as fallback/bootstrap;
- Q-Home still controls its own discovery/root infrastructure.

## What this project does

1. Starts a self-hosted ZeroTier controller.
2. Starts ZTNET.
3. Generates a Q-Home Moon/private root.
4. Publishes the generated `.moon` file for Q-Box provisioning.
5. Allows Q-Boxes to orbit the Q-Home Moon.

## Client provisioning

Every Q-Box installs the generated `.moon` file in:

```text
/var/lib/zerotier-one/moons.d/
```

Example:

```bash
sudo mkdir -p /var/lib/zerotier-one/moons.d

sudo curl -fsSL \
  https://zt.q-home.be/qbox/0000009445e68ada.moon \
  -o /var/lib/zerotier-one/moons.d/0000009445e68ada.moon

sudo chmod 0644 /var/lib/zerotier-one/moons.d/0000009445e68ada.moon
sudo systemctl restart zerotier-one
```

## Verification

After restarting ZeroTier:

```bash
sudo zerotier-cli listpeers
```

The Q-Home Moon/root should eventually appear.

## Important note

Public ZeroTier `PLANET` servers will still appear in `listpeers`.

This is expected and intentional.

The Moon/private root architecture keeps the official bootstrap/fallback mechanism while adding Q-Home-controlled roots/discovery infrastructure.

## Recommended production topology

Minimum:

```text
1 controller server
1 Moon/root server
```

Recommended:

```text
1 controller server
2 or 3 Moon/root servers
```

Each Moon/root should run on a different public IPv4 address and preferably in different datacenters.
