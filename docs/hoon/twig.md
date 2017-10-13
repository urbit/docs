---
navhome: /docs/
sort: 14
next: true
title: Expressions
---

# Expressions

A Hoon expression is called a `twig`.  A `twig` is an AST node:
the noun that the Hoon compiler makes when it parses a source
expression.

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
of this structure is a *subexpression* or just *leg*.

Usually a subexpression is itself a `twig`; sometimes it's a
`@tas` (symbol) or a `wing` (reference path).

## Moldy moss; woody seed

When defining each page in the `twig` book, we never use `twig`
itself as a leg.  Instead, we use the mold `moss` to describe
twigs whose product is used as a mold, and `seed` for twigs whose
product could be anything.  Both `moss` and `seed` are just
aliases for `twig`, but they serve as documentation.

For adjectives, we say *moldy* and *woody* respectively.  An
example of X is the woody form of X; a mold producing X is its
moldy form.

For instance, `[%foo %bar]` is woody: a twig producing the noun
`[7.303.014 7.496.034]`.  `{$foo $bar}` is moldy: a twig
producing a function whose product is always `[7.303.014
7.496.034]`.

This mold, of course, is a noun (a gate).  The value of that noun
is not `[7.303.014 7.496.034]`, or anything remotely like it.
The noun is a pile of code.  It is probably a big pile of code,
because most cores include a lot of formulas, contexts, etc,
generally including the whole standard library.  (Having a
pointer to the standard library does not burden a noun much,
unless of course you're trying to print that noun and you don't
have a span that describes it.)

And of course, Hoon is a functional language, so seeds sometimes
produce a mold -- because we do pass around functions as values.
Don't worry about this issue.  It will totally make sense soon.

But writing `[%foo %bar]` where you mean `{$foo $bar}`, or the
reverse, is a common beginner's mistake in Hoon.  At least it
always results in a compiler error (since the noun types are so
different).  There's really no way around learning not to make
this mistake the hard way, but designating subexpressions as
`moss` or `seed` can't hurt.

## Twig categories

Most twigs fit into clear categories by meaning and rune prefix:

<div><list/></div>
