+++
title = "Structures"
weight = 12
template = "doc.html"
+++
The `$` family of runes is used for defining custom types.  Strictly speaking,
these runes are used to produce 'structures'.  A structure is a compile-time
value that at runtime can be converted to either an example value (sometimes
called a 'bunt' value) for its corresponding type, or to a 'factory' (sometimes
called a 'mold').  An example value is used as a placeholder for sample values,
among other things.  A factory/mold is used as a data validator.

## Overview

A correct mold is a **normalizer**: an idempotent function across
all nouns.  If the sample of a gate has type `%noun`, and its
body obeys the constraint that for any x, `=((mold x) (mold (mold
x)))`, it's a normalizer and can be used as a mold.

(Hoon is not dependently typed and so can't check idempotence
statically, so we can't actually tell if a mold matches this
definition perfectly.  This is not actually a problem.)

Validation, though very
important, is a rare use case.  Except for direct raw input,
it's generally a faux pas to rectify nouns at runtime -- or even
in userspace.

In any case, since molds are just functions, we can use
functional programming to assemble interesting molds.  For
instance, `(map foo bar)` is a table from mold `foo` to mold
`bar`.  `map` is not a mold; it's a function that makes a mold.
Molds and mold builders are generally described together.

## Base Structures

`[%base p=$@(?(%noun %cell %bean %null) [%atom p=aura])]`: trivial structures (types).

##### Produces

A structure is a noun produced, usually at compile-time, for use in tracking types.  In most cases, structures don't exist in the runtime semantics.

A structure for the base in `p`. `%noun` is any noun; `%atom` is any
atom; `%cell` is a cell of nouns; `%flag` is a loobean, ``?(`@f`0
`@f`1)``. `%null` is zero with aura `@n`.

##### Syntax

Irregular: `*` makes `%noun`, `^` makes `%cell`, `?` makes
`%bean`, `~` makes `%null`, `@aura` makes atom `aura`.

## Runes

### $_ "buccab"

`[%bscb p=hoon]`: structure that normalizes to an example.

##### Expands to

```
|=(* p)
```

##### Syntax

Regular: **1-fixed**.

Irregular: `_foo` is `$_(foo)`.

##### Discussion

`$_` discards the sample it's supposedly normalizing
and produces its **example** instead.

##### Examples

```
~zod:dojo> =foo $_([%foobaz %moobaz])

~zod:dojo> (foo %foo %baz)
[%foobaz %moobaz]

~zod:dojo> `foo`[%foobaz %moobaz]
[%foobaz %moobaz]

~zod:dojo $:foo
[%foobaz %moobaz]
```

### $% "buccen"

`[%bscn p=(list spec)]`: structure which recognizes a union tagged by head atom.

##### Defaults to

The default of the last item `i` in `p`. Crashes if `p` is empty.

##### Syntax

Regular form: **2-running**.

##### Discussion

A `$%` is a tagged union, a common data model.

Make sure the first item in your `$%` terminates, or the default will
be an infinite loop!

##### Examples

```
~zod:dojo> =foo $%([%foo p=@ud q=@ud] [%baz p=@ud])

~zod:dojo> (foo [%baz 37])
[%baz p=37]

~zod:dojo> $:foo
[%foo p=0 q=0]~
```

### "buccol"

`[%bscl p=(list spec)]`: form a cell type.

##### Normalizes

The tuple the length of `p`, normalizing each item.

##### Defaults to

The tuple the length of `p`.

##### Syntax

Regular: **running**.

Irregular (noun mode): `,[a b c]` is `$:(a b c)`.
Irregular (structure mode): `[a b c]` is `$:(a b c)`.

##### Examples

```
~zod:dojo> =foo $:(p=@ud q=@tas)

~zod:dojo> (foo 33 %foo)
[p=33 q=%foo]

~zod:dojo> `foo`[33 %foo]
[p=33 q=%foo]

~zod:dojo> $:foo
[p=0 q=%$]
```

### $- "buchep"

`[%bshp p=spec q=spec]`: structure that normalizes to an example gate.

##### Expands to

```
$_  ^|
|=(p $:q)
```

##### Syntax

Regular: **2-fixed**.

##### Discussion

