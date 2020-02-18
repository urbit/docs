+++
title = "Breach"
template = "doc.html"
+++

Continuity on the [Ames](../ames) network occasionally needs to be broken at
this early stage in order to correct a networking error or make major changes to
Arvo. These infrequent events are known as
**breaches** which either cause an individual ship to forget its network message
history, called a **personal breach**, or cause the entire network to forget its
history, called a **network breach**.

Personal breaches are always initiated by the user, frequently in response to a
connectivity error. Each one increments the _life_ of the ship by one, which is
an integer that represents how many personal breaches have been performed on
that ship.

Network breaches happen when a major Arvo revision that cannot be implemented 
via an [OTA update](../ota-updates.md) occurs. When this happens, a new binary
will need to be downloaded.

You can check your life number and the current rift number by typing `+keys`
into dojo and pressing Enter.

### Further Reading

- [Guide to breaches](@/docs/tutorials/guide-to-breaches.md): A more in-depth
  explanation of breaches, including how to perform a personal breach.
