---
navhome: /developer/docs/
next: true
sort: 15
title: Subscriptions
---

# Subscriptions

We've dealt fairly extensively with "poke" messages to an app, but these
are somewhat limited. A poke is a one-way message, but more often we
want to subscribe to updates from another app. You could build a
subscription model out of one-way pokes, but it's such a common pattern
that it's built into arvo.

Let's take a look at two apps, `:source` and `:sink`. First,
`:source`:
    
```
::  Sends subscription updates to sink.hoon             ::  1
::                                                      ::  2
::::  /===/app/source/hoon                              ::  3
  ::                                                    ::  4
!:                                                      ::  5
::                                                      ::  6
|%                                                      ::  7
++      move  {bone card}                               ::  8
++      card  $%  {$diff diff-contents}                 ::  9
          ==                                            ::  10
++      diff-contents  $%  {$noun *}                    ::  11
               ==                                       ::  12
--                                                      ::  13
::                                                      ::  14
|_      {bow/bowl $~}                                   ::  15
::                                                      ::  16
++      poke-noun                                       ::  17
  |= non/*                                              ::  18
  ^-  {(list move) _+>.$}                               ::  19
  :_  +>.$                                              ::  20
  %+  turn      (prey /example-path bow)                ::  21
  |=({o/bone *} [o %diff %noun non])                    ::  22
::                                                      ::  23
++      peer-example-path                               ::  24
  |=  pax/path                                          ::  25
  ^-  {(list move) _+>.$}                               ::  26
  ~&  source+peer-notify+'Someone subscribed to you!'   ::  27
  ~&  source+[ship+src.bow path+pax]                    ::  28
  [~ +>.$]                                              ::  29
::                                                      ::  30
++  coup                                                ::  31
  |=  {wir/wire err/(unit tang)}                        ::  32
  ^-  {(list move) _+>.$}                               ::  33
  ?~  err                                               ::  34
    ~&  source+success+'Poke succeeded!'                ::  35
    [~ +>.$]                                            ::  36
  ~&  source+error+'Poke failed. Error:'                ::  37
  ~&  source+error+err                                  ::  38
  [~ +>.$]                                              ::  39
::                                                      ::  40
++      reap                                            ::  41
  |=  {wir/wire err/(unit tang)}                        ::  42
  ^-  {(list move) _+>.$}                               ::  43
  ?~  err                                               ::  44
    ~&  source+success+'Peer succeeded!'                ::  45
    [~ +>.$]                                            ::  46
  ~&  source+error+'Peer failed. Error:'                ::  47
  ~&  source+error+err                                  ::  48
  [~ +>.$]                                              ::  49
::                                                      ::  50
--                                                      ::  51
```

And secondly, `:sink`:
```
::  Sets up a simple subscription to source.hoon        ::  1
::                                                      ::  2
::::  /===/app/sink/hoon                                ::  3
  ::                                                    ::  4
!:                                                      ::  5
|%                                                      ::  6
++      move  {bone card}                               ::  7
++      card  $%  {$peer wire dock path}                ::  8
          {$pull wire dock $~}                          ::  9
          ==                                            ::  10
--                                                      ::  11
::                                                      ::  12
|_      {bow/bowl val/?}                                ::  13
::                                                      ::  14
++      poke-noun                                       ::  15
  |=  non/*                                             ::  16
  ^-  {(list move) _+>.$}                               ::  17
  ?:  &(=(%on non) val)                                 ::  18
    :_  +>.$(val |)                                     ::  19
    :~  :*      ost.bow                                 ::  20
        %peer                                           ::  21
        /subscribe                                      ::  22
        [our.bow %source]                               ::  23
        /example-path                                   ::  24
        ==                                              ::  25
    ==                                                  ::  26
  ?:  &(=(%off non) !val)                               ::  27
    :_  +>.$(val &)                                     ::  28
    ~[[ost.bow %pull /subscribe [our.bow %source] ~]]   ::  29
  ~&  ?:  val                                           ::  30
        sink+unsubscribed+'You are now unsubscribed!'   ::  31
      sink+subscribed+'You are now subscribed!'         ::  32
  [~ +>.$]                                              ::  33
::                                                      ::  34
++      diff-noun                                       ::  35
  |=  {wir/wire non/*}                                  ::  36
  ^-  {(list move) _+>.$}                               ::  37
  ~&  sink+received-data+'You got something!'           ::  38
  ~&  sink+data+non                                     ::  39
  [~ +>.$]                                              ::  40
::                                                      ::  41
++      coup                                            ::  42
  |=  {wir/wire err/(unit tang)}                        ::  43
  ^-  {(list move) _+>.$}                               ::  44
  ?~  err                                               ::  45
    ~&  sink+success+'Poke succeeded!'                  ::  46
    [~ +>.$]                                            ::  47
  ~&  sink+error+'Poke failed. Error:'                  ::  48
  ~&  sink+error+err                                    ::  49
  [~ +>.$]                                              ::  50
::                                                      ::  51
++      reap                                            ::  52
  |=  {wir/wire err/(unit tang)}                        ::  53
  ^-  {(list move) _+>.$}                               ::  54
  ?~  err                                               ::  55
    ~&  sink+success+'Peer succeeded!'                  ::  56
    [~ +>.$]                                            ::  57
  ~&  sink+error+'Peer f ailed. Error:'                 ::  58
  ~&  sink+error+err                                    ::  59
  [~ +>.$]                                              ::  60
::                                                      ::  61
--                                                      ::  62
```