Since a `$-` reduces to a [`$_`](#buccab), it is not useful for normalizing, just for typechecking.  In particular, the existence of `$-`s does **not** let us send gates or other cores over the network!

##### Examples

```
~zod:dojo> =foo $-(%foo %baz)

~zod:dojo> ($:foo %foo)
%baz
```

### $^ "bucket"

`[%bskt p=spec q=spec]`: structure which normalizes a union tagged by head depth (cell).

##### Normalizes to

Default, if the sample is an atom; `p`, if the head of the sample
is an atom; `q` otherwise.

##### Defaults to

The default of `p`.

##### Syntax

Regular: **2-fixed**.

##### Examples

```
~zod:dojo> =a $%([%foo p=@ud q=@ud] [%baz p=@ud])

~zod:dojo> =b $^([a a] a)

~zod:dojo> (b [[%baz 33] [%foo 19 22]])
[[%baz p=33] [%foo p=19 q=22]]

~zod:dojo> (b [%foo 19 22])
[%foo p=19 q=22]

~zod:dojo> $:b
[%baz p=0]
```

### $~ "bucsig"

`[%bssg p=hoon q=spec]`: define a custom type default value

## Product

Creates a structure (custom type) just like `q`, except its default value is `p`.

##### Defaults to

The product of `p`.

##### Syntax

Regular: **2-fixed**.

```
$~  p=hoon  q=spec
```

`p` defines the default value, and `q` defines everything else about the structure.

##### Discussion

You should make sure that the product type of `p` nests under `q`.  You can check the default value of some structure (custom type) `r` with `*r`.  (See the [`^*` rune](./docs/reference/hoon-expressions/rune/ket.md#kettar).)

Do not confuse the `$~` rune with the constant type for null, `$~`.  (The latter uses older Hoon syntax that is still accepted.  Preferably it would be `%~`.)

##### Examples

First, let's define a type without using `$~`:

```
> =b $@(@tas $%([%two *] [%three *]))

> `b`%hello
%hello

> `b`[%two %hello]
[%two 478.560.413.032]

> *b
%$

> *@tas
%$
```

Using `$~`:

```
> =c $~(%default-value $@(@tas $%([%two *] [%three *])))

> `c`%hello
%hello

> `c`[%two %hello]
[%two 478.560.413.032]

> *c
%default-value
```

### $@ "bucvat"

`[%bsvt p=spec q=spec]`: structure which normalizes a union tagged by head depth (atom).

###### Normalizes to

Default, if the sample is an atom; `p`, if the head of the sample
is an atom; `q` otherwise.

##### Defaults to

The default of `p`.

#### Syntax

Regular: **2-fixed**.

Product: a structure which applies `p` if its sample is an atom,
`q` if its sample is a cell.

Regular form: **2-fixed**.

Example:

```
~zod:dojo> =a $@(%foo $:(p=%baz q=@ud))

~zod:dojo> (a %foo)
%foo

~zod:dojo> `a`[%baz 99]
[p=%baz q=99]

~zod:dojo> $:a
[%foo p=0 q=0]
```


### $= "buctis"

`[%bsts p=skin q=spec]`: structure which wraps a face around another structure.

##### Expands to

```
|=  *
^=(p %-(q +6))
```

##### Syntax

Regular: **2-fixed**.

Irregular (structure mode): `foo=baz` is `$=(foo baz)`.

##### Discussion

Note that the Hoon compiler is at least slightly clever about
compiling structures, and almost never has to actually put in a gate
layer (as seen in the expansion above) to apply a `$=`.

##### Examples

```
~zod:dojo> =a $=(p %foo)

~zod:dojo> (a %foo)
p=%foo

~zod:dojo> (a %baz)
p=%foo
```

### $? "bucwut"

`[%bswt p=(list spec)]`: form a type from a union of other types.

###### Normalizes to

The first item in `p` which normalizes the sample to itself.

Void, if `p` is empty.

##### Defaults to

The first item in `p`.

##### Syntax

Regular: **running**.

Irregular: `?(%foo %baz)` is `$?(%foo %baz)`.

##### Discussion

For a union of atoms, a `$?` is fine.  For more complex nouns,
always try to use a [`$%`](#buccen), [`$@`](#bucpat) or
[`$^`](#buchep), at least if you expect your structure to be used as a
normalizer.

##### Examples

```
~zod:dojo> =a ?(%foo %baz %baz)

~zod:dojo> (a %baz)
%baz

~zod:dojo> (a [37 45])
%baz

~zod:dojo> $:a
%baz
```
