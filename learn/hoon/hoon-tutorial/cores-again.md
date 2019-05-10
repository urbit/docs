+++
title = "Cores Again"
weight = 28
template = "doc.html"
+++
In the last lesson you learned a bit about how to use cores as state machines.  In this lesson you'll expand on that knowledge, in particular by learning how to use the `=^` rune.  At the end of the lesson you'll learn how to write a generator that shuffles a 52 card deck and deals hands from it.

## The `num` Core Again

In the last lesson we used a simple door to illustrate the use of doors as state machines.  Let's modify the code for that core slightly:

```
|_  a/@
  ++  this  .
  ::
  ++  inc
    [+(a) this(a +(a))]
  ::
  ++  plus
    |=  b=@
    [(add a b) this(a (add a b))]
  ::
  ++  reset
    [a this(a 0)]
--
```

The `this` arm is unchanged.  The other arms -- `inc`, `plus`, and `reset` -- no longer evaluate to cores.  They evaluate to cells in which the head is some value of type `@`, and the tail is a core, i.e., a variant of `this`.  The idea behind these changes is that each arm should produce not just a new state, but a relevant atom value for the sample as well.  When `inc` is evaluated the new value for `a` is produced, along with the new version of the core.  When `reset` is evaluated, the sum total of `a` is produced, along with the new version of the core in which `a` is set to `0`.

Here's a new version of the program that uses this new core code:

```
|=  c=@
=/  num                                  ::  define the `num` core
  |_  a/@
    ++  this  .
    ::
    ++  inc
      [+(a) this(a +(a))]
    ::
    ++  plus
      |=  b=@
      [(add a b) this(a (add a b))]
    ::
    ++  reset
      [a this(a 0)]
  --
=^  v1  num  inc.num                     ::  increment `a` by 1, store in `v1`
=^  v2  num  inc.num                     ::  do it again, storing `a` in `v2`
=^  v3  num  (plus:num c)                ::  add `c` to `a`, store in `v3`
=^  v4  num  (plus:num c)                ::  do it again, storing `a` in `v4`
=^  v5  num  reset.num                   ::  reset `a` to `0`, total in `v5`
[v1 v2 v3 v4 v5]                         ::  return `v1` through `v5`
```

Save this as `numcore2.hoon` in `/gen` of your urbit's pier and run it in the dojo:

```
> +numcore2 10
[1 2 12 22 22]

> +numcore2 100
[1 2 102 202 202]

> +numcore2 500
[1 2 502 1.002 1.002]
```

Now you can see the intermediate values of the sample of `a` for each modified version of the `num` core that was created.  Of course, you can't really understand how this program works until you understand what the `=^` rune does.

### `=^` Pin a Value and Replace a Leg

The `=^` rune takes four subexpressions: `=^(a b c d)`.  The first three modify the subject, and the `d` is evaluated against that subject.  `a` is a face name, `b` is a wing, and `c` is an expression that evaluates to a cell.  The subject is modified as follows: (1) `c` is evaluated, producing a cell; (2) the head of that cell is pinned to the subject, `a` becoming the face name for it; and (3) the wing at `b` is replaced with the tail of the cell produced by `c`.

This is particularly useful when you want to return data for the form `[result new-state]`.

For example, let's consider `=^  v1  num  inc.num` from the program above.  `inc.num` produces a cell, the head of which is an atom.  This atom is pinned to the head of the subject and given the face name `v1`.  The tail of the cell produced by `inc.num` is a variant of the `num` core, and becomes the new value of `num`.  The fourth subexpression of this `=^` expression is the rest of the program, i.e.:

```
=^  v2  num  inc.num
=^  v3  num  (plus:num c)
=^  v4  num  (plus:num c)
=^  v5  num  reset.num
[v1 v2 v3 v4 v5]
```

The `=^` rune was designed for use with state machine data structures, doors in particular.  Understanding `=^` is important!  This whole lesson is intended to emphasize the use and importance of this rune.

### Casting for Cores

You'll notice that the `plus` arm of the `num` core above evaluates to a gate.

```
++  plus
  |=  b=@
  [(add a b) this(a (add a b))]
```

But this gate doesn't have a cast in it, and that's bad practice.  Any time you produce a gate you should include a cast.  The desired output type of the `plus` gate is a cell whose head is an atom and whose tail is a core of the same type as `num`.  We know how to cast for the head -- it's just an atom, `@`.  But what about the tail?  How do we cast for a core of the same type as `num`?