Cheat sheet:

-   `&` (pam) can either be the boolean true (as can `%.y`, `0`), or
    the irregular wide form of the `?&`
    ([wutpam](../../hoon/twig/wut-test/pam-and)) rune, which computes
    logical `AND` on its two children.

-   Similar to `&`,`|` is either the boolean false (along with `%.n` and
    `1`), or the irregular short for of `?|`
    ([wutbar](../../hoon/twig/wut-test/bar-or)), which computes logical `OR`
    on its two children.

-   `!` is the irregular wide form of `?!`
    ([wutzap](../../hoon/twig/wut-test/zap-not/)), which computes logical
    `NOT` on its child.

-   `?~` ([wutsig](../../hoon/twig/wut-test/sig-ifno/)) is basically an
    if-then-else that checks whether condition `p` is `~` (null). `?~`
    is slightly different from `?:(~ %tru %fal)` in that `?~` reduces to
    `?:($=(%type value) %tru %false)`. `$=`
    ([buctis](../../hoon/twig/buc-mold/tis-coat/)) tests whether value `q` is
    of type `p`.
<!-- One thing to watch out for in hoon: if you do `?~`, it
      affects the type of the conditional value: XXexample -->

-   `:_` ([colcab](../../hoon/twig/col-cell/cab-scon/)) is inverted `:-`: it
    accepts `p` and `q`, and produces `[q p]`.

-   `++bowl` is the type of the system state within our app. For
    example, it includes things like `our`, the name of the host urbit,
    and `now`, the current time.

-   `$%` ([buccen](../../hoon/twig/buc-mold/cen-book/)) is a type
    constructor: it defines a new type, composed of `n` types that it is
    passed. For example `$%  @  *  ^  ==` is the type of either `@`,
    `*`, or a cell `^`.
<!-- XX this is a union, right? -->

