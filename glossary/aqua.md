+++
title = "Aqua"
template = "doc.html"
[extra]
category = "arvo"
insert_anchor_links = "none"
+++

**Aqua** is something like Docker but for Urbit; it is a virtualization tool whose primary purpose is testing and development.

Aqua is a [Gall](../gall) app that runs an [Arvo](../arvo) instance or instances in userspace. It pretends to be [Vere](../vere), and as such it loads [Pills](../pill) to boot up a virtual ship or fleet of ships and then manages them from within the parent Arvo instance. Running tests for a virtual fleet of Aqua ships is done using [pH](../ph).

Aqua is jetted with the usual [Nock](../nock) interpreter and thus virtual ships do not run any slower than the parent ship.

### Further Reading

- [The Gall tutorial](@/docs/tutorials/arvo/gall.md): A technical guide to the Gall vane.
