+++
title = "Breach"
template = "doc.html"
[extra]
category = "arvo"
+++

Continuity on the [Ames](../ames) network occasionally needs to be broken
(though with increasing rarity) in order to correct a networking error. These
infrequent events are known as **breaches**, which cause an individual ship to
forget its network message history.

Breaches are always initiated by the user, frequently in response to a
connectivity error. The easiest way to do this is with [Bridge](../bridge).
There are two types of personal breaches: changing networking keys, and changing
the Urbit ID ownership address.

Historically, there were also "network breaches", which happened when a major
Arvo revision that could not be implemented via an [OTA update](../ota-updates)
occured. Network breaches were effectively breaching every ship on the network
at once. The most recent network breach occurred in December 2020, and we expect
it to be the final one.

### Further Reading

- [Guide to breaches](@/using/id/guide-to-breaches.md): A more in-depth
  explanation of breaches, including how to perform a personal breach.
- [Ship Troubleshooting](@/using/os/ship-troubleshooting.md): General instructions on getting your ship to work, which includes network connectivity issues.
