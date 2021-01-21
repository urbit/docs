+++
title = "Ames"
template = "doc.html"
[extra]
category = "arvo"
insert_anchor_links = "none"
+++

**Ames** is the name of the Urbit network and the [vane](../vane) that communicates over it. It's an encrypted peer-to-peer network composed of instances of the [Arvo](../arvo) operating system. Each [galaxy](../galaxy), [star](../star), [planet](../planet), [moon](../moon), and [comet](../comet) communicates over the network utilizing the Ames protocol.

Your ship upgrades itself with [OTA updates](../ota-updates) via communication over Ames. The web interface, [Landscape](../landscape), of ships can be accessed by typing `sampel-palnet.arvo.network` into a browser, where `sampel-palnet` is the name of your ship.
 
Network continuity occasionally needs to be broken, either at an individual
level to fix networking issues or at a network-wide level to update Arvo beyond
what OTA updates are capable of doing. These events are called [breaches](../breach).
### Further Reading

- [The Ames tutorial](@/docs/tutorials/arvo/ames.md): An in-depth technical guide to the Ames protocol.
- [A Guide to Breaches](@/docs/tutorials/guide-to-breaches.md): Instructions on handling continuity breaches (resets) on the Ames network.
- [Ship Troubleshooting](@/docs/tutorials/ship-troubleshooting.md): General instructions on getting your ship to work, which includes network connectivity issues.
