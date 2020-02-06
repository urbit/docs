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
Gall and Clay to communicate with other ships rather than using Ames
directly, but this isn't a requirement. Of course, Gall and Clay use
Ames behind the scenes to communicate across the network. These are
the only two vanes that use Ames.

Ames includes several significant components. Although the actual
crypto algorithms are defined in zuse, they're used extensively in
Ames for encrypting and decrypting packets. Congestion control and
routing is handled entirely in Ames. Finally, the actual Ames
protocol itself, including how to route incoming packets to the correct
vane or app, is defined in Ames.

## Technical Overview

Ames extends Arvo's `%pass`/`%give` move semantics across the network.

A "forward flow" message, which is like a request, is passed to
Ames from a local vane.  Ames transmits the message to the peer's
Ames, which passes the message to the destination vane.

Once the peer has processed the "forward flow" message, it sends a
message acknowledgment over the wire back to the local Ames.  This
"ack" can either be positive or negative, in which case we call it a
"nack".  (Don't confuse Ames nacks with TCP nacks, which are a
different concept).

When the local Ames receives either a positive message ack or a
combination of a nack and nack-trace (explained in more detail
below), it gives a `%done` move to the local vane that had
requested the original "forward flow" message be sent.

A "backward flow" message, which is similar to a response or a
subscription update, is given to Ames from a local vane.  Ames
transmits the message to the peer's Ames, which gives the message
to the destination vane.

Ames will give a `%memo` to a vane upon hearing the message from a
remote. This message is a "backward flow" message, forming one of
potentially many responses to a "forward flow" message that a
local vane had passed to our local Ames, and which local Ames had
relayed to the remote.  Ames gives the `%memo` on the same duct the
local vane had originally used to pass Ames the "forward flow"
message.

Backward flow messages are acked automatically by the receiver.
They cannot be nacked, and Ames only uses the ack internally,
without notifying the client vane.

Forward flow messages can be nacked, in which case the peer will
send both a message-nack packet and a nack-trace message, which is
sent on a special diagnostic flow so as not to interfere with
normal operation.  The nack-trace is sent as a full Ames message,
instead of just a packet, because the contained error information
can be arbitrarily large.

Once the local Ames has received the nack-trace, it knows the peer
has received the full message and failed to process it.  This
means if we later hear an ack packet on the failed message, we can
ignore it.

Also, due to Ames's exactly-once delivery semantics, we know that
when we receive a nack-trace for message `n`, we know the peer has
positively acked all messages `m+1` through `n-1`, where `m` is the last
message for which we heard a nack-trace.  If we haven't heard acks
on all those messages, we apply positive acks when we hear the
nack-trace.
