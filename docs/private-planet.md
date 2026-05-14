# Private planet

A ZeroTier private planet/private root replaces the default public root infrastructure for clients that install the custom `planet` file.

## What this project does

1. Starts a ZeroTier controller/root service.
2. Reads the generated `identity.public`.
3. Builds a private root definition with `zerotier-idtool initmoon`.
4. Sets the public stable endpoint from `.env`.
5. Generates the root/world file.
6. Publishes it as `/qbox/planet`.

## Client impact

Every Q-Box must install:

```text
/var/lib/zerotier-one/planet
```

After replacing the planet file, restart ZeroTier One and join the Q-Home network.

## Limitations

A single private root server is a single point of failure. For production, extend the planet with at least two root servers on different public IP addresses.
