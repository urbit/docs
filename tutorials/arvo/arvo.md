+++
title = "Arvo"
weight = 1
template = "doc.html"
aliases = ["/docs/learn/arvo/arvo/"]
+++
Arvo, also called Urbit OS, is our operating system.

# Introduction

## Overview

This article is intended to provide a thorough summary of all of the most
important aspects of the Arvo kernel and how this functionality gives life to
the ambitions of the Urbit platform. We work on two levels: a conceptual level
that should be useful to anybody interested in how Arvo works, and a more
technical level intended for those that intend to write software for Urbit.

The [Urbit white paper](https://media.urbit.org/whitepaper.pdf) is a good
companion to this document, and some segments are direct quotes or paraphrases, but it should be noted that some parts of it are now either out of date or not yet implemented.

## Prerequisites

The conceptual section titled [What is Arvo?](#what-is-arvo-) can be understood
without knowing Hoon, the Urbit programming language. The technical section
titled [The kernel](#the-kernel) will require Chapter One of the [Hoon
tutorial](@/docs/tutorials/hoon/_index.md) for full understanding, and some
material from Chapter Two will be helpful as well. At the bare minimum, we
presume that the reader has read through the [Technical
Overview](@/docs/tutorials/concepts/technical-overview.md). Lastly, we apply the
knowledge learned in this document with a hands-on tutorial to investigate a [stack
trace](#stack-trace-tutorial) of what happens when a timer is set in Arvo.

We also suggest to the reader to peruse the [glossary](@/docs/glossary/_index.md) before diving into this article. It will provide the initial scaffolding that you will be able to gradually fill in as you read this article and go deeper into the alternate universe of computing that is Urbit.


# Table of Contents

- [What is Arvo?](#what-is-arvo)
  * [An operating function](#an-operating-function)
    + [Determinism](#determinism)
    + [Event log](#event-log)
  * [Solid state interpreter](#solid-state-interpreter)
    + [Over-the-air updates](#over-the-air-updates)
    + [ACID Database](#acid-database)
    + [Single-level store](#single-level-store)
    + [Non-preemptive](#non-preemptive)
- [The kernel](#the-kernel)
  * [Overall structure](#overall-structure)
    + [Formal interface](#formal-interface)
    + [Types](#types)
    + [Arvo cores](#arvo-cores)
  * [The state](#the-state)
  * [Vanes](#vanes)
- [Stack trace tutorial](#stack-trace-tutorial)

# What is Arvo?

Arvo is a
[non-preemptive](#non-preemptive)
operating system purposefully built to create a new, peer-to-peer internet
whereby users own and manage their own data. Despite being an operating system,
Arvo does not replace Windows, Mac OS, or Linux. It is better to think of the
user experience of Arvo as being closer to that of a web browser despite being a
fully fledged OS. As such, Arvo is generally run inside a virtual machine, though in theory it could be run on bare metal.

Urbit is a “browser for the server side”; it replaces multiple developer-hosted web services on multiple foreign servers, with multiple self-hosted applications on one personal server. Every architectural decision for Arvo (and indeed, the entire Urbit stack) was made with this singular goal in mind. Throughout this document, we connect the various concepts underlying Arvo with this overarching goal.

Arvo is designed to avoid the usual state of complex event networks: event spaghetti. We keep track of every event's cause so that we have a clear causal chain for every computation. At the bottom of every chain is a Unix I/O event, such as a network request, terminal input, file sync, or timer event. We push every step in the path the request takes onto the chain until we get to the terminal cause of the computation. Then we use this causal stack to route results back to the caller.

Unlike any other popular operating system, it is possible for a single human to understand every aspect of Arvo due to its compact size. The entire Urbit stack is around 30,000 lines of code, while the Arvo kernel is only about 1,000 lines of code. We strive for a small codebase because the difficulty in administering a system is roughly proportional to the size of its code base.

## An operating function

Arvo is the world's first _purely functional_ operating system, and as such it may reasonably be called an _operating function_. The importance of understanding this design choice and its relevance to the overarching goal cannot be understated. If you knew only a single thing about Arvo, let it be this.

This means two things: one is that the there is a notion of _state_ for the operating system, and that the current state is a pure function of the [event log](#event-log), which is a chronological record of every action the operating system has ever performed. A _pure function_ is a function that always produces the same output given the same input. Another way to put this is to say that Arvo is _deterministic_. Other operating systems are not deterministic for a number of reasons, but one simple reasons is because they allow programs to alter global variables that then affect the operation of other programs.

In mathematical terms, one may think of Arvo as being given by a transition function _T_:

```
T: (State, Input) -> (State, Output).
```

In practice, _T_ is implemented by the `+poke` [arm](/docs/glossary/arm/) of the Arvo kernel, which is described in more detail in the [kernel section](#the-kernel). In theoretical terms, it may be more practical to think of Arvo as being defined by a _lifecycle function_ we denote here by _L_:

```
L: History -> State.
```

Which perspective is more fruitful depends on the problem being considered.

### Determinism

We consider Arvo to be deterministic at a high level. By that we mean that it is
stacked on top of a frozen instruction set known as Nock. Frozen instruction
sets are a new idea for an operating system, but not for computing in general.
For instance, the CPU instruction sets such as
[x86-64](https://en.wikipedia.org/wiki/X86-64v) are frozen at the level of the
chip. A given operating system may be adapted to run on more than one CPU
instruction set, we merely freeze the instruction set at a higher level in order
to enable deterministic computation.

Arvo handles nondeterminism in an interesting way. Deciding whether or not to
halt a computation that could potentially last forever becomes a heuristic
decision that is akin to dropping a packet. Thus it behooves one to think of
Arvo as being a stateful packet transceiver rather than an ordinary computer - events
are never guaranteed to complete, even if one can prove that the computation
would eventually terminate. We elaborate on this in the [solid state
interpreter](#solid-state-intrepeter) section.

Because Arvo is run on a VM, nondeterministic information such as the stack
trace of an infinite loop that was entered into may be obtained. This is
possible because while Arvo may be unable to obtain that information, the
interpreter beneath does and can inject that information back into the event log.

Being deterministic at a high level enables many
things that are out of reach of any other operating system. For
instance, we are able to do [over-the-air](#over-the-air-updates) (OTA) updates,
which allows software updates to be implemented across the network without
needing to worry whether it won't work on someone's ship, since Arvo is an
[interpreter](#solid-state-intrepeter) that can accept source code to
update itself instead of requiring a pre-compiled binary. This essential
property is why Urbit is able to act as a personal server while only having the
the user experience is akin to that of a web browser.

### Event log

The formal state of an Arvo instance is an event history, as a linked list of [nouns](/docs/glossary/noun/) from first to last. The history starts with a bootstrap sequence that delivers Arvo itself, first as an inscrutable kernel, then as the self-compiling source for that kernel. After booting, we break symmetry by delivering identity and entropy. The rest of the log is actual input.

The Arvo event log is a list of every action ever performed on your ship that
lead up to the current state. In principle, this event log is maintained by the
[Nock runtime environment](@/docs/tutorials/vere/_index.md), but in practice
event logs become too long over time to keep, as the event log has a size of
O(n) where n is the number of events. Thus it is our intention to
implement a feature whereby periodic snapshots of the state of Arvo are taken
and the log up to that state is pruned. This is currently unnecessary and thus
this feature has not been prioritized.

The beginning of the event log starting from the very first time a ship is
booted up until the kernel is compiled and identity and entropy are created is a
special portion of the Arvo lifecycle known as the _larval stage_. We describe
the larval stage in more detail in the [larval stage](#larval-stage-core) section.

More information on the structure of the Arvo event log and the Arvo state is given in the section on [the kernel](#the-kernel).



##  Solid state interpreter

Arvo is a _solid state interpreter_. In this section we describe what is meant
by this new term, and how this behavior derives from the fact that Arvo is an [ACID database](#acid-database) and a [single-level store](#single-level-store).

In computer science, an _interpreter_ is a program that directly executes
instructions written in some human-understandable programming or scripting
language, rather than requiring the code to first be compiled into a machine
language. Arvo is an interpreter, which is important for us since it allows us
to perform derministic [over-the-air updates](#over-the-air-updates) by the
direct transfer of raw source code.

To understand what we mean by _solid state_ interpreter, consider the operation of a solid state hard drive when a computer shuts down or loses power. Data written to an SSD is permanent unless otherwise deleted - loss of power may leave some partially written data, but nothing is ever lost. Thus, the state of an SDD can be considered to be equivalent to the data that it contains. That is to say, you do not need to know anything about the system which is utilizing the SSD to know everything there is to know about the SSD. There is no notion of "rebooting" a SSD - it simply stores data, and when power is restored to it, it is in exactly the same state as it was when power was lost.

Contrast this with other popular operating systems, such as Windows, Mac, or Linux. The state of the operating system is something that crucially depends on having a constant power supply because much of the state of the operating system is stored in RAM, which is volatile. When you reboot your computer or suddenly lose power, any information stored in RAM is lost. Modern operating systems do mitigate this loss of information to some extent. For instance, it may remember what applications you were running at the time power was lost and try to restore them. Particularly durable programs may go as far as writing their state to disk every few seconds so that only very minimal information can be lost in a power outage. However, this is not the default behavior, and indeed if it were then they would be so slow as to be unusable, as you would effectively be using your hard disk as the RAM.

How Arvo handles loss of power is closer to that of an SSD. Since it is an [ACID database](#acid-database) and a [single-level store](#single-level-store), a sudden loss of power have no effect on the state of the operating system. When you boot your ship back up it will be exactly as it was before the failure. Your information can never be lost, and because it was designed from the ground up to behave in this fashion, it does not suffer significant slowdown by persisting all data in this manner as would be the case if your typical operating system utilized its hard disk as RAM.

Another way to describe a solid state interpreter is to think of it as a
stateful packet transceiver. Imagine
it as a chip. Plug this chip into power and network; packets go in and
out, sometimes changing its state. The chip never loses data and has
no concept of a reboot; every packet is an [ACID transaction](#acid-database).


### Over-the-air updates

Arvo can hotpatch any other semantics at any layer in the system (apps, vanes, Arvo or Hoon itself) with automatic over-the-air updates.

Typically, updates to an operating system are given via a pre-compiled binary,
which is why some updates will work on some systems but not on others where the
hardware and environment may differ. This is not so on Arvo - because it is an
[interpreter](#solid-state-interpreter), Arvo may update itself by receiving
source code from your sponsor over [Ames](@/docs/tutorials/arvo/ames.md), our
network. As Hoon compiles down to Nock, which is an axiomatic representation of
a deterministic computer, this code is guaranteed to run identically on your machine as it
would on anybody else's.

Some subtleties regarding types arise when handling OTA updates, since they can
potentially alter the type system. Put more concretely, the type of `type` may
be updated. In that case, the update is an untyped Nock formula from the
perspective of the old kernel, but ordinary typed Hoon code from the perspective of
the new kernel. Besides this one detail, the only functionality of the Arvo
kernel proper that is untyped are its interactions with the Unix runtime.

### ACID Database

In the client-server model, data is stored on the server and thus reliable and efficient databases are an integral part of server architecture. This is not quite so true for the client - a user may be expected to reboot their machine in the middle of a computation, alter or destroy their data, never make backups or perform version control, etc. In other words, client systems like your personal computer or smart phone are not well suited to act as databases.

In order to dismantle the client-server model and build a peer-to-peer internet, we need the robustness of modern database servers in the hands of the users. Thus the Arvo operating system itself must have all of the properties of a reliable database.

Database theory studies in precise terms the possible properties of anything that could be considered to be a database. In this context, Arvo has the properties of an [ACID database](https://en.wikipedia.org/wiki/ACID), and the Ames network could be thought of as network of such databases. ACID stands for _atomicity_, _consistency_, _isolation_, and _durability_. We review here how Arvo satisfies these properties.

 - Atomicity: Events in Arvo are _atomic_, meaning that they either succeed completely or fail completely. In other words, there are no transient periods in which something like a power failure will leave the operating system in an invalid state. When an event occurs in Arvo, e.g. [the kernel](#the-kernel) is `poke`d, the effects of an event are computed, the event is [persisted](https://en.wikipedia.org/wiki/Persistence_(computer_science)) by writing it to the event log, and only then are the actual effects applied.

 - Consistency: Every possible update to the database puts it into another valid state. Given that Arvo is purely functional, this is easier to accomplish than it would be in an imperative setting.

 - Isolation: Transactions in databases often happen concurrently, and isolation
   ensures that the transactions occur as if they were performed sequentially,
   making it so that their effects are isolated from one another. Arvo ensures
   this simply by the fact that it only ever performs events sequentially. While
   Arvo
   transactions are sequential and performed by the daemon, persistence and effect application are performed
   in parallel by the worker; see [worker and
   daemon](@/docs/tutorials/vere/_index.md) for more detail.

 - Durability: Completed transactions will survive permanently. In other words,
   since the event log is stored on disk, if power is lost you are guaranteed
   that no transactions will be reversed.

It is easy to think that "completed transaction will survive permanently"
along with "the state of Arvo is pure function of its event log" implies that
nothing can ever be deleted. This is not quite true.
[Clay](@/docs/tutorials/arvo/clay.md) is our [referentially
transparency](https://en.wikipedia.org/wiki/Referential_transparency)
file system, which could naively be thought to mean that since data must be
immutable, files cannot be deleted. However, Clay can replace a file with a
"tombstone" that causes Clay to crash whenever it is accessed. Referential
transparency only guarantees that there won't be new data at a previously
accessed location - not that it will still be available.

### Single-level store

A kernel which presents the abstraction of a single layer of permanent state is also called a _single-level store_. One way to describe a single-level store is that it never reboots; a formal model of the system does not contain an operation which unpredictably erases half its brain.

Today's operating systems utilize at least two types of memory: the hard disk and the RAM, and this split is responsible for the fact that data is lost whenever power is lost. Not every operating system in history was designed this way - in particular, [Multics](https://en.wikipedia.org/wiki/Multics) utilized only one store of memory. Arvo takes after Multics - all data is stored in one permanent location, and as a result no data is ever lost when power is lost.

### Non-preemptive

Most operating systems are preemptive, meaning that they regularly interrupt
tasks being performed with the intention of resuming that task at a later time,
without the task explicitly yielding control.
Arvo does not do this - tasks run until they are complete or are cancelled due
to some heuristic, such as taking too long or because the user pressed Ctrl-C.
This is known as
[non-preemptive](https://en.wikipedia.org/wiki/Cooperative_multitasking) or
cooperative multitasking.


# The kernel

The Arvo kernel, stored in `sys/arvo.hoon`, is about 1k lines of Hoon whose primary purpose is to implement the transition function, `+poke`. In this section we point out the most important parts of `arvo.hoon` and describe their role in the greater system. We also give brief descriptions of Arvo's kernel modules, known as vanes, and how Arvo interfaces with them.

This section requires an understanding of Hoon of at least the level of Chapter One of the [Hoon tutorial](@/docs/tutorials/hoon/_index.md).

## Overall structure

`arvo.hoon` contains five top level cores as well as a "formal interface" consisting of a single [gate](/docs/glossary/gate/) that implements the transition function. They are nested with the `=<` and `=>` runes like so, where items lower on the list are contained within items higher on the list:
 + Types
 + Section 3bE Arvo Core
 + Implementation core
 + Structural interface core, or adult core
 + Larval stage core
 + Formal interface

See [Section 1.7](@/docs/tutorials/hoon/arms-and-cores.md#core-nesting) of the Hoon tutorial for further explanation of what is meant here by "nesting". We now describe the functionality of each of these components.

### Formal interface

The formal interface is a single gate that takes in the current time and a noun that encodes the input. This input, referred to as an _event_, is then put into action by the `+poke` arm, and a new noun denoting the current [state of Arvo](#the-state) is returned. In reality, you cannot feed the gate just any noun - it will end up being an `ovum` described below - but as this is the outermost interface of the kernel the types defined in the type core are not visible to the formal interface.

```hoon
    ::  Arvo formal interface
    ::
    ::    this lifecycle wrapper makes the arvo door (multi-armed core)
    ::    look like a gate (function or single-armed core), to fit
    ::    urbit's formal lifecycle function. a practical interpreter
    ::    can ignore it.
    ::
    |=  [now=@da ovo=*]
    ^-  *
    ~>  %slog.[0 leaf+"arvo-event"]
    .(+> +:(poke now ovo))
```

### Types

This core contains the most basic types utilized in Arvo. We discuss a number of them here.

#### `+duct`

```hoon
++  duct  (list wire)                                   ::  causal history
```

Arvo is designed to avoid the usual state of complex event networks: event
spaghetti. We keep track of every event's cause so that we have a clear causal
chain for every computation. At the bottom of every chain is a Unix I/O event,
such as a network request, terminal input, file sync, or timer event. We push
every step in the path the request takes onto the chain until we get to the
terminal cause of the computation. Then we use this causal stack to route
results back to the caller.

The Arvo causal stack is called a `duct`. This is represented simply as a list of paths, where each path represents a step in the causal chain. The first element in the path is the first letter of whichever vane handled that step in the computation, or the empty span for Unix.

Here's a `duct` that was recently observed in the wild upon entering `-time ~s1`
into the dojo and pressing Enter, which sets a timer for one second that will
then produce a `@d` with the current time after the timer has elapsed:

```
~[
  /g/a/~zod/4_shell_terminal/u/time
  /g/a/~zod/shell_terminal/u/child/4/main
  /g/a/~zod/terminal/u/txt
  /d/term-mess
  //term/1
]
```

This is the `duct` that the timer vane, Behn, receives when the `time` sample app asks the Behn to set a timer. This is also the `duct` over which the response is produced at the specified time. Unix sent a terminal keystroke event (enter), and Arvo routed it to Dill (our terminal), which passed it on to the Gall app terminal, which sent it to shell, its child, which created a new child (with process id 4), which on startup asked Behn to set a timer.

Behn saves this `duct`, so that when the specified time arrives and Unix sends a
wakeup event to the timer vane, it can produce the response on the same `duct`.
This response is routed to the place we popped off the top of the `duct`, i.e. the
time app. This app returns a `@d` which denotes the current time, which falls down to the shell,
which drops it through to the terminal. Terminal drops this down to Dill, which
converts it into an effect that Unix will recognize as a request to print the
current time to the screen. When Dill produces this, the last path in the `duct` has an
initial element of the empty span, so this is routed to Unix, which applies the effects.

This is a call stack, with a crucial feature: the stack is a first-class citizen. You can respond over a `duct` zero, one, or many times. You can save `duct`s for later use. There are definitely parallels to Scheme-style continuations, but simpler and with more structure.


#### `wire`

```hoon
++  wire  path                                          ::  event pretext
```

Synonym for `path`, used in `duct`s. These should be thought of as a list of symbols
representing a cause.

#### `move`

```hoon
++  move  [p=duct q=arvo]                               ::  arvo move
```

If `duct`s are a call stack, then how do we make calls and produce results? Arvo
processes `move`s which are a combination of message data and metadata. There
are three types of `move`s: `%pass`, `%give`, and `%unix`.

A `%pass` `move` is analogous to a call:

```
[duct %pass return-path=path vane-name=@tD data=card]
```

Arvo pushes the return path (preceded by the first letter of the vane name) onto
the `duct` and sends the given data, a `card`, to the vane we specified. Any response will come along the same `duct` with the `wire` `return-path`.

A `%give` `move` is analogous to a return:

```
[duct %give data=card]
```

Arvo pops the top `wire` off the `duct` and sends the given `card` back to the caller.

Lastly, a `%unix` `move` is how Arvo represents communication from Unix, such as a
network request or terminal input.

#### `card`s and `curd`s

`card`s are the vane-specific portion of a `move`, while `curd`s are typeless
`card`s utilized at the level of the kernel. `card`s are not actually defined in
`arvo.hoon`, rather they are given by `+note-arvo` and `+sign-arvo` in the
standard library `zuse`
(which then refer to `+task` and `+gift` in each of the vane cores), but they are closely
connected to `curd`s so we speak of them in the same breath.

Each vane defines a protocol for interacting with other vanes (via Arvo) by defining four types of `card`s: `task`s, `gift`s, `note`s, and `sign`s.

When one vane is `%pass`ed a `card` in its `task` (defined in `zuse`), Arvo activates the `+call` gate with the `card` as its argument. To produce a result, the vane `%give`s one of the `card`s defined in its `gift`. If the vane needs to request something of another vane, it `%pass`es it a `note` `card`. When that other vane returns a result, Arvo activates the `+take` gate of the initial vane with one of the `card`s defined in its `sign`.

In other words, there are only four ways of seeing a `move`: (1) as a request seen by the caller, which is a `note`. (2) that same request as seen by the callee, a `task`. (3) the response to that first request as seen by the callee, a `gift`. (4) the response to the first request as seen by the caller, a `sign`.

When a `task` `card` is `%pass`ed to a vane, Arvo calls its `+call` gate,
passing it both the `card` and its `duct`. This gate must be defined in every vane.
It produces two things in the following order: a list of `move`s and a possibly
modified copy of its context. The `move`s are used to interact with other vanes,
while the new context allows the vane to save its state. The next time Arvo
activates the vane it will have this context as its subject.

This cycle of `%pass`ing a `note` to `%pass`ing a `task` to `%give`ing a `gift`
to `%give`ing a `%sign` is summarized in the following diagram:

<div style="text-align:center">
<img class="mv5 w-150" src="https://media.urbit.org/docs/arvo/cycle.png">
</div>

Note that `%pass`ing a `note` doesn't _always_ result in a return - this diagram
just
shows the complete cycle. However, `%give`ing a `gift` is always in response to being
`%pass`ed some `task`. Since the Arvo kernel acts as a middleman between all `move`s in Arvo, in diagrams we will
generally represent the intermediate steps of a vane `%pass`ing a `note` to the kernel addressed to
another vane followed by the kernel `%pass`ing a `task` to the
addressed vane as a single arrow from one vane to the other to make the diagrams
less cluttered.

This overview has detailed how to pass a `card` to a particular vane. To see the `card`s each vane can be `%pass`ed as a `task` or return as a `gift` (as well as the semantics tied to them), each vane's public interface is explained in detail in its respective overview.

#### `ovum`

This mold is used to represent both steps and actions.

A pair of a `wire` and a `curd`, with a `curd` being like a typeless `card`. The
reason for a typeless `card` is that this is the data structure which Arvo uses
to communicate with the runtime, and Unix events have no type. Additionally,
upgrading the kernel may alter the type system and thus may not be able to be
described within the current type system. Then the `wire` here is the default Unix `wire`, namely `//`. In particular, it is not a `duct` because `ovum`s come from the runtime rather than from within Arvo.

### Arvo cores

`arvo.hoon` has four additional cores that encode the functionality of Arvo. The [larval core](#larval-stage-core), [structural interface core](#structural-interface-core), and [implementation core](#implementation-core) each have five arms, called `+come`, `+load`, `+peek`, `+poke`, and `+wish`. Of these five arms, only `+poke` affects the [Arvo state](#the-state), while the rest leave the state invariant. Thus `+poke` is the aforementioned transition function that sends Arvo from one state to the next.

A short summary of the purpose of each these arms are as follows:

 - `+poke` is the transition function that `move`s Arvo from one state to the
   next. It is the most fundamental arm in the entire system. It is a typed
   transactional message that is processed at most once. If the `+poke` causes
   Arvo to send an message over [Ames](@/docs/tutorials/arvo/ames.md) Ames
   guarantees that the message will be delivered exactly once. This is sometimes said
   to be impossible, and it is for standard operating systems, but that is not the case for single-level stores engaged in
   a permanent session, as is the case among Arvo ships.
 - `+peek` is an arm used for inspecting things outside of the kernel. It grants
   read-only access to `scry` Arvo's global referentially transparent namespace.
   It takes in a `path` and returns a `unit (unit)`. If the product is `~`, the
   path is unknown and its value cannot be produced synchronously. If its
   product is `[~ ~]` the `path` is known to be unbound and can never become
   bound. Otherwise the product is a `mark` and a noun.
 - `+wish` is a function that takes in a core and then parses and compiles it
   with the standard library, `zuse`. It is useful from the outside if you ever
   want to run code within. One particular way in which it is used is by the
   runtime to read out the version of `zuse` so that it knows if it is
   compatible with this particular version of the kernel.
 - `+load` is used when upgrading the kernel. It is only ever called by Arvo
   itself, never by the runtime. If upgrading to a kernel where types are
   compatible, `+load` is used, otherwise `+come` is used.
 - `+come` is used when the new kernel has incompatible types, but ultimately
 reduces to a series of `+load` calls.

 The [Section 3bE core](#section-3be-core) does not follow this pattern.

#### Section 3bE core

This core defines helper functions that are called in the larval and adult cores. These helper functions are placed here for safety so that they do not have access to the entire [state of Arvo](#the-state), which is contained in the structural interface core. One reason this core is required is that the Arvo interface has only five arms and additional arms are required to perform everything the kernel needs to do in a clean manner, so they must be segregated from the other three cores that stick to the five-arm paradigm.

#### Implementation core

This core is where the real legwork of the Arvo kernel is performed during the adult stage. It does not communicate with Unix directly, rather it is called by the structural interface core.

#### Structural interface core

This core could be thought of as the primary "adult core" - the one that is in operation for the majority of its lifecycle and the one that contains the [Arvo state](#the-state). This core should be thought of as an interface - that is, the amount of work the code does here is minimal as its main purpose is to be the core that communicates with Unix, and Unix should not be able to access deeper functions stored in the implementation core and 3bE core on its own. Thus, arms in this core are there primarily to call arms in the implementation core and 3bE core.

#### Larval stage core

This core is in use only during the larval stage of Arvo, which is after the Arvo kernel has compiled itself but before it has "broken symmetry" by acquiring identity and entropy, the point at which the larval stage has concluded. We call this breaking symmetry because prior to this point, every Urbit is completely identical. The larval stage performs the following steps in order:

 + The standard library, `zuse`, is installed.
 + Entropy is added
 + Identity is added
 + Metamorph into the next stage of Arvo

Once the larval stage has passed its functionality will never be used again.

## The state

As we follow functional programming paradigms, the state of Arvo is considered
to be the entire Arvo kernel core currently in operation (whether it be the larval
stage or adult stage). Thus when `+poke` is performed, a new core with the
updated state is produced, rather than modifying the existing core as would be
expected to happen in an imperative setting.

Thus besides the battery of the Arvo core, we have the [payload](/docs/glossary/payload/) which is as
follows.

```hoon
::  persistent arvo state
::
=/  pit=vase  !>(..is)                                  ::
=/  vil=vile  (viol p.pit)                              ::  cached reflexives
=|  $:  lac=_&                                          ::  laconic bit
        eny=@                                           ::  entropy
        our=ship                                        ::  identity
        bud=vase                                        ::  %zuse
        vanes=(list [label=@tas =vane])                 ::  modules
    ==                                                  ::
```

Let's investigate the state piece by piece.

```hoon
=/  pit=vase  !>(..is)                                  ::
```
This `vase` is part of the state but does not get directly migrated when `+poke`
is called. `!>(..is)` consists of the code in `arvo.hoon` written above this core contained in
a `vase`. Thus this part of the state changes only when that code changes in an
update.

```hoon
=/  vil=vile  (viol p.pit)                              ::  cached reflexives

```
This is a cache of specific types that are of fundamental importance to Arvo -
namely `type`s, `duct`s, `path`s, and `vase`s. This is kept because it is
unnecessarily wasteful to recompile these fundamental types on a regular basis.
Again, this part of the state is never updated directly by `+poke`.

```hoon
=|  $:  lac=_&                                          ::  laconic bit
        eny=@                                           ::  entropy
        our=ship                                        ::  identity
        bud=vase                                        ::  %zuse
        vanes=(list [label=@tas =vane])                 ::  modules
    ==
```
This is where the real state of the Arvo kernel is kept. `lac` detemines whether
Arvo's output is verbose, which can be set using the `|verb` command in the
dojo. `eny` is the current entropy. `our` is the ship, which is permanently
frozen during the larval stage. `bud` is the standard library. Lastly, `vanes`
is of course the list of vanes, which have their own internal states.

As you can see, the state of Arvo itself is quite simple. Its primary role is that of
a traffic cop, and most of the interesting part of the state lies in `vanes`.


## Vanes

The Arvo kernel can do very little on its own. Its functionality is extended in a careful and controlled way with vanes, also known as kernel modules.

As described above, we use Arvo proper to route and control the flow of `move`s.
However, Arvo proper is rarely directly responsible for processing the event
data that directly causes the desired outcome of a `move`. This event data is contained within a `card`. Instead, Arvo proper passes the `card` off to one of its vanes, which each present an interface to clients for a particular well-defined, stable, and general-purpose piece of functionality.

As of this writing, we have nine vanes, which each provide the following services:

- [Ames](@/docs/tutorials/arvo/ames.md): the name of both our network and the vane that communicates over it.
- [Behn](@/docs/tutorials/arvo/behn.md): a simple timer.
- [Clay](@/docs/tutorials/arvo/clay.md): our version-controlled, referentially- transparent, and global filesystem.
- [Dill](@/docs/tutorials/arvo/dill.md): a terminal driver. Unix sends keyboard events to `%dill` from the console, and `%dill` produces terminal output.
- [Eyre](@/docs/tutorials/arvo/eyre.md): an http server. Unix sends http messages to `%eyre`, and `%eyre` produces http messages in response.
- [Ford](@/docs/tutorials/arvo/ford.md): a build system also utilized for marks
  (file types) and debugging.
- [Gall](@/docs/tutorials/arvo/gall.md): manages our userspace applications. `%gall` keeps state and manages subscribers.
- `Iris`: an http client.
- `Jael`: storage for Azimuth information.


## Stack trace tutorial

In this section we will see some of what we learned in [the kernel](#the-kernel)
in action - namely, we will investigate how setting a timer from the terminal
makes its way through Arvo as a series of `move`s passed between various vanes
and processes.

<img class="mv5 w-100" src="https://media.urbit.org/docs/arvo/stack.png">

Ultimately, everything that happens in Arvo is reduced to Unix events, and the
Arvo kernel acts as a sort of traffic cop for vanes and apps to talk to one
another. Here we look at how a simple command, `-time ~s1`, goes from pressing
Enter on your keyboard in Dojo towards returning a notification that one second
has elapsed.

### Running a stack trace

To follow along yourself, boot up a fake `~zod` and enter `|verb` into the dojo
and press Enter to enable verbose mode (this is tracked by the laconic bit
introduced in the section on [the state](#the-state)), followed by `-time ~s1`
followed by Enter. Your terminal should display something like this:

```
["" %unix p=%belt //term/1 ~2020.1.14..19.01.25..7556]
["|" %pass [%d %g] [[%deal [~zod ~zod] %hood %poke] /] [i=//term/1 t=~]]
["||" %pass [%g %g] [[%deal [~zod ~zod] %dojo %poke] /use/hood/~zod/out/~zod/dojo/drum/phat/~zod/dojo] [i=/d t=~[//term/1]]]
["|||" %give %g [%unto %fact] [i=/g/use/hood/~zod/out/~zod/dojo/drum/phat/~zod/dojo t=~[/d //term/1]]]
["||||" %give %g [%unto %fact] [i=/d t=~[//term/1]]]
["|||||" %give %d %blit [=//term/1 t=~]]
["|||" %pass [%g %f] [%build /use/dojo/~zod/drum/hand] [i=/d t=~[//term/1]]]
["||||" %give %f %made [i=/g/use/dojo/~zod/drum/hand t=~[/d //term/1]]]
["|||||" %pass [%g %g] [[%deal [~zod ~zod] %spider %watch] /use/dojo/~zod/out/~zod/spider/drum/wool] [i=/d t=~[//term/1]]]
["||||||" %give %g [%unto %watch-ack] [i=/g/use/dojo/~zod/out/~zod/spider/drum/wool t=~[/d //term/1]]]
["|||||" %pass [%g %g] [[%deal [~zod ~zod] %spider %poke] /use/dojo/~zod/out/~zod/spider/drum/wool] [i=/d t=~[//term/1]]]
//term/1]]]
["||||||" %pass [%g %f] [%build /use/spider/~zod/find/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u] [i=/d t=~[//term/1]]]
["|||||||" %give %f %made [i=/g/use/spider/~zod/find/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u t=~[/d //term/1]]]
["||||||||" %pass [%g %f] [%build /use/spider/~zod/build/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u] [i=/d t=~[//term/1]]]
["|||||||||" %give %f %made [i=/g/use/spider/~zod/build/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u t=~[/d //term/1]]]
["||||||||||" %pass [%g %b] [%wait /use/spider/~zod/thread/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u/wait/~2020.1.14..19.01.26..7556] [i=/d t=~[//term/1]]]
["|||||||||||" %give %b %doze [i=//behn/0v1p.sn2s7 t=~]]
> -time ~s1
```
followed by a pause of one second, then
```
["" %unix p=%wake //behn ~2020.1.14..19.01.26..755d]
["|" %give %b %doze [i=//behn/0v1p.sn2s7 t=~]]
["|" %give %b %wake [i=/g/use/spider/~zod/thread/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u/wait/~2020.1.14..19.01.26..7556 t=~[/d //term/1]]]
["||" %give %g [%unto %fact] [i=/g/use/dojo/~zod/out/~zod/spider/drum/wool t=~[/d //term/1]]]
["|||" %give %g [%unto %fact] [i=/g/use/hood/~zod/out/~zod/dojo/drum/phat/~zod/dojo t=~[/d //term/1]]]
["||||" %give %g [%unto %fact] [i=/d t=~[//term/1]]]
["|||||" %give %d %blit [=//term/1 t=~]]
["||" %give %g [%unto %kick] [i=/g/use/dojo/~zod/out/~zod/spider/drum/wool t=~[/d //term/1]]]
~s1..0007
```
This gives us a stack trace that is a list of `move`s and some
associated metadata. Some of the `move`s are a bit of a distraction from what's
going on overall such as acknowledgements that a `poke` was received
(`%poke-ack`s), so we've omitted them for clarity. Furthermore, two `move`s (the
`%blit` events) is not printed even in verbose mode because it occurs so
frequently, but there is only one of them here and so we have added it in.

The main process that is occurring here is a sequence of `%pass` `move`s initiated
by pressing Enter in the terminal that goes on to be handled by Dill, then Gall,
and finally Behn. After the timer has elapsed, a sequence of `%give` `move`s is
begun by Behn, which then passes through Gall and ultimately ends up back at the
terminal. Any `move`s besides `%pass` in the first segment of the stack trace is a
secondary process utilized for book-keeping, spawning processes, interpreting
commands, etc. All of this will be explained in detail below.


It is important to note that this stack trace should be thought of
as being from the "point of view" of the kernel - each line represents the
kernel taking in a message from one source and passing it along to its
destination. It is then processed at that destination (which could be a vane or
an app), and the return of that process is sent back to Arvo in the form of
another `move` to perform and the loop begins again. Thus this stack trace does
not display information about what is going on inside of the vane or app such as
private function calls, only what the kernel itself sees.

### Interpreting the stack trace

What is happening here can be summarized in the following diagram,
which we will proceed to explain in detail:

(insert diagram)

This diagram should be read starting from the left and following the arrows.
Each arrow represents a move where the table connected to the arrow by a dotted
line contains some of the information about the `move` such as the `duct` and
tag of the `move`. It is crucial to note here that for every arrow to the right
of the Arvo kernel on the diagram, i.e. where vanes or apps are speaking to one another,
actually represents two arrows: one from the caller to the Arvo kernel, and then
from the Arvo kernel to the callee. The kernel is the intermediary between all
communications - vanes and apps do not speak directly to one another.

#### The call

Let's put the first part of the stack trace into a table to make reading a little easier.

| Length | move    | vane(s)   |                                                                                                     card   | duct                                                                              |
|--------|---------|-----------|-----------------------------------------------------------------------------------------------------------:|-----------------------------------------------------------------------------------|
| 0      | `%unix` |           | `%belt`                                                                                                    |  ~                                                                                |
| 1      | `%pass` | `[%d %g]` | `[[%deal [~zod ~zod] %hood %poke] /]`                                                                      | `//term/1 ~`                                                                      |
| 2      | `%pass` | `[%g %g]` | `[[%deal [~zod ~zod] %dojo %poke] /use/hood/~zod/out/~zod/dojo/drum/phat/~zod/dojo]`                       | `/d //term/1 ~`                                                                   |
| 3      | `%give` | `%g`      | `[%unto %fact]`                                                                                            | `/g/use/hood/~zod/out/~zod/dojo/drum/phat/~zod/dojo /d //term/1 ~`                |
| 4      | `%give` | `%g`      | `[%unto %fact]`                                                                                            | `/d //term/1 ~`                                                                   |
| 5      | `%give` | `%d`      | `%blit`                                                                                                    | `//term/1 ~`                                                                      |
| 3      | `%pass` | `[%g %f]` | `[%build /use/dojo/~zod/drum/hand]`                                                                        | `/d //term/1 ~`                                                                   |
| 4      | `%give` | `%f`      | `%made`                                                                                                    | `/g/use/dojo/~zod/drum/hand /d //term/1 ~`                                        |
| 5      | `%pass` | `[%g %g]` | `[[%deal [~zod ~zod] %spider %watch] /use/dojo/~zod/out/~zod/spider/drum/wool]`                            | `/d //term/1 ~`                                                                   |
| 6      | `%give` | `%g`      | `[%unto %watch-ack]`                                                                                       | `/g/use/dojo/~zod/out/~zod/spider/drum/wool /d //term/1 ~`                        |
| 5      | `%pass` | `[%g %g]` | `[[%deal [~zod ~zod] %spider %poke] /use/dojo/~zod/out/~zod/spider/drum/wool]`                             | `/d //term/1 ~`                                                                   |
| 6      | `%pass` | `[%g %f]` | `[%build /use/spider/~zod/find/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u]`                                  | `/d //term/1 ~`                                                                   |
| 7      | `%give` | `%f`      | `%made`                                                                                                    | `/g/use/spider/~zod/find/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u /d //term/1 ~`  |
| 8      | `%pass` | `[%g %f]` | `[%build /use/spider/~zod/build/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u]`                                 | `/d //term/1 ~`                                                                   |
| 9      | `%give` | `%f`      | `%made`                                                                                                    | `/g/use/spider/~zod/build/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u /d //term/1 ~` |
| 10     | `%pass` | `[%g %b]` | `[%wait /use/spider/~zod/thread/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u/wait/~2020.1.14..19.01.26..7556]` | `/d //term/1 ~`                                                                   |
| 11     | `%give` | `%b`      | `%doze`                                                                                                    | `//behn/0v1p.sn2s7 ~`                                                             |

This simple action ends up involving four vanes - Dill, Gall, Behn, and Ford -
as well as four applications - hood, spider, dojo, and time.

Now let's go through each line one by one.
```
["" %unix p=%belt //term/1 ~2020.1.14..19.01.25..7556]
```
This tells us that Unix has sent a `%belt` command, which corresponds to
terminal input (the Enter keystroke) at time `~2020.1.14..19.01.25..7556`

Here is the line of code in `arvo.hoon`, found in the [section
3bE core](#section-3be-core), that generated the output:

```hoon
    ~?  !lac  ["" %unix -.q.ovo p.ovo now]
```
First we note that this line is executed only if the laconic bit is set to true,
as we did when we input `|verb`. Here, `ovo` is the input `ovum`. Knowing that an `ovum` is a `[p=wire q=curd]`,
we can then say that this is a `%unix` `move` tagged with `%belt` whose cause is a `wire` given by `//term/1`,
where the empty span `//` represents Unix and `term/1` represents the terminal
in Unix. Here we have a `wire` instead of a `duct` (i.e. a list of `wire`s)
since Unix I/O events are always the beginning and end of the Arvo event loop,
thus only a single `wire` is ever required at this initial stage.

The `""` here is a metadatum that keeps track of how many steps deep in the
causal chain the event is. An event
with `n` `|`'s was caused by the most recent previous event with `n-1` `|`'s. In
this case, Unix events are an "original cause" and thus represented by an empty
string.

At this point in time, Dill has received the `move` and then processes it. The
`%belt` `task` in `dill.hoon` is `+call`ed, which is processed using the `+send`
arm:

```hoon
      ++  send                                          ::  send action
        |=  bet/dill-belt
        ^+  +>
        ?^  tem
          +>(tem `[bet u.tem])
        (deal / [%poke [%dill-belt -:!>(bet) bet]])
```

Dill has taken in the command and in response it sends a `%poke` `move` to hood, which is a Gall app
primarily used for interfacing with Dill. Here, `+deal` is an arm for
`%pass`ing a `note` to Gall to ask it to create a `%deal` `task`:

```hoon
      ++  deal                                          ::  pass to %gall
        |=  [=wire =deal:gall]
        (pass wire [%g %deal [our our] ram deal])
```

Next in our stack trace we have this:
```
["|" %pass [%d %g] [[%deal [~zod ~zod] %hood %poke] /] [i=//term/1 t=~]]
```
Here, Dill sends a `%poke` (of the Enter keystroke) to Gall's hood app.

Let's glance at part of the `+jack` arm in `arvo.hoon`, located in the [section 3bE
core](#section-3be-core). This arm is what the Arvo kernel uses to send `card`s,
and here we look at the segment that includes `%pass` `card`s.

```hoon
  ++  jack                                              ::  dispatch card
    |=  [lac=? gum=muse]
    ^-  [[p=(list ovum) q=(list muse)] _vanes]
    ~|  %failed-jack
    ::  =.  lac  |(lac ?=(?(%g %f) p.gum))
    ::  =.  lac  &(lac !?=($b p.gum))
    %^    fire
        p.gum
      s.gum
    ?-    -.r.gum
        $pass
      ~?  &(!lac !=(%$ p.gum))
        :-  (runt [s.gum '|'] "")
        :^  %pass  [p.gum p.q.r.gum]
          ?:  ?=(?(%deal %deal-gall) +>-.q.q.r.gum)
            :-  :-  +>-.q.q.r.gum
                (,[[ship ship] term term] [+>+< +>+>- +>+>+<]:q.q.r.gum)
            p.r.gum
          [(symp +>-.q.q.r.gum) p.r.gum]
        q.gum
      [p.q.r.gum ~ [[p.gum p.r.gum] q.gum] q.q.r.gum]
```

Code for writing stack traces can be a bit tricky, but let's try not to get too
distracted by the lark expressions and such. By paying attention to the lines
concerning the laconic bit (following `!lac`) we can mostly determine what is being told to us.

From the initial input event, Arvo has generated a `card` that it is now
`%pass`ing from Dill (represented by `%d`) to Gall (represented by `%g`). The
`card` is a `%deal` `card`, asking Gall to `%poke` hood using data that has
originated from the terminal `//term/1`, namely that the Enter key was pressed. The line `:-  (runt [s.gum '|'] "")`
displays the duct depth datum mentioned above. Lastly, `[~zod ~zod]` tells us that
`~zod` is both the sending and receiving ship.

From here on our explanations will be more brief. We include some information
that cannot be directly read from the stack trace in [brackets]. Onto the next line:

```
["||" %pass [%g %g] [[%deal [~zod ~zod] %dojo %poke] /use/hood/~zod/out/~zod/dojo/drum/phat/~zod/dojo] [i=/d t=~[//term/1]]]
```

Here is another `%pass` `move`, this time from Gall to iself as denoted by `[%g
%g]`. Hood has received the `%deal` `card` from Dill, and in response it is
`%poke`ing dojo with the information [that Enter was pressed].

```
["|||" %give %g [%unto %fact] [i=/g/use/hood/~zod/out/~zod/dojo/drum/phat/~zod/dojo t=~[/d //term/1]]]
```

Gall's dojo app gives a "fact" (subscription update) to hood, [saying to clear
the terminal prompt].

```
["||||" %give %g [%unto %fact] [i=/d t=~[//term/1]]]
```
Gall's hood gives a "fact" to Dill [saying to replace the current terminal line with `~zod:dojo>`]

Next is the `move` that is not actually printed in the stack trace mentioned
above:

```
["|||||" %give %d %blit [=//term/1 t=~]]
```

Dill gives a `%blit` (terminal output) event to unix [saying to replace the current terminal line with `~zod:dojo>`].

```
["|||" %pass [%g %f] [%build /use/dojo/~zod/drum/hand] [i=/d t=~[//term/1]]]
```

Gall's dojo also sends a "build" request to Ford [asking to run "~s1" against the subject we use in the dojo].

```
["||||" %give %f %made [i=/g/use/dojo/~zod/drum/hand t=~[/d //term/1]]]
```

Ford gives a result back to dojo [with the value `~s1`]

```
["|||||" %pass [%g %g] [[%deal [~zod ~zod] %spider %watch] /use/dojo/~zod/out/~zod/spider/drum/wool] [i=/d t=~[//term/1]]]
```

Gall's dojo sends a `%watch` to Gall's spider app [to start listening for the result of the thread it's about to start].

```
["||||||" %give %g [%unto %watch-ack] [i=/g/use/dojo/~zod/out/~zod/spider/drum/wool t=~[/d //term/1]]]
```

Gall's spider acknowledges the subscription from dojo.

```
["|||||" %pass [%g %g] [[%deal [~zod ~zod] %spider %poke] /use/dojo/~zod/out/~zod/spider/drum/wool] [i=/d t=~[//term/1]]]
```

Gall's dojo also sends a `poke` to Gall's spider [asking it start the thread "-time" with argument `~s1`].

```
["||||||" %pass [%g %f] [%build /use/spider/~zod/find/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u] [i=/d t=~[//term/1]]]
```

Gall's spider sends a "build" request to Ford [asking it to find the path in /ted where the "time" thread is].

```
["|||||||" %give %f %made [i=/g/use/spider/~zod/find/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u t=~[/d //term/1]]]
```

Ford gives a result back to Gall's spider [saying it's in /ted/time.hoon].

```
["||||||||" %pass [%g %f] [%build /use/spider/~zod/build/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u] [i=/d t=~[//term/1]]]
```

Gall's spider sends a "build" request to Ford [asking it to compile the file /ted/time.hoon].

```
["|||||||||" %give %f %made [i=/g/use/spider/~zod/build/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u t=~[/d //term/1]]]
```

Ford gives a result back to Gall's spider [with the compiled thread].

```
["||||||||||" %pass [%g %b] [%wait /use/spider/~zod/thread/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u/wait/~2020.1.14..19.01.26..7556] [i=/d t=~[//term/1]]]
```

Gall's spider's thread with id `~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u` asks Behn to set a timer [for one second].

```
["|||||||||||" %give %b %doze [i=//behn/0v1p.sn2s7 t=~]]
```

Behn gives a "doze" event to Unix, asking it to set a timer [for one second from
now]. At this point Arvo may rest.

#### The return

At this point, Unix waits for one second and then informs Behn that a second has
passed, leading to a chain of `%give` `move`s that ultimately prints
`~s1..0007`.

Let's throw the stack trace into a table:

+--------+---------+---------+-----------------+-----------------------------------------------------------------------------------------------------+
| length | move    | vane(s) | card            | duct                                                                                                |
+--------+---------+---------+-----------------+-----------------------------------------------------------------------------------------------------+
| 0      | `%unix` |         | `%wake`         | `//behn`                                                                                            |
+--------+---------+---------+-----------------+-----------------------------------------------------------------------------------------------------+
|        |         |         |                 | `//behn/0v1p.sn2s7                                                                                  |
| 1      | `%give` | `%b`    | `%doze`         | ~                                                                                                   |
|        |         |         |                 | `                                                                                                   |
+--------+---------+---------+-----------------+-----------------------------------------------------------------------------------------------------+
|        |         |         |                 | `/g/use/spider/~zod/thread/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u/wait/~2020.1.14..19.01.26..7556 |
| 1      | `%give` | `%b`    | `%wake`         | /d                                                                                                  |
|        |         |         |                 | //term/1                                                                                            |
|        |         |         |                 | ~`                                                                                                  |
+--------+---------+---------+-----------------+-----------------------------------------------------------------------------------------------------+
|        |         |         |                 | `/g/use/dojo/~zod/out/~zod/spider/drum/wool                                                         |
| 2      | `%give` | `%g`    | `[%unto %fact]` | /d                                                                                                  |
|        |         |         |                 | //term/1                                                                                            |
|        |         |         |                 | ~`                                                                                                  |
+--------+---------+---------+-----------------+-----------------------------------------------------------------------------------------------------+
| 3      | `%give` | `%g`    | `[%unto %fact]` | `/g/use/hood/~zod/out/~zod/dojo/drum/phat/~zod/dojo                                                 |
|        |         |         |                 | /d                                                                                                  |
|        |         |         |                 | //term/1                                                                                            |
|        |         |         |                 | ~`                                                                                                  |
+--------+---------+---------+-----------------+-----------------------------------------------------------------------------------------------------+
| 4      | `%give` | `%g`    | `[%unto %fact]` | `/d                                                                                                 |
|        |         |         |                 | //term/1                                                                                            |
|        |         |         |                 | ~`                                                                                                  |
+--------+---------+---------+-----------------+-----------------------------------------------------------------------------------------------------+
| 5      | `%give` | `%d`    | `%blit`         | `//term/1                                                                                           |
|        |         |         |                 | ~`                                                                                                  |
+--------+---------+---------+-----------------+-----------------------------------------------------------------------------------------------------+
| 2      | `%give` | `%g`    | `[%unto %kick]` | `/g/use/dojo/~zod/out/~zod/spider/drum/wool                                                         |
|        |         |         |                 | /d                                                                                                  |
|        |         |         |                 | //term/1`                                                                                           |
+--------+---------+---------+-----------------+-----------------------------------------------------------------------------------------------------+

Now we follow it line-by-line:

```
["" %unix p=%wake //behn ~2020.1.14..19.01.26..755d]
```

Unix sends a `%wake` (timer fire) event at time `~2020.1.14..19.01.26..755d`.

```
["|" %give %b %doze [i=//behn/0v1p.sn2s7 t=~]]
```

Behn `give`s a `%doze` event to Unix, asking it to set a timer [for whatever next timer it has in its queue].

```
["|" %give %b %wake [i=/g/use/spider/~zod/thread/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u/wait/~2020.1.14..19.01.26..7556 t=~[/d //term/1]]]
```

Behn `give`s a `%wake` to Gall's spider's thread with id `~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u`.

```
["||" %give %g [%unto %fact] [i=/g/use/dojo/~zod/out/~zod/spider/drum/wool t=~[/d //term/1]]]
```

Gall's spider `give`s a `%fact` (subscription update) to dojo [saying that the thread completed successfully and produced value `~s1.0007`].

```
["|||" %give %g [%unto %fact] [i=/g/use/hood/~zod/out/~zod/dojo/drum/phat/~zod/dojo t=~[/d //term/1]]]
```

Gall's dojo `give`s a `%fact` to hood [saying to output `~s1..0007`].

```
["||||" %give %g [%unto %fact] [i=/d t=~[//term/1]]]
```

Gall's hood `give`s a `%fact` to Dill [saying to output `~s1..0007`].

```
["|||||" %give %d %blit [=//term/1 t=~]]
```

Dill gives a `%blit` (terminal output) event to Unix [saying to print a new line with output `~s1..0007`].

```
["||" %give %g [%unto %kick] [i=/g/use/dojo/~zod/out/~zod/spider/drum/wool t=~[/d //term/1]]]
```

Gall's spider also closes the subscription from dojo [since the thread has completed].
