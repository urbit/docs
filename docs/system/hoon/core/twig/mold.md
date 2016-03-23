---
sort: 8
---

# Molds (`$` runes).

A *mold* is a `gate` (function) that helps us build simple and
rigorous data structures.  (In fact, since "mold" sounds nasty,
molds are often called "structures.")

## Overview

While Hoon can't check this property statically, any true mold 
is a *rectifier*: an idempotent function across all nouns.  If
the sample of a gate has span `%noun`, and its body obeys the
constraint that for any x, `=((mold x) (mold (mold x)))`, it's a
rectifier and can be used as a mold.

Twigs in the `$` family are macros designed for making molds.
But any Hoon twig may produce a mold.  (This is why `moss` is a
synonym for `twig`).

Many macros *bunt* a mold, producing `:per(mold $)`.  This value,
simply the result of executing the gate on the default sample,
is a constant by definition and normally can be compiled as such.
The range of a mold (the span of its bunt) is called its *icon*.

Molds have two uses: defining simple and rigorous structures, and
validating untrusted input data.  Validation, though very
important, is a rare use case.  Except for direct raw input,
it's generally a faux pas to rectify nouns at runtime -- or even
in userspace.

As a structure definition, a mold has three common uses.  One,
its bunt is a default value (such as the sample in a gate.)  Two,
the product of some computation is cast to its icon, both
checking the type and regularizing it.  Three, it's used as a
building block in other molds.

## Regular forms

The rune prefix is `$`.  Suffixes: 

### `:bank`, `$:`, "buccol", `{$bank p/(list moss)}`

Syntax: *running*.

The product: a rectifier gate producing the tuple `p`.

Where `a`, `b` and `c` produce molds, `:bank(a b c)` produces a
mold whose icon is the span `[$.a $.b $.c]`.

### `:coat`, `$=`, "buctis", `{$coat p/@tas q/moss}`

Syntax: *2-fixed*.

The product: a rectifier gate producing mold `q` under label `p`.

Where `q` produces a mold, `:coat(p q)` produces a mold whose
icon matches the span of `:name(p $.q)`.

### `:pick`, `$?`, "bucwut", `{$pick p/(list moss)}`

Syntax: *running*.

The product: a rectifier gate producing the union of the molds in
`p`.

Where `a`, `b`, and `c` produce molds, `:pick(a b c)` produces a
mold whose icon matches the span of `?:(& $.a ?:(& $.b $.c))`.

The default mold is the first item in `p`.  To avoid an infinite
loop, it has to be a termination case (such as a constant).

### `:book`, `$%`, "buccen", `{$book p/(list moss)}`

Syntax: *running*.

The product: a rectifier gate producing the tagged union of the
molds in `p`, all of which must be of the form `:bank(stem
bulb)`, where `stem` is an atomic mold.

`$book` has the same icon as `$pick`, but rectifies better.

The default mold is the first item in `p`.  To avoid an infinite
loop, it has to be a termination case (such as a constant).

### `:shoe`, `$_`, "buccab", "{$shoe p/twig}"

Syntax: *1-fixed*.

Expands to: `:gate(* p)`.

A `$shoe` is not useful for rectification; it ignores its input.
It is only useful for defaults and typechecks.  Sometimes we have
no choice but to describe by example.

### `:lamb`, `$-`, `"buchep"`, `{$lamb p/moss q/moss}`

Syntax: *1-fixed*.

Expands to: `:shoe(:gate(p $.q))`.

`$lamb` is a lambda.  We shoe a trivial function from `p` to `q`.
Like any `$shoe`, a `$lamb` is not useful for rectification (eg,
you can't use it to typecheck cores sent over the network).

## Irregular forms

### Primitives 

`*` means any noun; `@` with an aura means an atom, such as `@ud`
for unsigned decimal, or just `@` for a generic noun; `?` for
boolean; `^` for a cell (of `*`).

### Constants 

For a mold producing a cold atom, replace the `%` of the constant
syntax with `$`.  `%42` is the constant number `42`; `$42` is a
function that, passed 42 or any other argument, produces `%42`.

Similarly, `%foo` is the number `7.303.014` or `0x6f.6f66`;
`$foo` is a function that produces `%foo`.

`$~` produces `~`.

### Miscellaneous

Translation:

```
{a b c}`   :bank(a b c)
a/b        :coat(a b)
?(a b c)   :pick(a b c)
_a         :shoe(a)
```
