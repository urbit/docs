---
navhome: /docs/
sort: 13
next: true
title: Concepts
---

# Concepts and terminology

Usually, a new language is an improvement on one you already
know.  If it isn't, it probably at least shares concepts with a
large family of relatives.  These concepts come with words, like
*type* or *function*, that map cleanly onto its semantics.

In Hoon we throw away almost all these words and invent new
ones, which mean almost the same things.  But why?

## Motivation

Hoon has no close relatives.  The normal jargon of programming
maps poorly onto its semantics.  For example, although Hoon is a
typed language, the term "type" is not formally defined in Hoon.
"Type" is a great word, but Hoon has three separate concepts
which could comfortably claim it.  We say "type" all the time; we
mean [`span`](#span), or `mold`, or `mark`, or possibly all three.

Other common programming concepts used only informally in Hoon
are "function," "object," "event," "expression," "variable,"
"label," "closure", "environment," "scope," and probably a few
more.  We do use these words informally, but we're always making
an analogy whose precision depends on context.

Hoon has concepts *like* all these abstractions, but they remain
*false cognates*.  The closer an inexact cognate, the more
unsettling it feels when the abstractions don't match.  Learning
a few new words is a small price for avoiding this pain point.

## Concepts

A few major Hoon concepts: `noun` (data), `nock` (interpreter),
[`mint`](#mint) (compiler), [`span`](#span) (type), [`twig`](#twig) (expression),
`gate` (function), `mold` (constructor), `core` (object), `mark`
(protocol).

### `noun` (data value)

A value in Hoon is called a `noun`.  A noun is either a
unsigned integer of any size (`atom`), or an ordered pair of any
two nouns (`cell`).  Nouns are like Lisp S-expressions, but
simpler (Lisp atoms effectively have dynamic type bits).

The simplest noun syntax uses brackets, like `[a b]` for the cell
of `a` and `b`.  Brackets nest right; `[a b c d]` is `[a [b [c
d]]]`.  You'll also see braces: `{a b c d}`.

A noun list, by convention, points right and is zero-terminated.
Hoon uses tuples (improper nouns) more freely than Lisp; only
genuinely iterative structures are null-terminated lists.

When an atom is used as a string (a `cord`), the bytes are always
UTF-8 in LSB first order.  When you see `foo`, `$foo`, `%foo`,
etc, this refers to the integer `0x6f.6f66`, aka `7.303.014`.
(Hoon syntax breaks integer atoms in the German style.)

One common operation on nouns is `slot`, a tree addressing
scheme which maps an atom to a subtree.  The whole noun is slot
`1`; the left child of `n` is `2n`, the right child `2n+1`.

Nothing in Nock, Hoon or Urbit can create cycles in a noun or
detect pointer equivalence.  Nouns are generally implemented
with reference counting, and have a lazy short Merkle hash to
help with equality testing and associative containers.

### `nock` (interpreter)

Hoon compiles itself to the [Nock](../../nock) VM.  Nock is a
Turing-complete, non-lambda combinator function.  The function
takes a cell `{subject formula}`, and produces a noun `product`.

To program in Hoon, this is all you need to know about Nock.  But
it's still fun and useful to [learn more](../../nock).

## Compilation concepts

### <a name="mint">`mint`</a> (compiler)

[`mint`](#mint) is the Hoon compiler.  It maps a cell `{span twig}` to a
cell `{span nock}`, where a [`span`](#span) is a type, a [`twig`](#twig)
is a compiled expression (AST), and a `nock` is a Nock formula.  `mint` accepts
a subject type and a source expression; it produces a product type
and an executable formula.

Calculating the output type from the input type and the source
code is called "type inference." If you've used another typed
functional language, like Haskell, Hoon's type inference does the
same job but with less intelligence.

Haskell infers backward and forward; Hoon only infers forward.
Hoon can't figure out the type of a noun from how you use it,
only from how you make it.  Hoon can infer tail recursion, but
not head recursion.

Low-powered type inference means you need more type annotations,
which makes your program more readable anyway.  Also, the dumber
the compiler, the easier it is for a dumb human to understand
what the compiler is thinking.

### <a name="twig">`twig`</a> (expression)

A [`twig`](../reference) is a Hoon AST node, the result of parsing a
source expression.  A Hoon source file encodes one twig.

As the noun that the parser produces, a twig is a tagged union of
the form `{stem bulb}`, where `stem` (the tag) is a `cord` which
controls the type of `bulb` (the data).

As text, each twig has both regular and irregular syntax forms.
Regular syntax can be either *tall* or *flat*: multiline or
single-line.  Irregular syntax is always flat.   Tall twigs can
contain flat twigs, but not vice versa.

Regular forms always start with a *sigil*, which is either a
*keyword* or a *rune* at the programmer's choice.  A keyword is
the stem cord.

For most stems, tall regular form has no delimiter or terminator,
eliminating the `)))))` problem common in functional languages.
Hoon also uses an unusual "backstep" indentation pattern to
control left-margin drift.

Hoon is mildly whitespace-sensitive.  It knows the difference
between no whitespace, one-space, and more-space.  But all cases
of more-space mean the same thing.  Flat syntax uses one-space,
tall syntax more-space.

As an example, the regular flat keyword syntax `:call(a b)` means
the same thing as the flat rune syntax `%-(a b)`, the tall
keyword syntax

```
:call  a
b
```
or the tall rune syntax (here on one line, with double spaces):
```
%-  a  b
```

### <a name="span">`span`</a> (type, as range)

A `span` is a Hoon type.  It defines a set (finite or
infinite) of nouns and ascribes some semantics to it.  There is
no syntax for spans; they are always defined by inference (ie, by
[`mint`](#mint)), usually using a constructor (`mold`).

### `gate` (function)

A `gate` is a Hoon function (lambda or closure).  Other
constructs in Urbit are functions in the mathematical sense -- for
instance, a Nock formula is also a function.  But a gate is not a
formula.  The gate's argument is its *sample*; the result is its
*product*.

### `core` (object)

A `core` has no exact equivalent in conventional languages, but
the closest equivalent is an object.  An object has methods; a
core has functionally computed attributes (*arms*).  An arm that
produces a gate is the Hoon equivalent of a conventional method;
think of it as a computed attribute whose value is a lambda.

A gate is a special case of a core: a core with one arm, whose
name is the empty string.  The shape of a core is `[battery
payload]`, where *battery* is a tree of Nock formulas

### `mold` (type, as constructor)

A `mold` is a constructor function (`gate`).  Its sample is any
noun; its product is a structured noun.  A mold is idempotent;
`(mold (mold x))` always equals `(mold x)`.

Since there's no such thing as a [`span`](#span) declaration, we use molds
to define useful spans by example; we also use them to validate
untrusted network input.

### `face` (named variable)

In a conventional language, we have a scope, environment or
symbol table.  Declaring a variable, like `var foo: atom`, adds
the name `foo` to the table with type `atom`.

The Hoon equivalent is `:var  foo  atom`.   But Hoon has a
homoiconic heap; there is no inscrutable scope or environment.
There is just the subject, which is one noun.  To "declare a
variable" is to make a cell `[variable old-subject]`, and use it
as the subject of the [`twig`](#twig) below.

So the labe[`twig`](#twig)l `foo` isn't a key in a symbol table; it's in the
type ([`span`](#span)) of the new value.  It's not a variable named `foo`,
whose value is of type `atom`; it's a subtree of type `foo:atom`.

### <a name="limb">`limb`</a> (attribute or variable reference)

A [`limb`](../twig/limb/limb), like `foo`, is Hoon's equivalent of a variable
reference.  A limb is a [`twig`](#twig); given a subject [`span`](#span),
[`mint`](#mint) resolves it to a Nock formula and a product [`span`](#span).

To resolve limb `foo`, [`mint`](#mint) searches the subject depth-first,
head-first for either a `face` named `foo`, or a `core` with the
arm `foo`.  If it finds a face, the product is a *leg*, or
subtree of the subject.  If it finds a core, it computes the arm
formula with that core as the subject.

A limb can also be a slot (direct tree address), like `+15`.

### `wing` ([`limb`](#limb) path)

A [wing](../twig/limb/wing) is a list of limbs.  Like attribute references in a
conventional language, it uses the syntax `a.b.c`, but inside
out: Hoon `a.b.c` means "a within b within c", the equivalent of
`c.b.a` in any other language.  All limbs but the last, here `a`,
must be legs.

### `mark` (type, as protocol name)

A `mark` (really an Arvo concept, not a Hoon concept) is Urbit's
version of a MIME type, if a MIME type was an executable
specification.  The mark is just a label that's used as a path to
a local source file in the Arvo filesystem.  This source file
defines a core that can mold untrusted data, diff and patch,
convert to other marks, etc.

If this sounds like magic, it isn't quite magic.  There's no way
for different urbits to make sure they mean the same thing by the
same mark.  However, when incompatibility happens, marks ensure
that we at least handle the situation in a predictable way.