There is no straight-forward way of casting for a core in general, and anyway that isn't what is desired in this case.  We don't want `plus` to produce just any core; we want it to produce a core of the same type as `num`.

One way to cast appropriately is to use the `^+` rune, as in the following:

```
++  plus
  |=  b=@
  ^+  [0 this]
  [(add a b) this(a (add a b))]
```

The relevant addition is the line with `^+  [0 this]`.  The `^+` rune is used when one wants to do a cast with an example noun, i.e., when you want to cast for a value of the same type as the example.  The example `[0 this]` is a cell type whose head is an `@ud`, and whose tail is a core of the same type as `this`.  And `this` is how the `num` core refers to itself.

#### `$_` Create a Type From an Example

Another way to add a cast to the `plus` arm is to use the `$_` rune to create a core type.  This rune allows us to use the `^-` cast rune instead, as in the following:

```
++  plus
  |=  b=@
  ^-  [@ $_(this)]
  [(add a b) this(a (add a b))]
```

The `$_` rune takes one subexpression.  That subexpression is evaluated, and the type of the resulting noun is the type produced.  The default value of that type is exactly the noun used to create it.

The irregular form of `$_( )` is just `_`, so we can shorten the cast above to:

```
++  plus
  |=  b=@
  ^-  [@ _this]
  [(add a b) this(a (add a b))]
```

This kind of casting is relatively common.  It's generally used in cores used as state machines.

#### The `_+>.$` Construction

Another way to cast for the type of the parent core of an arm is to use `_+>.$`.  This construction looks a bit complicated, but it's also used somewhat frequently in the Urbit codebase.  It's worth a closer examination.  We can use it in the `plus` arm as follows:

```
++  plus
  |=  b=@
  ^-  [@ _+>.$]
  [(add a b) this(a (add a b))]
```

But what does it mean?  First, the `_` indicates the irregular form of the `$_` rune.  That is, `_+>.$` evaluates `+>.$` and produces a type from the resulting noun.

What is `+>.$`?  This is a wing of two limbs, `+>` and `$`.  As you saw in [section 1.4](../arms-and-cores), `+>` is the lark syntax for `+7`, i.e., address space `7`.  And `$` is the name of the lone arm in a gate.  Whenever an arm name is used in a wing expression and isn't the left-most limb in the series, it evaluates to its parent core.  The parent core of `$` is the gate itself.

Thus, `+>.$` evaluates to `+7` of the gate containing `$`.  For our `plus` arm, the gate in question is the one defined by:

```
|=  b=@
^-  [@ _+>.$]
[(add a b) this(a (add a b))]
```

What is `+7` of this gate?  It's the subject of the expression used to define the gate.  This gate is produced by the `plus` arm.  Every arm in the `num` core, including `plus`, is evaluated with the `num` core as the subject.  Hence, `+>.$` is just the `num` core.

It follows that `_+>.$` is the type of the `num` core.

## Random Number Generation

The `=^` rune can be used with the `og` door in the Hoon standard library to generate random numbers.  We'll illustrate this.

First, let's use the `rad` arm in the `og` core.  This arm takes an atom `n`, and produces another atom somewhere in the range of `0` to `n - 1` (inclusive):

```
> (rad:og 3)
0

> (rad:og 4)
2

> (rad:og 5)
4

> (rad:og 55)
50

> (rad:og 155)
108
```

Are these numbers randomly generated?  Not really.  The `og` core uses a 'seed number' which determines how a number is generated from the functions in `og`.  The seed number is stored in the sample of the `og` core as an atom.  In other words, `og` is a door whose 'state' is the seed number.  The default seed number is `0`.  If we use `rad` in `og` without changing the sample of the latter, the number produced by `rad` is always the same per any given argument.  E.g., `(rad:og 55)` will produce `50` every time.

To change the seed, we need to make a copy of `og` with a different sample.  How do we do that?  We do it as follows:

```
> ~(. og 123)
<4.rvc {a/@ud <51.zox 93.pqh 74.dbd 1.qct $141>}>

> ~(. og 456)
<4.rvc {a/@ud <51.zox 93.pqh 74.dbd 1.qct $141>}>

> ~(. og 456.789)
<4.rvc {a/@ud <51.zox 93.pqh 74.dbd 1.qct $141>}>
```

The seeds of these three cores are `123`, `456`, and `456.789`, respectively.  We can use these variants of `og` with `rad` to get different values from the ones we got before:

