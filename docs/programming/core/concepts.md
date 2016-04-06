---
sort: 3
next: true
title: Concepts
---

# Concepts and terminology

Usually, a new language is an improvement on one you already
know.  If it isn't, it probably at least shares concepts with a
large family of relatives.  These concepts come with words, like
*type* or *function*, that map cleanly onto its semantics.

In Hoon we throw away almost all these words and invent new
ones, which mean almost the same things.  But wait, wat?

## Motivation

Hoon has no close relatives, and the normal jargon of programming
maps poorly onto its semantics.  For example, although Hoon is a
typed language, the term *type* is not formally defined in Hoon.
It's a great word, but Hoon has three quite separate concepts
which could comfortably claim it.  We say *type* all the time;
we mean `span`, or `mold`, or `mark`, or possibly all three.
Sometimes this is ok and sometimes it isn't.

Other common programming concepts used only informally in Hoon
are "function," "object," "event," "expression," "variable,"
"label," "closure", "environment," "stack," and probably a few
more.  We can get away with any of these conventional words --
and we do.  But when we do, we're making an analogy that relies
on context for precision.

## Notation

Any `word` in code font is a `limb` (label) in the Hoon kernel.
Any jargon that isn't a limb is in *italics*.

## Enumeration

Top-level Hoon concepts: `noun` (data), `nock` (interpreter),
`mint` (compiler), `span` (type), `twig` (expression).

## Execution

### `noun` (data)

A value in Hoon is called a [`noun`](noun).  A noun is either a
unsigned integer of any size (`atom`), or an ordered pair of any
two nouns (`cell`).  Nouns are like Lisp S-expressions, but
simpler (Lisp atoms effectively have dynamic type bits).

### `nock` (interpreter)

Hoon compiles itself to the [Nock](nock) VM, a "functional assembly
language" whose spec fits on a T-shirt.  You don't need to know
Nock to use Urbit, but it helps.  Nock is an interpreter function
that maps a pair `{data nock}` to a *product* noun, where `data`
is the *subject* (input) and `nock` is the *formula* (program).

## Compilation

### `mint` (compiler)

[`mint`](mint) is the Hoon compiler.  It maps a cell `{span twig}` to a
cell `{span nock}`, where a `span` is a type, a `twig` is a compiled
expression (AST), and a `nock` is a Nock formula.  `mint` accepts
a subject type and a source expression; it produces a product type
and an executable formula.

### `span` (type, as range)

A [`span`](span) is a Hoon type.  It defines a set (finite or
infinite) of nouns and ascribes some semantics to it.  There is
no syntax for spans; they are always defined by inference (ie, by
`mint`), usually using a constructor (`mold`).
### `twig` (expression)

A [`twig`](twig) is a Hoon AST node, the result of parsing a
source expression.  In general, a twig is a tagged union of the
form `{stem bulb}`, where `stem` is a symbolic atom which
controls the type of `bulb`.  The regular form is a Hoon keyword
`:stem` and a *rune*, or digraph keyword, made of two ASCII
punctuation marks.  The rune prefix character defines a twig
category, like `:` 
