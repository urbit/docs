---
navhome: /docs/
sort: 15
next: true
title: Basic types
---

# Basic types

A Hoon `type` is a set of nouns. There is no syntax for directly 
defining the data type of a Hoon expression. Instead, the compiler 
infers the type of a Hoon expression by calculating the range of 
possible values of that expression.

Working with a type in Hoon normally requires the use of a `mold`. 
Each type is defined by a mold. To define a custom type, you must 
create a custom mold.

## Molds

A mathematical function is a mapping from one set (the domain) to 
another (the range). Pass an object from the domain to some 
function *f*, and *f* returns an object from the range. In Hoon we 
can think of a `gate` as a function, where the gate's `sample` is 
its argument.

A `mold` is an idempotent function whose domain is the set of all 
nouns. (That is, it's an idempotent gate that takes any noun for its 
sample.) An idempotent function *f* is one such that, if *f(x)* 
terminates, *f(x) = f(f(x))*.  The product range of a mold is the 
type defined by that mold. That is, each mold's type is the set of 
possible outputs of that mold.

Essentially, molds are constructor functions. You can pass a mold 
any data you like, and the product is guaranteed be of the type 
defined by that mold. Molds are the perfect tool for validating 
untrusted foreign data. Just call the relevant mold with that data 
and check that the input equals the output. This is one reason why 
molds must be idempotent; if the untrusted data is of the correct 
type, passing it to the mold shouldn't change it. But this use case 
is unusual for beginners; in normal practice you shouldn't call 
molds directly.

More frequently, molds are used when we want to `cast`. We use a 
cast when we want the Hoon compiler's type-checker to test whether 
a Hoon expression is guaranteed to evaluate to a product of the 
desired type. If it isn't, then the compiler will halt with a 
`nest-fail` crash. Proper Hoon code will include a cast for the 
product type of each gate.

The `^` family of runes is for casting. In particular, `^-` allows 
us to cast with a mold. For example, we can cast for an `atom` using 
the `@` mold as follows:

```
^-  @
17
```

Evaluating the above in `dojo` should return 17, because 17 is of 
the type `atom`.  On the other hand,

```
^-  @
[17 18]
```

...this should result in a `nest-fail`, because `[17 18]` is a cell, 
not an atom.

See the documentation on the [`^` family](../rune/ket/) of runes
for more information on casts. See the documentation on the
[`$` family](../rune/buc/) of runes for building molds.
(Also check out the irregular `,` operator.)

## `type`: a set of types

Below is the mold for `type`, which effectively defines all the types 
available in Hoon.

Strictly speaking, this mold defines the tree data structure the Hoon 
compiler uses to represent type information. It has a label for each 
of the base types, and it's recursive, so a complex type is 
represented as a nested combination of base types and various other 
odds and ends.

You haven't seen this syntax before, and we haven't explained it yet; 
just treat it as pseudocode.

This is a slightly simplified version of `type`.  We undo and 
explain the simplifications in the [advanced types](../advanced) 
section.

```
++  term  @tas
++  type
  $@  $?  %noun
          %void
  ==  $%  [%atom p=term q=(unit atom)]
          [%cell p=type q=type]
          [%core p=type q=(map term hoon)]
          [%face p=term q=type]
          [%fork p=(set type)]
          [%hold p=type q=hoon]
      ==
```

If the `type`-tree is an atom, it's either a `%noun` or a `%void`; if 
the `type`-tree is a cell, it's a tuple with one of the heads `%atom`, 
`%cell`, `%core`, etc.  We'll go through each of these cases below.
these cases below.

### `?(%noun %void)`

`%noun` is the label for the set of all nouns. `%void` is the label 
for the empty set. 

(For now, don't worry too much about the switch from `$` to `%`.)

### `[%cell p=type q=type]`

`[%cell p=type q=type]` is for the set of all cells with head `p` and
tail `q`.

### `[%fork p=(set type)]`

`[%fork p=(set type)]` is for the union of all types in the set `p`.

### `[%hold p=type q=hoon]`

A `%hold` type, with type `p` and hoon `q`, is a lazy reference
to the type of `(mint p q)`.  In English, it means: "the type of
the product when we compile `q` against subject `p`."

Note that this means we can have parsed Hoon AST data in the 
`type`-tree.

### `[%face p=term q=type]`

A `[%face p=term q=type]` wraps the label `p` around the type
`q`.  `p` is a `term` or `@tas`, an atomic ASCII string which
obeys symbol rules: lowercase and digit only, infix hyphen,
first character must be lowercase.

See [`%limb`](../limb/limb/) for how labels are resolved.  It's
nontrivial.

### `[%atom p=term q=(unit atom))]`

`%atom` is for an atom, with two twists.  `q` is a `unit`, Hoon's
equivalent of a nullable pointer or a Haskell `Maybe`.  If `q`
is `~`, null, the type is *warm*; any atom is in the type.  
If `q` is `[~ x]`, where `x` is any atom, the type is *cold*;
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
  @ta           ASCII text (knot)
    @tas        ASCII text symbol (term)
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

### `[%core p=type q=(map term type)]`

`%core` is for a code-data cell.  The data (or *payload*) is the
tail; the code (or *battery*) is the head.  `p`, a type, is the
type of the payload.  `q`, a name-hoon table, is the source code
for the battery.

Each hoon in the battery source is compiled to a formula, with
the core itself as the subject.  The battery is a tree of these
formulas, or *arms*.  An arm is a computed attribute against its
core.

All code-data structures in normal languages (functions, objects,
modules, etc) become cores in Hoon.  A Hoon battery looks a bit
like a method table, but not every arm is a "method" in the OO
sense.  An arm is a computed attribute.  A method is an arm whose
product is a Hoon function (or *gate*).

A gate (function, lambda, etc) is a core with one arm, whose name
is the empty symbol `$`, and a payload whose shape is `[sample
context]`.  The *context* is the subject in which the gate was
defined; the *sample* is the argument.

To call this function on an argument `x`, replace the sample (at
tree address `6` in the core) with `x`, then compute the arm.
(Of course, we don't mutate the noun, we make a mutant copy.)
