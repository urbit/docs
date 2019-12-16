+++
title = "Gall"
weight = 4
template = "doc.html"
+++

# Gall

## Reference Agent

This app stores a number for each user. You can increment your number, increment
someone else's number, start tracking someone else's number by poking. It
exposes a scry namespace to inspect everyone's number.

### `app/example-gall.hoon`

```hoon
::  Import sur/example-gall
/-  *example-gall
::  Import lib/default-agent
/+  default-agent
|%
+$  card  card:agent:gall
+$  note
  $%
    [%arvo =note-arvo]
    [%agent [=ship name=term] =task:agent:gall]
  ==
+$  state-zero  [%0 local=@ud]
+$  state-one  [%1 local=@ud remote=(map @p @ud)]
+$  versioned-state
  $%
    state-zero
    state-one
  ==
--
=|  state-one
=*  state  -
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
::
:: Set local counter to 1 by default
++  on-init
  ^-  (quip card _this)
  `this(local 1)
:: Expose state for saving
++  on-save
  !>(state)
::
:: Load old state and upgrade if neccessary
++  on-load
  |=  old=vase
  ^-  (quip card _this)
  =/  loaded=versioned-state
    !<(versioned-state old)
  ?-  -.loaded
      %0
    `this(local local.loaded) :: Upgrade old state
      %1
    `this(state loaded)
  ==
