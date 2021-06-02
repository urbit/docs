+++
title = "Moon"
template = "doc.html"
[extra]
category = "arvo"
+++

A **moon** is a kind of [ship](../ship) on the [Arvo](../arvo) network. Moons
are child identities issued by [planets](../planet), [stars](../stars), and
[galaxies](../galaxy). A moon is not independent; it is always subordinate to
the ship that issued it. By this we mean that the networking keys for the moon
are controlled by the parent, and may be altered or revoked at any time by that parent.

Moons may be utilized for many purposes, including but not limited to:
 - vanity identities
 - backup identities incase the parent identity cannot be accessed
 - identities for children
 - testing software
 - bots
Looking towards the future, we expect moons to also be utilized as identities
for devices, such as such as phones, desktops, smart TVs, and digital thermostats

Unlike planets, stars, and galaxies, moons have no presence on
[Azimuth](../azimuth). Moons are representable with 64 bits and have long names
like `~doznec-salfun-naptul-habrys`, the latter half of which is inherited from
their parent planet.

### Further Reading

- [Using Your Ship](@/using/os/getting-started.md#moons): The "Moons" section contains instructions for creating and managing moons.

- [Lunar Urbit and the Internet of Things](@/blog/iot.md): Blog post on the
  past, present, and future of moons

