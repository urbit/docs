+++
title = "Galaxy"

template = "doc.html"
[extra]
category = "arvo"
insert_anchor_links = "none"
+++

A **galaxy** can be one of two related things:

- A kind of [Azimuth](../azimuth) Urbit identity that sits at the top of the identity hierarchy. Galaxies, in this sense, have the power to issue [stars](../star), meaning that all other kinds of identities ultimate derive from galaxies. Galaxies also form a [Senate](../senate), the governing body of Azimuth. The Senate has the power to update the logic of Azimuth by [majority vote](../voting).

- A [ship](../ship) on the Arvo network whose identity is a planet in the former definition. In this sense, galaxies act as infrastructure for the [Arvo](../arvo) network, providing [Ames](../ames)-related services, such as peer-to-peer routing and distributing [over-the-air software updates](../ota-updates). Stars rely on galaxies for these services in the way that planets rely on stars.

Galaxies are 8-bit, representable by numbers 0 to 255. This means that there are 256 possible galaxies; each of these galaxies is able to issue 255 [stars](../star). Galaxies have one-syllable names like `~mul` or `~lux`.
