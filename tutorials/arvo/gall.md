+++
title = "Gall Apps"
weight = 6
template = "doc.html"
aliases = ["/docs/learn/arvo/gall/"]
+++

This document describes Gall, the Arvo userspace vane. It is accurate as of 2019.12.02.

# Agents

Urbit code lives in the following basic categories:

- Runtime (Nock interpreter, persistence engine, IO drivers, jets)
- Kernel vanes (managed by Arvo)
- Userspace agents (managed by Gall, permanent state)
- Userspace imps (managed by Spider, transient state)

This lays out the framework for the third category:  Agents.

An agent is a piece of software that is primarily focused on maintaining
and distributing a piece of state with a defined structure.  It exposes
an interface that lets programs read, subscribe to, and manipulate the
state.  Every event happens in an atomic transaction, so the state is
never inconsistent.  Since the state is permanent, when the agent is
upgraded with a change to the structure of the state, the developer
provides a migration function from the old state type to the new state
type.

It's not too far off to think of an agent as simply a database with
developer-defined logic.  But an agent is significantly less constrained
than a database.  Databases are usually tightly constrained in one or
more ways because they need to provide certain guarantees (like
atomicity) or optimizations (like indexes).  Urbit is a single-level
store, so atomicity comes for free.  Many applications don't use
databases because they need relational indices; rather, they use them
for their guarantees around persistence.  Some do need the indices,
though, and it's not hard to imagine an agent which provides a SQL-like
interface.

On the other hand, an agent is also a lot like what many systems call a
"service".   An agent is permanent and addressable -- a running program
can talk to an agent just by naming it. An agent can perform IO, unlike
most databases.  This is a critical part of an agent:  it performs IO
along the same transaction boundaries as changes to its state, so if an
effect happens, you know that the associated state change has happened.
You should be careful, though, to avoid creating implicit non-atomicity
-- eg if it comes into an inconsistent state pending a response to an IO
action.

But the best way to think about an agent is as a state machine.  Like a
state machine, any input could happen at any time, and it must react
coherently to that input.  Ouput (effects) and the next state of the
machine are both pure functions of the previous state and the input
event.  Of course, it's important to ensure there isn't an order of
events that could cause your agent to enter an inconsistent state.

We often think of state machines as finite state machines, but of course
in this instance, the state is not actually finite (though it should be
definable in a regular recursive data type).  

## Specification

An agent is defined as a [core](/docs/glossary/core/) with a set of [arm](/docs/glossary/arm/)s to handle various
events.  These handlers usually produce a list of effects and the next
state of the agent.  The interface definition can be found in
`sys/zuse.hoon`, which at the time of writing is:

```hoon
++  agent
  =<  form
  |%
  +$  step  (quip card form)
  +$  card  (wind note gift)
  +$  note
    $%  [%arvo =note-arvo]
        [%agent [=ship name=term] =task]
    ==
  +$  task
    $%  [%watch =path]
        [%watch-as =mark =path]
        [%leave ~]
        [%poke =cage]
        [%poke-as =mark =cage]
    ==
  +$  gift
    $%  [%fact path=(unit path) =cage]
        [%kick path=(unit path) ship=(unit ship)]
        [%watch-ack p=(unit tang)]
        [%poke-ack p=(unit tang)]
    ==
  +$  sign
    $%  [%poke-ack p=(unit tang)]
        [%watch-ack p=(unit tang)]
        [%fact =cage]
        [%kick ~]
    ==
  ++  form
    $_  ^|
    |_  bowl
    ++  on-init
      *(quip card _^|(..on-init))
    ::
    ++  on-save
      *vase
    ::
    ++  on-load
      |~  old-state=vase
      *(quip card _^|(..on-init))
    ::
    ++  on-poke
      |~  [mark vase]
      *(quip card _^|(..on-init))
    ::
    ++  on-watch
      |~  path
      *(quip card _^|(..on-init))
    ::
    ++  on-leave
      |~  path
      *(quip card _^|(..on-init))
    ::
    ++  on-peek
      |~  path
      *(unit (unit cage))
    ::
    ++  on-agent
      |~  [wire sign]
      *(quip card _^|(..on-init))
    ::
    ++  on-arvo
      |~  [wire sign-arvo]
      *(quip card _^|(..on-init))
    ::
    ++  on-fail
      |~  [term tang]
      *(quip card _^|(..on-init))
    --
```

Here's a skeleton example of an implementation:

```hoon
^-  agent:gall
=|  state=@
|_  bowl:gall
+*  this  .
++  on-init
  `this
::
++  on-save
  !>(state)
