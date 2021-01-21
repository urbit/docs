+++
title = "Proxies"

template = "doc.html"
[extra]
category = "azimuth"
insert_anchor_links = "none"
+++

**Proxies** are Ethereum addresses in the [Urbit HD Wallet](../hdwallet) system that have limited powers. They are lower-powered "siblings" of the ownership key, which has the sole power to transfer the assigned Urbit identity. Using [Bridge](../bridge), you can change the Ethereum addresses used for your proxies.

There are three types of proxy.

- **Management Proxy**

The management proxy can configure or set Arvo networking keys and conduct sponsorship-related operations.

- **Voting Proxy**

The voting proxy can cast votes on behalf of its assigned point on new proposals, including changes to [Ecliptic](../ecliptic). The voting proxy is unique to [galaxies](../galaxy), since only power galaxies have seats in the Senate.

- **Spawn Proxy**

Creates new child points given Ethereum address. For [stars](../stars) and [galaxies](../galaxy) only.


### Further Reading

- [Azimuth glossary page](../azimuth): The glossary entry for Azimuth.
- [The Azimuth concepts page](@/docs/tutorials/concepts/azimuth.md): A more in-depth explanation of Azimuth, including information the storage of Urbit identities.
