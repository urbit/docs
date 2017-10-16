---
navhome: /docs/
next: true
sort: 1
title: Technical overview
---

# Technical overview

Urbit is a clean-slate system software stack defined as a
deterministic computer.  An encrypted P2P network, `%ames`, runs
on a functional operating system, Arvo, written in a strict,
typed functional language, Hoon, which compiles itself to a
combinator interpreter, Nock, whose spec gzips to 340 bytes.

## Architectural overview

A deterministic computer?  Urbit's state is a pure function of
its event history.  In practice it uses a memory checkpoint and
an append-only log.  Every event is a transaction; Urbit is an
ACID database and a single-level store.  Urbit runs on Unix now,
but it's easy to imagine on a hypervisor or even bare metal.

A purely functional OS?  Urbit is pure -- no code inside it can
make system calls or otherwise affect the underlying platform.
Instead, the top-level event function defines an I/O protocol.
It maps an input event and the current state to a list of output
actions and the subsequent state.  In Hoon:

```
$-([event state] [(list action) state])
```

### Nock

Nock is a sort of nano-Lisp without syntax, symbols or lambdas.
Most Lisps are one-layer: they create a practical language by
extending a theoretically simple interpreter.  The abstraction is
simple and the implementation is practical; there is no actual
codebase both simple and practical.  Hoon and Nock are two
layers: Hoon compiles itself to pure Nock.  Since Urbit is
defined in Nock, not Hoon, we can upgrade Hoon over the air.

The Nock data model is especially trivial.  A *noun* is an atom
or a cell.  An atom is any unsigned integer.  A cell is an
ordered pair of nouns.  Nouns are acyclic and expose no pointer
equality test.

### Hoon

Hoon is a strict combinator language that avoids mathematical
theory and notation.  It aims at a mechanical, imperative feel.
Hoon uses ASCII digraphs instead of keywords; there are no
user-level macros.  The type system infers only forward and does
not use unification, but is not much weaker than Haskell's.  The
compiler and inference engine is about 2000 lines of Hoon.

### Arvo

Arvo is an event-driven OS written in Hoon.  It can upgrade
itself and everything inside it over the network.  The Arvo
kernel proper is 500 lines of Hoon, which implements a typed
event system with explicit call-stack structure.  Arvo ships
with modules that provide P2P networking (`%ames`), a revision-
control system (`%clay`), a web client/server (`%eyre`), a
functional build system (`%ford`), and an application engine
`(%gall)`.

### Ames

Ames, the Urbit network, is an encrypted P2P protocol over UDP.
Its address space is semi-decentralized; 64-bit addresses are
hierarchically distributed, 128-bit addresses are self-created.
Addresses (or *plots*) are rendered in a phonemic syntax for
memorability.  The scarcity of short plots helps control spam and
other Sybil attacks.  The short plot hierarchy is also reused as
a supernode routing system for NAT traversal.

### Dojo and talk

Urbit ships with two default applications: a REPL or shell
`:dojo`, and a distributed user-level message-bus `:talk`.
`:talk` under the hood resembles NNTP; to the user, it looks like
a self-hosted Slack or persistent IRC.

The full Urbit stack (compiler, standard library, kernel,
modules, and applications) is about 25,000 lines of Hoon.
Urbit is patent-free and MIT licensed.
