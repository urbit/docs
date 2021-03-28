+++
title = "Breach"
template = "doc.html"
[extra]
category = "arvo"
+++

Continuity on the [Ames](../ames) network occasionally needs to be broken at
this early stage in order to correct a networking error or make major changes to
Arvo. These infrequent events are known as
**breaches** which either cause an individual ship to forget its network message
history, called a **personal breach**, or cause the entire network to forget its
history, called a **network breach**.

Personal breaches are always initiated by the user, frequently in response to a
connectivity error. The easiest way to do this is with [Bridge](../bridge).
There are two types of personal breaches: changing private keys, and changing
the Urbit ID ownership address. Each one increments the _life_ number of the ship by one, which is
an integer that represents how many personal breaches have been performed on
that ship. Transferring the ID to a new address will also increase the _rift_
number of the ship in addition to the life number.

You can check your life and rift number by typing `+keys our`
into dojo and pressing Enter.

Network breaches happen when a major Arvo revision that cannot be implemented
via an [OTA update](../ota-updates) occurs. When this happens, a new binary
will need to be downloaded, and your ship's [pier](../pier) needs to be moved to the
directory containing the new binary.

### Further Reading

- [Guide to breaches](@/using/id/guide-to-breaches.md): A more in-depth
  explanation of breaches, including how to perform a personal breach.
- [Ship Troubleshooting](@/using/os/ship-troubleshooting.md): General instructions on getting your ship to work, which includes network connectivity issues.