::
:: Respond to poke
:: App can be poked in the dojo by running the following commands
:: Increment local counter
:: :example-gall &example-gall-action [%increment ~]
:: Increment ~zod's counter
:: :example-gall &example-gall-action [%increment-remote ~zod]
:: Subscribe to ~zod's counter
:: :example-gall &example-gall-action [%view ~zod]
:: Unsubscribe from ~zod's counter
:: :example-gall &example-gall-action [%stop-view ~zod]
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ::  Ensure poke is of mark %example-gall-action
  ?>  =(mark %example-gall-action)
  =/  act=example-gall-action  !<(example-gall-action vase)
  ?-  act
        ::
        :: Increment local counter and send new counter to subscribers
        ::
      [%increment ~]
    :-  [%give %fact `/local %atom !>(+(local))]~
    this(local +(local))
        ::
        :: Send remote %increment poke
        ::
      [%increment-remote who=@p]
    :_  this
    :~  :*
      %pass
      /inc/(scot %p who.act)
      %agent
      [who.act %example-gall]
      %poke  %example-gall-action  !>([%increment ~])
    ==  ==
        ::
        :: Subscribe to a remote counter
        ::
      [%view who=@p]
    :_  this
    [%pass /view/(scot %p who.act) %agent [who.act %example-gall] %watch /local]~
        ::
        :: Unsubscribe from remote counter and remove from state
        ::
      [%stop-view who=@p]
    :_  this(remote (~(del by remote) who.act))
    [%pass /view/(scot %p who.act) %agent [who.act %example-gall] %leave ~]~
        ::
  ==
::
:: Print on unsubscribe
::
++  on-leave
  |=  =path
  ^-  (quip card _this)
  ~&  "Unsubscribed by: {<src.bowl>} on: {<path>}"
  `this
::
:: Handle new subscription
::
:: When another ship subscribes to our counter, give them the current state of
:: the counter immediately
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  :_  this
  :: Crash if we see a subscription we don't recognise
  ?+  path  ~|("unexpected subscription" !!)
         ::
       [%local ~]
    [%give %fact ~ %atom !>(local)]~
  ==
::
:: Expose scry namespace
::
:: .^(@ %gx /=example-gall=/local/atom) will produce the current local counter
:: .^(@ %gx /=example-gall=/remote/~zod/atom) will produce the counter for ~zod
:: .^(arch %gy /=example-gall=/remote) will produce a listing of the current
:: remote counters
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+  path  [~ ~]
        ::
        :: Produce local counter
        ::
      [%x %local ~]
    ``[%atom !>(local)]
        ::
        :: Produce remote counter
        ::
      [%x %remote who=@ta ~]
    =*  location  i.t.t.path :: Ship name is third in the list
    =/  res
      (~(got by remote) (slav %p location))
    ``[%atom !>(res)]
        ::
        :: Produce listing of remote counters
        ::
      [%y %remote ~]
    =/  dir=(map @ta ~)
      %-  molt           :: Map from list of k-v pairs
      %+  turn           :: iterate over list of k-v pairs
        ~(tap by remote) :: list of k-v pairs from map
      |=  [who=@p *]
      [(scot %p who) ~]
    ``[%arch !>(`arch`[~ dir])]
  ==
::
:: Handle sign from agent
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?-    -.sign
          ::
          :: Print error if poke failed
          ::
        %poke-ack
      ?~  p.sign
        `this
      %-  (slog u.p.sign)
      `this
          ::
          :: Print error if subscription failed
          ::
        %watch-ack
      ?~  p.sign
        `this
      =/  =tank  leaf+"subscribe failed from {<dap.bowl>} on wire {<wire>}"
      %-  (slog tank u.p.sign)
      `this
          ::
          :: Do nothing if unsubscribed
          ::
        %kick  `this
          ::
          :: Update remote counter when we get a subscription update
          ::
        %fact
      :-  ~
      ?.  ?=(%atom p.cage.sign)
        this
      this(remote (~(put by remote) src.bowl !<(@ q.cage.sign)))
  ==
::
:: Handle arvo signs
::
:: We never give any cards to arvo. Therefore we never need to handle any signs
:: from arvo. We use the default-agent library to avoid implementing this arm,
:: as gall apps must have all the arms.
::
++  on-arvo  on-arvo:def
::
:: Handle error
::
:: Print errors when they happen
::
++  on-fail
  |=  [=term =tang]
  ^-  (quip card _this)
  %-  (slog leaf+"error in {<dap.bowl>}" >term< tang)
  `this
--

```

### `sur/example-gall.hoon`

```hoon
|%
+$  example-gall-action
  $%
     [%view who=@p]
     [%stop-view who=@p]
     [%increment-remote who=@p]
     [%increment ~]
  ==
--
```

### `mar/example-gall/action.hoon`

```hoon
/-  *example-gall
|_  act=example-gall-action
++  grab
  |%
  ++  noun  example-gall-action
  --
--
```

## Arms

### `++on-init`

Application initialisation

`++on-init` is called when an application is first started. It is not a gate and
has no input.

#### Returns

```hoon
(quip card _this)
```

List of cards and new agent

#### Example

```hoon
:: From reference agent.
:: Set local counter to 1 by default
::
++  on-init
  ^-  (quip card _this)
  `this(local.sta 1)
:: From app/weather.hoon. This setup is typical of a landscape tile.
::
++  on-init
  :_  this
  :~  [%pass /bind/weather %arvo %e %connect [~ /'~weather'] %weather]
      :*  %pass  /launch/weather  %agent  [our.bol %launch]  %poke
          %launch-action  !>([%weather /weathertile '/~weather/js/tile.js'])
      ==
  ==
```

### `++on-save`

Expose state for saving.

This arm is called immediately before the agent is upgraded.  It packages the
permament state of the agent in a vase for the next version of the agent.
Unlike most handlers, this cannot produce effects. It is not a gate and has no input.

#### Returns

`vase` of permanent state.

#### Example

```hoon
:: From reference agent
::
:: Expose state for saving
::
++  on-save
  !>(state)
```

### `++on-load`

Application upgrade.

This arm is called immediately after the agent is upgraded.  It receives
a vase of the state of the previously-running version of the agent, obtained
from `+on-save`, which allows it to cleanly upgrade from the old agent.

#### Accepts

```hoon
=vase
```

`vase` of previous state, from `++on-save`

#### Returns

```hoon
(quip card _this)
```

List of cards and new agent

#### Examples

```hoon
:: From reference agent
::
:: Load old state and upgrade if neccessary
++  on-load
  |=  old=vase
  ^-  (quip card _this)
  =/  loaded=versioned-state
    !<(versioned-state old)
  ?-  -.loaded
      %0
    `this(local local.loaded) :: Upgrade old state
      %1
    `this(state loaded)
  ==
```

### `++on-poke`

Handle application poke.

This arm is called when the agent is "poked".  The input is a cage, so
it's a pair of a mark and a dynamic vase.

#### Accepts

```hoon
[=mark =vase]
```

`mark` is the mark of the poked data.

`vase` is a vase with the poked data inside.

#### Returns

```hoon
(quip card _this)
```

List of cards and new agent.

#### Example

```hoon
:: From reference agent.
::
:: Respond to poke
:: App can be poked in the dojo by running the following commands
:: Increment local counter
:: :example-gall &example-gall-action [%increment ~]
:: Increment ~zod's counter
:: :example-gall &example-gall-action [%increment-remote ~zod]
:: Subscribe to ~zod's counter
:: :example-gall &example-gall-action [%view ~zod]
:: Unsubscribe from ~zod's counter
:: :example-gall &example-gall-action [%stop-view ~zod]
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ::  Ensure poke is of mark %example-gall-action
  ?>  =(mark %example-gall-action)
  =/  act=example-gall-action  !<(example-gall-action vase)
  ?-  act
        ::
        :: Increment local counter and send new counter to subscribers
        ::
      [%increment ~]
    :-  [%give %fact `/local %atom !>(+(local))]~
    this(local +(local))
        ::
        :: Send remote %increment poke
        ::
      [%increment-remote who=@p]
    :_  this
    :~  :*
      %pass
      /inc/(scot %p who.act)
      %agent
      [who.act %example-gall]
      %poke  %example-gall-action  !>([%increment ~])
    ==  ==
        ::
        :: Subscribe to a remote counter
        ::
      [%view who=@p]
    :_  this
    [%pass /view/(scot %p who.act) %agent [who.act %example-gall] %watch /local]~
        ::
        :: Unsubscribe from remote counter and remove from state
        ::
      [%stop-view who=@p]
    :_  this(remote (~(del by remote) who.act))
    [%pass /view/(scot %p who.act) %agent [who.act %example-gall] %leave ~]~
        ::
  ==
