+++
title = "Azimuth"
weight = 4
template = "doc.html"
aliases = ["/docs/learn/azimuth"]
+++
Azimuth is a general-purpose public-key infrastructure (PKI) on the Ethereum blockchain, used as a platform for _Urbit identities_. You need such an identity to use the Arvo network.

The primary way to interact with Azimuth is through our [Bridge](https://github.com/urbit/bridge) application and the node libraries that it depends on, [azimuth-js](https://github.com/urbit/azimuth-js) and [urbit-key-generation](https://github.com/urbit/urbit-key-generation). Take a look at the source and play around, or see [Getting Started](@/using/install.md).

## Arvo vs. Azimuth

Urbit is a project, not a single computer system. It has multiple components: Arvo, the operating system; and Azimuth, the identity system. Let's compare them.

**Arvo** is an operating system that provides the software for a personal server. These personal servers together constitute the peer-to-peer Arvo network. To make this network work on the social level, Arvo is built to work with a system of scarce and immutable identities.

**Azimuth** is the public-key infrastructure built to be such a system. A suite of smart-contracts on the Ethereum blockchain, Azimuth determines which Ethereum addresses own which Azimuth identities, called _Urbit identities_, or just _identities_. All identity-related operations, such as transfers, are governed at this layer. But Azimuth isn't built strictly for Arvo -- it could be used as a generalized identity system for other projects.

These otherwise-parallel systems meet when you want to connect to the Arvo network. Your Arvo personal server, called your _ship_, needs to be able to prove cryptographically that it is who it says it is. This proof comes in the form of a keyfile, derived from your identity, that you use to start your ship.

A metaphor might help illustrate the relationship between these two systems: the Arvo network is the neighborhood that you live in; Azimuth is the bank vault that stores the deed to your house.

## The Urbit HD Wallet

Owners of Urbit identities need safeguards that allow for the use of Urbit without jeopardizing cryptographic ownership of their assets. Toward this end, we created the **Urbit Hierarchical Deterministic (HD) Wallet** for the storage of identities. The Urbit HD Wallet is not one key-pair, but a system of related key-pairs that each have distinct powers, from setting networking keys for communicating in the Arvo network to transferring ownership of identities.

The Urbit HD Wallet's derivation paths have a hierarchical structure, so that
keys with different powers can be physically separated. A "master ticket" can
[re-derive the entire wallet](#hd-wallet-generation) in case of loss. The
encryption and authentication keys that identities ships use to sign messages
within the network are also derived from the wallet.

Another HD wallet option you may wish to utilize to store your Urbit are hardware
wallets such as Trezor or Ledger. We compare this method to the Urbit HD wallet
[below](#hardware-hd-wallet).

Urbit HD wallets are composed of the following items, which are each assigned to their own individual Ethereum key-pairs.

### Master Ticket

Think of your master ticket like a very high-value password. The master ticket is the secret code from which all of your other keys are derived. Technically, your master ticket is seed entropy. You should never share it with anyone, and store it very securely. This ticket can derive all of your other keys: your ownership key and all of the related proxies.

### Ownership Address

An ownership address has all rights over the assets deeded to it. These rights are on-chain actions described and implemented in the Ecliptic, Azimuth's suite of governing smart-contracts.

### Proxies

Proxy addresses allow you to execute non-ownership related actions like spawning child identities, voting, and setting networking keys without jeopardizing the keys you've designated with ownership rights. Setting proxy rights is optional, but it is recommended for on-chain actions you will execute more frequently.

- **Management Proxy**

  Can configure or set Arvo networking keys and conduct sponsorship related
  operations.

- **Voting Proxy**

  Galaxies only. Galaxies are the part of the galactic senate, and this means
  they can cast votes on new proposals including changes to the Ecliptic.

- **Spawn Proxy**

  For stars and galaxies only. Can create new child identities.

### HD wallet generation

Your Urbit HD wallet is generated from a `@q` seed called `T`, which looks
something like `~sampel-ticket-bucbel-sipnem`. This is the string known as your
"Master Ticket" that you input into Bridge to sign in. This is put through a
series of algorithms that ultimately generate your keys and the Ethereum addresses at which they are stored.

![](https://media.urbit.org/fora/proposals/UP-8.jpg)

First, your `@q` is converted into a numeric value `E` as an intermediary step
by adding [salt](https://en.wikipedia.org/wiki/Salt_(cryptography)). Then by
adding additional salts, `E` is converted into a set of BIP39 seed phrases -
these are 24 word mnemonic sequences used to generate Ethereum wallets. You end up
with one seed phrase for each proxy associated with your ship, and these seed
phrases are then used to generate Ethereum wallets.

One of the wallets will store your Azimuth point, an [ERC-721](#erc-721) token,
which will be known as your ownership address. Bridge then automatically uses
your ownership address to assign the other proxies to the other wallets
generated.

### ERC-721

Most Ethereum tokens use the ERC-20 standard for smart contracts. Urbit identities
are, however, essentially different from most Ethereum tokens, due to identities not
being fungible. Since any two stars will handle social-networking realities in a
different way, they will carry a different reputation. identities are to houses as
tokens are to gold.

The ERC-721 standard, having been made specifically to provide a smart-contract
interface for non-fungible assets, serves our needs well. This is the standard
that we use for deeding Urbit identities.

Identities, and all of their blockchain operations, are governed by the Ecliptic.
The Ecliptic is an Ethereum smart-contract that governs identity state and the
ownership, spawn, management, and voting rights affiliated with your identities.

For the technical implementation details, take a look at Azimuth's
[Github repository](https://github.com/urbit/azimuth).
