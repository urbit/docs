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

