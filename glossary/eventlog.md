+++
title = "Event Log"

template = "doc.html"
[extra]
category = "arvo"
+++

The **event log** of a [ship](../ship) is a totally ordered list of every single [Arvo](../arvo) event that ship has undergone. The state of a ship is a pure function of the event log.

The event log is maintained by [Vere](../vere).

If the physical machine loses power and your urbit's state is 'lost' from memory, when your urbit restarts it will replay its entire event log and recover its last valid state from scratch.

In practice, event logs become large and unwieldy over time. Periodically a snapshot of the permanent state is taken and the logs are pruned. You're still able to rebuild your state in case of power outage down to the last keystroke. This is due to the practice of persistence.

Persistence, in the context of storing data in a computer system, means that data is stored in a non-volatile manner and that input must be recorded before the output result is performed. Thus, every event must be written to disk - or must be _persisted_ - before the event effects actually take place.

The initial entries of the event log are created during the bootstrap sequence contained in a [Pill](../pill).

### Further Reading

- [Pier](../pier): The directory on disk which contains the ship's state.
