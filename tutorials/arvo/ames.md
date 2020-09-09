+++
title = "Ames"
weight = 2
template = "doc.html"
aliases = ["/docs/learn/arvo/ames/"]
+++
Our networking protocol.

Ames is the name of both our network and the vane that communicates
over it. When Unix receives a packet over the correct UDP port, it pipes
it straight into Ames for handling. Also, all packets sent over the
Ames network are sent by the Ames vane. Apps and vanes may use
Ames to directly send messages to other ships. In general, apps use
[Gall](@/docs/tutorials/arvo/gall.md) and [Clay](@/docs/tutorials/arvo/clay.md)
to communicate with other ships rather than using Ames
directly, but this isn't a requirement. Of course, Gall and Clay use
Ames behind the scenes to communicate across the network. Jael is the only other
vane to utilize Ames.

Ames includes several significant components. Although the actual
crypto algorithms are defined in `zuse`, they're used extensively in
Ames for encrypting and decrypting packets. Congestion control and
routing is handled entirely in Ames. Finally, the actual Ames
protocol itself, including how to route incoming packets to the correct
vane or app, is defined in Ames.

## Technical Overview
Ames extends [Arvo's](@/docs/tutorials/arvo/arvo.md) `%pass`/`%give` `move` semantics across the network.

Ames receives packets as Arvo events and emits packets as Arvo
effects.  The runtime is responsible for transferring the bytes in
an Ames packet across a physical network to another ship.

The runtime tells Ames which physical address a packet came from,
represented as an opaque atom.  Ames can emit a packet effect to
one of those opaque atoms or to the Urbit address of a galaxy
(root node), which the runtime is responsible for translating to a
physical address.  One runtime implementation sends UDP packets
using IPv4 addresses for ships and DNS lookups for galaxies, but
other implementations may overlay over other kinds of networks.

A local vane can pass Ames a `%plea` request message.  Ames
transmits the message over the wire to the peer ship's Ames, which
passes the message to the destination vane.

Once the peer has processed the `%plea` message, it sends a
message-acknowledgment packet over the wire back to the local
Ames.  This "ack" can either be positive to indicate the request was
processed, or negative to indicate the request failed, in which
case it's called a "nack".  (Don't confuse Ames nacks with TCP
nacks, which are a different concept).

When the local Ames receives either a positive message-ack or a
combination of a nack and "naxplanation" (explained in more detail
below), it gives an `%done` `move` to the local vane that had
requested the original `%plea` message be sent.

A local vane can give Ames zero or more `%boon` response messages in
response to a `%plea`, on the same duct that Ames used to pass the
`%plea` to the vane.  Ames transmits a `%boon` over the wire to the
peer's Ames, which gives it to the destination vane on the same
duct the vane had used to pass the original `%plea` to Ames.

`%boon` messages are acked automatically by the receiver Ames.  They
cannot be nacked, and Ames only uses the ack internally, without
notifying the client vane that gave Ames the `%boon`.

If the Arvo event that completed receipt of a `%boon` message
crashes, Ames instead sends the client vane a `%lost` message
indicating the `%boon` was missed.

`%plea` messages can be nacked, in which case the peer will send
both a message-nack packet and a naxplanation message, which is
sent in a way that does not interfere with normal operation.  The
naxplanation is sent as a full Ames message, instead of just a
packet, because the contained error information can be arbitrarily
large.  A naxplanation can only give rise to a positive ack --
never ack an ack, and never nack a naxplanation.

Ames guarantees a total ordering of messages within a "flow",
identified in other vanes by a duct and over the wire by a "bone":
an opaque number.  Each flow has a FIFO (first-in-first-out) queue of `%plea` requests
from the requesting ship to the responding ship and a FIFO queue
of `%boon`'s in the other direction.

Message order across flows is not specified and may vary based on
network conditions.

Ames guarantees that a message will only be delivered once to the
destination vane.

Ames encrypts every message using symmetric-key encryption by
performing an elliptic curve Diffie-Hellman using our private key
and the public key of the peer.  For ships in the Jael PKI
(public-key infrastructure), Ames looks up the peer's public key
from Jael.  Comets (128-bit ephemeral addresses) are not
cryptographic assets and must self-attest over Ames by sending a
single self-signed packet containing their public key.

When a peer suffers a continuity breach, Ames removes all
messaging state related to it.  Ames does not guarantee that all
messages will be fully delivered to the now-stale peer.  From
Ames's perspective, the newly restarted peer is a new ship.
Ames's guarantees are not maintained across a breach.

A vane can pass Ames a `%heed` `$task` to request Ames track a peer's
responsiveness.  If our `%boon`'s to it start backing up locally,
Ames will give a `%clog` back to the requesting vane containing the
unresponsive peer's urbit address.  This interaction does not use
ducts as unique keys.  Stop tracking a peer by sending Ames a
`%jilt` `$task`.

Debug output can be adjusted using `%sift` and `%spew` `$task`'s.

## Packet structure

Ames datagram packets are handled as nouns internally by Arvo but as serial data
by Unix. Here we document their serial structure.
For further information, see `+encode-packet` and `+decode-packet` in `ames.hoon`.

There is a 32-bit header followed by a variable width body.

### Header

The 32-bit header is given by the following data, presented in order:

 - 3 bits: Ames `protocol-version`,
 - 20 bits: a checksum as a truncated insecure hash of the body, done with
   `+mug`,
 - 2 bits: the bit width of the sender address encoded as a 2-bit enum,
 - 2 bits: the bit width of the receiver address encoded as a 2-bit enum,
 - 1 bit: whether the packet is encrypted or not,
 - 4 bits: unused.
 
 Every packet sent between ships is encrypted except for self-signed attestation packets from 128-bit comets.
 
### Body

The body is of variable length and consists of three parts in this order:

 - The `@p` of the sending ship,
 - The `@p` of the receiving ship,
 - The payload, which is the `+jam` (i.e. serialization) of the noun `[origin content]`.
 
 `origin` is the IP and port of the original sender if the packet was proxied
 through a relay and null otherwise. `content` is a noun that is either an encrypted ack or an
 encrypted message fragment, unless it is a comet attestation packet in which
 case it is unencrypted.
 
 The sender and receiver live outside of the jammed data section to simplify
 packet filtering for the interpreter.
 

## Journey of a Packet

In this section we follow a packet through its entire journey, originating from
the Ames vane of ship A and ending in the Ames vane of ship B.

This journey is broken into several stages:

1. Ames receives a `%plea` note.
1.5 Does encryption happen here?
2. Serf A gives the note to King A (in what form? does it jam the payload?)k
3. King A checks that it is a valid Ames packet and wraps the Ames packet in a UDP packet (what does this look like?) and
   give it to its Ames I/O submodule to send
4. UDP packet is sent to the receiving IP address (how is this determined? along
   some port?)
5. King B receives a UDP packet on socket ? via the Ames submodule. It checks
   that it is a valid Ames packet


A `%plea` `note` is given by `[vane=@tas =path payload=*]`, where
`vane` is the destination vane on the remote ship, `path` is the internal
route on the receiving ship `payload` is the semantic message content.
