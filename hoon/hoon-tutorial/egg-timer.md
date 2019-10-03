+++
title = "2.7.1 Gall Walkthrough: Egg Timer"
weight = 36
template = "doc.html"
+++

The Arvo operating system is divided up into modules called vanes. Gall is the vane responsible for providing an API for building stateful applications in Urbit. Gall is a complex system that takes a lot of getting used to, so let's dip our toes in with a simple egg-timer app.


```hoon
|%
+$  effect   (pair bone syscall)
+$  syscall  [%wait path @da]
--
|_  [bowl:gall ~]
++  poke-noun
  |=  t=@dr
  ^+  [*(list effect) +>.$]
  :_  +>.$  :_  ~
  [ost %wait /egg-timer (add now t)]
++  wake
  |=  [=wire error=(unit tang)]
  ^+  [*(list effect) +>.$]
  ~&  "Timer went off!"
  [~ +>.$]
--
```

The first thing to notice is that we are creating a `core` (`|%`) and a `door` (`|_`). This is a typical style of Gall programming where your types are defined in the first `core` and your application is defined in the following `door`.

```hoon
|%
+$  effect   (pair bone syscall)
+$  syscall  [%wait path @da]
--
```

The `core` here defines two types: `effect` and `syscall`. An `effect` is a `pair` of `bone` and `syscall`. A `bone` is a Gall-only type that identifies app event chains by mapping atoms to them. We define `syscall` to be a request to Arvo to do something for us. In this case, the only valid `syscall` will be `%wait` which we'll discuss in a bit.

It's important to note that the names `effect` and `syscall` are arbitrary; you can call them whatever you'd like. Commonly you will see them called `move` and `card`, respectively, but we've changed the names here to try to introduce some clarity that that older convention lacks.

The sample of the `door` is:

```hoon
[bowl:gall ~]
```

You can find the full definition of `bowl` in `sys/zuse.hoon`, but for now it's enough to know that this is the default app state and includes various faces for information. Below are some important such faces:

`our`  The ship this code is running on
`src`  The ship the current event originated from
`ost`  A reference to the current chain of events
`eny`  Guaranteed-fresh entropy
`now`  The current time

The `door` we've made has two arms `poke-noun` and `wake`. Gall is capable of dispatching `pokes`, or requests, to an app based on the mark of the data given along with that poke. These are sent to the arm with the name that matches the mark of the data. Here we use the generic `noun` mark:

```hoon
++  poke-noun
  |=  t=@dr
  ^+  [*(list effect) +>.$]
  :_  +>.$  :_  ~
  [ost %wait /egg-timer (add now t)]
```

In the above code, we create a gate that takes a single `@dr` argument. `@dr` is an aura for a 128-bit relative date. Here are a few examples.

`~s17`  17 seconds
`~m20`  20 minutes
`~d42`  42 days

As a matter of good type hygiene, we explicitly cast the output of this gate with `^+` to ensure we are producing the correct thing for Gall to handle. `^+` is the rune for casting by example. Our example is a cell: `list` of `effect`, which we `bunt` with `*`, is the head; `+>.$`, the enclosing core which is our `door`, is the tail.

Next we're going to use the `:_` rune which is just the inverted form a `:-` the cell construction rune. We use it twice so the actual data will end up looking something like:

```hoon
[[[ost %wait /egg-timer (add now t)] ~] +>.$]
```

`ost` is the `bone`, the opaque reference to a chain of events, that comes from `bowl`, so we're going to continue to use it here. `%wait` is the name of the `syscall`, in this case a request to the Behn vain to start a timer for us.

After `%wait`, we have the `path`, a `list` of `cords` that serves as the unique identifier for this `syscall`:

```
/egg-timer
```

The `/` here is an irregular syntax to make a `path`.

The final part of this `syscall` is:

```
(add now t)
```

`now` is the current time of type `@da`, and `t` was declared as `@dr`. Because they are both atoms, we can add `now` and `t` these two to get an atom that is `t` units of time into the future from `now`. That produced atom can be interpreted as a `@da`.

That's all for our `poke-noun` arm. But what about when the timer goes off? Behn will create a `gift`, a similar construct to how we created an `effect`, only this time it will end up being dispatched back to us via Gall in the `++wake` arm. Any app that wants to use a timer trigger needs to have an arm called `++wake`.

```hoon
++  wake
  |=  [=wire error=(unit tang)]
  ^+  [*(list effect) +>.$]
  ~&  "Timer went off!"
  [~ +>.$]
```

`wake` is a `gate` that has two arguments: a `wire`, and a `(unit tang)` with the face `error`. The syntax of `=wire` is a shortcut for `wire=wire`; it's a common pattern to shadow the name of a type when you only have one instance of the type and are not going to refer to the type itself. A `wire` is just an alias for `path`. Our `wire` will be the `path` that we gave original `syscall`. If we needed to do something based on which request caused this gate to be called, we could use the wire to do so. In this case, we don't do perform such a dispatch.

Next we have the same cast we used in `++poke-noun` to make sure we are producing the correct thing for Gall. These casts are not strictly necessary, as the type system can infer what the type will be, but they can be very useful both for debugging our own code and for someone else trying to determine what our code should be producing.

```
~&  "Timer went off!"
```

`~&` is the debugging printf rune. Here we're using it to output a message. We could, however, modify this line of code to do any other computation we would want to happen when `++wait` gets called.

Finally, we need to produce our `effect`. Here the effect is simply `[~ +>.$]`, since we have no `syscall` to make and we are not changing the state of our app. We just use the `door` without changing its sample.

### [Next Up: Reading -- Ford](../ford)
