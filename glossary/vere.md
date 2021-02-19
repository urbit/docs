+++
title = "Vere"

template = "doc.html"
[extra]
category = "hoon-nock"
+++

**Vere**, pronounced "Vair", is the [Nock](../nock) runtime environment and Urbit virtual machine. Vere is written in C, runs on Unix, and is the intermediate layer between your urbit and Unix. Unix system calls are made by Vere, not Arvo; Vere must also encode and deliver relevant external events to [Arvo](../arvo). Vere is also responsible for implementing jets and maintaining the persistent state of each urbit (computed as a pure function of its [event log](../eventlog) with [Replay](../replay)). It also contains the I/O drivers for Urbit’s vanes, which are responsible for generating events from Unix and applying effects to Unix.

When you boot your [ship](../ship), Vere passes your [Azimuth](../azimuth) [keyfile](../keyfile) into the Arvo state, allowing a connection to the [Ames](../ames) network.

Vere consists of two processes that communicate via a socket: a daemon process in charge of managing I/O channels, and a worker process that acts as a Nock interpreter that is instructed by the daemon process. Currently the worker is written in C, but a new worker written in Java, called [Jacque](../jacque), is under development.

### Further Reading

- [The Technical Overview](@/docs/systemoverview/technical-overview.md)
- [The Vere tutorial](@/docs/vere/_index.md): An in-depth technical guide to Vere.
