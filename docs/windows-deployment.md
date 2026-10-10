# Windows-client installeren

## 1. ZeroTier installeren

Download de Windows-client via [zerotier.com/download](https://www.zerotier.com/download/) en installeer deze met de standaardinstellingen.

## 2. De Q-Home Moon toevoegen

Open **Opdrachtprompt als administrator** en voer uit:

```cmd
zerotier-cli orbit MOON_ID MOON_ID
net stop ZeroTierOneService
net start ZeroTierOneService
```

Vervang beide keren `MOON_ID` door de Moon-ID die je van de Q-Home beheerder krijgt. Voor deze setup wordt dezelfde ID tweemaal gebruikt.

Voorbeeld: bij het Moon-bestand `0000009445e68ada.moon` is de ID `9445e68ada`:

```cmd
zerotier-cli orbit 9445e68ada 9445e68ada
```

Dit is een voorbeeld; gebruik de ID van de actieve Q-Home Moon. De client haalt het Moon-bestand zelf op.

## 3. Aanmelden op het juiste netwerk

1. Klik met de rechtermuisknop op het **ZeroTier-icoon** naast de Windows-klok.
2. Kies **Join New Network**.
3. Vul de **Network ID** van het gewenste Q-Home netwerk in en klik op **Join**.
4. Laat de beheerder je toestel autoriseren in [Q-Home ZTNET](https://zt.q-home.be).

De Network ID bestaat uit **16 hexadecimale tekens** en is een andere ID dan de Moon-ID.

Na autorisatie moet het netwerk de status **OK** tonen en een ZeroTier-IP-adres krijgen.

Bron: [ZeroTier Moon toevoegen via orbit](https://docs.zerotier.com/roots/#option-2-use-the-zerotier-cli-orbit-command).
