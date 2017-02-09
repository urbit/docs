---
navhome: /docs/
sort: 1
---

# `:make  %=  "centis"`

`{$make p/wing q/(list (pair wing seed))}`: take a wing with changes.

## Produces

`p`, modified by the change list `q`.

If `p` resolves to a leg, `q` is a list of changes to that leg.
If `p` resolves to an arm, `q` is a list of changes to the core
containing that arm.  We compute the arm on the modified core.

## Syntax

Regular: *1-fixed*, then *jogging*.

Irregular: `foo(x 1, y 2, z 3)` is `:make(foo x 1, y 2, z 3)`.

## Discussion

Note that `p` is a wing, not a twig.  Knowing that a function
call `(foo bar)` involves making `foo`, replacing its sample 
at slot `+6` with `bar`, and taking the `$` limb, you might think
`(foo bar)` would mean `:make(foo +6 bar)`.

But it's actually `:pin(foo :per(:make(+2 +6 bar) $))`. Even if `foo` is
a wing, we would just be mutating `+6` within the core that defines the
`foo` arm.  Instead we want to modify the *product* of `foo` -- the gate
-- so we have to pin it into the subject.

Here's that again using runes:
```
=+  foo
=>  %=  +2
      +6  bar
    ==
  $
```

## Examples

```
~zod:dojo> =foo [p=5 q=6]
~zod:dojo> foo(p 42)
[p=42 q=6]
~zod:dojo> foo(+3 99)
[p=5 99]
```
