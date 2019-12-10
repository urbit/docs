+++
title = "Bridge"
template = "doc.html"
[extra]
category = "azimuth"
+++

**Bridge** is a client made for interacting with [Azimuth](../azimuth). It's the recommended way to receive, send, and manage your Urbit identity, and it's by far the easiest way to generate the [keyfile](../keyfile) required to get your [ship](../ship) onto the [Arvo](../arvo) network. Most Bridge functions are accessed by "logging in" to an identity's ownership address or one of its [proxy addresses](../proxies). It's accessed at [bridge.urbit.org](https://bridge.urbit.org/).

Below are some important functions of Bridge.

#### View a Point

This function allows you to view the public information of any Urbit identity, such as its ownership and proxy public keys. If you are viewing an identity that's controlled by the Ethereum address that you've accessed with Bridge, then at least some of the actions below will be available to you depending on the type of identity and what address you accessed it with.

#### Actions

- **Issue child:** Spawn a child from a [galaxy](../galaxy) or a [star](../star).
- **Transfer:** Send the Urbit identity to another Ethereum address.
- **Accept incoming transfer:** If someone is trying to send you an Urbit identity, you must use this action to receive it.
- **Cancel outgoing transfer:** Cancel a transfer that you initiated before the recipient has accepted it.
- **Generate Arvo keyfile:** Generate the keyfile to boot a ship with your Urbit identity.
- **Change spawn proxy:** Assign your spawn proxy to a new Ethereum address.
- **Change management proxy:** Assign your transfer proxy to a new Ethereum address.
- **Set network keys:** Set new authentication and encryption keys used on your Arvo ship. Will change your Arvo keyfile.
- **Generate Arvo keyfile:** Gets the file you need to get your ship on the Arvo network with your Urbit identity.

### Further Reading

- [bridge.urbit.org](https://bridge.urbit.org/): The Bridge website.
- [Using Bridge](@/using/operations/using-bridge.md): A guide to starting out with Bridge.
- [The Azimuth concepts page](@/docs/tutorials/concepts/azimuth.md): A more in-depth explanation of our identity layer.