::
++  on-load
  |=  =old-state=vase
  =/  old-state  !<(@ old-state-vase)
  ?~  old-state
    ~&  %prep-lost
    `this
  ~&  %prep-found
  `this(state u.old-state)
::
++  on-poke
  |=  [=mark =vase]
  ~&  state=state
  ~&  got-poked-with-data=mark]
  =.  state  +(state)
  `this
::
++  on-watch
  |=  path
  `this
::
++  on-leave
  |=  path
  `this
::
++  on-peek
  |=  path
  *(unit (unit cage))
::
++  on-agent
  |=  [wire sign:agent:gall]
  `this
::
++  on-arvo
  |=  [wire sign-arvo]
  `this
::
++  on-fail
  |=  [term tang]
  `this
--
```

We also supply a `default-agent` library, which is useful if you don't
want to handle some of the [arm](/docs/glossary/arm/)s.  Most of the above could also be
implemented as:

```hoon
/+  default-agent
^-  agent:gall
=|  state=@
|_  =bowl:gall
+*  this      .
    default   ~(. (default-agent %|) bowl)
::
++  on-init   on-init:default
++  on-save   on-save:default
++  on-load   on-load:default
++  on-poke
  |=  [=mark =vase]
  ~&  >  state=state
  ~&  got-poked-with-data=mark
  =.  state  +(state)
  `this
::
++  on-watch  on-watch:default
++  on-leave  on-leave:default
++  on-peek   on-peek:default
++  on-agent  on-agent:default
++  on-arvo   on-arvo:default
++  on-fail   on-fail:default
--
```

So, an agent is a [core](/docs/glossary/core/) with 10 [arm](/docs/glossary/arm/)s.  The handlers correspond to
different sorts of input.  We'll discuss each of these in detail, but
first a few general concepts.

## Basic concepts

### Interacting with an agent

There are two basic ways programs can interact with an agent:  you may
subscribe to data as described above, or you may "poke" an agent to send
it a command.  Suppose there is an agent for a calendar service; then,
pokes would likely include `%create-event`, `%modify-event`,
`%delete-event`, and `%change-time-zone` (along with assocated data).
Subscription paths could include `/next-event` and `/all-events`.

Agents generally conform to CQRS -- pokes may change state, but
subscriptions generally shouldn't.  In practice, there may be state
changes required to properly initialize the subscription, but these
shouldn't change the essential state of the agent.

### Cards

Most of the handlers produce a `(quip card agent:gall)`, which is just
`[(list card) agent:gall]`.  The first allows us to produce effects, and
the second allows us to maintain state.

A card is one of two things:  a `note` or a `gift`.  You `%pass` `note`s
and you `%give` `gift`s.  When you pass a `note`, you expect zero or more
responses; when you give a `gift`, you will not get a response.  Since you
may get a response to a `note`, you tag it with a `wire` so that you can
identify the response.

Thus, we say you "pass a `note` along a `wire`", or you "give a `gift`".
These phrases correspond to producing a card that looks like:

```hoon
[%pass /my/wire a-note]
```

or

```hoon
[%give a-gift]
```

When you give a `gift`, that's the end of the story, but when you pass a
`note`, you may get a response.  If you do, then the response will come
tagged with the `wire` that you used to pass the `note`.  It's generally
good practice to make your `wire`s fairly unique within your agent, since
otherwise you may not be able to distinguish the responses.

#### Notes

An agent may pass `note`s to either Arvo or another agent.  If the `note` is
to another agent, then it should usually be one of these:

```hoon
[%pass /my/wire %agent our.bowl agent-name %watch /a/path]
[%pass /my/wire %agent our.bowl agent-name %leave ~]
[%pass /my/wire %agent our.bowl agent-name %poke %foo-mark !>(poke-data)]
```

Note that to unsubscribe to a `path`, you must send the unsubscription on
the same `wire` that sent for the original subscription.  Don't subscribe
to separate `path`s along the same `wire`, because then you can't properly
distinguish them for cancelling (besides not being able to distinguish
the subscription updates).  In other words, besides letting *you*
distinguish your `card`s, the `wire` also identifies requests for the system.

If the `note` is not to another agent but to Arvo itself, then it is a
request to one of the vanes, which are kernel modules that provide
various system services, including IO.  Here are some examples:

```hoon
[%pass /my/wire %arvo %b %wait (add now.hid ~s10)]
```

This is a request to the `%b` vane (Behn, the timer vane) to set a timer
for 10 seconds in the future.  After 10 seconds, Behn will respond with
a `%wake` card, which you will recieve in `+on-arvo`.  It will come back
on `/my/wire`.

