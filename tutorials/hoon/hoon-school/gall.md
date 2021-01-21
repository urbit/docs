+++
title = "2.7 Gall"
weight = 35
template = "doc.html"
aliases = ["/docs/learn/hoon/hoon-tutorial/gall/"]
insert_anchor_links = "none"
+++

Gall is the Arvo vane responsible for handling user space applications. When writing a Gall application there are several things you will need to understand.

For another explanation of Gall, take a look at [/tutorial/arvo/gall](/docs/tutorials/arvo/gall)

## bowl and moves

The [core](/docs/glossary/core/) of a gall app is a [door](/docs/glossary/door/) which has two parts of its subject, the first a `bowl:gall` which contains a lot of standard things used by gall apps, the second a type containing app state information.

Vanes in Arvo communicate by means of `moves`. When a move is produced by an [arm](/docs/glossary/arm/) in a gall app, it's dispatched by Arvo to the correct handler for the request, be it another application or another vane. A `move` is pair of `bone` and `card`. These are essential components to understand when learning to use gall.

A `bone` is an opaque cause that initiates a request. When constructing a `move` you can often use `ost.bowl` and when responding to an incoming `move` you can use the `bone` in that `move` to construct your response.

A `card` is the effect or event that is being requested. Each application should define the set of `cards` it can produce. Here is an excerpt from `clock.hoon` showing its `cards`

```hoon
+$  card
  $%  [%poke wire dock poke]
      [%http-response =http-event:http]
      [%connect wire binding:eyre term]
      [%diff %json json]
  ==
```

Each `card` is a pair of a tag and a [noun](/docs/glossary/noun/). The tag indicates what the event being triggered is and the [noun](/docs/glossary/noun/) is any data required for that event.

## Arms

Gall applications can have a number of arms that get called depending on the information they are sent.

This arm is called once when the agent is started.  It has no input and
lets you perform any initial IO.

### +on-init

This arm is called when the app is initially started.

### +on-save

This arm is called immediately before the agent is upgraded.  It
packages the permament state of the agent in a `vase` for the next version
of the agent.  Unlike most handlers, this cannot produce effects.

### +on-load

This arm is called immediately after the agent is upgraded.  It receives
a `vase` of the state of the previously running version of the agent,
which allows it to cleanly upgrade from the old agent.

### +on-poke

This arm is called when the agent is "poked".  The input is a `cage`, so
it's a pair of a mark and a dynamic `vase`.

### +on-watch

This arm is called when a program wants to subscribe to the agent on a
particular `path`.  The agent may or may not need to perform setup steps
to intialize the subscription.  It may produce a `%give`
`%subscription-result` to the subscriber to get it up to date, but after
this event is complete, it cannot give further updates to a specific
subscriber.  It must give all further updates to all subscribers on a
specific `path`.

If this arm crashes, then the subscription is immediately terminated.
More specifcally, it never started -- the subscriber will receive a
negative `%watch-ack`.  You may also produce an explicit `%kick` to
close the subscription without crashing -- for example, you could
produce a single update followed by a `%kick`.

### +on-leave

This arm is called when a program becomes unsubscribed to you.
Subscriptions may close because the subscriber intentionally
unsubscribed, but they also could be closed by an intermediary.  For
example, if a subscription is from another ship which is currently
unreachable, Ames may choose to close the subscription to avoid queueing
updates indefinitely.  If the program crashes while processing an
update, this may also generate an unsubscription.  You should consider
subscriptions to be closable at any time.

### +on-peek

This arm is called when a program reads from the agent's "scry"
namespace, which should be referentially transparent.  Unlike most
handlers, this cannot perform IO, and it cannot change the state.  All
it can do is produce a piece of data to the caller, or not.

If this arm produces `[~ ~ data]`, then `data` is the value at the the
given `path`.  If it produces `[~ ~]`, then there is no data at the given
`path` and never will be.  If it produces `~`, then we don't know yet
whether there is or will be data at the given `path`.

### +on-agent

This arm is called to handle responses to `%give` moves to other agents.
It will be one of the following types of response:

- `%poke-ack`: acknowledgment (positive or negative) of a poke.  If the
  value is `~`, then the poke succeeded.  If the value is `[~ tang]`,
  then the poke failed, and a printable explanation (e.g. a stack trace)
  is given in the `tang`.

- `%watch-ack`: acknowledgment (positive or negative) of a subscription.
  If negative, the subscription is already ended (technically, it never
  started).

- `%fact`: update from the publisher.

- `%kick`: notification that the subscription has ended.

### +on-arvo

This arm is called to handle responses to `%pass` `move`s to vanes.  The
list of possible responses from the system is statically defined in
sys/zuse.hoon (grep for `+  sign-arvo`).

### +on-fail

If an error happens in `+on-poke`, the crash report goes into the
`%poke-ack` response.  Similarly, if an error happens in
`+on-subscription`, the crash report goes into the `%watch-ack`
response.  If a crash happens in any of the other handlers, the report
is passed into this arm.