```

### `++on-watch`

Handle new subscriber.

This arm is called when a program wants to subscribe to the agent on a
particular path.  The agent may or may not need to perform setup steps
to intialize the subscription.  It may produce a `%give`
`%subscription-result` to the subscriber to get it up to date, but after
this event is complete, it cannot give further updates to a specific
subscriber.  It must give all further updates to all subscribers on a
specific path.

If this arm crashes, then the subscription is immediately terminated.
More specifcally, it never started -- the subscriber will receive a
negative `%watch-ack`.  You may also produce an explicit `%kick` to
close the subscription without crashing -- for example, you could
produce a single update followed by a `%kick`.

#### Accepts

```hoon
=path
```

Path of new subscription.

#### Returns

```hoon
(quip card _this)
```

List of cards and new agent.

#### Example

```hoon
:: From reference agent
::
:: Handle new subscription
::
:: When another ship subscribes to our counter, give them the current state of
:: the counter immediately
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  :_  this
  ?+  path  on-watch:def
         ::
       [%local ~]
    [%give %fact ~ %atom !>(local)]~
  ==
```

### `++on-leave`

Handle unsubscribe.

This arm is called when a program becomes unsubscribed to you.
Subscriptions may close because the subscriber intentionally
unsubscribed, but they also could be closed by an intermediary.  For
example, if a subscription is from another ship which is currently
unreachable, Ames may choose to close the subscription to avoid queueing
updates indefinitely.  If the program crashes while processing an
update, this may also generate an unsubscription.  You should consider
subscriptions to be closable at any time.

#### Accepts

```hoon
=path
```

Path of the closed subscription.

#### Returns

```hoon
(quip card _this)
```

List of cards and new agent.

#### Example

```hoon
:: From reference agent. Prints a message when programs become unsubscribed.
++  on-leave
  |=  =path
  ^-  (quip card _this)
  ~&  "Unsubscribe by: {<src.bowl>} on: {<path>}"
  `this
```

### `++on-peek`

Handle scry request.

This arm is called when a program reads from the agent's "scry"
namespace, which should be referentially transparent.  Unlike most
handlers, this cannot perform IO, and it cannot change the state.  All
it can do is produce a piece of data to the caller, or not.

#### Accepts

```hoon
=path
```

The path being scryed for.

```hoon
:: Example scry to path mappings
::
.^(arch %gy /=example-gall=/remote)
:: Path will be /y/remote
.^(@ %gx /=example-gall=/local/atom)
:: Path will be /x/local
```

#### Returns

```hoon
(unit (unit cage))
```

