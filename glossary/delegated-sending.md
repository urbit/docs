+++
title = "Delegated Sending"

template = "doc.html"
[extra]
category = "azimuth"
insert_anchor_links = "none"
+++

The **Delegated Sending** [Azimuth](../azimuth) contract is a way that a [star](../star ) distributes [planets](../planet). After a star configures the Delegated Sending contract as its [spawn proxy](../proxies) it can give invites to planets, and those invitees can subsequently send additional planets from that star to their friends, and pass on this invite power indefinitely. This contract keeps track of those operations in the form of the [Invite Tree](../invite-tree), so the relationship between inviters and invitees is publicly known.
