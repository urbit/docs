+++
title = "chat-cli"

template = "doc.html"
[extra]
category = "arvo"
+++

**Chat**, also referred to as `:chat-cli`, is an application that handles communication between ships.

There are four types of chats (lowercase). Each is a named collection of messages created by and hosted on a ship's [Hall](../hall), usually represented as `~ship-name/circle-name`. Most of Chat revolves around doing things with these chats.

Circles are subscribed to by some number of ships which are permitted to post and retrieve messages from the circle.

There are several default types of chats.

 * A channel is a chat that is publicly readable and writable, with a blacklist for blocking.
 * A village is an invite-only chat.
 * A journal is publicly readable and privately writable, with a whitelist for authors.
 * A mailbox is readable by its owner and publicly writable, with a blacklist for blocking.

### Further Reading

- [Messaging guide](@/using/operations/using-your-ship.md#messaging): A guide to using Chat.
