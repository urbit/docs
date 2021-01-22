+++
title = "Behn"
template = "doc.html"
[extra]
category = "arvo"
+++

**Behn** is the timing [vane](../filesystem). It allows for applications to schedule events, which are managed in a simple priority queue. For example, [Clay](../clay), the Urbit filesystem, uses Behn to keep track of time-specific file requests. [Eyre](../eyre), the Urbit web vane, uses Behn for timing-out HTTP sessions.

Behn is located in `/home/sys/vane/behn.hoon` within [Arvo](../arvo).

### Further Reading

- [The Behn tutorial](@/docs/tutorials/arvo/behn.md): A technical guide to the Behn vane.
