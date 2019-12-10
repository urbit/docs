+++
title = "Keyfile"
weight = 8
template = "doc.html"
[extra]
category = "azimuth"
+++

A **keyfile** is a piece of information used to associate a [ship](../ship) with an Urbit identity so that the ship can use the [Arvo](../arvo) network. A keyfile is dependent upon the [networking keys](../bridge) that have been set for the identity; we recommend using [Bridge](../bridge) to set the networking keys and to generate the corresponding keyfile.

The keyfile is used as an argument in the command line when booting a ship. During the boot process, [Vere](../vere) passes the keyfile into the Arvo state.

### Further Reading

- [Installation Guide](@/using/install.md): Instructions on using a keyfile to boot a ship.
