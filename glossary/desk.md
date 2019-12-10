+++
title = "Desk"
weight = 18
template = "doc.html"
+++

A **desk** is an independently revision-controlled branch of a [ship](../ship) that usesthe [Clay](../clay) filesystem. Each desk contains its own apps, [mark](../mark) definitions, files, and so forth.

Traditionally a ship has at least a base desk and a home desk. The base desk has all the system software from the distribution, and the home desk is a fork of base with all the items specific to the user of the ship. A desk is a series of numbered commits, the most recent of which represents the current state of the desk. A commit is composed of `1` an absolute time when it was created, `2` a list of zero or more parents, and `3` a map from paths to data.

### Further Reading

- [Using Your Ship](@/using/operations/using-your-ship.md#filesystem): A user guide that includes instructions for using desks.
