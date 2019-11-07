+++
title = "Guide to Breaches"
weight = 10
template = "doc.html"
+++

An important concept on the Arvo network is that of continuity. Continuity refers to ships remember the order of its own network messages and the network messages of others -- these messages are numbered, starting from zero. A _breach_ is when ships on the network agree to forget about this sequence and treat one or more ships like they are brand new.

There are two kinds of breaches: **personal breaches** and **network breaches**.

## Personal Breaches

Ships on the Arvo network sometimes need to reset their continuity. A personal breach is when an individual ship announces to the network: "I forgot who I am, let's start over from scratch." That is, it clears its own event log and sends an announcement to the network, asking all ships that have communicated with it to reset its networking information in their state. This makes it as though the ship was just started for the first time again, since everyone has network has forgotten about it.

Personal breaches often fix connectivity issues, but should only be used as a last resort. To perform a personal breach, follow the steps below.

- Go to [bridge.urbit.org](https://bridge.urbit.org) and log into your identity.
- Go to the `Admin` section. Then go to `Networking Keys`.
- Check the `Trigger New Continuity Era` box. Click `Reset Networking Keys`, and then click `Send Transaction`.
- Click `Download Arvo Keyfile`.
- Delete or archive your old pier.
- Create a new pier by booting your ship with your new keyfile.
- Rejoin your favorite chat channels and subscriptions.

## Network Breaches

A network breach is an event where all ships on the network are required to update to a new continuity era. The current continuity era is determined by a value in Ames, our networking module, that is incremented when a network; only ships with the same such value are able to communicate with one another. So network breaches happen when an Arvo update is released that is too large to release over the air.

If a network breach is happening, follow the steps below.

- Delete your old Urbit binary.
- Delete or archive your old pier.
- Download the new Urbit binary by following the instructions in the [Install page](https://urbit.org/using/install/).
- Create a new pier by booting your ship with your key, according to the instructions on the install page. (Note: You do _not_ need to use new a new key to boot into a new continuity era.)
- Rejoin your favorite chat channels and subscriptions.
