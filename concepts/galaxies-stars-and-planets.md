+++
title = "Galaxies, Stars, and Planets"
weight = 7
template = "doc.html"
description = "An explanation of the Urbit address-space hierarchy. "
+++

The current internet has no consistent system of identity. There are only quasi-identities such as IP addresses, Google accounts and email addresses, each able to be assumed and abandoned without much trouble. The result is a hostile social experience, since bad actors -- spammers, scammers, malware-spreaders, and harassers -- have an inexhaustible supply of places to hide.

That's why we built a system for persistent identity called [Azimuth](@/docs/concepts/azimuth.md). Azimuth identities are called _points_, and you need one to use the Arvo network. Points are secure, since they are owned and controlled with key-pair the Ethereum blockchain, which Azimuth is built on top of.

An Azimuth point is a pronounceable string like `~firbyr-napbes`. It means nothing, but it's easy to remember and say out loud. `~firbyr-napbes` is actually just a 32-bit number (`3.237.967.392`, to be exact) that we turn into a human-memorable string.

Points come in three classes: **galaxies**, **stars**, and **planets**. You can tell what class a point is in by how long its name is. The address space grows like a family tree. Galaxies are 8-bit and have names like `~mul`. Galaxies can issue 16-bit stars (`~dacpyl`), which can themselves issue 32-bit planets (`~laptel-holfur`).

Planets are intended for everyday use by an adult human, and there is a maximum of about 4.3 billion of them (2 to the 32nd power). Stars and galaxies, on the other hand, are meant to act as network infrastructure: in the Arvo network they provide P2P routing and distribute software updates.

```
    Size   Name    Parent  Object      Example
    -----  ------  ------  ------      -------
    2^8    galaxy  ~       supernode   ~zod
    2^16   star    galaxy  supernode   ~dozbud
    2^32   planet  star    user        ~tasfyn-partyv
    2^64   moon    planet  device      ~sigsam-nimbot-tasfyn-partyv
    2^128  comet   ~       bot         ~racmus-mollen-fallyt-linpex--watres-sibbur-modlux-rinmex
```

## Moons and Comets

In addition to these three classes of Azimuth points, there two other kinds of Urbit identities, but they do _not_ use Azimuth.

**Moons** are 64 bits, are issued by planets, and have names like `~doznec-salfun-naptul-habrys`. Moons are meant for connected devices: phones, smart TVs, digital thermostats. Moons are not independent, but are subordinated to their parent planet. To create new moon under your planet, follow [this guide](/docs/using/admin#moons).

**Comets** are 128-bit points with no parents that can be launched by anyone. They are meant for bots. Being disposable and essentially unlimited, they will likely not be trusted by the others on the Arvo network. They have enormous names, like `~racmus-mollen-fallyt-linpex--watres-sibbur-modlux-rinmex`.
