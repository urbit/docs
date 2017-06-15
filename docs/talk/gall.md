
# The Gall Delta Model

This document is complemented by the source code of applications that use the new gall model (like hall), but doesn't require it. Code snippets and diagrams will be provided where useful. Some knowledge of the functioning of Hoon apps is assumed.

Naming of functions and molds in this document is tentative.

## Table of contents

@TODO

## Introduction

Imagine a `++poke`, `++diff`, or even a `++peer` arm. In current implementations, you'll often see their product defined through cast as the following:  
`^-  (quip move +>)`  
Or (sadly) more commonly:  
`^-  {(list move) _+>.$}`

These arms are producing both side-effects and new state. To do this, the application has to simultaneously figure out "how does this poke/diff/whatever change our state?" and "what side-effects does this change have?". You'll find that the logic relating to these two often becomes tangled, making the flow of the whole more difficult to understand. Gall currently does not help here.

@TODO better segue  
What if we could separate these two, untangling state changes from side effects? And if we plucked state changes apart into *calculating* and *applying* the change, wouldn't we be able to deduce side-effects from calculated changes? Enter New Gall.

@TODO better argumentation, lay out advantages of change, etc.

State gets changed, subscriptions need to be updated to reflect that, etc.

Queries: we're just getting data (and maybe staying up to date on it)!


## Structure

This wouldn't be Urbit if we had some cool new terminology for people to learn. These aren't super obscure though, don't worry.

`brain`: application state.  
`delta`: change to application state.  
`opera`: side-effect, operation, move.  
`query`: request (to an app) for data on a specific path.  
`prize`: query result.  
`rumor`: change to a query result.

These should be fairly straightforward. The idea of `brain`+`delta` and `prize`+`rumor` is comparable to Urbit's "state is a function of facts" way of thinking. If I diligently update the `prize` I got using the `rumor`s, then I won't ever need to `query` again to pull down the full correct `prize`.

This also wouldn't be Urbit if we couldn't boil that down to a few simple functions. Let's try, shall we?

```
++  bake  |=  {brain delta}  ^-  {brain opera}
++  peek  |=  {brain query}  ^-  (unit (unit prize))
++  feel  |=  {query delta}  ^-  (unit rumor)
++  gain  |=  {prize rumor}  ^-  prize
```

The first three are part of new gall. `++gain` usually won't be implemented in that exact way, but needs to be possible still, to illustrate our functional definitions. The following two statements should be equal, for any given brain, query and delta:

```
(peek brain:(bake brain delta) query)
(gain rumor:(feel query delta) (peek brain query))
```


## By example

### State & deltas

To help solidify this, let's look at a very simple example app. We'll be making a counter that can go up and down. (The app code in its entirety can be found [here](gall-eg.hoon).)  
Below is the application state, and the deltas we'll be using to modify it.

```
|%
++  brain  {num/@ud $~}                                 :<  application state
++  delta                                               :>  state change
  $%  {$increment $~}                                   :<  +1
      {$decrement $~}                                   :<  -1
  ==                                                    ::
```

Fairly simple, right? We store a number, and every change either in- or decrements it.

### Queries & rumors

Let's also define the queries we'll be supporting, their results, and the changes to their results. Instead of only allowing people to query the current number, let's make it a tad more interesting by allowing them to query whether or not the current number is a multiple of something.

```
++  query                                               :>  valid queries
  $%  {$number $~}                                      :<  current number
      {$mul-of val/@ud}                                 :<  is num multiple of?
  ==                                                    ::
++  prize                                               :>  query results
  $%  {$number num/@ud}                                 :<  /number
      {$mul-of mul/?}                                   :<  /mul-of
  ==                                                    ::
++  rumor                                               :>  query result changes
  $%  {$number delta}                                   :<  /number
      {$mul-of mul/?}                                   :<  /mul-of
  ==                                                    ::
--
```

