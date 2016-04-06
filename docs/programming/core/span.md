---
sort: 7
next: true
---

# Type: `span`

A `span` is a set of nouns and an interpretation of these nouns.

## Span, mold, type: what's in a type system?

There is no Hoon syntax for a span.  The programmer never defines
a span explicitly.  It is always produced as the inferred range
of an expression (twig).

But we still need simple, well-formed expressions that produce
regular and well-shaped ranges, for three reasons.

First: in most cases, this trivial generator should be much
simpler than the computation itself.  Casting the actual result
to its ideal shape makes sure we know what we're building.

Second: we can define a standard form for such generators, and
the standard form is useful.  The standard form is a constructor
function, or *mold*.

A mold is an idempotent function (`gate`), accepting any noun.
(An idempotent function is one such that f(f(x)) equals f(x) if
f(x) does not crash.)  The product range of the function is the
span, or *icon*, of the mold.

Usually we use molds purely in the first sense: as an abstract
definition of a noun.  Don't actually call a mold unless you're
actually validating untrusted foreign data.  As a beginner,
hopefully you aren't!

(It's also important to remember that any twig can be a mold.
Some stems are macros designed for making molds, but a mold is
defined by how it's used, not what it's made of.  The Hoon type
system cannot even check the mold definition, since Hoon lacks
dependent type and therefore can't verify idempotence.)

To summarize: a Hoon "type declaration" is the definition of a
function, the mold.  A mold and a span are different things.  A
mold is a constructor.  A span defines a set of nouns, possibly
infinite, and annotates them with semantics.

Either mold or span could be called a "type," but not both.  We
often say "type" in Hoon.  But we always mean it informally.
Ideally, the meaning is obvious from context.  ("Type" can also
mean a `mark`, Urbit's equivalent of a MIME type.)

## The `span` mold

Usually in Hoon we define the semantics of a primitive by the
state the span of all nouns that implement that primitive.  We
state this span as the icon of a mold.  That mold is produced by
a kernel arm `span`:

```
++  term  @tas
++  span
  $@  $?  $noun
          $void
  ==  $%  {$atom p/term q/(unit atom)}
          {$cell p/span q/span}
          {$core p/span q/(map term span)}
          {$face p/term q/span}
          {$fork p/(set span)}
          {$hold p/span q/twig}
      ==
```

This is a syntactically correct Hoon twig, but treat it as
pseudocode.  If a span is an atom, it's either the atomic string
`noun` or `void`; if a cell, it's a tuple with one of the heads
`atom`, `cell`, `core`, etc.  We'll go through each of these
cases below.

## `$noun` and `$void`

`$noun` is the set of all nouns.  `$void` is the set of no nouns.

## `{$cell p/span q/span}`

`{$cell p/span q/span}` is the set of all cells with head `p` and
tail `q`.

## `{$fork p/(set span)}

`{$fork p/(set span)}` is the union of all spans in the set `p`.

## `{$hold p/span q/twig}`

A `$hold` span, with span `p` and twig `q`, is a lazy reference
to the span of `(mint p q)`.  In English it means: "the type of
the product when we compile `q` against subject `p`.

## `{$face p/term q/span}

A `{$face p/term q/span}` wraps the label `p` around the span
`q`.  `p` is a `term` or `@tas`, an atomic ASCII string which
obeys symbol rules: lowercase and digit only, infix hyphen,
first character must be lowercase.

See the [twig chapter](twig) for how labels are resolved.  It's
nontrivial.

## `{%atom p/term q/(unit atom))}

An `$atom` is an atom, with two twists.  `q` is a `unit`, Hoon's
equivalent of a nullable pointer or a Haskell `Maybe`.  If `q`
is `~`, null, the span is *warm*; any atom is in the span.  
If `q` is `[~ x]`, where `x` is any atom, the span is *cold*;
its only legal value is the constant `x`.

`p` in the atom is a terminal used as an *aura*, or soft atom
type.  Auras are a lightweight, advisory representation of the
units, semantics, and/or syntax of an atom.  An aura is an atomic
string; Two auras are compatible if one is a prefix of the other.

For instance, `@t` means UTF-8 text (LSB low), `@ta` means ASCII
text, and `@tas` means an ASCII symbol.  `@u` means an unsigned
integer, `@ud` an unsigned decimal, `@ux` an unsigned
hexadecimal.  You can use a `@ud` atom as a `@u` or vice versa,
but not as a `@tas`.

Auras are truly soft; you can turn any aura into any other,
statically, by casting through the empty aura `@`.  Hoon is not
dependently typed and can't statically enforce data constraints
(for example, it can't enforce that a `@tas` is really a symbol).

## `{$core p/span q/(map term span)}

A `$core` is a code-data cell.  The data (or *payload*) is the
tail; the code (or *battery*) is the head.  `p`, a span, is the
span of the payload.  `q`, a name-twig table, is the source code
for the battery.

Each twig in the battery source is compiled to a formula, with
the core itself as the subject.  The battery is a tree of these
formulas, or *arms*.  An arm is a computed attribute against its
core.

All code-data structures in normal languages (functions, objects,
modules, etc) become cores in Hoon.  A Hoon battery looks a bit
like a method table, but not every arm is a "method" in the OO
sense.  An arm is a computed attribute.  A method is an arm whose
product is a Hoon function (or *gate*).

A gate is a core with one arm, whose name is the empty symbol
`$`, and a payload whose shape is `{sample context}`.  The
*context* is the subject in which the gate was defined; the
*sample* is the argument.

To call this function on an argument `x`, replace the sample (at
tree address `6` in the core) with `x`, then compute the arm.
(Of course, we don't mutate the noun, we make a mutant copy.)
