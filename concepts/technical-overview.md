+++
title = "Technical overview"
weight = 1
template = "doc.html"
description = "A more in-depth description of the entire Urbit stack."
+++
Urbit is a clean-slate software stack designed to implement an encrypted P2P
network of general-purpose personal servers.  Each server on this network is a
deterministic computer called an 'urbit' that runs on a Unix-based virtual
machine.

The current Urbit stack includes (among other things):

- Arvo: the functional operating system of each urbit, written in Hoon.
- Hoon: a strictly typed functional programming language whose standard library
  includes a Hoon-to-Nock compiler.
- Nock: a low-level combinator language whose formal specification fits readably on a t-shirt.
- Vere: a Nock interpreter and Unix-based virtual machine that mediates between
  each urbit and the Unix software layer.

## Anatomy of a personal server

Your urbit is a deterministic computer in the sense that its state is a pure
function of its event history.  Every event in this history is a
[transaction](https://en.wikipedia.org/wiki/Transaction_processing); your
urbit's state is effectively an [ACID database](https://en.wikipedia.org/wiki/ACID).

Because each urbit is deterministic we can describe its role appropriately in
purely functional terms: it maps an input event and the old urbit state to a
list of output actions and the subsequent state.  This is the Urbit transition
function.

```
<input event, old state> -> <output actions, new state>
```

For example, one input event could be a keystroke from the terminal, say
`[enter]` after having already typed `(add 2 2)`; and an output action could be
to print in the terminal window the resulting value of a computation performed
when the user hit `[enter]`, in this case `4`.  The input event is stored in the
urbit's event history.

Events always start from outside of your urbit, whether they're local to the
computer running the urbit (e.g., a keystroke in the terminal) or they originate
elsewhere (e.g., a packet received from another urbit).  When an event is
processed, various parts of the urbit state can be modified before the resulting
list of output actions is returned.

Can output actions from your urbit cause side-effects in the outside world?
The answer had better be "yes," because a personal server without side effects
isn't useful for much.  In another sense the answer had better be "no," or else
there is a risk of losing functional purity; your urbit cannot _guarantee_ that
the side effects in question actually occur.  What's the solution?

Each urbit is
[sandboxed](https://en.wikipedia.org/wiki/Sandbox_%28computer_security%29) in a
virtual machine, Vere, which runs on Unix.  Code running in your urbit cannot
make Unix system calls or otherwise directly affect the underlying platform.
Strictly speaking, internal urbit code can only change internal urbit state; it
has no way of sending events outside of its runtime environment.  Functional
purity is preserved.

In practical terms, however, you don't want your urbit to be an impotent
[brain in a vat](https://en.wikipedia.org/wiki/Brain_in_a_vat).  That's why
Vere also serves as the intermediary between your urbit and Unix.  Vere observes
the list of output events, and when external action is called for makes the
appropriate system calls itself.  When external events relevant to your urbit
occur in the Unix layer, Vere encodes and delivers them as input events.

### Arvo

Arvo is a purely functional, [non-preemptive](https://en.wikipedia.org/wiki/Cooperative_multitasking)
OS, written in Hoon, that serves as the event manager of your urbit.
It can upgrade itself from over the network without downtime.  The Arvo kernel
proper is quite simple -- it's only about 600 lines of code, excluding its
various modules.

The Urbit transition function is implemented in Arvo.  Upon being 'poked' by
Vere with the pair of `<input event, state>`, Arvo directs the event to the
appropriate OS module.  The result of each Vere 'poke' is a pair of
`<output events, new state>`.  Events are typed, and each has an explicit
call-stack structure indicating the event's source module in Arvo.

Arvo modules are also called 'vanes'.  Arvo's vanes are:

- Ames: defines and implements Urbit's encrypted P2P network protocol, as well
  as Urbit's identity protocol.
- Behn: manages timer events for other vanes.
- Clay: global, version-controlled, and referentially-transparent file system.
- Dill: terminal driver.
- Eyre: HTTP web client and server.
- Ford: typed functional build system.
- Gall: application sandbox and manager.
  - Dojo (app): Shell and Hoon REPL.
  - Talk (app): Chat client.

### Hoon

Hoon is a strictly typed functional programming language that compiles itself
to Nock and is designed to support higher-order functional programming without
requiring knowledge of category theory or other advanced mathematics.  Haskell
is fun but it isn't for everybody.

Hoon aspires to a concrete, imperative feel.  To discourage the creation of
write-only code, Hoon forbids user-level macros and uses ASCII digraphs instead
of keywords.  The type system infers only forward and does not use unification,
but is not much weaker than Haskell's.  The compiler and inference engine is
about 3000 lines of Hoon.

### Nock

Nock is a low-level [homoiconic](https://en.wikipedia.org/wiki/Homoiconicity)
combinator language.  It's so simple that its [specification](../../nock/definition)
fits on a t-shirt.  In some ways Nock resembles a nano-Lisp but its ambitions
are more narrow.  Most Lisps are one-layer: a practical language is to be
created by extending a theoretically simple interpreter.  The abstraction is
simple and the implementation is practical.  Unfortunately it's far more difficult
to enforce both simplicity and practicality in an actual Lisp codebase.  Hoon
and Nock are two layers: Hoon, the practical layer, compiles itself to Nock, the
simple layer.  Your urbit runs in Vere, which includes a Nock interpreter, so it
can upgrade Hoon over the network without downtime.

The Nock data model is quite simple.  Every piece of data is a 'noun'.  A noun
is an atom or a cell.  An atom is any unsigned integer.  A cell is an ordered
pair of nouns.  Nouns are acyclic and expose no pointer equality test.

### Vere

Vere is the Nock runtime environment and Urbit VM.  It's written in C, runs on
Unix, and is the intermediate layer between your urbit and Unix.  As noted
earlier, Unix system calls are made by Vere, not Arvo; Vere must also encode
and deliver relevant external events to Arvo.  Vere is also responsible for
implementing jets and maintaining the persistent state of each urbit.

In principle, Vere keeps a comprehensive log of every event from the time you
initially booted your urbit.  What happens if the physical machine loses power
and your urbit's state is 'lost' from memory?  When your urbit restarts it will
replay its entire event history and totally recover its latest state from
scratch.

In practice, event logs become large and unwieldy over time.  Periodically a
snapshot of the permanent state is taken and the logs are pruned.  You're still
able to rebuild your state in case of power outage, down to the last keystroke.

Vere is not essential to the Urbit stack; one can imagine using Urbit on a
hypervisor, or even bare metal.  One member of the community is even working on
an independent implementation of Urbit using Graal/Truffle on the JVM.

The Urbit stack (compiler, standard library, kernel, modules, and applications,
but excluding Vere) is about 30,000 lines of Hoon.  Urbit is patent-free and MIT
licensed.

### Azimuth

Azimuth is a general-purpose public-key infrastructure (PKI) on the Ethereum
blockchain, used as a decentralized ledger for Urbit identities that we call
*points*. Having a point is necessary to use the Urbit network, which makes it
important to have a neutral ledger to determine who owns what.

Azimuth is not, however, part of the Urbit stack. Azimuth is a parallel system
that be used as a generalized identity system for other projects. Azimuth
"touches" the Urbit ecosystem when a point is used to boot a virtual computer
on the Urbit network for the first time. When that happens, the point considered
*linked* to Azimuth and the point’s full powers are available for use. Once a
point is linked, it cannot be unlinked.

A metaphor might make the relationship between these two systems to understand:
Azimuth is the bank vault that stores the deed to your house. The Urbit network
is the neighborhood that you live in.
