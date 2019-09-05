+++
title = "Azimuth Glossary"
weight = 4
template = "doc.html"
+++


Azimuth is a general-purpose public-key infrastructure (PKI) on the Ethereum blockchain, used as a platform for Urbit identities. You need an Azimuth identity to use the Arvo network. All identity-related operations are governed at this layer For more information, see the [Azimuth documentation](https://urbit.org/docs/concepts/azimuth/).

This glossary is intended to familiarize you with Azimuth-related terminology. To brush up on terminology related to Arvo, check out the [Arvo glossary](../arvo-glossary).

### Azimuth identity

An Azimuth identity, previously known as a _point_, is a non-fungible Ethereum token ([ERC-271](https://medium.com/@brenn.a.hill/noobs-guide-to-understanding-erc-20-vs-erc-721-tokens-d7f5657a4ee7)) that represents a digital identity. The ERC-721 standard, having been made specifically to provide a smart-contract interface for non-fungible assets, allows Azimuth identity ownership to be take advantage of existing third-party tools and systems.

#### Planet

An Azimuth identity to be used as a personal identity. Issued by stars.

#### Star

An Azimuth identity meant to be used as network infrastructure. Issued by galaxies, issues planets.

#### Galaxy

An Azimuth identity meant to be used as top-level network infrastructure, with governance powers. Issues stars.

### Bridge

A tool that's the primary way to interact with Azimuth and manage your identities. It can be accessed at bridge.azimuth.network.

### Master Ticket

Think of your master ticket as a very high-value password. The master ticket is the secret code from which all of your other secrets are derived. Technically, your master ticket is seed entropy. You should never share it with anyone, and store it very securely. This ticket can derive all of your other keys: your ownership key and all of the related proxies.

### Multipass

Multipass is a planned feature of an Azimuth point that can be used as a universal, real-world identity. It will be able to hold money and have packets routed to it. See this [blog post](https://urbit.org/posts/azimuth-as-multipass/) for more information.

#### Network Explorer

A Bridge-based interface for browsing Azimuth identities. You can do things such as see which ships are on which parties, and much more.

### Ownership Address

The Ethereum address that owns a point. As the owner, it can perform all possible operations for that point.

### Party

Also called an _invite tree_. A host starts a party and all individuals invited to this tree have the ability to share remaining, unclaimed invites with others; when an invite is sent to someone, they become a full member of the party and themselves have the ability to invite. So parties grow like a tree.

#### Party Host

The ship that generates the party. It's most often a star.

#### Guest List

The names of planets invited to the same party, as viewed by a party host.

#### Invite Cohort

The names of planets invited to the same party, as viewed by a guest/planet in a party.

#### Sending Invites

The action of giving someone a planet using Bridge.

#### Code

Activation code from an email that allows you to claim an invite

#### Birth Time

When a ship is claimed from an invite

### Passport

The Passport is a folder of files one downloads that contains the secrets of your point and should be stored securely. As long as you own the passport, you own the point. The master ticket is stored in the Passport.

### Proxy Address

An Ethereum address that's allowed to perform a specific subset of the operations the owner of the point can perform. Useful for allowing some control over a point while keeping its ownership address in cold storage. Below, the specific kinds of proxy addresses are listed.

#### Management Proxy Address

An Ethereum address used for managing a point. This means it can only configure public (aka networking) keys, and perform sponsorship-related operations (requesting sponsor changes & approving/rejecting those).
Use cases:
- Keeping this handy so you can put the ownership/master ticket in a super safe place
- Allowing someone to manage your ship (by setting/deriving networking keys, managing sponsorship)
- Allowing a smart contract to manage sponsorship ops (ie star service smart contract)

#### Network Keys

Your public key contains Authentication and Encryption addresses, and also have Revision, Continuity Era, and Crypto Suite versions. Resetting Network Keys increases the revision number on the key. A main use case would be if your Network Keys were compromised, so you can use your Management Address to re-derive your Network Keys to another revision.

#### Spawn Proxy Address

An Ethereum address used for spawning children of a point. It can only perform the spawn operation (creating child points) and can do nothing else.

Use cases:
- Keeping this handy so you can put the ownership/master ticket in a super safe place
- Allowing a smart contract to spawn on your behalf (delegated sending/invites, planet sale)

#### Voting Proxy Address
An Ethereum address used for voting as a point.

Use cases:
- Keeping this handy so you can put the ownership/master ticket in a super safe place
- Delegating your voting rights to someone else

#### Transfer Proxy Address

An Ethereum address that's allowed to transfer ownership of a point. Generally not used outside of transfers-in-progress. Using a transfer proxy allows one to give the recipient the power to take ownership of a point, rather than being given it. This "control check" is a strong safety mechanism commonly used in many (Ethereum-based) cryptographic assets.

### Sponsorship

Azimuth registers hierarchical dependence of identities on other identities; planets depend on stars, and stars depend on galaxies. Applications that use Azimuth can use this to set up things like network topology. In Arvo's case, the sponsor promises to provide software updates and peer discovery.
