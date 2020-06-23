+++
title = "Structures $ ('buc')"
weight = 12
template = "doc.html"
aliases = ["docs/reference/hoon-expressions/rune/buc/"]
+++
The `$` family of runes is used for defining custom types.  Strictly speaking,
these runes are used to produce 'structures'.  A structure is a compile-time
value that at runtime can be converted to either an example value (sometimes
called a 'bunt' value) for its corresponding type, or to a 'mold'.  An example
value is used as a placeholder for sample values, among other things.  A
mold is an idempotent function used as a data validator.

## Overview

A correct mold is a **normalizer**: an idempotent function across
all nouns.  If the sample of a gate has type `%noun`, and its
body obeys the constraint that for any x, `=((mold x) (mold (mold
x)))`, it's a normalizer and can be used as a mold.

(Hoon is not dependently typed and so can't check idempotence
statically, so we can't actually tell if a mold matches this
definition perfectly.  This is not actually a problem.)

Validation (done with [`$|`](#bucbar), though very important, is a rare use
case. Except for direct raw input, it's generally a faux pas to rectify nouns at runtime -- or even
in userspace. Nonetheless they are sometimes utilized for structures that will
be faster to use if they satisfy some validating gate.

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

### $| "bucbar"

`[%bsbr p=spec q=hoon]`: structure that satisfies a validator.

##### Expands to

```hoon
$|(a b) 
```
expands to
```hoon
|=  x=*
=/  foo  ;;(a x)
?>  (b foo)
foo
```

##### Syntax

Regular: **2-fixed**

##### Discussion

`$|` takes two arguments, a mold and a gate that produces a `flag` or loobean that is used to validate the structure produced by the mold to ensure that the noun
has a certain shape. It crashes if the input fails the validation test. Else it
produces a mold-gate that does the following.

`$|(a b)` is a gate that takes in a noun `x` and first pins the product of
clamming `a` with `x`, call this `foo`. Then it calls `b` on `foo`. It asserts
that the product of `(b foo)` is `&`, and then produces `foo`. This sequence of
events can be seen from the Expands To section above.

For example, the elements of a `set` are treated as being
unordered, but the values will necessarily possess an order by where they are in
the memory. Thus if every `set` is stored using the same order scheme then faster algorithms involving `set`s may be
written. Furthermore, if you just place elements in the `set` randomly, it may
be mistreated by algorithms already in place that are expecting a certain order.
This is not the same thing as casting - it is forcing a
type to have a more specific set of values than its mold would suggest. This
rune should rarely be used, but it is extremely important when it is.

##### Examples

```
~zod:dojo> =foo $|  (list @)
           |=(a=(list) (lth (lent a) 4))
```
This creates a structure `foo` whose values are `list`s with length less than 4. 
```
> (foo ~[1 2 3])
~[1 2 3]
> (foo ~[1 2 3 4])
ford: %ride failed to execute:
```


The definition of `+set` in `hoon.hoon` is the following:
```hoon
++  set
  |$  [item]                                            ::  set
  $|  (tree item)
  |=(a=(tree) ~(apt in a))
```
Here [`|$`](@/docs/reference/hoon-expressions/rune/bar.md#barbuc) is used to
define a mold builder that takes in a mold (given the face `item`) and creates a
structure consisting of a `tree` of `item`s with `$|` that is validated with the
gate `|=(a=(tree) ~(apt in a))`. `in` is a door in `hoon.hoon` with functions
for handling `set`s, and `apt` is an arm in that door that checks that the
values in the `tree` are arranged in the particular way that `set`s are arranged
in Hoon, namely 'ascending `+mug` hash order'.


### `$_` "buccab"

`[%bscb p=hoon]`: structure that normalizes to an example.

##### Expands to

```hoon
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

### `$%` "buccen"

`[%bscn p=(list spec)]`: structure which recognizes a union tagged by head atom.

##### Defaults to

The default of the last item `i` in `p`. Crashes if `p` is empty.

##### Syntax

Regular form: **2-running**.

##### Discussion

A `$%` is a tagged union, a common data model.

Make sure the last item in your `$%` terminates, or the default will
be an infinite loop!  Alteratively, you can use `$~` to define a custom
type default value.

##### Examples

```
~zod:dojo> =foo $%([%foo p=@ud q=@ud] [%baz p=@ud])

~zod:dojo> (foo [%foo 4 2])
[%foo p=4 q=2]

~zod:dojo> (foo [%baz 37])
[%baz p=37]

~zod:dojo> $:foo
[%baz p=0]
```

### `$:` "buccol"

`[%bscl p=(list spec)]`: form a cell type.

##### Normalizes to

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


### `$<` "bucgal"

`[%bsld p=spec q=spec]`: Filters a pre-existing mold to obtain a mold 
that excludes a particular structure.

##### Syntax

Regular:  **2-fixed**.

##### Discussion

This can be used to obtain type(s) from a list of types `q` that do not satisfy a
requirement given by `p`.

##### Examples

```
~zod:dojo> =foo $%([%bar p=@ud q=@ud] [%baz p=@ud])

~zod:dojo> =m $<(%bar foo)

~zod:dojo> (m [%bar 2 4])
ford: %ride failed to execute:

~zod:dojo> (m [%baz 2])
[%baz p=2]

~zod:dojo> ;;($<(%foo [@tas *]) [%foo 1])
ford: %ride failed to execute:

~zod:dojo> ;;($<(%foo [@tas *]) [%bar 1])
[%bar 1]
 ```


### `$>` "bucgar"

`[%bsbn p=spec q=spec]`: Filters a mold to obtain a new mold 
matching a particular structure.

##### Syntax

Regular:  **2-fixed**.

##### Discussion

This can be used to obtain type(s) from a list of types `q` that satisfy a
requirement given by `p`.

##### Examples

Examples with `$%`:
```
~zod:dojo> =foo $%([%bar p=@ud q=@ud] [%baz p=@ud])

~zod:dojo> =m $>(%bar foo)

~zod:dojo> (m [%bar 2 4])
[%bar p=2 q=4]

>~zod:dojo> (m [%baz 2])
ford: %ride failed to execute:
```

Examples with `;;`:
```
~zod:dojo> ;;([@tas *] [%foo 1])
[%foo 1]

~zod:dojo> ;;([@tas *] [%bar 1])
[%bar 1]

~zod:dojo> ;;($>(%foo [@tas *]) [%foo 1])
[%foo 1]

~zod:dojo> ;;($>(%foo [@tas *]) [%bar 1])
ford: %ride failed to execute:
 ```


### `$-` "buchep"

`[%bshp p=spec q=spec]`: structure that normalizes to an example gate.

##### Expands to

```hoon
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


### `$^` "bucket"

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

### $& "bucpam"

`[%bspd p=spec q=hoon]`: repair a value of a tagged union type

##### Syntax

Regular: **2-fixed**.

```hoon
$&(combined-mold=spec normalizing-gate=hoon)
```
Here `combined-mold` is a tagged union type (typically made with `$%`) and `normalizing-gate` is a
gate which accepts values of `combined-mold` and normalizes them to be of one particular type
in `combined-mold`.

##### Normalizes to

The product of the normalizing gate and sample.

##### Defaults to

The default of the last type listed in `p`, normalized with the normalizing gate.

##### Discussion

This rune is used to "upgrade" or "repair" values of a structure, typically from
an old version to a new version. For example, this may happen when migrating state after
updating an app.

##### Examples

```hoon
+$  old  [%0 @]
+$  new  [%1 ^]
+$  combined  $%(old new)
+$  adapting  $&(combined |=(?-(-.a %0 [%1 1 +.a], %1 a)))
```
Here `adapting` is a structure that bunts to `[%1 ^]` but also normalizes from
`[%0 @]` if called on such a noun.


### `$~` "bucsig"

`[%bssg p=hoon q=spec]`: define a custom type default value

##### Product

Creates a structure (custom type) just like `q`, except its default value is `p`.

##### Defaults to

The product of `p`.

##### Syntax

Regular: **2-fixed**.

```hoon
$~  p=hoon  q=spec
```

`p` defines the default value, and `q` defines everything else about the structure.

##### Discussion

You should make sure that the product type of `p` nests under `q`.  You can check the default value of some structure (custom type) `r` with `*r`.  (See the [`^*` rune](@/docs/reference/hoon-expressions/rune/ket.md#kettar).)

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

### `$@` "bucpat"

`[%bsvt p=spec q=spec]`: structure which normalizes a union tagged by head depth (atom).

##### Normalizes to

`p`, if the sample is an atom; `q`, if the sample is a cell.

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
%foo
```


### `$=` "buctis"

`[%bsts p=skin q=spec]`: structure which wraps a face around another structure.

##### Expands to

```hoon
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
ford: %ride failed to execute:
```

### `$?` "bucwut"

`[%bswt p=(list spec)]`: form a type from a union of other types.

##### Normalizes to

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
[`$^`](#bucket), at least if you expect your structure to be used as a
normalizer.

##### Examples

```
~zod:dojo> =a ?(%foo %baz %baz)

~zod:dojo> (a %baz)
%baz

~zod:dojo> (a [37 45])
ford: %ride failed to execute:

~zod:dojo> $:a
%baz
```
