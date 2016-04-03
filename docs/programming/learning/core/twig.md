---
sort: 8
---

# Expression: `twig`

A `twig` is an AST node: the noun that the Hoon compiler makes
when it parses a source expression.

The definition of `twig` is the definition of Hoon.  So let's
define the syntax and semantics of Hoon, a twig at a time.  But
first, basic twig anatomy.

## Twig anatomy

A twig is a tagged union (`book`) with the form `{stem bulb}`,
where the `stem` is an atomic symbol.  The bulb for each stem has
its own type, which varies by stem.  (Compare with Lisp, where
every AST node is a tag and a list of child nodes.)

There are no user-level macros.  All stems are built into Hoon.
Most stems are implemented as internal macros, however.

The bulb is usually a tuple, sometimes a list or map.  An element
of this structure is a *subexpression*.

Usually a subexpression is itself a `twig`; sometimes it's an
`@tas` (symbol) or a `wing` (reference path).  Solely for
clarity, we use the type alias `moss` for twigs meant to produce
molds.  A `moss` is just a twig, both in syntax and semantics.

## Twig categories

Fortunately, the twigs fit neatly into clear categories which
match their rune prefix.  Read forward by category:

<div><list/></div>

## Structures

The whole Crash twig system, as a 

```
|%
++
--
```

