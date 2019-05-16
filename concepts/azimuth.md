+++
title = "Azimuth"
weight = 4
template = "doc.html"
description = "An explanation of the Urbit identity layer."
+++
Azimuth is a general-purpose public-key infrastructure (PKI) on the Ethereum blockchain, used as a platform for Urbit identities that we call _points_. You need a point to use the Arvo network.

The primary way to interact with Azimuth is through our [Bridge](https://github.com/urbit/bridge) application and the node libraries that it depends on, azimuth-js and keygen-js. Take a look at the source and play around or see [Getting Started](/docs/getting-started).

## Arvo vs. Azimuth

Urbit is a project, not a single computer system. It has three components: Arvo, the operating system; Azimuth, the identity system; and Aegean, the pattern for creating software experiences for individual Urbit communities. Let's compare the first two.

**Arvo** is an operating system that provides the software for a personal server. These personal servers together constitute the peer-to-peer Arvo network. To make this network work on the social level, Arvo is built to work with a system of scarce and immutable identities.

**Azimuth** is the public-key infrastructure built to be such a system. A suite of smart-contracts on the Ethereum blockchain, Azimuth determines which Ethereum addresses own which Azimuth identities, called _points_. All point-related operations, such as transfers, are governed at this layer. But Azimuth isn't built strictly for Arvo -- it could be used as a generalized identity system for other projects.

These otherwise-parallel systems meet when you want to connect to the Arvo network. Your Arvo personal server, called your _ship_, needs to be able to prove cryptographically that it is who it says it is. This proof comes in the form of a keyfile, derived from your point, that you use to start your ship.

A metaphor might help illustrate the relationship between these two systems: the Arvo network is the neighborhood that you live in; Azimuth is the bank vault that stores the deed to your house.

## Why Urbit Uses a Blockchain

The Arvo network is composed of personal servers: instances of the Arvo operating system, called ships, that communicate as peers.

Every ship has an associated secure identity, called a point, that it needs to connect to the network. Your point is your name and your network address. Each point has associated authentication and encryption keys for networking. Think of a point as an IP address, a domain name, and a PGP key-pair.

There are a limited number of points and, as you might expect, scarcity gives points value. This means that bad actors – spammers, scammers, and malware-spreaders – can be made economically unviable. Points being immutable allows for reputation systems to be built on top, keeping the network friendly and giving users information to help them decide who to treat as a trusted peer.

At the user level, having one identity for your digital life means that all the services that you trust recognize you. You no longer need to worry about managing dozens of different logins. When you're using Arvo, everything you do is "verified" in the sense that it links back to your point.

But wait! We need some way to secure these identities. To that end, we have built the Azimuth identity layer on the Ethereum blockchain to determine which PKI. As mentioned above, it's separate from and parallel to the Arvo network.

In theory, our ecosystem doesn't need a blockchain, because Urbit identities are more like real estate than currency: they change hands slowly. A low-friction, zero-trust solution to the double-spend problem isn't an economic necessity for transactions such as ours. So we could have the Arvo network run its own key-signing system. But, since Azimuth identities are valuable, you don't want to put them in an self-hosted PKI that isn't generally recognized as secure. Arvo is still young, we'd prefer to use an existing system for people to secure their property.

Moving the Urbit land registry to Ethereum is an easy and obvious solution to this problem. We chose Ethereum over Bitcoin because the former is built for computation Landscape the latter is not. We need a computational blockchain to enforce the specific rules of the Urbit identity registry.

For more background on the decision to use the Ethereum blockchain, check out [these](https://urbit.org/posts/essays/urbit-and-the-blockchain/) [two](https://urbit.org/posts/essays/bootstrapping-urbit-from-ethereum/) posts.

## The Urbit HD Wallet

Owners of Azimuth points need safeguards that allow for the use of Urbit without jeopardizing cryptographic ownership of their assets. Toward this end, we created the **Urbit Hierarchical Deterministic (HD) Wallet** for the storage of points. The Urbit HD Wallet is not one key-pair, but a system of related key-pairs that each have distinct powers, from setting networking keys for communicating in the Arvo network to transferring ownership of points.

The Urbit HD Wallet's derivation paths have a hierarchical structure, so that keys with different powers can be physically separated. A \"master ticket" can re-derive the entire wallet in case of loss. The encryption and authentication keys that points ships use to sign messages within the network are also derived from the wallet.

Urbit HD wallets are composed of the following items, which are each assigned to their own individual Ethereum key-pairs.

### Master Ticket

Think of your master ticket like a very high-value password. The master ticket is the secret code from which all of your other keys are derived. Technically, your master ticket is seed entropy. You should never share it with anyone, and store it very securely. This ticket can derive all of your other keys: your ownership key and all of the related proxies.

### Ownership Address

An ownership address has all rights over the assets deeded to it. These rights are on-chain actions described and implemented in the Ecliptic, Azimuth's suite of governing smart-contracts.

### Proxies

Proxy addresses allow you to execute non-ownership related actions like spawning child points, voting, and setting networking keys without jeopardizing the keys you've designated with ownership rights. Setting proxy rights is optional, but it is recommended for on-chain actions you will execute more frequently.

- **Management Proxy**

  Can configure or set Arvo networking keys and conduct sponsorship related
  operations.

- **Voting Proxy**

  Galaxies only. Galaxies are the part of the galactic senate, and this means
  they can cast votes on new proposals including changes to the Ecliptic.

- **Spawn Proxy**

  For stars and galaxies only. Can create new child points.

![](https://media.urbit.org/fora/proposals/UP-8.jpg)


Most Ethereum tokens use the ERC-20 standard for smart contracts. Azimuth points
are, however, essentially different from most Ethereum tokens, due to points not
being fungible. Since any two stars will handle social-networking realities in a
different way, they will carry a different reputation. Points are to houses as
tokens are to gold.

The ERC-721 standard, having been made specifically to provide a smart-contract
interface for non-fungible assets, serves our needs well. This is the standard
that we use for deeding Azimuth points.

Points, and all of their blockchain operations, are governed by the Ecliptic.
The Ecliptic is an Ethereum smart-contract that governs point state and the
ownership, spawn, management, and voting rights affiliated with your points.

For the technical implementation details Azimuth, take a look at the
[Github repo](https://github.com/urbit/azimuth).
