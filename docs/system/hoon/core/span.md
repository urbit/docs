---
sort: 7
---

# Type: `span`

A `span` is a type as most languages define it: a set of values
and a semantic interpretation of these values.

## `mold`: type (as constructor)

Why isn't `span` called "type"?  Because Hoon also has a `mold`,
a completely different concept that could also be called a "type."
Hoon has no syntax for declaring spans.  Spans are always created
by `mint`, using type inference.

But we do want to define data structures with regular shapes.  A
*mold* is an idempotent function (`gate`), accepting any noun.
The span of our structure is the result set of this function.

In theory, either molds or spans could be called "types."  In
practice, they're both called "types."  The T-word has to stay
informal: it can't be banned, and it's already confusing enough.

## `span`: definition

This twig defines a mold named `span`, whose icon is the set of
all spans.  Don't worry about the syntax yet:

```
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

## `$noun` and `$void`

`$noun` is the set of all nouns.  `$void` is the set of
no nouns.

## `{$cell p/span q/span}`

`{$cell p/span q/span}` is the set of all cells with head `p` and
tail `q`.

## `{$fork p/(set span)}

`{$fork p/(set span)}` is the union of all spans in the set `p`.

## `{$hold p/span q/twig}`

A `$hold` span, with span `p` and twig `q`, is a lazy reference
to the span of `(mint p q)`.  In English it means: "the type of
the product when we compile `q` with the subject `p`.  (Hoon is 
a strict language and the Hoon compiler is written in Hoon, so
laziness has to be implemented manually.)

## `{$face p/term q/span}

A `{$face p/term q/span}` wraps the label `p` around the span
`q`.  See the twig section for how labels are resolved.

## `{%atom p/term q/(unit atom))}

An `$atom` is an atom, with two twists.  `q` is a `unit`, Hoon's
equivalent of `Maybe` in Haskell or a nullable in Rust.  If `q`
is `~`, null, the span is *warm*; any atom is in the span.  
If `q` is `[~ x]`, where `x` is any atom, the span is *cold*;
its only legal value is the constnat `x`.

`p` in the atom is a terminal used as an *aura*, or soft atom
type.  Auras are a lightweight, advisory representation of the
units, semantics, and/or syntax of an atom.  Two auras are
compatible if one is a prefix of the other.

For instance, `@t` means UTF-8 text (LSB low), `@ta` means ASCII
text, and `@tas` means an ASCII symbol.  `@u` means an unsigned
integer, `@ud` an unsigned decimal, `@ux` an unsigned
hexadecimal.  You can use a `@ud` atom as a `@u` or vice versa,
but not as a `@tas`.

Auras are truly soft; you can turn any aura into any other,
statically, by casting through the empty aura `@`.  Hoon is not
dependently typed and can't enforce data constraints.

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
