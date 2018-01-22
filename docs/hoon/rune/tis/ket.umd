---
navhome: /docs/
sort: 12
title: =^ "tisket"
---

# `=^ "tisket"`

`[%tskt p=taco q=wing r=hoon s=hoon]`: pin the head of a pair; change 
a leg with the tail.

## Expands to

```
=/(p -.r =.(q +.r s))
```

## Syntax

Regular: *4-fixed*.

## Discussion

We use `=^` ("tisket" when we have a state machine with a function that
produces a cell, whose head is a result and whose tail is a new
state.  We want to use the head as a new variable, and stuff the
tail back into wherever we stored the old state.

This may also remind you of Haskell's State monad.

## Examples

The `og` core is a stateful pseudo-random number generator.
We have to change the core state every time we generate a
random number, so we use `=^`:

```
~zod:dojo> =+  rng=~(. og 420)
           =^  r1  rng  (rads:rng 100)
           =^  r2  rng  (rads:rng 100)
           [r1 r2]
[99 46]
```
