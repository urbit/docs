+++
title = "chat"

template = "doc.html"
[extra]
category = "arvo"
+++

**Chat** is a suite of applications that handle "instant messaging"-style communication between ships.

A chat is a named collection of messages created by and hosted in a ship's chat-store, usually represented as `~ship-name/circle-name`. Most of Chat revolves around doing things with these chats.

Chats are subscribed to by some number of ships which are permitted to post and retrieve messages from the chat.

There are two "kinds" of chats, that use different permission modes:

 * A `channel` is a chat that is publicly readable and writable, with a blacklist for blocking.
 * A `village` is an invite-only chat.

### Further Reading

- [Messaging guide](@/using/operations/using-your-ship.md#messaging): A guide to using Chat from the command line.
