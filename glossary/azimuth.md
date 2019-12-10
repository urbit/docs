+++
title = "Azimuth"
weight = 1
template = "doc.html"
+++

**Azimuth** is Urbit's identity layer, built as a suite of smart contracts on the Ethereum blockchain. It is Urbit's method of securing digital identities that are required to use the [Arvo](../arvo) peer-to-peer network, without the need for a central authority. Azimuth identities exist as non-fungible tokens, which are owned by Ethereum addresses and can be transferred between such addresses. Identities can use the [claims](../claims) contract to make assertions – real-world or otherwise – about their owner.

The primary way to interact with Azimuth and to manage your identities is through our [Bridge](bridge.urbit.org) application. Bridge is a front-end for [Ecliptic](../ecliptic), the Azimuth contract that's used to perform actions on the blockchain.

There are a limited number of Azimuth identities which results in identities having value. This allows for identities to function as reputation primitives, since such scarcity creates an economic incentive for identities to remain static and to keep the network friendly. Undesirable behavior – spamming, scamming, and malware-spreading - will generally result in a [censure](../censure) from [galaxies](../galaxy) and [stars](../star), marking the bad actor.

It should be noted that Azimuth isn't built just for Arvo. It can be used as an identity system for other projects.

### Further Reading

- [The Azimuth concepts page](@/docs/tutorials/concepts/azimuth.md): A more in-depth explanation of Azimuth, including information the storage of Urbit identities.
- [Install instructions](@/docs/using/install.md): Guide to installing Urbit, which includes instructions on booting with your Urbit identity.
- [Understanding Urbit ID](@/understanding-urbit/urbit-id.md)
