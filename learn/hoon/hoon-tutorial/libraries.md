+++
title = "Libraries"
weight = 0
template = "doc.html"
+++

As in other languages, it's often very useful in hoon to create a library for your code. Let's take a look at one example of a library for dealing with playing cards.

```
|%
+$  suit  ?(%hearts %spades %clubs %diamonds)
+$  darc  [sut=suit val=@ud]
+$  deck  (list darc)
++  make-deck
  ^-  deck
  =|  mydeck=deck
  =/  i  1
  |-
  ?:  (gth i 4)
    mydeck
  =/  j  1
  |-
  ?.  (lte j 13)
    ^$(i +(i))
  %=  $
    j       +(j)
    mydeck  [(num-to-suit i) j]^mydeck
  ==
++  num-to-suit
  |=  val=@ud
  ^-  suit
  ?+  val  !!
    %1  %hearts
    %2  %spades
    %3  %clubs
    %4  %diamonds
  ==
++  shuffle-deck
  |=  [unshuffled=deck entropy=@]
  ^-  deck
  =|  shuffled=deck
  =/  random  ~(. og entropy)
  =/  remaining  (lent unshuffled)
  |-
  ?:  =(remaining 1)
    :_  shuffled
    (snag 0 unshuffled)
  =^  index  random  (rads:random remaining)
  %^  $
  shuffled      (snag index unshuffled)^shuffled
  remaining     (dec remaining)
  unshuffled    (oust [index 1] unshuffled)
++  draw
  |=  [n=@ud d=deck]
  ^-  [hand=deck rest=deck]
  :-  (scag n d)
  (slag n d)
--
```

After creating a core, we use the `+$` arm to create three types we're going to need.

```
+$  suit  ?(%hearts %spades %clubs %diamonds)
+$  darc  [sut=suit val=@ud]
+$  deck  (list darc)
```

The first is `suit` which can be one of `%hearts`, `%spades`, `%clubs`, or `%diamonds`.

Next is a `darc` which is a pair of `suit` and an `@ud` which is a numeric value for the card. Why is it called `darc` and not `card`? `card` already has a meaning in gall where we are likely to use this library so it's worth while to avoid any name confusion in the future.

Our final type is `deck` which is simply a `list` of `darc`

One way to get a feel for how a library works is to skim the arm names before diving into any specific arm. In this library, the arms are `make-deck`, `num-to-suit`, `shuffle-deck`, and `draw`. In this case, these names should be very clear with the exception of `num-to-suit` though you could probably hazard a guess at what it does. Let's take a closer look at that one first.

```
++  num-to-suit
  |=  val=@ud
  ^-  suit
  ?+  val  !!
    %1  %hearts
    %2  %spades
    %3  %clubs
    %4  %diamonds
  ==
```

We can see this is a gate that takes a single `@ud` and produces a `suit`.

The `?+` rune is the rune to switch against a value with a default.  The default here is to crash with `!!`. Then we have the four possible options 1-4 which each result in a suit.

```
++  draw
  |=  [n=@ud d=deck]
  ^-  [hand=deck rest=deck]
  :-  (scag n d)
  (slag n d)
```

`draw` takes two arguments, `n` a number and `d` a `deck`. It's going to produce a cell of two `decks` the first contains a hand of `n` `darcs` and the second is the rest of the `deck`. This is done with the `scag` and `slag` gates. 

```
++  shuffle-deck
  |=  [unshuffled=deck entropy=@]
  ^-  deck
  =|  shuffled=deck
  =/  random  ~(. og entropy)
  =/  remaining  (lent unshuffled)
  |-
  ?:  =(remaining 1)
    :_  shuffled
    (snag 0 unshuffled)
  =^  index  random  (rads:random remaining)
  %^  $
  shuffled      (snag index unshuffled)^shuffled
  remaining     (dec remaining)
  unshuffled    (oust [index 1] unshuffled)
```

Finally we come to `shuffle-deck`. This gate takes two arguments, a `deck` and a `@` as a bit of `entropy` to seed the `og` core. It's going to produce a `deck`. 

`=|` adds a defaulted `deck` to the subject.

Next we feed the `og` core the entropy it needs in preparation for using it and we get the length of the unshuffled deck with `lent`.

If we have only one card remaining, we produce a cell of `shuffled` and that one card left in `unshuffled` with the `:_` rune so we can have the heavier twig to the bottom of the expression.

Else we are going to do a little work.  `=^` is a rune that pins the head of a pair and changes the leg with a tail. It's useful for interacting with the `og` core arms as many of them produce a pair of a random number and the next state of the core. We're going to put the random number in the subject with the face `index` and change `random` to be the next core.

That completed, we use `%^` to call `$` to recurse back up to the `|-` with a few changes. 

`shuffled` gets the `darc` from `unshuffled` at `index` added to the front of it.

`remaining` gets decremented. Why are we using a counter here instead of just checking the length of `unshuffled` on each loop? `lent` traverses the entire list every time it's called so maintaining a counter in this fashion is much faster.

`unshuffled` becomes the result of using `oust` to remove 1 `darc` at `index` on `unshuffled`.

This is a very naive shuffling algorithm and you could imagine a better one. Implementation of a better algorithm is left as an exercise for the reader.

So now that we have this library, how do we actually use it? Let's look at a very simple `say` generator that uses it.

```
/+  playing-cards
:-  %say
|=  [[* eny=@uv *] *]
:-  %noun
(shuffle-deck:playing-cards make-deck:playing-cards eny)
```

If you save this in the `gen` directory and the library as `playing-cards.hoon` in the `lib` directory, you can import the library with the `/+` rune. This is not a hoon rune, but instead a rune used by Ford, the Urbit build system. When this file gets built, Ford will pull in the requested library and also build it. It will also create a dependency so that if `playing-cards.hoon` changes, this file will also get rebuilt.

Here you have the standard `say` generator boilerplate that allows us to get a bit of entropy from `arvo` when the generator is run. Then we feed that and a `deck` created by `make-deck` into `shuffle-deck` to get back a shuffled `deck`.