```
> (rad:~(. og 123) 3)
1

> (rad:~(. og 123) 4)
3

> (rad:~(. og 123) 5)
3

> (rad:~(. og 123) 55)
28

> (rad:~(. og 123) 155)
58
```

This can be a bit tedious, however.  And, in any case, this syntax requires that we pick a seed value manually.

Part of the solution is to use the `rads` arm of `og` with the `=^` rune.  The gate defined by the `rads` arm takes an atom `n` produces a pair of: (1) another atom somewhere in the range of `0` to `n - 1` (inclusive); and (2) another version of the `og` core with a different seed value.

```
> (rads:og 3)
[0 <4.rvc {a/@ <51.zox 93.pqh 74.dbd 1.qct $141>}>]

> (rads:og 4)
[2 <4.rvc {a/@ <51.zox 93.pqh 74.dbd 1.qct $141>}>]

> (rads:og 5)
[4 <4.rvc {a/@ <51.zox 93.pqh 74.dbd 1.qct $141>}>]

> (rads:og 55)
[50 <4.rvc {a/@ <51.zox 93.pqh 74.dbd 1.qct $141>}>]
```

Let's create a copy of the `og` core in the dojo, giving it the face `rng`.  By first putting it in the subject as a door, we're able to mutate it.  (Strictly speaking, there is no `og` door until the `++  og` arm in the Hoon standard library is evaluated.  If you try to mutate it before putting a copy of the core in the subject, you'll run into problems.)  Let's make a copy of the `og` door with its initial seed value as `123`:

```
> =rng ~(. og 123)

> rng
<4.rvc {a/@ud <51.zox 93.pqh 74.dbd 1.qct $141>}>

> +6:rng
a=123
```

Good.  Now let's use the `=^` rune with `rng`.  Paste the multi-line expression into the dojo:

```
> =^  r1  rng  (rads:rng 3)
  =^  r2  rng  (rads:rng 4)
  =^  r3  rng  (rads:rng 5)
  =^  r4  rng  (rads:rng 55)
  =^  r5  rng  (rads:rng 155)
  [r1 r2 r3 r4 r5]
[1 0 4 22 88]
```

For each random number generation, the `rng` core has a different seed number.  However, we still picked the initial seed value.  This isn't random enough; given the same initial seed and the same arguments for `rads`, the resulting numbers produced by `rads` will be the same as well.  This is what `eny` is for:

```
> eny
\/0v3en.c4udf.jg3op.njvu9.sdhp3.oq9vm.j5g93.2njmu.6bk6j.agjme.ef451.7icfo.134\/
  fv.i4dor.dv6ls.9m7ig.vb8m7.ir3mb.gt7vn.q57l6.sant1
\/                                                                           \/

> eny
\/0v1hu.1i95m.infcn.a6sc2.47fph.idjoc.2jcd4.2hj3p.ma12d.jtphu.5585b.9t0ru.48q\/
  61.3qmpl.gvn5b.evhl3.us653.kffap.vef21.kaavg.p5sl3
\/                                                                           \/
```

`eny` is an environment value for [entropy](https://en.wikipedia.org/wiki/Entropy_%28computing%29).  Its value changes every time it's evaluated.  We can use `eny` to produce a seed value for `rng` and retry the `=^` expression from above:

```
> =rng ~(. og eny)

> =^  r1  rng  (rads:rng 3)
  =^  r2  rng  (rads:rng 4)
  =^  r3  rng  (rads:rng 5)
  =^  r4  rng  (rads:rng 55)
  =^  r5  rng  (rads:rng 155)
  [r1 r2 r3 r4 r5]
[0 2 4 51 40]
```

(Your output values will differ.)

## Dealing Cards

Let's write a gate that shuffles and deals from a deck of cards.  We'll start with a simpler gate that produces an unshuffled deck.

```
|=  *
=|  sorted=(list [@tas @tas])
=/  values=(list @tas)
  :*  %two
      %three
      %four
      %five
      %six
      %seven
      %eight
      %nine
      %ten
      %jack
      %queen
      %king
      %ace
      ~  ==
=/  suits=(list @tas)
  ~[%spades %diamonds %clubs %hearts]
|-  ^-  (list [@tas @tas])
?~  suits  sorted
%=  $
  suits  t.suits
  sorted  |-  ^-  (list [@tas @tas])
          ?~  values  sorted
          [[i.values i.suits] $(values t.values)]
==
```

Save this as `deck.hoon` in the `/gen` directory of your urbit's pier and run in the dojo:

```
> +deck 1
~[
  [%two %hearts]
  [%three %hearts]
  [%four %hearts]
  [%five %hearts]
  [%six %hearts]
  [%seven %hearts]
  [%eight %hearts]
  [%nine %hearts]
  [%ten %hearts]
  [%jack %hearts]
  [%queen %hearts]
  [%king %hearts]
  [%ace %hearts]
  [%two %clubs]
  [%three %clubs]
  [%four %clubs]
  [%five %clubs]
  [%six %clubs]
  [%seven %clubs]
  [%eight %clubs]
  [%nine %clubs]
  [%ten %clubs]
  [%jack %clubs]
  [%queen %clubs]
  [%king %clubs]
  [%ace %clubs]
  [%two %diamonds]
  [%three %diamonds]
  [%four %diamonds]
  [%five %diamonds]
  [%six %diamonds]
  [%seven %diamonds]
  [%eight %diamonds]
  [%nine %diamonds]
  [%ten %diamonds]
  [%jack %diamonds]
  [%queen %diamonds]
  [%king %diamonds]
  [%ace %diamonds]
  [%two %spades]
  [%three %spades]
  [%four %spades]
  [%five %spades]
  [%six %spades]
  [%seven %spades]
  [%eight %spades]
  [%nine %spades]
  [%ten %spades]
  [%jack %spades]
  [%queen %spades]
  [%king %spades]
  [%ace %spades]
]
```

(This gate doesn't use the sample for anything, but you still have to give one when you run the generator.  That's because of the kind of generator this is, 'naked'.)

We can create our own types for use with this generator.  In the following modified version, we create the types `value` for card value, `suit` for card suit, and `card` for a pair of value and suit.  We put these definitions into a core and put that core into the subject so we can use them from elsewhere in the gate.

```
|=  *
=<
=|  sorted=(list card)
=/  values=(list value)
  :*  %two
      %three
      %four
      %five
      %six
      %seven
      %eight
      %nine
      %ten
      %jack
      %queen
      %king
      %ace
      ~  ==
=/  suits=(list suit)
  ~[%spades %diamonds %clubs %hearts]
|-  ^-  (list card)
?~  suits  sorted
%=  $
  suits  t.suits
  sorted  |-  ^-  (list card)
          ?~  values  sorted
          [[i.values i.suits] $(values t.values)]
==
::
|%
::
+$  card  [value suit]
::
+$  value  @tas
::
+$  suit  $?  %clubs
              %hearts
              %spades
              %diamonds
          ==
--
```

This version of the gate produces the same result as the last version, but uses the custom types we defined instead of the native Hoon types.

Next, let's use the `og` core to shuffle the deck of cards:

```
|=  *
=<
=/  deck=(list card)  sorted-deck       :: `deck` is sorted deck of cards
=|  shuffled=(list card)                :: `shuffled` is shuffled deck
=/  len=@  (lent deck)                  :: `len` is # of cards in `deck`
=/  rng  ~(. og 123)                    :: `rng` is copy of `og` core, seed 123
|-  ^-  (list card)
?:  =(~ deck)  shuffled                 ::  when `deck` is null, return shuffled
=^  val  rng  (rads:rng len)            :: `val` picks random card from `deck`
%=  $
  shuffled  [(snag val deck) shuffled]  :: add random card to `shuffled`
  deck  (oust [val 1] deck)             :: remove that card from `deck`
  len  (dec len)                        :: decrement # of cards in `deck`
==
::
|%
::
++  sorted-deck
  =|  sorted=(list card)
  =/  values=(list value)
    :*  %two
        %three
        %four
        %five
        %six
        %seven
        %eight
        %nine
        %ten
        %jack
        %queen
        %king
        %ace
        ~  ==
  =/  suits=(list suit)
    ~[%spades %diamonds %clubs %hearts]
  |-  ^-  (list card)
  ?~  suits  sorted
  %=  $
    suits  t.suits
    sorted  |-  ^-  (list card)
            ?~  values  sorted
            [[i.values i.suits] $(values t.values)]
  ==
::
+$  card  [value suit]
::
+$  value  @tas
::
+$  suit  $?  %clubs
              %hearts
              %spades
              %diamonds
          ==
--
```

Save this as a new copy of `deck.hoon` and run it in the dojo:

```
> +deck 1
~[
  [%two %clubs]
  [%five %diamonds]
  [%ace %spades]
  [%three %hearts]
  [%queen %clubs]
  [%four %clubs]
  [%seven %hearts]
  [%king %clubs]
  [%seven %clubs]
  [%six %diamonds]
  [%nine %diamonds]
  [%eight %clubs]
  [%eight %spades]
  [%king %hearts]
  [%four %hearts]
  [%ten %clubs]
  [%jack %clubs]
  [%nine %hearts]
  [%six %hearts]
  [%five %clubs]
  [%nine %spades]
  [%two %hearts]
  [%three %clubs]
  [%queen %hearts]
  [%five %hearts]
  [%five %spades]
  [%six %spades]
  [%ten %hearts]
  [%king %diamonds]
  [%three %spades]
  [%eight %hearts]
  [%king %spades]
  [%ten %diamonds]
  [%queen %diamonds]
  [%nine %clubs]
  [%jack %hearts]
  [%queen %spades]
  [%jack %diamonds]
  [%eight %diamonds]
  [%jack %spades]
  [%three %diamonds]
  [%four %spades]
  [%ace %hearts]
  [%ten %spades]
  [%two %spades]
  [%ace %diamonds]
  [%six %clubs]
  [%seven %spades]
  [%seven %diamonds]
  [%two %diamonds]
  [%ace %clubs]
  [%four %diamonds]
]
```

The deck is shuffled, but the way it's shuffled depends upon the seed value manually entered for `rng`.  You can use `eny` in the dojo, but this environment value isn't available in the kind of generator we're using above.  We've been using 'naked' generators in this chapter.  Let's use a different kind which does have access to `eny`: a `%say` generator.

A naked generator must evaluate to a gate, but a `%say` generator must evaluate to a pair of (1) the `@tas` noun `%say`, and (2) a gate.  But the latter can't be just any gate.  The gate in (2) must produce a pair of (1) type information, and (2) output of the type indicated in (1).

We won't explain all the details of `%say` generators here; that's for a later tutorial.  But we'll show a version of the program above that can use `eny` as entropy for the `rng` seed:

```
:-  %say                                ::  pair of `%say` and gate
|=  [[* eny=@ *] [* ~] ~]               ::  don't worry about this line for now
:-  %noun                               ::  pair of `%noun` and gate output
=<
=/  deck=(list card)  sorted-deck
=|  shuffled=(list card)
=/  len=@  (lent deck)
=/  rng  ~(. og eny)                    :: `rng` has seed of `eny`
|-  ^-  (list card)
?:  =(~ deck)  shuffled
=^  val  rng  (rads:rng len)
%=  $
  shuffled  [(snag val deck) shuffled]
  deck  (oust [val 1] deck)
  len  (dec len)
==
::
|%
::
++  sorted-deck
  =|  sorted=(list card)
  =/  values=(list value)
    :*  %two
        %three
        %four
        %five
        %six
        %seven
        %eight
        %nine
        %ten
        %jack
        %queen
        %king
        %ace
        ~  ==
  =/  suits=(list suit)
    ~[%spades %diamonds %clubs %hearts]
  |-  ^-  (list card)
  ?~  suits  sorted
  %=  $
    suits  t.suits
    sorted  |-  ^-  (list card)
            ?~  values  sorted
            [[i.values i.suits] $(values t.values)]
  ==
::
+$  card  [value suit]
::
+$  value  @tas
::
+$  suit  $?  %clubs
              %hearts
              %spades
              %diamonds
          ==
--
```

With this version of the program, you get a different sorted deck of cards each time it's run!

### Dealing Cards with a State Machine

Let's use a door as a state machine.  The state will have two parts: (1) `deck`, a deck of cards, and (2) `rng`, a copy of the `og` core with a seed value.  Instead of having functions that produce a sorted deck of cards or a shuffled deck of cards, let's have the arms of this door compute a new version of the state machine with an appropriately modified state.

We'll use this state machine in a program that deals `a` hands of `b` cards each:

```
::
::  carddeal.hoon
::
::  this program deals cards from a randomly shuffled deck.
::
::  save as `carddeal.hoon` in the `/gen` directory of your
::  urbit's pier and run in the dojo:
::
::  +carddeal [4 5]
::
::
::  this is a %say generator; unlike naked gens, these have access
::  to environment data such as entropy
::
:-  %say
::
::  a is the number of hands to be dealt
::  b is the number of cards per hand
::
|=  [[* eny=@ *] [[a=@ b=@] ~] ~]
:-  %noun
=<
::
::  `cards` is a core with a shuffled deck and `rng` as state
::
=/  cards  shuffle:sorted-deck:cards
|-  ^-  (list (list card))
?:  =(0 a)  ~
::
::  `draw` returns a pair of [hand cards]
::  `hand` is a list of cards, i.e. a dealt hand, and
::  `cards` is the core with a modified deck
::  (the cards of `hand` were removed from the deck)
::
=^  hand  cards  (draw:cards b)
[hand $(a (dec a))]
::
|%
::
::  a `card` is a pair of [value suit]
::
+$  card  [value suit]
::
::  a `value` is a `@tas`, e.g., %two, %queen
::
+$  value  @tas
::
::  the card suits are: clubs, hearts, spades,
::  and diamonds
::
+$  suit  $?  %clubs
              %hearts
              %spades
              %diamonds
          ==
::
::  `cards` is a door with `deck` and `rng` as state
::  `deck` is a deck of cards
::  `rng` is a Hoon stdlib core for random # generation
::  a door is a core with a sample, often multi-arm
::
++  cards
  |_  [deck=(list card) rng=_~(. og eny)]
  ::
  ::  `this` is, by convention, how a door refers
  ::  to itself
  ::
  ++  this  .
  ::
  ::  `draw` returns two things: (1) a list of cards (i.e. a hand),
  ::  and (2) a modified core for `cards`.  the `deck` in `cards`
  ::  has the dealt cards removed.
  ::
  ++  draw
    |=  a=@
    =|  hand=(list card)
    |-  ^-  [(list card) _this]
    ?:  =(0 a)  [hand this]
    ?~  deck  !!
    %=  $
      hand  [i.deck hand]
      deck  t.deck
      a  (dec a)
    ==
  ::
  ::  `shuffle` returns the `cards` core with a modifed `deck`.
  ::  the cards in the deck have been shuffled randomly.
  ::
  ++  shuffle
    =|  shuffled=(list card)
    =/  len=@  (lent deck)
    |-  ^-  _this
    ?:  =(~ deck)  this(deck shuffled)
    =^  val  rng  (rads:rng len)
    %=  $
      shuffled  [(snag val deck) shuffled]
      deck  (oust [val 1] deck)
      len  (dec len)
    ==
  ::
  ::  `sorted-deck` returns the `cards` core with a modifed
  ::  `deck`.  the full deck of cards is provided, unshuffled.
  ::
  ++  sorted-deck
    %_  this
      deck  =|  sorted=(list card)
            =/  values=(list value)
              :*  %two
                  %three
                  %four
                  %five
                  %six
                  %seven
                  %eight
                  %nine
                  %ten
                  %jack
                  %queen
                  %king
                  %ace
                  ~  ==
            =/  suits=(list suit)
              ~[%spades %diamonds %clubs %hearts]
            |-  ^-  (list card)
            ?~  suits  sorted
            %=  $
              suits  t.suits
              sorted  |-  ^-  (list card)
                      ?~  values  sorted
                      [[i.values i.suits] $(values t.values)]
            ==
    ==
  --
--
```

Save this as `carddeal.hoon` in `/gen` of your urbit's pier and run in the dojo:

```
> +carddeal [3 4]
~[
  ~[[%queen %spades] [%jack %hearts] [%three %diamonds] [%six %spades]]
  ~[[%king %diamonds] [%eight %hearts] [%five %clubs] [%two %diamonds]]
  ~[[%three %clubs] [%nine %spades] [%six %diamonds] [%three %hearts]]
]

> +carddeal [3 4]
~[
  ~[[%king %clubs] [%ten %clubs] [%ten %diamonds] [%seven %spades]]
  ~[[%six %hearts] [%six %clubs] [%three %spades] [%four %hearts]]
  ~[[%seven %clubs] [%jack %diamonds] [%two %spades] [%five %spades]]
]

> +carddeal [3 4]
~[
  ~[[%seven %diamonds] [%nine %clubs] [%five %diamonds] [%three %diamonds]]
  ~[[%ace %spades] [%jack %spades] [%two %spades] [%nine %hearts]]
  ~[[%king %diamonds] [%six %spades] [%queen %clubs] [%eight %clubs]]
]

```

You get a different set of hands each time you run the generator.

### [Next Lesson: Lists](../lists)
