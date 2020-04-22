+++
title = "2.7.1 Gall Walkthrough: Egg Timer"
weight = 36
template = "doc.html"
aliases = ["/docs/learn/hoon/hoon-tutorial/egg-timer/"]
+++

The Arvo operating system is divided up into modules called vanes.  Gall is the vane responsible for providing an API for building stateful applications in Urbit.  Gall is a complex system that takes a lot of getting used to, so let's dip our toes in with a simple egg-timer app.

The following code sample should be saved as `/home/app/egg-timer.hoon`
After committing: `|start egg-timer` and poke with `:egg-timer ~s10`

```hoon
/+  default-agent
|%
+$  card  card:agent:gall
--
::
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  =/   t   !<(@dr vase)
  :_  this
  [%pass /egg-timer %arvo %b %wait (add now.bowl t)]~
::
++  on-arvo
  ^+  on-arvo:*agent:gall
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ~&  "Timer went off!"
  [~ this]
::
++  on-init   on-init:def
++  on-save   on-save:def
++  on-load   on-load:def
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent  on-agent:def
++  on-fail   on-fail:def
--
```

The first thing to notice is that we are creating a core (`|%`) and a door (`|_`).  This is a typical style for Gall programming wherein types are defined in the first core and your application is defined in the following door.
Our door will have type `agent:gall` as specified in `sys/zuse.hoon`

```hoon
|%
+$  card  card:agent:gall
--
```

The core here defines only one type: `card`. 
A `card` is a request to Arvo to do something for us.  In this case, the only card used will be a `%wait` request to Behn which we'll discuss later.

It's important to note that the name `card` is technically arbitrary.  By convention, however, you will see it called `card` practically everywhere.

The sample of the door(`|_`) is:

```hoon
=bowl:gall
```

You can find the full definition of `bowl` in `sys/zuse.hoon`, but for now it's enough to know that includes contextual data used by Gall with particular faces.  Below are some important such faces:

- `our`  The ship this code is running on
- `src`  The ship the current event originated from
- `eny`  Guaranteed-fresh entropy
- `now`  The current time

We give `bowl:gall` the face `bowl`.
Additionally, we use `+*` to create two structures for future use:

```hoon
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
```
`this` is our current context(the door).
`def` uses `default-agent` to produce a standard `gall:agent` door, from which we will instance default definitions for our unused arms.

All Gall agents have a fixed set of 10 arms.  In this trivial case, we will specify only two and use the default definitions from `default-agent` for the remaining arms.

```hoon
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  =/   t   !<(@dr vase)
  :_  this
  [%pass /egg-timer %arvo %b %wait (add now.bowl t)]~
```

The `++on-poke` arm evaluates to a gate which takes a sample `[mark vase]`.  `mark` is a type specification and `vase` is a cell of `[specification  value]`
Note: since `++on-poke` may take many different samples, it would be prudent to add a `%noun` mark check here.
In this example, we assume that our sample will contain a `@dr` and pull it from the `vase` with `=/   t   !<(@dr vase)`
`@dr` is an aura for a 128-bit relative date. Here are a few examples.

- `~s17`    17 seconds
- `~m20`    20 minutes
- `~m13s37` 13 minutes, 37 seconds
- `~d42`    42 days

As a matter of good type hygiene, we explicitly cast the output of this gate with `^-` to ensure we are producing the correct structure for Gall to handle.
Our specification is `(quip card _this)` which produces a type,  `[(list card) _this]`.  Note that `_this` is irregular form of `$_(this)` which normalizes to the type of `this`, our door.

Next we use the `:_` rune which is the inverted form of `:-`, the cell construction rune. 

```hoon
:_  this
  [%pass /egg-timer %arvo %b %wait (add now.bowl t)]~
```
Our card should follow the basic form `[%pass /my/wire a-note]`
In this case, our card will ask Arvo to `%pass` a note along the wire `/egg-timer` to Behn(`%b`) containing a `%wait` request.
Behn will start a timer for us, and will respond along our wire, `/egg-timer`.

`now.bowl` is the current time of type `@da`, and `t` was declared as `@dr`.  Because they are both atoms, we can add `now` and `t` to produce an atom that is `t` units of time into the future from `now`.  That produced atom can be interpreted as a `@da`.
The calculated time will be passed via Arvo to Behn with instruction to `%wait @da`, i.e., to set a timer.

That's all for our `++on-poke` arm.  But what about when the timer goes off?  Behn will create a `gift`, a similar construct to our `card` which will be dispatched back to us via Gall in the `++on-arvo` arm.

```hoon
++  on-arvo
  ^+  on-arvo:*agent:gall
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ~&  "Timer went off!"
  [~ this]
```
`++on-arvo` evaluates to a gate whose sample is a cell of `wire` and `sign-arvo` here given default faces.  The syntax of `=wire` is a shortcut for `wire=wire`; it's a common pattern to shadow the name of a type when you only have one instance of the type and are not going to refer to the type itself.
A `wire` is an alias for a path.  Our `wire` will be the path  we provided in our `++on-poke` card.  If we needed to do something particular depending on which request triggered this Arvo card, we could use the wire to do so.

Note: since multiple vanes can send many sorts of cards via `++on-arvo`, it would be prudent to check if `sign-arvo` is `[%b %wake *]`.  Since our trivial example assumes the card is `%wake` from Behn, we will forgo that better practice here.

Next we have the same cast we used in `++on-poke` to make sure we produce the correct type for Gall.  `(quip card _this)` resolves to a type `[(list card) _this]`
```
~&  "Timer went off!"
```

`~&` is the debugging printf rune.  Here we're using it to output a message.  We could, however, modify this line of code to do any other computation when `++on-arvo` is called.

We need to produce a noun of type `(quip card _this)` i.e., `[(list card) _this]`.
In this case, we will not produce any card or change application state.  Therefore we simply produce a cell of a null list and our original context, `[~ this]`.

```hoon
++  on-init   on-init:def
++  on-save   on-save:def
++  on-load   on-load:def
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent  on-agent:def
++  on-fail   on-fail:def
--
```
Finally, we define the remaining 8 unused but required Gall Agent armsas instances of the default arms provided in `/lib/default-agent.hoon`.