+++
title = "Overview"
weight = 1
template = "doc.html"
+++

![landscape](https://storage.googleapis.com/media.urbit.org/tlon/landscapes.png)

The architecture of Landscape’s userspace application suite has gone through a
number of overhauls in the past few years, and each iteration has gotten closer
to a point where Urbit’s userspace can truly perform as a next-generation social
suite built entirely on distributed networking and individual-owned personal
servers.

As of this year, this application suite has arrived at a point where we’re
confident both in how all the parts fit together, and confident in the
individual parts.


## What is Landscape Intended to Be?

Landscape is a single suite of userspace applications built to run on top of
Urbit. Landscape is maintained by [Tlon](https://tlon.io), a for-profit corporation that helps
research Urbit. Landscape is one of many possible application suites for Urbit,
and we hope many others emerge that build on top of the Arvo kernel. We plan on
making Landscape itself more extensible for user-developers in late 2021.

Landscape is specifically a social suite of applications, meant to enable
communication and socializing in many forms. 


## What is Landscape technically composed of?

Landscape is composed of two primary parts: its backend, which runs as a suite of userspace applications (also known as Gall agents), and its frontend interface, which runs as a single-page web application. Both the backend and the frontend may be decomposed into their constituent parts for further understanding.


### Backend

The Landscape backend is implemented as a collection of long-running
microservices known as [Gall agents](@/docs/arvo/gall/gall.md). They can be divided into the following,
though this is a simplification:

- **Graph**: handles storing messages / posts in a non-relational database
- **Groups**: organizes people into groups and roles and handles permissioning
- **Metadata**: a database join between graphs and groups, it also provides
  titles and descriptions for graphs and groups
- **Contacts**: handles nicknames, profile pictures, and ship-related metadata
- **Invites**: a generic inviting subsystem that is used for joining graphs or groups
- **Hark**: a notification subsystem for keeping track of read state and
  notifying users

Each of these components are built out using a few microservices that handle
more specific responsibilities. These responsibilities can be subdivided into
two main categories: [stores](#stores) and [hooks](#hooks). To simply describe
the separation of responsibilities, stores are dumb databases (models in MVC)
and hooks are for processing data (controllers in MVC).


### Stores {#stores}

Concisely defined, a store is a dumb database. It does not send outgoing pokes,
watches, or peeks, except in an `+on-load` to migrate its state. It does store
permanent and/or temporary state, allows incoming peeks/watches to read that
data, and allows pokes to modify that data. A store may only accept local reads
and writes, not remote ones. It may or may not interact with various kernel
modules. Examples include:
[graph-store](https://github.com/urbit/urbit/blob/ac096d85ae847fcfe8786b51039c92c69abc006e/pkg/arvo/app/graph-store.hoon),
[group-store](https://github.com/urbit/urbit/blob/ac096d85ae847fcfe8786b51039c92c69abc006e/pkg/arvo/app/group-store.hoon),
[metadata-store](https://github.com/urbit/urbit/blob/ac096d85ae847fcfe8786b51039c92c69abc006e/pkg/arvo/app/metadata-store.hoon),
[contact-store](https://github.com/urbit/urbit/blob/ac096d85ae847fcfe8786b51039c92c69abc006e/pkg/arvo/app/contact-store.hoon),
and
[invite-store](https://github.com/urbit/urbit/blob/ac096d85ae847fcfe8786b51039c92c69abc006e/pkg/arvo/app/invite-store.hoon).


### Hooks {#hooks}

A hook is a more loosely-defined agent that performs business logic. It should
only keep track of a minimal amount of state (*e.g.* active subscriptions). Hooks
are used for a variety of purposes in the system, but there are a few important
hook patterns to be aware of:

#### Pull Hooks

A pull-hook syncs data from a remote resource down to a local resource. There is
a
[pull-hook](https://github.com/urbit/urbit/blob/master/pkg/arvo/lib/pull-hook.hoon)
library that drastically simplifies the implementation of such a hook, and is
the defacto standard for how to sync down remote data to your ship.

#### Push Hooks

A push-hook allows remote ships to subscribe to and sync down the information
from a local resource. There is a [push-hook
library](https://github.com/urbit/urbit/blob/ac096d85ae847fcfe8786b51039c92c69abc006e/pkg/arvo/lib/push-hook.hoon)
that drastically simplifies the implementation of such a hook, and is the
defacto standard for how to make local data available to remote ships.

#### Observe Hook

The observe-hook subscribes to data coming in from another agent, and starts up
a thread of computation every time a subscription update from that agent is
received.

#### Poke-Proxy Hook

The poke-proxy-hook conditionally forwards a poke from a foreign ship to a store
on the local ship if the foreign ship has permission to do so. 


### Major Components

#### Groups

Groups are the core building block of data permissioning within Landscape. A
group is made up of the following fields:

```
+$  group
  $:  members=(set ship)
      =tags
      =policy
      hidden=?
  ==
```

- `members` is a set of ships that are at present in the group
- `tags` are strings that may define additional permissions or roles within the
  group
- The `policy` defines whether a group is open to new members, is invite-only, or
  has some other scheme
- `hidden` is a boolean flag that determines whether the group’s lifecycle is
  attached to a single external resource (such as a chat DM, which when the DM
  is deleted, the group is deleted too), or whether it has an independent life
  of its own. This flag also determines whether the group should show up in
  interfaces as something that may be managed and edited.

The `%group-store` holds a map of these groups and allows subscriptions to their
data. The group-store may be accessed from foreign ships through the use of the
`%group-pull-hook` and `%group-push-hook`. Groups may be joined either by
manually discovering and pasting in a group name into the “join group” dialogue
in the interface for an open group, or by accepting an invite to an invite-only
group. When a group is deleted, all data related to it is deleted or archived as
well.

#### Graphs

Graphs are the core place where we store social user-generated content: chat
messages, social network posts, blog posts, links, and eventually multimedia.
Graph store is built to be flexible enough to support many different types of
“apps” built on top of it, whether you want to have a forum with some friends, a
Pinterest equivalent, a more private version of Facebook, a decentralized
Reddit, or an even more distributed version of Mastodon. You can read more about
graph-store by [viewing the
source](https://github.com/urbit/urbit/blob/ac096d85ae847fcfe8786b51039c92c69abc006e/pkg/arvo/app/graph-store.hoon)
or reading our [API Reference](@/docs/landscape/reference/graph-store.md) documentation.

The `%graph-store` may be accessed from foreign ships through the use of the
`%graph-pull-hook` and `%graph-push-hook`.

#### Metadata

Metadata is stored in the `%metadata-store`, and is where we store metadata
about resources (ex: graphs or groups). We store their display name,
description, a color, and the date they were added. We also store what group the
resource is associated with, what app the resource is associated with, and what
module (display mode) the resource should be used with. 

Metadata within the broader context of the userspace application suite can best
be thought of as a database join between the `%group-store` and the
`%graph-store`, as it provides bidirectional indices for querying all of the
graphs that a group has, or which group a particular graph is associated with.


#### Contacts

Contacts are your address book. Individual ships (people) you talk to may have a
 nickname, a profile picture, or a colored sigil background that helps you
 identify them in groups, chatrooms, blogs, and collections.


#### Invites

Invites is a simple subsystem that allows you to send all the details of a given
resource (*e.g.* graph or group) to some other ship so that they may join it if
they desire to. Invite acceptance is handled with threads that listen to the
`%invite-store` using the `%observe-hook` and invite sending is handled with the
`%invite-hook`, which allows any ship to send you an invite without any
permissions involved.


#### Hark

Hark is a generic notification and unread-tracking subsystem that currently
keeps track of all unread functionality for the system. The `%hark-graph-hook`
sends data about `%graph-store` events to `%hark-store`.
