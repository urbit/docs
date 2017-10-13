---
navhome: /docs/
sort: 15
next: true
title: Basic types
---

# Basic types

A `span` is a set of nouns and an interpretation of these nouns.
Officially, we don't use the word "type" in Hoon.  But if we had
to say "type," it would mean `span`.

## Type, span and mold

There is no Hoon syntax for a span.  The programmer never defines
a span explicitly.  It is always produced as the inferred range
of an expression (`twig`).

But we still need simple, well-formed expressions that produce
regular and well-shaped ranges, for three reasons.

First: in most cases, this trivial generator should be much
simpler than the computation itself.  Casting the actual result
to its ideal shape makes sure we know what we're building.

Second: we can define a standard form for such generators, and
the standard form is useful.  The standard form is a constructor
function, or *mold*.

A mold is an idempotent function (`gate`), accepting any noun.
(An idempotent function is one such that *f(f(x))* equals *f(x)*
if *f(x)* terminates.)  The product range of the function is the
span, or *icon*, of the mold.

Usually we use molds purely in the first sense: as an abstract
definition of a noun.  Don't actually call a mold unless you're
actually validating untrusted foreign data.  As a beginner,
hopefully you aren't!

## `span`: a set of nouns

Below is the mold for `span`.  You haven't seen this syntax before,
and we haven't explained it yet; just treat it as pseudocode.

This is a slightly simplified version of `span`.  We undo and explain the
simplifications in the [advanced types](../advanced) section.

```
++  term  @tas
++  span
  $@  $?  $noun
          $void
  ==  $%  {$atom p/term q/(unit atom)}
          {$cell p/span q/span}
          {$core p/span q/(map term twig)}
          {$face p/term q/span}
          {$fork p/(set span)}
          {$hold p/span q/twig}
      ==
```

If a span is an atom, it's either the atomic string `noun` or
`void`; if a cell, it's a tuple with one of the heads `atom`,
`cell`, `core`, etc.  We'll go through each of these cases below.

### `?($noun $void)`

`$noun` is the set of all nouns.  `$void` is the set of no nouns.

### `{$cell p/span q/span}`

`{$cell p/span q/span}` is the set of all cells with head `p` and
tail `q`.

### `{$fork p/(set span)}`

`{$fork p/(set span)}` is the union of all spans in the set `p`.

### `{$hold p/span q/twig}`

A `$hold` span, with span `p` and twig `q`, is a lazy reference
to the span of `(mint p q)`.  In English, it means: "the type of
the product when we compile `q` against subject `p`."

### `{$face p/term q/span}`

A `{$face p/term q/span}` wraps the label `p` around the span
`q`.  `p` is a `term` or `@tas`, an atomic ASCII string which
obeys symbol rules: lowercase and digit only, infix hyphen,
first character must be lowercase.

See [`:limb`](../twig/limb/limb) for how labels are resolved.  It's
nontrivial.

### `{%atom p/term q/(unit atom))}`

An `$atom` is an atom, with two twists.  `q` is a `unit`, Hoon's
equivalent of a nullable pointer or a Haskell `Maybe`.  If `q`
is `~`, null, the span is *warm*; any atom is in the span.  
If `q` is `[~ x]`, where `x` is any atom, the span is *cold*;
its only legal value is the constant `x`.

`p` in the atom is a terminal used as an *aura*, or soft atom
type.  Auras are a lightweight, advisory representation of the
units, semantics, and/or syntax of an atom.  An aura is an atomic
string; two auras are compatible if one is a prefix of the other.

For instance, `@t` means UTF-8 text (LSB low), `@ta` means ASCII
text, and `@tas` means an ASCII symbol.  `@u` means an unsigned
integer, `@ud` an unsigned decimal, `@ux` an unsigned
hexadecimal.  You can use a `@ud` atom as a `@u` or vice versa,
but not as a `@tas`.

Auras can also end with an optional, capitalized suffix, which
defines the atom's bitwidth as a log starting from `A`.  For
example, `@udD` is an unsigned decimal byte; `@uxG` is an
unsigned 64-bit hexadecimal.

You can make up your own auras and are encouraged to do so, but
here are some conventions bound to constant syntax:

```
@c              UTF-32 codepoint
@d              date
  @da           absolute date
  @dr           relative date (ie, timespan)
@f              yes or no (inverse boolean)
@n              nil
@p              phonemic base (plot)
@r              IEEE floating-point
  @rd           double precision  (64 bits)
  @rh           half precision (16 bits)
  @rq           quad precision (128 bits)
  @rs           single precision (32 bits)
@s              signed integer, sign bit low
  @sb           signed binary
  @sd           signed decimal
  @sv           signed base32
  @sw           signed base64
  @sx           signed hexadecimal
@t              UTF-8 text (cord)
  @ta           ASCII text (span)
    @tas        ASCII symbol (term)
@u              unsigned integer
  @ub           unsigned binary
  @ud           unsigned decimal
  @uv           unsigned base32
  @uw           unsigned base64
  @ux           unsigned hexadecimal
```

Auras are truly soft; you can turn any aura into any other,
statically, by casting through the empty aura `@`.  Hoon is not
dependently typed and can't statically enforce data constraints
(for example, it can't enforce that a `@tas` is really a symbol).

### `{$core p/span q/(map term span)}`

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

A gate (function, lambda, etc) is a core with one arm, whose name
is the empty symbol `$`, and a payload whose shape is `{sample
context}`.  The *context* is the subject in which the gate was
defined; the *sample* is the argument.

To call this function on an argument `x`, replace the sample (at
tree address `6` in the core) with `x`, then compute the arm.
(Of course, we don't mutate the noun, we make a mutant copy.)
