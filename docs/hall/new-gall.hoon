/=  kids  /%  /tree-kids/
:-  :~  navhome/'/docs/'
        navuptwo/'true'
        sort/'3'
        title/'The new Gall model'
    ==
;>

# The new Gall model

This document is complemented by the source code of applications that use the new Gall model (like [Hall](https://github.com/urbit/arvo/blob/master/app/hall.hoon)), but doesn't require it. Code snippets will be provided where useful. Some knowledge of Hoon and the functioning of Hoon apps is assumed.

New Gall has not yet fully solidified. As such, structure and naming are tentative to change.

## Table of contents

- [Renewing a pillar of Arvo](#renewing-a-pillar-of-arvo)
  - [Problems](#problems)
  - [Solutions](#solutions)
- [As seen in new Gall](#as-seen-in-new-gall)
  - [Structures](#structures)
  - [Arms](#arms)
- [By example](#by-example)
  - [State & deltas](#state--deltas)
  - [Queries & rumors](#queries--rumors)
  - [Responding to queries](#responding-to-queries)
  - [Updating state & query results](#updating-state--query-results)
- [Criticism](#criticism)
- [Further reading](#further-reading)

## Renewing a pillar of Arvo

When you write an app, Gall is responsible for making sure its event arms like `++poke` get called when they need to. In essence, it provides developers with a consistent interface for hooking their app up to the operating system.<br>It's not doing a lot to make sure this is done in a structured way though, which results in apps (especially larger ones) feeling like big tangled messes. Something needs to be done about this.

### Problems

Imagine a `++poke`, `++diff`, or even a `++peer` arm. In current implementations, you'll often see their product defined through cast as the following:<br>`^-  (quip move +>)`<br>Or (sadly) more commonly:<br>`^-  {(list move) _+>.$}`

These arms are producing both side-effects and new state. To do this, their code has to simultaneously figure out "how does this poke/diff/whatever change our state?" and "what side-effects does this change have?".<br>You'll find that the logic relating to these two often becomes tangled, making the flow of the whole more difficult to understand. And the side-effects more often than not relate to subscriptions, for which the developer may be writing a lot of boilerplate code. Gall currently does not help in either of these places.

> The main significant cost of software development is the cost of
  untangling what the computer is doing, and or is supposed to be doing,
  over and over again in your head. Any way of lowering this untangling
  cost is extremely welcome.

-- _~sorreg-namtyv_

### Solutions

Let's imagine a world in which Gall _does_ help, in both those places.

It would be wonderful if Gall could take care of all standard subscription management logic for you, and direct the flow of code as it concludes is appropriate.<br>Applications, then, would have to help Gall by providing the different parts of this flow, and the checks that allow Gall to make the right decisions. This takes some work out of the developer's hands and results in more structured application code.

If we expand on that a bit we can even have Gall help us in untangling state changes from side effects. We do so by separating state changes into two phases: _analyzing_ what changes need to be made, and _applying_ those changes.<br>But where do the side-effects go then? We need to realize there's two kinds: side-effects that are subscription updates, and those that aren't. The latter get produces by applying state changes, while the former get integrated into the Gall flow we described above.<br>Since subscriptions are essentially queries to an app, requesting a specific part of its data/state, we can deduce subscription updates from state changes. We merely provide the logic, and Gall chains it all together.

Having Gall support all this allows us to cleanly and structurally untangle state change analysis, application, and subscription logic into their own arms.<br>For trivial apps, this might result in some arms with trivial code. Though it may feel like writing cruft, it makes understanding the app just as simple as it actually as.<br>For more complex apps, all logic is no longer a big chunk of "what do we do when x happens?", but rather a couple of smaller chunks, like "x happened, how does that change our state?" and "if our state changes like y, what does that mean for subscription z?" These are precisely the kinds of questions that application developers should be asked.

## As seen in new Gall

Of course for the above to be made into reality, Gall will need to see some changes. Let's outline the new structures and the arms they get passed between.

### Structures

This wouldn't be Urbit if we had some cool new terminology for people to learn. These ones are (for the most part) semantically sensible though, and you might already see how these relate to the story above.

`brain`: application state.<br>`delta`: change to application state.<br>`opera`: side-effect, operation, move.<br>`query`: request (to an app) for data on a specific path.<br>`prize`: query result.<br>`rumor`: change to a query result.

These should be fairly straightforward. Like packets are to Urbits, `delta`s are to `brain`s and `rumor`s are to `prize`s. If one diligently updates the `prize` they received using all the `rumor`s that are relevant to it, they will always have the same `prize` as if they queried for it all over again.

### Arms

This also wouldn't be Urbit if we couldn't boil that down to a few simple pseudocode functions. Let's try, shall we?

```
++  bake  |=  {brain delta}  ^-  {brain opera}
++  peek  |=  {brain query}  ^-  (unit (unit prize))
++  feel  |=  {query delta}  ^-  (unit rumor)
++  gain  |=  {prize rumor}  ^-  prize

::  for any given brain, delta and query:
.=  (peek brain:(bake brain delta) query)
    (gain rumor:(feel query delta) prize:(peek brain query))
```

There, in the first three arms we already have the bulk of new Gall! `++gain` won't be part of it, since most applications don't need to keep track of `prize`s directly. Those that do may still implement and hook it up themselves though.

Of course, these aren't all of the new Gall arms. Most important to still mention is `++leak`, which takes a `ship` and `query` and checks if the former has permission to ask for the latter.<br>There's also `++look` for asynchronous reads, `++hear` for subscription updates (rumors), `++fail` for dealing with process errors, `++cope` for dealing with transaction results, and `++pour` for dealing with responses from arvo.<br>`++prep`, `++poke` and `++pull` continue to function as they do right now.<br>For a more verbose specification of all of these, see the new Gall spec.

## By example

To help solidify this and see what this would looks like in the wild, let's make a very simple example app. It's a counter that can go up and down, and can be queried for its value, or whether or not its value is a multiple of x. First we write all the structures that will support our app, and then we implement the arms that operate on them.<br>(The app code in its entirety can be found [here](example).)

### State & deltas

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

### Responding to queries

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

### Updating state & query results

Our app can get queried! If they're interested enough, they'll want to receive updates on that whenever relevant state changes. First, let's see how state changes happen. We still have regular old `++poke` arms, let's use that to prompt our application to change its state.

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
    ::  we could, of course, store mul/? in state, and
    ::  make a delta for it, but should we need to?
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

## Criticism

- Where event arms currently get passed a `wire`, and the new Gall described above passes them a custom `query` structure, the original new Gall spec gave them `(list coin)`, a "pre-parsed wire". These structures (eg `[%$ p=[p=~.ud q=123]]`) are uncomfortable to work with. Even with a "coin list parsing library" it still doesn't feel ideal.  
  Because of custom structures being easier to work with than lists of knots or coins, writing a `++path-to-query` arm by hand is a small cost for huge gains.

- Why do `prize` units mean what they do? Would have expected `~` to mean "invalid" and `[~ ~]` to mean "unavailable" as opposed to the other way around.

- The original new Gall spec mentions output lists (like `(list delta)` etc.) to be in reverse order. This was done because adding to the head of a list (`[item list]`) is easier than appending to the tail of a list (`(weld list [item ~])` or other).  
  While it's technically easier to produce a list in reverse order, semantically it's yet another thing to keep in mind. Luckily, most of the "add to x, produce all of it later" code is set-and-forget, so probably not a huge deal, but do we really fear a few stray `++flop`s that much?

- There's some weirdness with relation to relying on old state in `++feel` to determine whether a query result actually changed. Just relying on state in general for delta-to-rumor conversion may or may not violate the new Gall spec.

- The original new Gall spec specifies `++leak` as taking a `(unit (set ship))`, where `~` means public. Is there a use case for checking more than just a single ship?

- Gall should probably cache `++feel` results during a single pass, to avoid the cycles of generating what it can be certain of is the same `(unit rumor)`. (But then for eg `/circle/nom/13` and `/circle/nom/14` it would still recalculate. Better than nothing.)

## Further reading

;+  (kids %title datapath/'/docs/hall/new-gall/' ~)
