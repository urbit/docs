+++
title = "chat"

template = "doc.html"
[extra]
category = "arvo"
insert_anchor_links = "none"
+++

**Chat** is a suite of [Gall](../gall) applications that handle "instant
messaging"-style communication between [ships](../ship).

A chat is a named collection of messages created by and hosted in a ship's
`chat-store`. Most of Chat revolves around doing things with these chats.

Chats are subscribed to by some number of ships which are permitted to post and
retrieve messages from the chat.

There are two "kinds" of chats:

 * A `channel` is a chat that exists as part of a group that is readable and writable by
   members of the group. Messages are sent to the chat's host ship, and the host
   ship distributes those messages to members of the chat. Therefore, if you
   plan to host a chat, you should ensure that your ship has high uptime.
 * A `DM` is a direct message from one ship to another, visible to no other
   ship, and not part of a group. Messages may be sent while offline, but the
   other party will not receive them until both ships are online simultaneously.

### Further Reading

- [Landscape](../landscape) includes a web interface for using Chat.
- [Messaging guide](@/using/operations/using-your-ship.md#messaging): A guide to
  using Chat from the command line.
