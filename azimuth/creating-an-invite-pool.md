+++
title = "Creating an Invite Pool"
weight = 3
template = "doc.html"
+++

If you’re a star owner, you have the ability to create **invite pools**. These invite pools let you give your friends a piece of the network in the form of planets. This document will give you an explanation of how to create an invite pool and how to share it with your friends using our tool [Bridge](bridge.urbit.org).

## Anatomy of an Invite Pool

An invite pool is a set of planet invites that can be distributed via email; each invite is worth one planet when redeemed. An invite pool can be as big as you’d like, providing that you have enough planets left to spawn. All invite pools must be created by a star, but they must be given to a planet. If you’re interested in how this works technically, take a look at the [DelegatedSending.sol contract](https://github.com/urbit/azimuth/blob/master/contracts/DelegatedSending.sol).

Keep in mind that all planets will have access to the invite pool until the invite pool is exhausted.

For example: As `~marzod`, I spawn `~wicdev-wisryt` and give it an invite pool of 100 planets. `~wicdev-wisryt` can now send an invite to a friend at galen@tlon.io. When Galen claims his planet (`~ravmel-ropdyl`), `~ravmel-ropdyl` can now invite his friend — or 99 of them.

## How to Invite Friends

Giving your friends a piece of Urbit only takes a few minutes: send an invite pool to a planet, and then that planet can email an invite to a friend (or friends)

1. Log into Bridge using your ownership address for your star.

2. Get the name (like `~poldec-tonteg`) of the planet to whom you'd like to give invites, it can be one you control or a friend's.

3. Click “Manage Invite Pools” to assign an invite pool to the planet. You may receive a notification that you need to assign your spawn proxy to the address of the Delegated Sending contract. This is so that the contract can send invites on your behalf when the recipient claims them.

![](https://storage.cloud.google.com/media.urbit.org/docs/invite-pool/browser-point.png)

4. Enter the planet name and the number of invites you’d like to assign them.

![](https://storage.cloud.google.com/media.urbit.org/docs/invite-pool/browser-create-pool.png)

5. If you control the planet that you gave the invite pool to, it should be accessible from the Bridge homepage. Click the Planet, then “Invite” to create invites for your friends.

![](https://storage.cloud.google.com/media.urbit.org/docs/invite-pool/browser-invite.png)

Your friend will get an email shortly with your gift of an identity for life!
