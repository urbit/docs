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

### Packet format

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
17, packet 13, etc., so that when the receiver receives these packets it knows
which number they are. Finally it encrypts each individual packet and enqueues
them to be sent along their stated flow. 

Network packets aren't always received in order, so this numbering is important
for reconstruction, and also packets may get lost. So Ames does transmission
control (the TC in TCP) to solve this problem. It makes sure that all packets
eventually get through, and when the other side gets them it can put them in the
correct order. If Ames doesn't get an ack on a packet then it will resend it
until it does. The logic for determining how many packets to send or re-send at what time is performed by an Ames-specific variant of TCP's "NewReno" congestion control algorithm.

As each packet in a message is received, Ames decrypts it and stores the message fragment.  Once it's received every packet for a message, Ames concatenates the fragments back into a single large atom and uses `+cue` to deserialize that back into the original message noun.


 
### Acks and Nacks

In this section we discuss acks and nacks. In Ames, an "ack", short for "acknowledgment", is a small packet attesting that a piece of information (either a packet or a whole message) was received. Ames makes use of
acks to maintain synchronization between two communicating parties. Nacks are 'negative
acknowledgments' and are used when something goes wrong.

#### Acks

Every message (i.e. a `%plea` or `%boon`) is split up by Ames into some number
of _fragments_ that are 1kB in size or less. The fragments are then encrypted
and encapsulated into
packets and sent along a flow. The message will be considered successfully
received once the sender has received the appropriate set of acks in response,
defined as follows.

There are two types of acks: fragment acks and message acks. Acks are
not considered messages, and thus are not `%plea`s or `%boon`s. Given a message split into N
fragments, the sender of the message will expect N-1 fragment acks followed
by exactly one message ack (ignoring any duplicate packets, which are idempotent
from the perspective of the application). This is because the receiver
will send a fragment ack for the first N-1 packets it received, and what
would have been the final fragment ack will instead be a message ack.

