+++
title = "Replay"

template = "doc.html"
[extra]
category = "arvo"
insert_anchor_links = "none"
+++

**Replay** is how [Vere](../vere) computes the state of a ship's [Arvo](../arvo) instance from the [event log](../eventlog) after a ship reboots. In order to avoid replaying the entire event log, Replay takes a snapshot of the current state of the ship approximately once every ten minutes. Then when a ship reboots, Replay loads the most recent snapshot and replays events from the event log up to the most recent event.

### Further Reading

- [The Vere tutorial](@/docs/tutorials/vere/_index.md): An in-depth technical guide to Vere.
