+++
title = "Ames Public API"
weight = 1
template = "doc.html"
+++

# Ames

In this document we describe the public interface for Ames.  Namely, we describe
each `task` that Ames can be `%pass`ed, and which `gift`(s) Ames can `%give` in return.

Ames `task`s can be naturally divided into two categories: messaging tasks and
system/lifecycle tasks.

## Messaging Tasks

### %hear

`%hear` handles raw packet receipt. 

#### Accepts

This looks a bit heavy, gonna just ask about this instead of trying to tease it
out myself.

```hoon
  ::  $lane: ship transport address; either opaque $address or galaxy
  ::
  ::    The runtime knows how to look up galaxies, so we don't need to
  ::    know their transport addresses.
  ::
  +$  lane  (each @pC address)
```

```hoon
  ++  blob                                              ::  fs blob
    $%  {$delta p/lobe q/{p/mark q/lobe} r/page}        ::  delta on q
        {$direct p/lobe q/page}                         ::  immediate
    ==                                                  ::
```

#### Returns

#### Source

```hoon
  ::  +on-hear: handle raw packet receipt
  ::
  ++  on-hear
    |=  [=lane =blob]
    ^+  event-core
    (on-hear-packet lane (decode-packet blob) ok=%.y)
```

### %heed

A vane can pass Ames a `%heed` `task` to request Ames track a peer's
responsiveness.  If our `%boon`s to it start backing up locally,
Ames will give a `%clog` back to the requesting vane containing the
unresponsive peer's Urbit address.  This interaction does not use
ducts as unique keys.  Stop tracking a peer by sending Ames a
`%jilt` `task`.


#### Accepts

```hoon
=ship
```

The ship to be tracked.

#### Returns

The `+on-heed` arm returns `event-core` with `heeds` modified to include `ship`.
(why does it look like heeds is a list of ducts then?)

#### Source

```hoon
  ::  +on-heed: handle request to track .ship's responsiveness
  ::
  ++  on-heed
    |=  =ship
    ^+  event-core
    =/  ship-state  (~(get by peers.ames-state) ship)
    ?.  ?=([~ %known *] ship-state)
      %+  enqueue-alien-todo  ship
      |=  todos=alien-agenda
      todos(heeds (~(put in heeds.todos) duct))
    ::
    =/  =peer-state  +.u.ship-state
    =/  =channel     [[our ship] now channel-state -.peer-state]
    abet:on-heed:(make-peer-core peer-state channel)
```


### %hole

`%hole` handles packet crash notification.

Another one with lane and blob, ask about it.

#### Accepts

#### Returns

#### Source

```hoon
  ::  +on-hole: handle packet crash notification
  ::
  ++  on-hole
    |=  [=lane =blob]
    ^+  event-core
    (on-hear-packet lane (decode-packet blob) ok=%.n)
```

### %jilt

`%jilt` stops tracking a potentially unresponsive peer that was previously being
tracked as a result of the `%heed` `task`.

#### Accepts

```hoon
=ship
```

The `ship` we no longer wish to track.

#### Returns

`+on-jilt` returns `event-core` with `ship` removed from `heeds`, assuming it is
there. Otherwise it returns `event-core` unchanged.

#### Source

```hoon
  ::  +on-jilt: handle request to stop tracking .ship's responsiveness
  ::
  ++  on-jilt
    |=  =ship
    ^+  event-core
    =/  ship-state  (~(get by peers.ames-state) ship)
    ?.  ?=([~ %known *] ship-state)
      %+  enqueue-alien-todo  ship
      |=  todos=alien-agenda
      todos(heeds (~(del in heeds.todos) duct))
    ::
    =/  =peer-state  +.u.ship-state
    =/  =channel     [[our ship] now channel-state -.peer-state]
    abet:on-jilt:(make-peer-core peer-state channel)
```

### %plea

`%plea` is the `task` used to send messages over Ames. It extends the
`%pass`/`%give` semantics across the network. As such, it is the most
fundamental `task` in Ames and the primary reason for its existence.

Ames `pass`es a `%plea` `note` to another vane when it receives a message on a
"forward flow" from a peer, originally passed from one of the peer's vanes to
peer's Ames.

Ames `pass`es a `%plea` to itself to trigger a heartbeat message to be sent to
our ship's sponsor

#### Accepts

```hoon
[=ship =plea]
```

A `%plea` `task` takes in the `ship` the `plea` is addressed to, and a `$plea`,
which is

```hoon
  +$  plea  [vane=@tas =path payload=*]
```
Here, `vane` is the destination vane on the remote ship, `path` is the internal
route on the receiving ship, and `payload` is the semantic message content.

#### Returns

`event-core` is returned, modified to...

#### Source

```hoon
  ::  +on-plea: handle request to send message
  ::
  ++  on-plea
    |=  [=ship =plea]
    ^+  event-core
    ::  .plea is from local vane to foreign ship
    ::
    =/  ship-state  (~(get by peers.ames-state) ship)
    ::
    ?.  ?=([~ %known *] ship-state)
      %+  enqueue-alien-todo  ship
      |=  todos=alien-agenda
      todos(messages [[duct plea] messages.todos])
    ::
    =/  =peer-state  +.u.ship-state
    =/  =channel     [[our ship] now channel-state -.peer-state]
    ::
    =^  =bone  ossuary.peer-state  (bind-duct ossuary.peer-state duct)
    %-  %^  trace  msg.veb  ship
        |.  ^-  tape
        =/  sndr  [our our-life.channel]
        =/  rcvr  [ship her-life.channel]
        "plea {<sndr^rcvr^bone^vane.plea^path.plea>}"
    ::
    abet:(on-memo:(make-peer-core peer-state channel) bone plea %plea)
```