Acks are considered to be part of the flow in which that `%plea` or
`%boon` lives, as the packets containing their fragments and packets acking the
receipt of those packets are considered to be what makes up a given message.
Thus a message-level ack must be received before the next message on the flow
can begin. The full story is more complicated than this; see the section on
[flows](#flows).


#### Nacks

A nack indicates a negative acknowledgement to a `%plea`, meaning that the
requested action was not performed.

`%boon`s and naxplanations are never nacked.
Individual packets are also never nacked, only complete `%plea` messages are.
Whether a malformed packet causes a `%plea` to be nacked depends on its content.
In the case of an incorrect checksum or a failure to decrypt then Ames drops the
packet and it is as though it never happened. However, if the packet does
decrypt and has invalid ciphertext (i.e. something other than a jammed
`$shutpacket` data structure), then Ames will nack the whole `%plea` since that
indicates that the peer is misbehaving. Eventually Ames should also present a
warning to the user that the peer is untrustworthy.

A nack will be accompanied by a naxplanation, which is a special type of`%boon`
that uses its own `bone` (see [flows](#flows)). Ames won't give the vane that requested the
initial `%plea` a nack until it also receives the naxplanation, which it will send to
the vane as a `%done` gift. Naxplanations may only be acked, never nacked.
Furthermore, naxplanations can only ever be sent as a rejection of a `%plea` -
the receiver will never both perform a `%plea` and return a naxplanation.

#### (N)ack packets

A fragment ack's contents (before encryption) are a pure function of the
following noun:
```hoon
[our-life her-life bone message-num fragment-num]
```
This means all re-sends of an ack packet will be bitwise identical to each other, unless one of the peers changes its encryption keys.

Each datum in this noun is an atom with the aura `@ud` or an aura that nests
under `@ud`.

Here, `our-life` refers to the [`life`](@/docs/glossary/breach), or revision
number, of the acking ship's networking keys, and `her-life` is the `life` of
the ack-receiving ship's networking keys. `bone` is an opaque number identifying
the flow. `message-num` denotes the number of the
message in the flow identified by `bone`. `fragment-num` denotes the number of
the fragment of the message identified by `message-num` that is being acked. 

A message (n)ack is a different kind of ack that is obtained by encrypting the
`+jam` of the following noun:

```hoon
[our-life her-life bone message-num ok=? lag=@dr]
```
`ok` is a flag that is set to `%.y` for a message ack and `%.n` for a message
nack. In the future, `lag` will be used to
describe the time it took to process a message, but for now it is always zero.


### Flows

Flows are asymmetric communication channels along which two ships send and
receive packets, and all Ames packets are part of some flow.

To create a new flow, a ship sends a
`%plea` to another ship. Only the creator of the flow may send `%plea`s, and the
other party may only send `%boon`s. In this sense flows are asymmetric.

The sequence of `%plea`s in a flow is totally ordered, though
the packets which make them up need not be. `%boon`s are totally ordered in the
same fashion, but there is not a coordinated ordering between `%plea`s and
`%boon`s in a given flow beyond the implicit one arising from the fact that a
`%boon` is always a response to a `%plea`. A `%plea` can give rise to zero, one,
or many `%boon`s.

Inside of Ames, each flow has four sequential opaque `@ud`s
called bones that are unique to that flow. Thus the flow itself is often
referred to by its first bone. Each bone is a one-way street
for packets to travel along, so e.g. acks to packets making up a `%plea` are
sent along a different bone than the `%plea`.

We give an example of such a partition. Let flow 12 be a flow between `~bacbel-tagfeg` and `~worwel-sipnum` with
`~bacbel-tagfeg` as the `%plea` sender. Then bones 12-15 are associated with the
flow, and the types of packets for each bone are:

 - bone 12, `%plea`s and acks to `~worwel-sipnum`,
 - bone 13, `%boon`s and (n)acks to `~bacbel-tagfeg`,
 - bone 14, acks of naxplanations to `~worwel-sipnum`,
 - bone 15, naxplanations to `~bacbel-tagfeg`.

Each bone is handled separately by congestion control, and this is one reason
for their segregation. For example, say a two-packet `%plea` is sent on bone 12,
with `~bacbel-tagfeg` requesting to join a group on `~worwel-sipnum`.
Then `~worwel-sipnum` can ack the first packet on bone 13, and then send a nack
on bone 13 as well. A nack by itself contains no information as to why the nack
happened. Then `~worwel-sipnum` can also send a naxplanation on bone 15 saying
to `~bacbel-tagfeg` that they cannot join the group, to which an ack is received
on bone 14.

Another reason to separate bones is to avoid race conditions. If
`~worwel-sipnum` and `~bacbel-tagfeg` attempt to start a flow with each other at
the same time we do not wish there to be a conflict when they receive each
others' packets. Flipping the last bit of the bone based on whether a packet is
an ack or a message fragment allows for `~worwel-sipnum` to create flow 8 with
`~bacbel-tagfeg` without coming into conflict with the flow 8 `~bacbel-tagfeg`
created for `~worwel-sipnum`.

`%plea`s and `%boon`s are handled on separate bones so that e.g. sending a large
`%boon` doesn't stop an additional `%plea` from being received. It is also
simply cleaner to make each bone one-way. Acks and nacks are very small packets
as well as integral to controlling the total orderings on `%plea`s and `%boon`s
and so they are included on these bones as well.

Naxplanations can potentially be very large, as they often contain things like stack
traces or other crash reports. Thus it is undesirable to have them share a bone
with `%boon`s and create congestion there. So naxplanations have their own bone,
and so do acks to packets that make up a naxplanation, as well as the
message-level naxplanation ack.

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

To prepare, `~bacbel-tagfeb` forms a Diffie-Hellman symmetric key with their own
private key and the public key of `~worwel-sipnum`, obtained via Jael. Then
`~bacbel-tagfeb` sends a packet addressed to `~worwel-sipnum` to `~zod`.

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
using the Diffie-Hellman symmetric key that was previously computed.

`~zod` receives the packet and reads the body. It sees that it is not the
intended recipient of the packet, and so gets ready to forward it to
`~worwel-sipnum`. First, it [`+cue`s](@/docs/reference/library/2p.md#cue)
(deserializes) the payload and changes the `origin` to the IP and port of
`~bacbel-tagfeb`. Then it `+jam`s `[origin content]` to form a new payload, and
`+mug`s that payload to get a new checksum. It replaces the old payload and
checksum with the new, and then sends the packet along to `~worwel-sipnum`.

Once `~worwel-sipnum` processes the packet, it will know the IP and port of
`~bacbel-tagfeb` since `~zod` included it when it forwarded the packet. Thus
`~worwel-sipnum` will send an ack packet directly to `~bacbel-tagfeb`, unless a
NAT and/or firewall prevents a direct peer-to-peer connection, in which case
`~zod` will contineu to relay packets. Absent these factors preventing a
peer-to-peer connection, communication between the two ships will now be direct
until one of them changes their IP address, port, or networking keys.


## The Serf and the King

Urbit's functionality is split between the two binaries `urbit-worker` (sometimes
called the Serf) and `urbit-king` (sometimes called the King). This division of
labor is currently not well-documented outside of the [Vere documents](@/docs/tutorials/vere/_index.md), but we summarize it here.

In short, the Serf is the Nock runtime and so keeps track of the current state
of Arvo as a Nock noun and updates the state by `%poke`ing it with nouns, and
then informs the King of the new state. The King manages snapshots of the Arvo
state and handles I/O with Unix, among other things. The Serf only ever talks to
the King, while the King talks with both the Serf and Unix.

### Ames I/O submodule

The King has several submodules, one of them being an Ames I/O submodule. This
submodule is responsible for wrapping outgoing Ames packets as UDP packets, and
unwrapping incoming UDP packets into Ames packets and forwarding them to the
worker. It also maintains an incoming packet queue.

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
instruction, wraps the packet contained within as a UDP packet, and immediately
hands it off the the Unix network interface to be sent.

Now the receiving King is handed a UDP packet by Unix. The King removes the UDP
wrapper, `+jam`s the `lane` on which it heard the packet, and delivers the packet
to the Ames vane as an atom by copying the bytes it heard on the UDP port.