If this arm produces `[~ ~ data]`, then `data` is the value at the the
given path.  If it produces `[~ ~]`, then there is no data at the given
path and never will be.  If it produces `~`, then we don't know yet whether
there is or will be data at the given path. The head of the path is known as the
`care`. Requests with a care of `%x` should return a vase that matches or is
convertible to the mark at the end of the scry request. This mark is not
included in the path passed to `++on-peek`. Requests with a care of `%y` should
return a cage with a mark of `%arch` and a vase of `arch`.

#### Example

```hoon
:: From reference agent
::
:: Expose scry namespace
::
:: .^(@ %gx /=example-gall=/local/atom) will produce the current local counter
:: .^(@ %gx /=example-gall=/remote/~zod/atom) will produce the counter for ~zod
:: .^(arch %gy /=example-gall=/remote) will produce a listing of the current
:: remote counters
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+  path  [~ ~]
        ::
        :: Produce local counter
        ::
      [%x %local ~]
    ``[%atom !>(local)]
        ::
        :: Produce remote counter
        ::
      [%x %remote who=@ta ~]
    =*  location  i.t.t.path :: Ship name is third in the list
    =/  res
      (~(got by remote) (slav %p location))
    ``[%atom !>(res)]
        ::
        :: Produce listing of remote counters
        ::
      [%y %remote ~]
    =/  dir=(map @ta ~)
      %-  molt           :: Map from list of k-v pairs
      %+  turn           :: iterate over list of k-v pairs
        ~(tap by remote) :: list of k-v pairs from map
      |=  [who=@p *]
      [(scot %p who) ~]
    ``[%arch !>(`arch`[~ dir])]
  ==
```

### `++on-agent`

Handle `%pass` card

This arm is called to handle responses to `%pass` cards to other agents.
It will be one of the following types of response:

- `%poke-ack`: acknowledgment (positive or negative) of a poke.  If the
  value is `~`, then the poke succeeded.  If the value is `[~ tang]`,
  then the poke failed, and a printable explanation (eg a stack trace)
  is given in the `tang`.

- `%watch-ack`: acknowledgment (positive or negative) of a subscription.
  If negative, the subscription is already ended (technically, it never
  started).

- `%fact`: update from the publisher.

- `%kick`: notification that the subscription has ended. This happens because
  either the target app passed a `%leave` note, or ames killed the subscription
  due to backpressure. Most of the time you will want to resubscribe. If you can
  no longer access the subscription you will get a negative `%watch-ack` and end
  your flow there.

#### Accepts

```hoon
[=wire =sign:agent:gall]
```

`wire` is the wire from the `+gift` that triggered `++on-agent`

`sign` is response for the gift.

#### Returns

```hoon
(quip card _this)
```

#### Example

```hoon
:: From reference agent
::
:: Handle sign from agent
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?-    -.sign
          ::
          :: Print error if poke failed
          ::
        %poke-ack
      ?~  p.sign
        `this
      %-  (slog u.p.sign)
      `this
          ::
          :: Print error if subscription failed
          ::
        %watch-ack
      ?~  p.sign
        `this
      =/  =tank  leaf+"subscribe failed from {<dap.bowl>} on wire {<wire>}"
      %-  (slog tank u.p.sign)
      `this
          ::
          :: Do nothing if unsubscribed
          ::
        %kick  `this
          ::
          :: Update remote counter when we get a subscription update
          ::
        %fact
      :-  ~
      ?.  ?=(%atom p.cage.sign)
        this
      this(remote (~(put by remote) src.bowl !<(@ q.cage.sign)))
  ==
```

### `++on-arvo`

Handle vane response

This arm is called to handle responses for `%pass` cards to vanes.

#### Accepts

```hoon
  [=wire =sign:agent:gall]
```

`wire` is the wire from the `++gift` that triggered `++on-arvo`.

`sign` is the response from the vane. The list of possible responses from the
vanes is statically defined in sys/zuse.hoon (grep for `++  sign-arvo`).

#### Returns

```hoon
(quip card _this)
```

List of cards and new agent.

#### Example

```hoon
:: From app/weather.hoon. Handles %bound, %wake and %http-response signs
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card:agent:gall _this)
  ?:  ?=(%bound +<.sign-arvo)
    [~ this]
  ?:  ?=(%wake +<.sign-arvo)
    =^  cards  state
      (wake:wc wire error.sign-arvo)
    [cards this]
  ?:  ?=(%http-response +<.sign-arvo)
    =^  cards  state
      (http-response:wc wire client-response.sign-arvo)
    [cards this]
  (on-arvo:def wire sign-arvo)
