---
sort: 8
---

# Expression: `twig`

A `twig` is an AST node: the noun that the Hoon compiler makes
when it parses a source expression.

The definition of `twig` is the definition of Hoon.  So let's
define the syntax and semantics of Hoon, a twig at a time.  But
first, basic twig anatomy.

## Twig anatomy and jargon

A twig is a tagged union (`book`) with the form `{stem bulb}`,
where the `stem` is an atomic symbol.  The bulb for each stem has
its own type, which varies by stem.  (Compare with Lisp, where
every AST node is a tag and a list of child nodes.)

There are no user-level macros.  All stems are built into Hoon.
Most stems are implemented as internal macros, however.

The bulb is usually a tuple, sometimes a list or map.  An element
of this structure is a *subexpression*.

Usually a subexpression is itself a `twig`; sometimes it's an
`@tas` (symbol) or a `wing` (reference path).

## Moss versus wood

Solely for clarity, we use the type alias `moss` for twigs whose
product is used as a mold.  A `moss` is just a twig, both in
syntax and semantics; again, the difference is how we use it.

Twigs are described as *mossy* and *woody*; an example of X is
the woody form of X, a mpld producing X is its woody form.  For
instance, `$foo` (mossy) is a mold whose product is always `%foo`
(woody).  (Obviously, wood is *yang* and moss is *yin*, so we
can also say "yang foo" or "yin foo".)

## Twig categories

Fortunately, the twigs fit neatly into clear categories which
match their rune prefix.  Read forward by category:

<div><list/></div>

## Twig structure

The full Core Hoon `twig`.  Note that this is simplified, but
everything useful can still be done in Core.
