+++
title = "Voting"

template = "doc.html"
[extra]
category = "azimuth"
+++

**Voting** is a power available to [galaxies](../galaxy), in their capacities as
members of the [Galactic Senate](../senate), through an [Azimuth](../azimuth)
smart contract. Galaxies collectively make decisions about the governance of
Azimuth and the [Arvo](../arvo) network by voting. There are two types of proposals that can be voted on:
an [upgrade proposal](../upgrade) and a [document proposal](../docvote).

A proposal is always a Yes/No vote. The vote concludes at the end of 30 days,
or whenever an absolute majority is reached, whichever comes first. Assuming a
quorum of at least 64 galaxies (1/4 of the Senate) has been achieved, at the end
of 30 days the option that has received the most votes is chosen. If a quorum
is not achieved then no action is taken.

In the case of an absolute majority (129 galaxies), the vote transaction that
achieves that majority triggers the upgrade or document ratification. If 30 days
passes without an absolute majority being reached, an explicit "update vote
status/check result" transaction will need to be made. This can be performed by
anyone at any time. Any effects from doing so will only take place if there was a
majority vote in favor.