You'll see the `rumor` for a `/number` query just contains a delta. In this specific case, a change in state maps directly to a change to `prize`. For `/mul-of` queries, things aren't that simple.

### Functionality

Now, let's implement all the arms that will be called as things start happening. First, we want to implement `++leak`, which checks if a given `ship` is allowed to make a certain `query`. In this case, we're fine with everyone checking out our application's data.

```
|_  {bol/bowl brain}
::
++  leak                                                :>  read permission
  |=  {who/ship qer/query}
  ^-  ?
  &  ::  everyone's allowed
```

Next, let's create the `prize`s for the folks that make it through `++leak`. We'll be producing a `(unit (unit prize))` so we can potentially say `~` for "unavailable" and `[~ ~]` for "invalid query".

```
++  peek                                                :>  synchronous read
  |=  qer/query
  ^-  (unit (unit prize))
  ?-  -.qer
    $number   ``[%number num]
    $mul-of   ?:  =(0 mul.qer)  [~ ~]
              ``[%mul-of =(0 (mod num mul.qer))]
  ==
```

Our app has been queried! If they're interested enough, they'll want to receive updates on that whenever relevant state changes. First, let's see how state changes happen. We still have regular old `++poke` arms, let's use that to prompt our application to change its state.

```
++  poke-loob                                           :>  regular old poke
  |=  inc/?
  ^-  (list delta)
  :_  ~
  ?:  inc  [%increment ~]
  [%decrement ~]
::
++  bake                                                :>  apply delta to state
  |=  del/delta
  ^-  (quip opera +>)
  :-  ~
  ?-  -.del
    $increment  +>(num +(num))
    $decrement  +>(num (dec num))
  ==
```

`delta`s get redirected into `++bake` so that our state can get changed as described. After this happens the same `delta`s get, for each active query, routed into `++feel`. That then figures out what the `rumor` relevant to the query is, if applicable.

```
++  feel                                                :>  delta to rumor
  |=  {qer/query del/delta}
  ^-  (unit rumor)
  ?-  -.qer
      $number
    `[%number del]
    ::
      $mul-of
    ::  since we only want to send a rumor if result
    ::  changed, we need to deduce the old state from
    ::  the current state and the delta. depends on the
    ::  fact that state changes before ++feel. funky!
    =/  old
      .=  0
      %+  mod
        ?-  -.del
          $increment  (dec num)
          $decrement  +(num)
        ==
      mul.qer
    =/  new  =(0 (mod num mul.qer))
    ?:  =(old new)  ~
    `[%mul-of new]
  ==
```

As we saw earlier, for `/number` queries the `delta`s match one-on-one with the relevant `rumor`s. For `/mul-of` queries we do a little bit of work to see if anything actually changed. No need to send a `rumor` if it hasn't.


## Under the hood

These arms get chained together by gall. `++cope`(?) can be implemented to accept `prize`s. `++hear`(?) can be implemented to accept `rumor`s.  
@TODO probably show examples?

One thing that wasn't shown was a `++path-to-query` arm. This is responsible for converting a query path to a query object as defined in the application's structures.


## Criticism

`coin`s are a pain to work with. The "coin list parsing library" makes this a bit easier, but ideally we'd just define a `++path-to-query` arm and do everything as described above.

Why do prize units mean what they do? Would've expected it the other way around.

Not sure if I'm a fan of "in reverse order". It's technically easier, but semantically yet another thing to keep in mind. Luckily, most of the "add to x, produce all of it later" code is set-and-forget, so probably not a huge deal.

`++bake` should just produce `(quip move +>)`. why would we want to be forced to keep operas in state? just to avoid [~ +>] over +>?

weirdness wrt relying on (old) state in ++feel

gall should probably cache `++feel` results during a single pass. (but then for eg /circle/nom/13 and /circle/nom/14 it would still recalculate. better than nothing though.)

Lots of cruft for small applications to bother with. (Though I admit it does feel like structured cruft, at least.)
