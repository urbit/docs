+++
title = "Behn"
weight = 0
template = "doc.html"
+++

Behn is an Arvo vane that acts as a simple timer. It allows vanes and applications to set timer events, which are managed in a simple priority queue.

An app or vane can make a request to Behn to be informed when a specified amount of time has elapsed. Behn then produces effects to begin a unix timer for that request. The unix timer informs Behn after the specified time has elapses, which then informs the requestee. There is no guarantee that the requestee will be informed of the elapsed timer at the precise moment it requested, or even that it will be close. The only guarantee is that the requester will be informed at some point after the allotted time has passed.

## Types

We review here some of the commonly used types in the Behn vane as found in `behn.hoon`.

### `timer`
```
+$  timer  [date=@da =duct]
```

A `timer` consists of a `@da` (an absolute date at which the timer will go off) and a `duct` (representing the causal stack that began the timer). As part of its state, `Behn` keeps track of a list of `timer`s.

### `behn-state`

```
+$  behn-state
  $:  timers=(list timer)
      unix-duct=duct
      next-wake=(unit @da)
      drips=drip-manager
  ==
```

We see that a `behn-state` is a list of all `timers` that `Behn` is currently keeping track of. `unix-duct` is Behn's link to the unix timer. `next-wake` is the next time that `Behn` is supposed to inform a requestee that the specified timer has elapsed. We will ignore `drips` for the purpose of this tutorial.

### `move`

Arvo vanes communicate via `moves`:
```
+$  move  [p=duct q=(wind note gift:able)]
```
A `duct` is a call stack, which is a list of `path`s that represent a step in a causal chain of events. A `wind` is a kernel action. See the following arm from `arvo.hoon`:

```
++  wind                                                ::  new kernel action
          |*  [a=mold b=mold]                           ::  forward+reverse
          $%  [%pass p=path q=a]                        ::  advance
              [%slip p=a]                               ::  lateral
              [%give p=b]                               ::  retreat
          ==
```

Here we see that `wind` produces a wet gate that takes in two molds, which for the `move` type for Behn are `note`s and `gift`s. When a vane needs to request something of another vane, it `%pass`es a `note`.  When a vane produces a result that was requested, it `%gives` a `gift` to the caller.

## Internal arms

The following arms are part of the `event-core` of Behn, which are essentially the internal functions of the Behn vane that are not directly accessible to other vanes and applications. We will not review all of them here, we only list some of most important ones.

### ++set-unix-wake
This arm is what Behn uses to tell the unix timer when to `%wake` Behn.

### ++set-timer
This arm is a dry gate that takes in a `timer` and adds it to the list of `timer`s in the `state`. ``++set-timer`` automatically places the new `timer` in chronological order, so that the timer at the front of the list of `timer`s is the `timer` that will expire the soonest.

### ++wait
```
++  wait  |=(date=@da set-unix-wake(timers.state (set-timer [date duct])))
```
This arm is called when Behn is `%pass`ed a `note` telling Behn to `%wait`. This adds a `timer` to the list of `timer`s in the `state` and correspondingly tells the unix timer to tell Behn when the specified time has passed.

### ++rest
```
++  rest  |=(date=@da set-unix-wake(timers.state (unset-timer [date duct])))
```
This undoes a `++wait` operation. That is, `++rest` removes a timer from the list of `timer`s.

### ++wake
This arm is ultimately called by the unix timer to let Behn know that a previously specified amount of time has elapsed.

### ++born

```
++  born  set-unix-wake(next-wake.state ~, unix-duct.state duct)
```
This arm is called when Behn is first launched. It gives Behn a `duct` to the unix timer and initializes the `behn-state` with the face `state` with a null list of `timer`s.

## External interface

Arvo talks to Behn via four arms, `++call`, `++load`, `++scry`, `++stay`, and ``++take``, which ultimately call arms in the `event-core` of which we have listed a subset above. Here we will only look at `++call` and `++take`.

### ++call
When Behn is `%pass`ed a `note` from another vane, that is enacted upon by Arvo via the `++call` gate. The `note` specifies what action to take, which are references to the internal arms. This is done by including in the `note` a symbol such as `%born`, `%rest`, `%wait`, or `%wake`, which ultimately call the arms with those names in the `event-core`.

### ++take
When Behn is ready to inform another vane or application that a timer has elapsed, Arvo activates the `++take` gate. That is, Arvo `take`s a `gift` from Behn that includes the symbol `%wake`, and `%pass`es it to the the requestee. `%wake` is the only kind of `gift` that Behn can make, but other vanes may possess multiple responses.