```hoon
=/  =path  /(scot %p our.hid)/home/(scot %da now.hid)/my-file/txt
=/  contents=cage  [%txt !>(~['text file line 1' 'line 2'])]
[%pass /my/wire %arvo %c %info (foal path contents)]
```

This is a request to the `%c` vane (Clay, the filesystem vane) to write
a file to `/my-file/txt` in the home desk.  You will not receive a
response to this `note`.

```hoon
=/  =path  /my-file/txt
=/  =moat  [da+now.hid da+(add now.hid ~h1) path]
[%pass /my/wire %arvo %c %warp our.hid %home ~ %many & moat]
```

This is a request to the `%c` vane to send us a `%writ` `card` whenever
`/my-file/txt` changes in the next hour.  There may be many responses to
this note if the file changes many times.

```hoon
=/  =request:http
  [%'GET' 'https://example.com' ~ ~]
[%pass /my/wire %arvo %i %request request *outbound-config:iris]
```

This is a request to the `%i` vane (Iris, the HTTP client vane) to make
a GET HTTP request to example.com.  The response will come as an
`%http-response` card.

#### Gifts

In contrast to the many possible `note`s, there are only two types of
`gift`s that an agent may give:

```hoon
[%give %fact (unit path) =cage]
[%give %kick (unit path)]
```

A subscription update is a new piece of subscription content for all
subscribers on a given `path`.  If no `path` is given, then the update is
only given to the program that instigated this request.  Typical use of
this mode is in `+on-watch` to give an initial update to a new
subscriber to get them up to date.

A subscription close closes the subscription for all subscribers on a
given `path`.  If no `path` is given, then the update is only given to the
program that instigated this request.  Typical use of this mode would be
in `+on-watch` to produce a single update to a subscription then close
the subscription.

### Vases and cages

A `vase` is a piece of dynamic data.  Structurally, it's a pair of an
explicit reification of a type and an untyped [noun](/docs/glossary/noun/).  This lets us
represent a value which has a type that isn't known at compile time.  A
vase has three operations:

- `!>` is a unary rune that lifts a statically typed value to a
  dynamically-typed `vase`.  For example, `!>('hi')` gives `[[%atom %t ~]
  26.984']`, which has type `[type *]`.

- `!<` is a binary rune that takes a mold and a dynamically typed `vase`
  and reduces it to a statically typed value.  If the `vase` does not in
  fact have the type of the mold you give it, then it produces `~`, else
  it produces `[~ value]`.  For example, `!<(@t !>('hi'))` produces `[~
  'hi']` while `!<(^ !>('hi'))` produces `~`.

- The compiler takes text and converts it to a `vase` of the compiled
  code.  Agents shouldn't need this directly, but Gall uses this to
  compile agents to `vase`s, on which it calls `!<(agent:gall
  compiled-agent-vase)`.

A `cage` is simply a pair of a mark and a vase.  A mark is a textual tag
that should correspond to the particular dynamic type in the vase.

In agents, we use vases to represent types which Gall doesn't know about
when it was compiled, but which nevertheless need to go outside the
agent.  In practice, there are three common cases:

- The data in a "poke" request is of a type that is defined by each
  agent, so it must by dynamic.  This is the input to `++on-poke` as well
  as the cage in the `%poke` case of the `%agent` note.

- The data in a subscription update is defined by each agent, so it must
  be dynamic.  This is the cage in `%fact`, both when giving the update
  and in the input to `+on-agent`.

- The state of an agent is also unique to each agent.  Most of the time,
  Gall doesn't interact directly with agent's state, but when upgrading
  an agent, it must pass the state of the old version of the agent to
  the new version of the agent.  This is the output of `+on-save` and
  the input to `+on-load`.

### State

In the definition of an agent, the entire [core](/docs/glossary/core/) is wrapped with the `^|`
rune, which corresponds to the "iron" variance mode.  This means it's
"contravariant" in the input, which allows Gall to write to the new bowl
on every event.  It also means that the context of the [core](/docs/glossary/core/) is opaque to
Gall, which means you can store state in your context in whatever
structure you want.

This is why most of the handler [arm](/docs/glossary/arm/)s produce not just a list of cards
but also a new `agent:gall`.  Usually, this will be the "same" agent in
the sense that the code will be the same, but you may have changed the
state that's stored in its (opaque to Gall) context.

The skeleton example above gives an example of keeping an [atom](/docs/glossary/atom/) as your
state.  Define the state in the context of your agent [core](/docs/glossary/core/), then you can
change it with `=.` or `%=`, as long as you produce the new version of
the agent [core](/docs/glossary/core/).

