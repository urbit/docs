+++
title = "Arvo"
weight = 1
template = "doc.html"
aliases = ["/docs/learn/arvo/arvo/"]
+++
Arvo, also called Urbit OS, is our operating system.

# Introduction

In this section we give a summary of the content and cover prerequisites for understanding the material presented here.

## Summary

This document is intended to provide a comprehensive summary of all of the most important aspects of Arvo. We work on two levels - a conceptual level that should be useful to anybody interested in how Arvo works, and a more technical level intended for those that intend to write software for Urbit. 

We include a number of quotes from the Urbit [white paper](https://media.urbit.org/whitepaper.pdf) where appropriate. The white paper is a good companion to this article, though it should be noted that some parts of it are out of date or not yet implemented.

### Prerequisites

The conceptual level may mostly be understood without knowing Hoon, but some of it will require understanding at the level of Chapter One of the [Hoon tutorial](@/docs/tutorials/hoon/_index.md). The technical level will require Chapter One for full understanding, and some material from Chapter Two will be helpful as well. At the bare minimum, we presume that the reader has read through the [Technical Overview](@/docs/concepts/technical-overview.md), though some of the content presented there is presented again here in greater detail. 

### Sections
Here we present a brief summary of each section.

#### [What is Arvo?](#what-is-arvo)
The big picture of Arvo.

#### [The stack](#the-stack)
An overview of each layer of the Arvo stack and how they interact, from Unix to userspace.

#### [The kernel](#the-kernel)
A description of how the Arvo kernel functions, including the basic arms and the structure of the event log.

#### [Vanes](#vanes)
A short description of each Arvo kernel module, known as a vane.

#### [File system](#file-system)
Essential information about Clay, our file system vane.

#### [Boot sequence](#boot-sequence)
An annotation of what is printed on the screen when you boot your ship for the first time, as well as subsequent boots.

#### Security
How Arvo handles cryptography.

#### [Kelvin versioning](#kelvin-versioning)
Our peculiar software versioning system.

#### [Virtual machine](#virtual-machine)
How the Nock runtime environment and virtual machine which Arvo lives is in implemented.

#### [Jets](#jets)
How Nock is made to run quickly.

#### [Daemons](#daemons)
How Arvo is split into a worker and ??? daemon.

#### I/O
How I/O is handled by Arvo.

# What is Arvo?

Arvo is a [non-preemptive](https://en.wikipedia.org/wiki/Cooperative_multitasking) operating system purposefully built to create a new internet whereby users own and manage their own data. Despite being an operating system, Arvo does not replace Windows, Mac OS, or Linux. It is better to think of the user experience of Arvo as being closer to that of a web browser for a more human internet. As such, Arvo is generally run inside a virtual machine, though in theory it could be run on bare metal.

> Urbit is a “browser for the server side”; it replaces multiple developer-hosted web services on multiple foreign servers, with multiple self-hosted applications on one personal server.

Every architectural decision for Arvo (and indeed, the entire Urbit stack) was made with this singular goal in mind. Throughout this document, we connect the various concepts underlying Arvo with this overarching goal.

## An operating function

Arvo is the world's first _purely functional_ operating system, and as such it may reasonably be called an _operating function_. The importance of understanding this design choice and its relevence to the overarching goal cannot be understated. If you knew only a single thing about Arvo, let it be this.

This means two things: one is that the there is a notion of _state_ for the operating system, and that the current state is a pure function of the [event log](#event-log), which is a chronological record of every action the operating system has ever performed. A _pure function_ is a function that always produces the same output given the same input. Another way to put this is to say that Arvo is _deterministic_. Other operating systems are not deterministic for a number of reasons, but one simple reasons is because they allow programs to alter global variables that then affect the operation of other programs.

In mathematical terms, one may think of Arvo as being given by a transition function _T_:

```
T: (State, Input) -> (State, Output).
```

In practice, _T_ is implemented by the `+poke` arm of the Arvo kernel, which is described in more detail in the [kernel section](#the-kernel). In theoretical terms, it may be more practical to think of Arvo as being defined by a _lifecycle function_ we denote here by _L_:

```
L: History -> State.
```

Arvo was made to be purely functional in order to eliminate the need for the user to have to manage their own server. Being deterministic enables many incredible things that are out of reach of any other operating system. For instance, we are able to do [over the air](#over-the-air-updates) (OTA) updates, which allows bug fixes to be implemented across the network without needing to worry whether it won't work on someone's ship.

### Event log

>The formal state of an Arvo instance is an event history, as a linked list of nouns from first to last. The history starts with a bootstrap sequence that delivers Arvo itself, first as an inscrutable kernel, then as the selfcompiling source for that kernel. After booting, we break symmetry by delivering identity and entropy. The rest of the log is actual input.

The Arvo event log is a list of every action ever performed on your ship that lead up to the current state. In principle, this event log is maintained by the [Nock runtime environment](#virtual-machine), but in practice event logs become too long over time to keep. Thus periodic snapshots of the state of Arvo are taken and the log up to that state is pruned.

The beginning of the event log starting from the very first time a ship is booted up until the kernel is compiled and identity and entropy are created is a special portion of the Arvo lifecycle known as the _larval stage_. We describe the larval stage in more detail in the [boot sequence](#boot-sequence) section.

More information on the structure of the Arvo event log and the Arvo state is given in the section on [the kernel](#the-kernel).

>User-level code is virtualized within a Nock interpreter written in Hoon (with zero virtualization overhead, thanks to a jet). Arvo defines a typed, global, referentially transparent namespace with the Ames network identity (page 34) at the root of the path. User-level code has an extended Nock operator that dereferences this namespace and blocks until results are available. So the Hoon programmer can use any data in the Urbit universe as a typed constant.

> Most Urbit data is in Clay, a distributed revision-control vane. Clay is like a typed Git. If we know the format of an object, we can do a much better job of diffing and patching files. Clay is also good at subscribing to updates and maintaining one-way or two-way automatic synchronization.


### Over the air updates

> Nock is frozen, but Arvo can hotpatch any other semantics at any layer in the system (apps, vanes, Arvo or Hoon itself) with automatic over-the-air updates.
### Solid-state interpeter

>We call an execution platform with these three properties (universal persistence, source-independent packet I/O, and high-level determinism) a solid-state interpreter (SSI). A solid-state interpreter is a stateful packet transceiver. Imagine it as a chip. Plug this chip into power and network; packets go in and out, sometimes changing its state. The chip never loses data and has no concept of a reboot; every packet is an ACID transaction.

### Single-level store

>A kernel which presents the abstraction of a single layer of permanent state is also called a single-level store [12]. One way to describe a single-level store is that it never reboots; a formal model of the system does not contain an operation which unpredictably erases half its brain.


### Event-driven


### Interacting with Arvo

#### Dojo

You will first interact with your instance of Arvo with a [REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop) known as the dojo. The dojo allows you to input commands to your ship as well as run Hoon code. You can find a comprehensive guide to using your ship in dojo in our guide on [using your ship](@/using/operations/using-your-ship.md)y.

(picture of dojo)

### Landscape


For those who would prefer to interact with Arvo via a GUI, we offer an application called Landscape. This is the most user-friendly way to utilize your ship. By default, Arvo comes installed with a timer, Chat, Weather, and Publish, which will populate your Landscape interface the first time you launch it. Again, see [using your ship](@/using/operations/using-your-ship.md#landscape) for instructions on how to access Landscape.

<img class="mv5 w-100" src="https://media.urbit.org/site/understanding-urbit/project-history/project-status-landscape%402x.png">

## The stack

Diagram with Unix -> Nock VM (Jacque) -> Arvo kernel -> Gall userspace -> Dojo

Ultimately, everything that happens in Arvo is reduced to Unix events.

## The kernel

The Arvo kernel, stored in `sys/arvo.hoon`, is about 1k lines of Hoon whose primary purpose is to implement the transition function, `+poke`. In this section we point out the most important parts of `arvo.hoon` and describe their role in the greater system. We also give brief descriptions of Arvo's kernel modules, known as vanes, and how Arvo interfaces with them.

This section requires an understanding of Hoon of at least the level of Chapter One of the [Hoon tutorial](@/docs/tutorials/hoon/_index.md).

### Overall structure

`arvo.hoon` contains five top level cores. We refer to them informally as follows, and list them in the order in which they are nested (i.e. cores lower in the list are nested within cores higher on the list via `=>`).
 + Types
 + "Section 3bE Arvo Core"
 + Implementation core
 + Structural interface core
 + Larval stage core
 
#### Types

This core contains the most basic types utilized in Arvo. We discuss a number of them here.

##### `+duct`

The `Arvo` causal stack is called a `+duct`. This is represented simply as a list of paths, where each path represents a step in the causal chain. The first element in the path is the first letter of whichever vane handled that step in the computation, or the empty span for Unix.

Here's a duct that was recently observed in the wild (I should redo this to make sure its up to date)

```
~[
  /g/a/~zod/4_shell_terminal/u/time
  /g/a/~zod/shell_terminal/u/child/4/main
  /g/a/~zod/terminal/u/txt
  /d/term-mess
  //term/1
]
```

This is the duct the timer vane, Behn, receives when the "timer" sample app asks the timer vane to set a timer. This is also the duct over which the response is produced at the specified time. Unix sent a terminal keystroke event (enter), and Arvo routed it to Dill (our terminal), which passed it on to the Gall app terminal, which sent it to shell, its child, which created a new child (with process id 4), which on startup asked Behn to set a timer.

Behn saves this duct, so that when the specified time arrives and Unix sends a wakeup event to the timer vane, it can produce the response on the same duct. This response is routed to the place we popped off the top of the duct, i.e. the time app. This app produces the text "ding", which falls down to the shell, which drops it through to the terminal. Terminal drops this down to Dill, which converts it into an effect that Unix will recognize as a request to print "ding" to the screen. When dill produces this, the last path in the duct has an
initial element of the empty span, so this is routed to Unix, which applies the effects.

This is a call stack, with a crucial feature: the stack is a first-class citizen. You can respond over a duct zero, one, or many times. You can save ducts for later use. There are definitely parallels to Scheme-style continuations, but simpler and with more structure.


##### `wire`
Synonym for path, used in ducts.

#### Section 3bE Arvo Core

#### Implementation core

#### Structural interface core

#### Larval stage core

### The state

The Arvo transition function, called `+poke`,  takes the current state of Arvo and an event and outputs the new state of Arvo and the response to the event, if any. Here we explain how the state of Arvo is actually structured, to inform our study of `+poke`.

`arvo.hoon`

### +poke

### +peek

### Vanes

## Boot sequence

### Larval stage

>Before we plug the newborn node into the network, we feed it a series of bootstrap or “larval” packets that prepare it for adult life as a packet transceiver on the public network. The larval sequence is private, solving the secret delivery problem, and can contain as much code as we like.









# Principles

At a high level `%arvo` takes a mess of Unix I/O events and turns them into something clean and structured for the programmer.

`%arvo` is designed to avoid the usual state of complex event networks: event spaghetti. We keep track of every event's cause so that we have a clear causal chain for every computation. At the bottom of every chain is a Unix I/O event, such as a network request, terminal input, file sync, or timer event. We push every step in the path the request takes onto the chain until we get to the terminal cause of the computation. Then we use this causal stack to route results back to the caller.

### Making Moves

If ducts are a call stack, then how do we make calls and produce results? Arvo processes "moves" which are a combination of message data and metadata. There are two types of moves. A `%pass` move is analogous to a call:

```
[duct %pass return-path=path vane-name=@tD data=card]
```

Arvo pushes the return path (preceded by the first letter of the vane name) onto the duct and sends the given data, a card, to the vane we specified. Any response will come along the same duct with the path `return-path`.

A `%give` move is analogous to a return:

```
[duct %give data=card]
```

Arvo pops the top path off the duct and sends the given card back to the caller.

### Vanes

As shown above, we use Arvo proper to route and control the flow of moves. However, Arvo proper is rarely directly responsible for processing the event data that directly causes the desired outcome of a move. This event data is contained within a card, which is simply a `(pair term noun)`. Instead, Arvo proper passes the card off to one of its vanes, which each present an interface to clients for a particular well-defined, stable, and general-purpose piece of functionality.

As of this writing, we have seven vanes, which each provide the following services:

- `%ames`: the name of both our network and the vane that communicates over it.
- `%behn`: a simple timer.
- `%clay`: our version-controlled, referentially- transparent, and global filesystem.
- `%dill`: a terminal driver. Unix sends keyboard events to `%dill` from either the console or telnet, and `%dill` produces terminal output.
- `%eyre`: an http server. Unix sends http messages to `%eyre`, and `%eyre` produces http messages in response.
- `%ford`: handles resources and publishing.
- `%gall`: manages our userspace applications. `%gall` keeps state and manages subscribers.

### Cards

Cards are the vane-specific portion of a move. Each vane defines a protocol for interacting with other vanes (via Arvo) by defining four types of cards: tasks, gifts, notes, and signs.

When one vane is `%pass`ed a card in its `++task` (defined in zuse), Arvo activates the `++call` gate with the card as its argument. To produce a result, the vane `%give`s one of the cards defined in its `++gift`. If the vane needs to request something of another vane, it `%pass`es it a `++note` card. When that other vane returns a result, Arvo activates the `++take` gate of the initial vane with one of the cards defined in its `++sign`.

In other words, there are only four ways of seeing a move: (1) as a request seen by the caller, which is a ++note. (2) that same request as seen by the callee, a `++task`. (3) the response to that first request as seen by the callee, a `++gift`. (4) the response to the first request as seen by the caller, a `++sign`.

When a `++task` card is passed to a vane, Arvo calls its `++call` gate, passing it both the card and its duct. This gate must be defined in every vane. It produces two things in the following order: a list of moves and a possibly modified copy of its context. The moves are used to interact with other vanes, while the new context allows the vane to save its state. The next time Arvo activates the vane it will have this context as its subject.

This overview has detailed how to pass a card to a particular vane. To see the cards each vane can be `%pass`ed as a `++task` or return as a `++gift` (as well as the semantics tied to them), each vane's public interface is explained in detail in its respective overview.
