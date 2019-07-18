+++
title = "2.3.1 Walkthrough: Libraries"
weight = 28
template = "doc.html"
+++

In Hoon, like in other languages, it's often useful to create a library for other code to access. In this example, we look at one example of a library that can be used to represent a deck of 52 playing cards. The core below builds such a library, and can be accessed by programs.

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
  %=  $
    shuffled      (snag index unshuffled)^shuffled
    remaining     (dec remaining)
    unshuffled    (oust [index 1] unshuffled)
  ==
++  draw
  |=  [n=@ud d=deck]
  ^-  [hand=deck rest=deck]
  :-  (scag n d)
  (slag n d)
--
```

On the very first line, we create a core with `|%`. This core contains all of our library code, and is closed by the `--` on the final line.

To create three types we're going to need, we use `+$`, which is an arm used to define a type.


```
+$  suit  ?(%hearts %spades %clubs %diamonds)
+$  darc  [sut=suit val=@ud]
+$  deck  (list darc)
```

The first is `suit`, which can be either `%hearts`, `%spades`, `%clubs`, or `%diamonds`.

Next is a `darc`, which which is a pair of `suit` and a `@ud`. By pairing a suit and a number, it forms a particular card, such as "nine of hearts." Why do we call it `darc` and not `card`?  Because `card` already has a meaning in gall, the Arvo app module, where one would likely to use this (or any) library. It's worthwhile to avoid any confusion over names.

Our final type is `deck`, which is simply a `list` of `darc`.

One way to get a feel for how a library works is to skim the `++` arm-names before diving into any specific arm. In this library, the arms are `make-deck`, `num-to-suit`, `shuffle-deck`, and `draw`. These names should be very clear, with the exception of `num-to-suit` though you could probably hazard a guess at what it does. Let's take a closer look at that one first.

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

The `?+` rune is the rune to switch against a value with a default.  The default here is to crash with `!!`. Then we have the four options of 1 through 4, based on the value of `val`, which each resulting in a different suit.

```
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
```

`num-to-suit` is used in the `make-deck` arm shown above. This arm should be quite readable to you at this point. Here we simply have two loops where we use counters to build up the full set of 52 cards, by cycling through every possible suit and number and combining them. Once we have reached the point where `j` is greater than 13, we're going to jump back out to the "suit" outer-loop and increment `i`. `?.` may be an unfamiliar rune; it is simply the inverted version of `?:`, so the first branch is actually the "no" branch and the second is the "yes" branch. This is done to keep the "heaviest" branch at the bottom.


```
++  draw
  |=  [n=@ud d=deck]
  ^-  [hand=deck rest=deck]
  :-  (scag n d)
  (slag n d)
```

`draw` takes two arguments: `n`, a number; and `d`, a `deck`. It's going to produce a cell of two `decks`. The cell is created using `scag` and `slag`. [`scag`](https://urbit.org/docs/reference/library/2b/#scag) is a standard-library gate produces the first `n` elements from a list, and [`slag`](https://urbit.org/docs/reference/library/2b/#slag) is a standard-library gate that produces the remaining elements of a list starting after the `n`th element. So we use `scag` to produce the drawn hand of `n` cards in the head of the cell as `hand`, and `slag` to produce the remaining deck in the tail of the cell as `rest`.

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
  %=  $
    shuffled      (snag index unshuffled)^shuffled
    remaining     (dec remaining)
    unshuffled    (oust [index 1] unshuffled)
  ==
```

Finally, in the code above, we come to `shuffle-deck`. This gate takes two arguments: a `deck`, and a `@` as a bit of `entropy` to seed the `og` core. It's going to produce a `deck`.

`=|` adds a default-valued `deck` to the subject.

Next, with `=/  random  ~(. og entropy)`, we feed the `og` core the entropy it needs in preparation for using it. Then, with `=/  remaining  (lent unshuffled)`, we get the length of the unshuffled deck with `lent`.

`?:  =(remaining 1)` checks if have only one card remaining. If that's true, we produce a cell of `shuffled` and the one card left in `unshuffled`. We use the `:_` rune here, so that the "heavier" hoon is at the bottom of the expression.

If the above conditional evaluates to false, we are going to do a little work.  `=^` is a rune that pins the head of a pair and changes the leg with a tail. It's useful for interacting with the `og` core arms, as many of them produce a pair of a random numbers and the next state of the core. We're going to put the random number in the subject with the face `index` and change `random` to be the next core.

With completed, we use `%^` to call `$` to recurse back up to `|-` with a few changes.

`shuffled` gets the `darc` from `unshuffled` at `index` added to the front of it.

`remaining` gets decremented. Why are we using a counter here instead of just checking the length of `unshuffled` on each loop? `lent` traverses the entire list every time it's called so maintaining a counter in this fashion is much faster.

`unshuffled` becomes the result of using `oust` to remove 1 `darc` at `index` on `unshuffled`.

This is a very naive shuffling algorithm, and you could imagine a better one. Implementation of a better algorithm is left as an exercise for the reader.

## Using the Library


So now that we have this library, how do we actually use it? Let's look at a very simple `say` generator that takes advantage of what we built.

```
/+  playing-cards
:-  %say
|=  [[* eny=@uv *] *]
:-  %noun
(shuffle-deck:playing-cards make-deck:playing-cards eny)
```

If you save our the library as `playing-cards.hoon` in the `lib` directory, you can import the library with the `/+` rune. Our above `say` -- let's call it `cards.hoon` -- imports our library in this way. It should be noted that `/+` is not a Hoon rune, but instead a rune used by Ford, the Urbit build-system. When `cards.hoon` gets built, Ford will pull in the requested library and also build that. It will also create a dependency so that if `playing-cards.hoon` changes, this file will also get rebuilt.

Below `/+  playing-cards`, you have the standard `say` generator boilerplate that allows us to get a bit of entropy from `arvo` when the generator is run. Then we feed the entropy and a `deck` created by `make-deck` into `shuffle-deck` to get back a shuffled `deck`.

### [Next Up: Reading -- Trees, Sets, and Maps](../trees-sets-and-maps)
