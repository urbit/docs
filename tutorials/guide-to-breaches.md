+++
title = "Guide to Breaches"
weight = 10
template = "doc.html"
+++

An important concept on the [Ames](@/docs/tutorials/arvo/ames.md) network is that of continuity. Continuity refers to how ships remember the order of their own network messages and the network messages of others -- these messages are numbered, starting from zero. A _breach_ is when ships on the network agree to forget about this sequence and treat one or more ships like they are brand new.

There are two kinds of breaches: **personal breaches** and **network breaches**.

## Personal Breaches

Ships on the Ames network sometimes need to reset their continuity. A personal breach is when an individual ship announces to the network: "I forgot who I am, let's start over from scratch." That is, it clears its own event log and sends an announcement to the network, asking all ships that have communicated with it to reset its networking information in their state. This makes it as though the ship was just started for the first time again, since everyone on the network has forgotten about it.

Personal breaches often fix connectivity issues, but should only be used as a last resort. Before performing a personal breach, look at alternative fixes in the [Ship Troubleshooting](../ship-troubleshooting) guide. Also reach out for help in `~/~dopzod/urbit-help`, or, failing that, in the `#ship-starting-support` channel in our [Discord server](https://discord.gg/n9xhMdz) to see if there is another option.

There are two types of personal breaches - one where your Ethereum ownership address
remains the same, and one where you are switching to a new Ethereum ownership
address. We make the emphasis about the Ethereum _ownership_ address as
changing your [proxies](@/glossary/proxies.md) does not require a breach.

If you will be keeping the same Ethereum ownership address and would like to perform a
personal breach, follow the steps below.

- Go to [bridge.urbit.org](https://bridge.urbit.org) and log into your identity.
- Click on `OS: Urbit OS Settings` at the bottom, then click `Reset Networking Keys`.
- Check the `Breach Continuity` box. Click `Reset Networking Keys`, and then click `Send Transaction` and wait for the progress bar to appear.
- Download your new keyfile following these instructions: [Generate your
  keyfile](@/using/operations/using-bridge.md#generate-your-keyfile).
- Proceed to [boot your ship](@/using/install.md#boot-your-planet) with the new keyfile.
- Delete your keyfile after successfully booting.
- Rejoin your favorite chat channels and subscriptions.

If you are switching to a new Ethereum ownerhsip address, you will necessarily be
performing a personal breach as well - there is no way to change the ownership
address without also breaching. The process here is slightly different.

- Go to [bridge.urbit.org](https://bridge.urbit.org) and log into your identity.
- Click on `ID: Identity and security settings` at the bottom, then click
  `Transfer this point`.
- Enter the new Ethereum address you would like to transfer ownership to.
  Click `Generate & Sign Transaction`, then click `Send Transaction` and wait
  for the progress bar to complete.
- Logout of your current session in Bridge by clicking `Logout` at the top, and
  then login to your new ownership address.
- From here, following the directions on how to [Accept your
  transfer](@/using/operations/using-bridge.md#accept-your-transfer), [Set your
  networking keys](@/using/operations/using-bridge.md#set-your-networking-keys),
  and [Generate your keyfile](@/using/operations/using-bridge.md#generate-your-keyfile).
- Proceed to [boot your ship](@/using/install.md#boot-your-planet) with the new keyfile.
- Delete your keyfile after successfully booting.
- Rejoin your favorite chat channels and subscriptions.

Performing a personal breach on your ship increments an integer value called
your ship's _life_ by one, which refers to your ship's [Azimuth](@/docs/tutorials/concepts/azimuth.md) _key
revision number_. This value is utilized by
Ames and Jael to ensure that you are
communicating with a ship created using its most recent set of keys. Your
ship's life is written at the end of the name of its keyfile, e.g.
`sampel-palnet-4.key`. Changing the Etherum address that holds the Urbit ID,
called _reticketing_, increments a number called the ship's _rift_ by one in
addition to incrementing your ship's life.
Rift refers to your ship's Azimuth _continuity number_.

You can check your current life and rift number by running the
`+keys our` generator in Dojo. You can inspect another ship's life and rift can be checked by
running `+keys ~sampel-palnet`.


## Network Breaches

A network breach is an event where all ships on the network are required to update to a new continuity era. Network breaches happen when an Arvo update is released that is too large to release over the air. The current continuity era is given by a value in Ames, our networking vane, that is incremented when a network breaches; only ships with the same such value are able to communicate with one another.

If a network breach is happening, follow the steps below.

- Delete your old Urbit binary.
- Delete or archive your old pier.
- Download the new Urbit binary by following the instructions in the [Install page](@/using/install.md).
- Create a new pier by booting your ship with your key, according to the instructions on the install page. (Note: You do _not_ need to use a new key to boot into a new continuity era.)
- Rejoin your favorite chat channels and subscriptions.