::
:: From reference agent
::
:: Handle arvo signs
::
:: We never give any cards to arvo. Therefore we never need to handle any signs
:: from arvo. We use the default-agent library to avoid implementing this arm,
:: as gall apps must have all the arms specified in the agent:gall definition.
::
++  on-arvo  on-arvo:def
```

### `++on-fail`

Handle error.

If an error happens in `+on-poke`, the crash report goes into the
`%poke-ack` response.  Similarly, if an error happens in
`+on-subscription`, the crash report goes into the `%watch-ack`
response.  If a crash happens in any of the other handlers, the report
is passed into this arm.

#### Accepts

```hoon
[=term =tang]
```

`term` is a cord describing the error.

`tang` is a stack trace for the error.

#### Returns

```hoon
(quip card _this)
```

List of cards and new agent

#### Example

```hoon
::
:: Handle error
::
:: Print errors when they happen
::
++  on-fail
  |=  [=term =tang]
  ^-  (quip card _this)
  %-  (slog leaf+"error in {<dap.bowl>}" >term< tang)
  `this
```

## Agent Gifts

Giving a gift takes the general form of

```hoon
[%give =gift]
```

### `%fact`

Produce a subscription update.

Produces a subscription update. A subscription update is a new piece of
subscription content for all subscribers on a given path.

#### Structure

```hoon
[%fact (unit path) =cage]
```

`(unit path)` is the path of the subscription being updated. If no path is
 given, then the update is only given to the program that instigated the
 request. Typical use of this mode is in `+on-watch` to give an initial update
 to a new subscriber to get them up to date.

`cage` is a cage of the subscription update.

#### Example

```hoon
:: From ++on-watch in reference agent.
::
:: Gives current local state to new subscribers.
[%give %fact ~ %atom !>(local.sta)]
```

### `%kick`

Close subscription.

Closes a subscription. A subscription close closes the subscription for all or
one subscribers on a given path.

#### Structure

```hoon
[%kick (unit path) (unit ship)]
```

`(unit path)` is the path of the subscription being updated. If no path is
given, then the update is only given to the program that instigated the request.
Typical use of this mode would be in `+on-watch` to produce a single update to a
subscription then close the subscription.

`(unit ship)` is the ship to close the subscription for. If no path is given,
then the subscription is closed for all subscribers.

## Agent Notes

Passing a agent note (a 'task') along a wire looks like so.

```hoon
[%pass =wire %agent [=ship name=term] =task]
```

`wire` is used to identify the response to the note.

`ship` is the ship to pass the note to.

`name` is the name of the agent that should receive the note.

`task` is the task itself, described below.

### `%poke`

Poke an application.

This note is passed to poke an application with a cage, a marked vase.

#### Structure

```hoon
[%poke =cage]
```

`cage` is the marked data to poke the application with. It is a pair of a mark
and vase.

#### Example

```hoon
:: From ++on-poke in reference agent.
::
:: Sends an increment poke to the example-gall agent
:: on who.act.
:*
  %pass
  /inc/(scot %p who.act)
  %agent
  [who.act %example-gall]
  %poke  %example-gall-action  !>([%increment ~])
==
```

### `%watch`

Subscribe to an application.

This note is given to subscribe to an application at a path

#### Structure

```hoon
[%watch =path]
```

`path` is the path to be subscribed to.

#### Example

```hoon
:: From ++on-poke in reference agent.
::
:: Subscribes to the example-gall agent on who.act on the path /local
::
[%pass /view/(scot %p who.act) %agent [who.act %example-gall] %watch /local]
```

### `%leave`

Unsubscribe from an application.

  This note is passed to unsubscribe from an application. It should be passed on
the same wire that the corresponding `%watch` note for the subscription was
passed on.

#### Structure

```hoon
[%leave ~]
```

#### Example

```hoon
:: From ++on-poke in reference agent.
::
:: Unsubscribes from the example-gall agent on who.act
[%pass /view/(scot %p who.act) %agent [who.act %example-gall] %leave ~]
```