## System and Lifecycle Tasks

### %born

Each time you start your Urbit, the Arvo kernel calls the `%born` task for Ames.

#### Accepts

`%born` takes no arguments.

#### Returns

In response to a `%born` `task`, Ames `%give`s Jael a `%turf` `gift`.

#### Source

```hoon
  ++  on-born
    ^+  event-core
    ::
    =.  unix-duct.ames-state  duct
    ::
    =/  turfs
      ;;  (list turf)
      =<  q.q  %-  need  %-  need
      (scry-gate [%141 %noun] ~ %j `beam`[[our %turf %da now] /])
    ::
    (emit unix-duct.ames-state %give %turf turfs)
```
    
### %crud

`%crud` is called whenever an error involving Ames occurs. It produces a crash
report in response.

#### Accepts

```hoon
=error
```

A `$error` is a `[tag=@tas =tang]`.

#### Returns

In response to a `%crud` `task`, Ames returns `event-core` with a new `%pass`
move to Dill to be performed instructing it to print the error.

#### Source

```hoon
  ++  on-crud
    |=  =error
    ^+  event-core
    (emit duct %pass /crud %d %flog %crud error)
```


## %init

`%init` is called a single time during the very first boot process, immediately
after the [larval stage](@/docs/tutorials/arvo/arvo.md#larval-stage-core)
is completed. This initializes the vane. Jael is initialized first, followed by
other vanes such as Ames.

In response to receiving the `%init` `task`, Ames subscribes to the information
contained by Jael.

#### Accepts

```hoon
our=ship
```

`%init` takes in the name of our ship, which is a `@p`. 

#### Returns

```hoon
    =~  (emit duct %pass /turf %j %turf ~)
        (emit duct %pass /private-keys %j %private-keys ~)
```

`%init` returns `event-core` with two new `move`s to be performed that subscribe
to `%turf` and `%private-keys` in Jael.

#### Source

```hoon
  ::  +on-init: first boot; subscribe to our info from jael
  ::
  ++  on-init
    |=  our=ship
    ^+  event-core
    ::
    =~  (emit duct %pass /turf %j %turf ~)
        (emit duct %pass /private-keys %j %private-keys ~)
    ==
```


### %sift

This `task` filters debug output by ship.

#### Accepts

```hoon
ships=(list ship)
```

The list of ships for which debug output is desired.

#### Returns

```hoon
    =.  ships.bug.ames-state  (sy ships)
    event-core
```

This `task` returns the `event-core` modified so that debug output is shown only
for `ships`.

#### Source

```hoon
  ::  +on-sift: handle request to filter debug output by ship
  ::
  ++  on-sift
    |=  ships=(list ship)
    ^+  event-core
    =.  ships.bug.ames-state  (sy ships)
    event-core
```


### %spew

Sets verbosity toggles on debug output. These toggles are as follows.

* `%snd` - sending packets
* `%rcv` - receiving packets
* `%odd` - unusual events
* `%msg` - message-level events
* `%ges` - congestion control
* `%for` - packet forwarding
* `%rot` - routing attempts

Each toggle is a flag set to `%.n` by default.

#### Accepts

```hoon
verbs=(list verb)
```

`%spew` takes in a `list` of `verb`, which are verbosity flags for Ames.

```hoon
+$  verb  ?(%snd %rcv %odd %msg %ges %for %rot)
```

`%spew` flips each toggle given in `verbs`.

#### Returns

`+on-spew` returns `event-core` with the changed toggles.

#### Source

```hoon
  ::  +on-spew: handle request to set verbosity toggles on debug output
  ::
  ++  on-spew
    |=  verbs=(list verb)
    ^+  event-core
    ::  start from all %.n's, then flip requested toggles
    ::
    =.  veb.bug.ames-state
      %+  roll  verbs
      |=  [=verb acc=_veb-all-off]
      ^+  veb.bug.ames-state
      ?-  verb
        %snd  acc(snd %.y)
        %rcv  acc(rcv %.y)
        %odd  acc(odd %.y)
        %msg  acc(msg %.y)
        %ges  acc(ges %.y)
        %for  acc(for %.y)
        %rot  acc(rot %.y)
      ==
    event-core
```

### %vega

`%vega` is called whenever the kernel is updated. Ames currently does not do
anything in response to this.

#### Accepts

`%vega` takes no arguments.

#### Returns

`%vega` returns `event-core`.

#### Source

```hoon
  ::  +on-vega: handle kernel reload
  ::
  ++  on-vega  event-core
```


### %wegh

This `task` is a request to Ames to produce a memory usage report.

#### Accepts

This `task` has no arguments.

#### Returns

In response to this `task,` Ames `%give`s a `%mass` `gift` containing Ames'
current memory usage.

#### Source

```hoon
  ++  on-wegh
    ^+  event-core
    ::
    =+  [known alien]=(skid ~(tap by peers.ames-state) |=(^ =(%known +<-)))
    ::
    %-  emit
    :^  duct  %give  %mass
    :+  %ames  %|
    :~  peers-known+&+known
        peers-alien+&+alien
        dot+&+ames-state
    ==
```

