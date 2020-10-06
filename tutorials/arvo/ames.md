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
This section summarizes the design of Ames. Beyond this section are deeper
elaborations on the concepts presented here.

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
identified in other vanes by a duct and over the wire by a `bone`:
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

## Packets

Ames datagram packets are handled as nouns internally by Arvo but as serial data
by Unix. In this section we describe how packets are formed, serialized, and relayed.

### Serial format

There is a 32-bit header followed by a variable width body.

#### Header

The 32-bit header is given by the following data, presented in order:

 - 3 bits: Ames `protocol-version`,
 - 20 bits: a checksum as a truncated insecure hash of the body, done with
   [`+mug`](@/docs/reference/library/2e.md#mug),
 - 2 bits: the bit width of the sender address encoded as a 2-bit enum,
 - 2 bits: the bit width of the receiver address encoded as a 2-bit enum,
 - 1 bit: whether the packet is encrypted or not,
 - 4 bits: unused.
 
 Every packet sent between ships is encrypted except for self-signed attestation packets from 128-bit comets.
 
#### Body

The body is of variable length and consists of three parts in this order:

 - The `@p` of the sending ship,
 - The `@p` of the receiving ship,
 - The payload, which is the [`+jam`](@/docs/reference/libary/2p.md#jam) (i.e. serialization) of the noun `[origin content]`.
 
 `origin` is the IP and port of the original sender if the packet was proxied
 through a relay and null otherwise. `content` is a noun that is either an encrypted ack or an
 encrypted message fragment, unless it is a comet attestation packet in which
 case it is unencrypted. `content` is always 1kB in size or less.
 
 The sender and receiver live outside of the jammed data section to simplify
 packet filtering for the interpreter.
 
### Packeting

When Ames has a message to be sent it must first determine how many packets are
required to send the message. To do this, it first `+jam`s the
message, producing an atom. Ames checks how large the atom is, and if it is
bigger than a kilobyte it will split it into packets whose payloads are 1 kB or
less. It then numbers each one - this is message 17, packet 12, this is message
17, packet 13, etc, so that when the receiver receives these packets it knows
which number they are. Finally it encrypts each individual packet and enqueues
them to be sent along their stated flow. 

Network packets aren't always received in order, so this numbering is important
for reconstruction, and also packets may get lost. So Ames does transmission
control (the TC in TCP) to solve this problem. It makes sure that all packets
eventually get through, and when the other side gets them it can put them in the
correct order. If Ames doesn't get an ack on a packet then it will resend it
until it does. The timing on resending packets is called congestion control and
works in the same fashion as TCP, namely exponential backoff.

Once all packets are received, the receiving Ames decrypts them, deserializes
them, and puts them back together to form a message.
 
### Acks

In this section we discuss acks, short for acknowledgements, which are small
packets attesting that packets were successfully received. Ames makes use of
acks maintain synchrony between two communicating parties. Nacks are 'negative
acknowledgments' and are used when something goes wrong. This topic is more
complicated and so discussion of them is deferred.

Every message (i.e. a `%plea` or a `%boon`) is split up by Ames into some number
of _fragments_ that are 1kB in size or less. The fragments are then encrypted
and encapsulated into
packets and sent along a flow. The message will be considered successfully
received once the sender has received the appropriate set of acks in response,
defined as follows.

There are two types of acks: fragment acks and message acks. Acks are
not considered messages, and thus are not `%plea`s or `%boon`s, and so are not
required to appear in a particular order. Given a message split into N
fragments, the sender of the message will expect N-1 fragment acks followed
by exactly one message ack. This is because the receiver
will send a fragment ack for the first N-1 packets it received, and what
would have been the final fragment ack will instead be a message ack.

Acks are considered to be part of the flow in which that `%plea` or
`%boon` lives, as the packets containing their fragments and packets acking the
receipt of those packets are considered to be what makes up a given message.
Thus a message-level ack must be received before the next message on the flow
can begin.

#### Ack packets

The contents of a given ack packet are deterministic. The `content` (i.e. the
encrypted portion of the packet) of a fragment ack is obtained by encrypting the `+jam` of the
following noun:

```hoon
[our-life her-life bone message-num fragment-num]
```
Each datum in this noun is an atom with the aura `@ud` or an aura that nests
under `@ud`.

Here, `our-life` refers to the [`life`](@/docs/glossary/breach), or revision
number, of the acking ship's networking keys, and `her-life` is the `life` of
the ack-receiving ship's networking keys. `bone` is an opaque number identifying the flow, `message-num` denotes the number of the
message in the flow identified by `bone`, and
`fragment-num` denotes the number of the fragment of the message identified by
`message-num` being acked. 

A message ack is an extended fragment ack that is obtained by encrypting the
`+jam` of the following noun:

```hoon
[our-life her-life bone message-num fragment-num ok=? lag=@dr]
```
`ok` is a flag that is set to `%.y` for a message ack and `%.n` for a message
nack. We defer discussion of nacks. In the future, `lag` will be used to
describe the time it took to process a message, but for now it is always zero.

### Packet relaying

Here we describes how the Ames network relays packets. We ignore all details
about UDP, which occurs at a lower layer than Ames.

When a ship first contacts another ship, it may only know its `@p`, but an IP
address and port are necessary for peer-to-peer communication to occur.
Thus the initial correspondence between two ships, or additional correspondence
following a change in IP or port of one of the parties, will need to be relayed
by an intermediary that knows the IP and port of the receiving ship.

For now packet relaying is handled entirely by galaxies. Every galaxy is
responsible for knowing the IP and port of every planet underneath it. In the
future, galaxies will only need to know the star sponsoring a planet, and stars
will be responsible for the final step of the relay.

The following diagram summarizes the packet creation and forwarding process.

<div style="text-align:center">
<img src="https://media.urbit.org/docs/arvo/datagram-long.png">
</div>

We elaborate on the above diagram.

A typical relay will look something like this: `~bacbel-tagfeb` wishes to
contact `~worwel-sipnum` but does not know the IP address and port at which
`~worwel-sipnum` resides. Both planets live under `~zod`, which knows both of
their IP and port numbers by virtue of being the galaxy that both live under.

So `~bacbel-tagfeb` sends a packet addressed to `~worwel-sipnum` to `~zod`.

The packet has the following format:
 - The standard Ames header described in [header](#header), where the checksum
   is the `+mug` of the body, and the sender and receiver ship types are `01`,
   denoting that the sender and receiver are planets. The remainder of the
   packet is the body.
 - The body of this packet will be the `@p` of the
sender `~bacbel-tagfeb`, followed by the `@p` of the receiver `~worwel-sipnum`,
followed by the payload.
 - The payload of this packet will be the `+jam` of `[origin content]`. `origin`
for this initial packet will be `~`, which implies that the packet is
originating from the sender. `content` is the `+jam` of the message, encrypted
using a Diffie-Hellman symmetric key obtained with the private key of
`~bacbel-tagfeb` and the public key of `~worwel-sipnum`.

`~zod` receives the packet and reads the body. It sees that it is not the
intended recipient of the packet, and so gets ready to forward it to
`~worwel-sipnum`. First, it [`+cue`s](@/docs/reference/library/2p.md#cue)
(deserializes) the payload and changes the `origin` to the IP and port of
`~bacbel-tagfeb`. Then it `+jam`s `[origin content]` to form a new payload, and
`+mug`s that payload to get a new checksum. It replaces the old payload and
checksum with the new, and then sends the packet along to `~worwel-sipnum`.

Once `~worwel-sipnum` processes the packet, it will know the IP and port of
`~bacbel-tagfeb` since `~zod` included it when it forwarded the packet and so
will send an ack packet directly to `~bacbel-tagfeb`. Communication between the
two ships will now be direct until one of them changes their IP address, port, or networking keys.


## The Serf and the King

Urbit's functionality is split between the two binaries `urbit-worker` (sometimes
called the Serf) and `urbit-king` (sometimes called the King). This division of
labor is currently not well-documented outside of the [Vere documents](@/docs/tutorials/vere/_index.md), but we summarize it here.

In short, the Serf is the Nock runtime and so keeps track of the current state
of Arvo as a Nock noun and updates the state by `%poke`ing it with nouns, and
then informs the King of the new state. The King manages snapshots of the Arvo
state and handles I/O with Unix, among other things. The Serf only ever talks to
the King, while the King talks with both the Serf and Unix.

### Ames

The King has several submodules, one of them being an Ames I/O submodule. This
submodule is responsible for wrapping outgoing Ames packets as UDP packets, and
looking at incoming UDP packets handed to it by Unix to ensure that they are
valid Ames packets. It also maintains an incoming and outgoing packet queue.

This division is summarized in the following diagram, describing how
`~bacbel-tagfeb` requests a subscription to the `recipes` notebook of
`~worwel-sipnum` in the Publish app.

<div style="text-align:center">
<img src="https://media.urbit.org/docs/arvo/packet.png">
</div>

Ames, as a part of Arvo, handles `+jam`ming, packetizing, encryption, and
forming Ames packets. Once it is ready to send an Ames packet, it `%give`s to
Unix a `%send` `gift` containing that packet. This will be a Nock noun
containing the `@tas` `%send` as well as the serialized packet.

"Unix", in this case, is actually the King. The King receives the `%send`
instruction, wraps the packet contained within as a UDP packet, and queues the
UDP packet contained. Once it is time to send it (which will be determined by
congestion control), it will go ahead and forward the packet to Unix's
networking interface, at which point it is no longer controlled by any part of Urbit.

Now the receiving King is handed a UDP packet by Unix. The King removes the UDP
wrapped and checks to see that it has received a valid Ames packet. If so, it
`+cue`s the payload and wraps it as a `%hear` `note` and passes it to the Serf.

