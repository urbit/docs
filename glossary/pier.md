+++
title = "Pier"
template = "doc.html"
[extra]
category = "arvo"
insert_anchor_links = "none"
+++

A **pier** is the directory which contains the state of an Urbit [ship](../ship). It is automatically created in the current directory when booting a ship for the first time.

Your pier should be kept safe - if it's deleted, you will need to perform a [breach](../breach) in order to advise the rest of the network that your ship's state has been lost.

Note that a backup should usually _not_ be taken of your pier as a means of keeping it safe - once the ship is run on the network, the backup will be outdated and running from it will necessitate a breach. A running ship automatically backs up its own state within the pier directory for recovery purposes, so as long as the pier is preserved, recovery from most problems is possible.

### Further Reading

- [Event Log](../eventlog): The main important content of the pier directory.
- [A Guide to Breaches](@/docs/tutorials/guide-to-breaches.md): Instructions on handling continuity breaches (resets) on the Ames network.
- [Ship Troubleshooting](@/docs/tutorials/ship-troubleshooting.md): General instructions on getting your ship to work, which includes network connectivity issues.
