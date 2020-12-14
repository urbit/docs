+++
title = "Creating an Invite Pool"
weight = 9
template = "doc.html"
+++

If you're a star owner, you have the ability to create **invite pools**. These
invite pools let you give your friends a piece of the network in the form of a
planet. This document will give you an explanation of how to create an invite
pool and how to share it with your friends using our tool
[Bridge](https://bridge.urbit.org).

For more general tips on using your star, check out the [Star and Galaxy
Operations page](https://urbit.org/using/operations/stars-and-galaxies/).

## Anatomy of an Invite Pool

An invite pool is a set of planet invites that can be distributed via email or
URL; each invite is worth one planet when redeemed. An invite pool can be as big
as you'd like, providing that you have enough planets left to spawn. All invite
pools must be created by a star, but they must be given to a planet. If you're
interested in how this works technically, take a look at the
[DelegatedSending.sol
contract](https://github.com/urbit/azimuth/blob/master/contracts/DelegatedSending.sol).

Keep in mind that all planets will have access to the invite pool until the
invite pool is exhausted.

For example: As `~marzod`, I spawn `~wicdev-wisryt` and give it an invite pool
of 100 planets. `~wicdev-wisryt` can now send an invite to a friend at
galen@tlon.io. When Galen claims his planet (`~ravmel-ropdyl`), `~ravmel-ropdyl`
can now invite his friend — or 99 of them. `~wicdev-wisryt` may also continue to
use the invite pool, as can anybody they invite.

## How To Create an Invite Pool

Giving your friends a piece of Urbit only takes a few minutes: send an invite
pool to a planet, and then that planet can email an invite to a friend (or
friends)

1. Log into Bridge using your ownership address for your star.

2. Change the spawn proxy of your star to
   `0xF7908Ab1F1e352F83c5ebc75051c0565AEaea5FB`. This is a contract address that
   will handle the spawning of planets for invitees.

3. Get the `@p` (like `~poldec-tonteg`) of the planet to whom you'd like to give
   access to the invite pool. It can be one you control or a friend's. It does
   not have to be a planet sponsored by your star.

3. Click "Manage Invite Pools" to assign an invite pool to the planet. You may
   receive a notification that you need to assign your spawn proxy to the
   address of the Delegated Sending contract. This is so that the contract can
   send invites on your behalf when the recipient claims them. This address is
   `0xF7908Ab1F1e352F83c5ebc75051c0565AEaea5FB`, which is also displayed in Bridge.

![](https://media.urbit.org/docs/invite-pool/browser-point.png)

4. Enter the `@p` of the planet and the number of invites you'd like to assign to them.

![](https://media.urbit.org/docs/invite-pool/browser-create-pool.png)

Once the transaction is complete, the planet will have access to the invite pool.

## How to Send an Invite

1. Log into Bridge using the planet assigned an invite pool above using the
   planet's Master Ticket or ownership address.
   
2. Under "Invite Group", click "Add Members" to unroll the invitation UI.

3. Select either "Email" or "URL".

4. If you selected "Email", enter the email address(es) of those you wish to
   invite to the dialog box. You may add more than one email address. Click "Add to
   Invite Group" when finished, and wait for the transaction to complete. Your
   friend(s) will get an email shortly with your gift of an identity for life!

   If you selected "URL", click "Generate Invite URL" to create an invitation URL
   that you can then share.

## FAQ

Q. What happens if the spawn proxy address is changed away from
`0xF7908Ab1F1e352F83c5ebc75051c0565AEaea5FB` after an invite pool has been
created? Will outstanding invite pool(s) still function?
A. They won't. Existing balances will remain, but Bridge (and `azimuth-js`) won't
consider any of the invites from that star usable, and trying to send one of
their planets anyway will result in a failed transaction.

Q. Can a star create more than one invite pool at a time?
A. Yes, a star can allow any given planet to send any number of invites
independently from one another.

Q. Can an invite pool be revoked?
A. Yes, this may be done by assigning zero invites to a planet that had been
previously been given access to an invite pool.

Q. Can a delegated planet have more than one invite pool assigned to it?
A. Yes, as a planet, multiple stars can give you invites to use.

Q. What can you do if you send an invite to an email address by mistake?
A. Planets that have been sent but not yet claimed live at the
ownership address of the star that created the invite pool. Log into Bridge
using the ownership address for the star and you will be able to cancel the
pending invite. Once an invite has been accepted, nothing can be done!
