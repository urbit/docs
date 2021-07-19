+++
title = "Life and Rift"
weight = 3
template = "doc.html"
+++

Associated to every Azimuth point are two non-negative integers known as _life_
and _rift_. This numbering system partition messages according to the quantity
of networking key changes and quantity of
[breaches](@/using/id/guide-to-breaches.md), respectively. This is explained in
more detail below. These values are utilized by [Ames](@/docs/arvo/ames/ames.md)
and [Jael](@/docs/arvo/jael/jael.md) to ensure that communication between
ships is always done with the most recent set of networking keys, and that
networking state is appropriately reset when a breach has occurred.

Every ship begins with a `life` and `rift` of 0. For
galaxies, stars, and planets, these values are stored in the Azimuth PKI, while
for moons, these values are stored by their parent. Comets cannot change their
networking keys, nor can they breach, and so their `life` and `rift` are always 0.

You can check your current `life` and `rift` number by running the `+keys our`
generator in dojo. You can inspect another ship's `life` and `rift` by running
`+keys ~sampel-palnet`.

## Life

A ship's `life`, or _key revision number_, is a count of the number of times which
a ship's networking keys have been altered. The initial value of each key is
always zero, and the initial `life` is always 0.

Thus, setting the keys of a ship to a nonzero value for the first time will
increment the `life` from 0 to 1. Rotating to a new set of keys will then
increment the `life` to 2. Setting the keys back to zero would increment the
`life` once more, to 3.

## Rift

A ship's `rift`, or _continuity number_, is a count of the number of times that
a ship has breached, also known as broken continuity.

In other words, a ship's `rift` will remain at 0 until the first time it is
breached.

Network-wide breaches do not affect the `rift` of any ship. They are only used to
count the number of personal breaches.

## Edge cases

Configuring the keys to the same value they already were (i.e. a no-op) is
possible, but has no effect on the `life`. Thus `life` is actually a measure of
networking key _revisions_, and not the number of times they've been set.

Thus under ordinary circumstances, a breach will increment both `life` and
`rift` since a breach typically also involves changing the networking keys.
However, it is possible to breach without changing the networking keys.
If the new keys specified
as part of a breach are the same as the old, `rift` will increment while
`life` will not.