-   You may have noticed the separate `|%`
    ([barcen](../../hoon/twig/bar-core/cen-core/)) above the application core
    `|_` ([barcab](../../hoon/twig/bar-core/cab-door/). We usually put our
    types in another core on top of the application core. We can access
    these type from our `|_` because in `hoon.hoon` files, all cores are
    called against each other. (The shorthand for 'called' is `=>`.)
    Thus, the `|%` with the types is in the context of the `|_`, as it
    lies above it: `hoon.hoon` `=> |% w types => |_`

Here's some sample output of the two working together:

```
~fintud-macrep:dojo/examples> |start %source
>=
~fintud-macrep:dojo/examples> |start %sink
>=
~fintud-macrep:dojo/examples> :sink %on
[%source %peer-notify 'Someone subscribed to you!']
[%source [%ship ~fintud-macrep] %path /]
[%sink %success 'Peer succeeded!']
>=
~fintud-macrep:dojo/examples> :source 5
[%sink %received-data 'You got something!']
[%sink %data 5]
>=
~fintud-macrep:dojo/examples> :sink %off
>=
~fintud-macrep:dojo/examples> :source 6
>=
~fintud-macrep:dojo/examples> :sink %on
[%source %peer-notify 'Someone subscribed to you!']
[%source [%ship ~fintud-macrep] %path /]
[%sink %success 'Peer succeeded!']
>=
~fintud-macrep:dojo/examples> :source 7
[%sink %received-data 'You got something!']
[%sink %data 7]
>=
```

### :source

Hopefully you can get a sense for what's happening here. When we poke
`:sink` with `%on`, `:sink` subscribes to `:source`,
and so whenever we poke `:source`, `:sink` gets the update and
prints it out. Then we unsubscribe by poking `:sink` with `%off`, and
`:sink` stops getting updates. We then resubscribe.

There's a fair bit going on in this code. Let's look at `:source`
first.

Our definition of `move` is fairly specific, since we're only going to
sending one kind of move. The `%diff` move is a subscription update, and
its content is marked data which gall routes to our subscribers.

This is a slightly different kind of move than [we've dealt with so
far](/arvo/network). It's producing a result rather than calling other
code (i.e. it's a return rather than a function call), so if you recall
the discussion of ducts, a layer gets popped off the duct rather than
added to it. This is why no wire is needed for the move -- we won't
receive anything in response to it.

Anyways, there are four functions (arms) inside the `|_`. We already know when
`++poke-noun` is called. `++peer-example-path` is called when someone tries to 
subscribe to our app. Of course, you don't just subscribe to an app; you 
subscribe to a path on that app. This path comes in as the argument to `++peer`.

In our case, we don't care what path you subscribed on, and all we do is print
out that you subscribed. Arvo keeps track of your subscriptions, so you don't
have to. You can access your subscribers by looking at `sup` in the bowl that's
passed in. `sup` is of type `(map bone {@p path})`, which associates bones with
the urbit who subscribed, and which path they subscribed on. If you want to
communicate with your subscribers, send them messages along their bone.

`++poke-noun` "spams" the given argument to all our subscribers.
There's a few things we haven't seen before. Firstly, `:_(a b)` is the
same as `[b a]`. It's just a convenient way of formatting things when
the first thing in a cell is much more complicated than the second.
Thus, we're producing our state unchanged.

Our list of moves is the result of a call to `++turn`. `++turn` is what many
languages call "map" -- it runs a function on every item in a list and collects
the results in a list. The list is `(prey /example-path bow)` and the function
is the `|=` line right after it.

`++prey` is a standard library function defined in `zuse.hoon`. It takes a path 
and a bowl and gives you a list of the subscribers who are subscribed on a path 
that begins with the given path. "Prey" is short for "prefix".

Now we have the list of relevant subscribers. This a list of triples,
`{bone @p path}`, where the only thing we really need is the bone, because we
don't need to know their urbit or what exact path they subscribed on. Thus, our
transformer function takes `{o/bone *}` and produces `[o %diff %noun non]`,
which is a move that provides bone `o` with this subscription update:
`[%noun non]`". This is fairly dense code, but what it's doing is
straightforward!

### :sink

`:source` should now make sense. `:sink` is a little longer, but not much more 
complicated.

In `:sink`, our definition of of `++move` is different. All moves start
with a `bone`, and we conventionally refer to the second half as the "card", so
that we can say a move is an action that sends a card along a bone.

We have two kinds of cards here: we `%peer` to start a subscription, and we
`%pull` to stop it. Both of these are "forward" moves that may receive a
response, so they need a wire to tack onto the duct before they pass it on. They
also need a target, which is a pair of an urbit and an app name. Additionally,
`%peer` needs a path on that app to subscribe too. `%pull` doesn't need this,
because its semantics are to cancel any subscriptions coming over this duct. If
your bone and wire are the same as when you subscribed, then the cancellation
will happen correctly.

The only state we need for `:sink` is a boolean to indicate whether
we're already subscribed to `:source`. We use `val/?`, where `?`
is the sign of type boolean (similar to `*`, `@`), which defaults to true (that
is, `0`).

In `++poke-noun` we check our input to see both if it's `%on` and we're
available (`val` is true). If so, we produce the move to subscribe to 
`:source`:

```
    :~  :*      ost.bow                                 ::  20
        %peer                                           ::  21
        /subscribe                                      ::  22
        [our.bow %source]                               ::  23
        /example-path                                   ::  24
        ==                                              ::  25
    ==                                                  ::  26
```

Also, in the preceding lines, we set `val` to false (`|`) with `+>.$(val |)`. 
Remember that the `:_` constructs an inverted cell, with the first child 
(`+>.$(val |` in our case) as the tail and the second child as the head. Here, 
the cell we produce when our subscription is `%on` and `val` is true has a 
head with our new state where `val` is set to false and a tail of our list of 
moves, which is shown in the code block above.

Otherwise, if our input is `%off` and we're already subscribed (i.e. `val`
is false), then we unsubscribe from `:source` and set `val` back to true (`&`), 
again using our handy inverted cell constructor mold `:_`:

```
    :_  +>.$(val &)                                     ::  28
    ~[[ost.bow %pull /subscribe [our.bow %source] ~]]   ::  29
```

It's important to send over the same bone and wire (`/subscribe`) as the
one we originally subscribed on.

If neither of these cases are true, then we print our current subscription
state, based on whether `val` is true or false, and return a cell containing 
a null list of moves and our unchanged app state:

```
  ~&  ?:  val                                           ::  30
        sink+unsubscribed+'You are now unsubscribed!'   ::  31
      sink+subscribed+'You are now subscribed!'         ::  32
  [~ +>.$]                                              ::  33
```

`++diff-noun` is called when we get a `%diff` update along a subscription with a
mark of `noun`. `++diff-noun` is given the wire that we originally passed with
the `%peer` subscription request along and the data we got back. In our case we
just print out the data:

```
  ~&  sink+received-data+'You got something!'           ::  38
  ~&  sink+data+non                                     ::  39
```

`++reap` is called when we receive an acknowledgment as to whether the
subscription was handled successfully. You can remember that `++reap` is the
counterpart to `++peer` as it's pronounced like 'peer' backwards. Similarly,
`coup` is similar to 'poke' backwards.

Moving forward, `++reap` is given the wire we attempted to subscribe over,
possibly along with an error message in cases of failure. `(unit type)` means
"either `~` or `[~ type]`, which means it's used like Haskell's "maybe" or C's
nullability. If `err` is `~`, then the subscription was successful and we tell
that to the user. Otherwise, we print out the error message.