When you upgrade an agent, you need to extract the state from your
opaque context and produce it to Gall as a dynamically typed vase.
Usually, this will be easy:  just call `!>` on whatever state you wish
to preserve.  This is `+on-save`.

When the new agent is about to be started, Gall will call it with
`+on-load` with the vase just produced above.  This allows you to ingest
your old state and continue right where you left off.

If the type of your state hasn't changed, you can just

```hoon
=.  state  !<(state-type old-state-vase)
```

If it has changed, then it should look more like:

```hoon
=.  state  (upgrade-state !<(old-state-type old-state-vase))
```

It's useful to tag your state with a version number so that the
`+upgrade-state` function can take a tagged union of all your old state
types and upgrade from any of them to the current state type.  For
example, it may have the following structure:

```hoon
+$  old-state-types
  $%  [%0 s=state-0]
      [%1 s=state-1]
      [%2 s=state-2]
  ==
++  upgrade-state
  |=  old=old-state-types
  =?  old  ?=(%0 -.old)
    (state-0-to-1 s.old)
  =?  old  ?=(%1 -.old)
    (state-1-to-2 s.old)
  ?>  ?=(%2 -.old)
  s.old
```

### Bowl

The [core](/docs/glossary/core/) takes as input a `bowl`, which includes useful info like the
current ship, the current time, and a renewable source of entropy.  This
information is available to any of the handlers.

## Arms

A description of each of the handler [arm](/docs/glossary/arm/)s follows.

### +on-init

This [arm](/docs/glossary/arm/) is called once when the agent is started.  It has no input and
lets you perform any initial IO.

### +on-save

This [arm](/docs/glossary/arm/) is called immediately before the agent is upgraded.  It
packages the permament state of the agent in a `vase` for the next version
of the agent.  Unlike most handlers, this cannot produce effects.

### +on-load

This [arm](/docs/glossary/arm/) is called immediately after the agent is upgraded.  It receives
a `vase` of the state of the previously-running version of the agent,
which allows it to cleanly upgrade from the old agent.

### +on-poke

This [arm](/docs/glossary/arm/) is called when the agent is "poked".  The input is a `cage`, so
it's a pair of a mark and a dynamic `vase`.

### +on-watch

This [arm](/docs/glossary/arm/) is called when a program wants to subscribe to the agent on a
particular `path`.  The agent may or may not need to perform setup steps
to intialize the subscription.  It may produce a `%give`
`%subscription-result` to the subscriber to get it up to date, but after
this event is complete, it cannot give further updates to a specific
subscriber.  It must give all further updates to all subscribers on a
specific `path`.

If this [arm](/docs/glossary/arm/) crashes, then the subscription is immediately terminated.
More specifcally, it never started -- the subscriber will receive a
negative `%watch-ack`.  You may also produce an explicit `%kick` to
close the subscription without crashing -- for example, you could
produce a single update followed by a `%kick`.

### +on-leave

This [arm](/docs/glossary/arm/) is called when a program becomes unsubscribed to you.
Subscriptions may close because the subscriber intentionally
unsubscribed, but they also could be closed by an intermediary.  For
example, if a subscription is from another ship which is currently
unreachable, Ames may choose to close the subscription to avoid queueing
updates indefinitely.  If the program crashes while processing an
update, this may also generate an unsubscription.  You should consider
subscriptions to be closable at any time.

### +on-peek

This [arm](/docs/glossary/arm/) is called when a program reads from the agent's "scry"
namespace, which should be referentially transparent.  Unlike most
handlers, this cannot perform IO, and it cannot change the state.  All
it can do is produce a piece of data to the caller, or not.

If this [arm](/docs/glossary/arm/) produces `[~ ~ data]`, then `data` is the value at the the
given `path`.  If it produces `[~ ~]`, then there is no data at the given
`path` and never will be.  If it produces `~`, then we don't know yet
whether there is or will be data at the given `path`.

### +on-agent

This [arm](/docs/glossary/arm/) is called to handle responses to `%pass` moves to other agents.
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

This [arm](/docs/glossary/arm/) is called to handle responses to `%pass` `move`s to vanes.  The
list of possible responses from the system is statically defined in
sys/zuse.hoon (grep for `+  sign-arvo`).

### +on-fail

If an error happens in `+on-poke`, the crash report goes into the
`%poke-ack` response.  Similarly, if an error happens in
`+on-subscription`, the crash report goes into the `%watch-ack`
response.  If a crash happens in any of the other handlers, the report
is passed into this [arm](/docs/glossary/arm/).
