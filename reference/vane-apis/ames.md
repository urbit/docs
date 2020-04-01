+++
title = "Ames Public API"
weight = 1
template = "doc.html"
+++

# Ames

In this document we describe the public interface for Ames.  Namely, we describe
each `task` that Ames can be `%pass`ed, and which `gift`(s) Ames can `%give` in return.

Some `task`s appear to have more than one arm associated to them, e.g. there are
four `+on-hear` arms. We denote this where it occurs, but always refer to the
`on-hear:event-core` arm.

Ames `task`s can be naturally divided into two categories: messaging tasks and
system/lifecycle tasks.

## Messaging Tasks

### %hear

`%hear` handles raw packet receipt. This `task` only ever originates from Unix.
It does the initial processing of a packet, namely by passing the raw packet
information to `+decode-packet` which deserializes the packet and giving that data and the origin of the
packet to `+on-hear-packet`, which begins the transformation of the packet into
a new event in the form of a `+event-core`.

There are multiple `+on-hear` arms in `ames.hoon`. Here we refer to
`on-hear:event-core`, as that is the one called by a `%hear` `task`. The other ones are used
primarily for ack and nack processing, or receiving message fragments.

#### Accepts
 
```hoon
[=lane =blob]
```

`%hear` takes in a `blob`, which is essentially a large atom (around 1kB or less)
that is the raw data of the message, and a `lane`, which is the origin of the
message (typically an IP address).

#### Returns

`%hear` can trigger a number of possible returns. It can trigger the release of
zero or more additional packets via `%send` `gift`s. It may also trigger a `%boon`
or `%memo` `gift` to a local vane in the case of a completed message. 


### %heed

A vane can pass Ames a `%heed` `task` to request Ames track a peer's
responsiveness.  If our `%boon`s to it start backing up locally,
Ames will `give` a `%clog` back to the requesting vane containing the
unresponsive peer's Urbit address.

Stop tracking a peer by sending Ames a
`%jilt` `task`.


#### Accepts

```hoon
=ship
```

The ship to be tracked.

#### Returns

If the `ship` is indeed being unresponsive, as measured by backed up `%boon`s,
Ames will `give` a `%clog` `gift` to the requesting vane containing the
unresponsive peer's urbit address.


### %hole

`%hole` handles packet crash notification. `%hole` works much like `%hear`, in
that it passes an incoming raw packet to `+decode-packet` to be deserialized,
and then passes that data along with the source of the packet to
`+on-hear-packet` along with a `?` set to `%.n` denoting that there is something wrong with
the packet. 

#### Accepts

```hoon
[=lane =blob]
```
`%hole` takes in a `blob`, which is essentially a large atom (around 1kB or less)
that is the raw data of the message, and a `lane`, which is the origin of the
message (typically an IP address).

#### Returns

Like `%hear`, `%hole` can trigger additional packets in the form of `%send`
`gift`s, and may also yield a `%boon` or `%memo` `gift` to a local vane.

### %jilt

`%jilt` stops tracking a potentially unresponsive peer that was previously being
tracked as a result of the `%heed` `task`.

There are two `+on-jilt` arms, this `task` utilizes `on-hear:event-core`.

#### Accepts

```hoon
=ship
```

The `ship` we no longer wish to track.

#### Returns

This `task` returns no `gift`s.

### %plea

`%plea` is the `task` used to send messages over Ames. It extends the
`%pass`/`%give` semantics across the network. As such, it is the most
fundamental `task` in Ames and the primary reason for its existence.

Ames also `pass`es a `%plea` `note` to another vane when it receives a message on a
"forward flow" from a peer, originally passed from one of the peer's vanes to the
peer's Ames.

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

This `task` returns no `gift`s.


## System and Lifecycle Tasks

### %born

Each time you start your Urbit, the Arvo kernel calls the `%born` task for Ames.

#### Accepts

`%born` takes no arguments.

#### Returns

In response to a `%born` `task`, Ames `%give`s Jael a `%turf` `gift`.
    

### %crud

`%crud` is called whenever an error involving Ames occurs. It produces a crash
report in response.

#### Accepts

```hoon
=error
```

A `$error` is a `[tag=@tas =tang]`.

#### Returns

Ames does not `give` a `gift` in response to a `%crud` `task`, but it does
`%pass` Dill a `%flog` `task` instructing it to print `error`. 


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

`%init` sends two moves that subscribe to `%turf` and `%private-keys` in Jael.


### %sift

This `task` filters debug output by ship.

#### Accepts

```hoon
ships=(list ship)
```

The list of ships for which debug output is desired.

#### Returns

This `task` returns no `gift`s.


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

This `task` returns no `gift`s.


### %vega

`%vega` is called whenever the kernel is updated. Ames currently does not do
anything in response to this.

#### Accepts

`%vega` takes no arguments.

#### Returns

This `task` returns no `gift`s.


### %wegh

This `task` is a request to Ames to produce a memory usage report.

#### Accepts

This `task` has no arguments.

#### Returns

In response to this `task,` Ames `%give`s a `%mass` `gift` containing Ames'
current memory usage.
