---
sort: 10
---

# `:sip, =^, "tisket", {$sip p/taco q/wing r/seed s/seed}`

Pin the head of a pair; mutate a leg with the tail.

## Expands to

```
:var(p -.r :set(q +.r s))
```

## Syntax

Regular: *4-fixed*.

## Discussion

We use `:sip` when we have a state machine with a function that
produces a cell, whose head is a result and whose tail is a new
state.  We want to use the head as a new variable, and stuff the
tail back into wherever we stored the old state.

This may also remind you of Haskell's State monad.

## Examples

The `og` core is a stateful pseudo-random number generator.
We have to change the core state every time we generate a
random number, so we need to `:sip`:

```
~zod:dojo> =+  rng=~(. og 420)
           =^  r1  rng  (rads:rng 100)
           =^  r2  rng  (rads:rng 100)
           [r1 r2]
[99 46]
```
