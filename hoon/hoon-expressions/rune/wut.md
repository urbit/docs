+++
title = "Conditionals ? ('wut')"
weight = 6
template = "doc.html"
+++
Hoon has the usual program control branches.  It also has the usual logical
operators: AND `?&`, OR `?|`, and NOT `?!`.  It also has a `?=` rune that tests
whether a value matches a given type.  In the course of type inference, Hoon
learns from `?=` tests in the test condition of [`?:` ("wutcol")](#wutcol)
expressions.

## Overview

All `?` runes reduce to `?:` and/or `?=`.

If the condition of an `?:` is a `?=`, **and** the `?=` is
testing a leg of the subject, the compiler specializes the subject
type for the branches of the `?:`.  Branch inference also works
for expressions which expand to `?:`.

The test does not have to be a single `?=`; the compiler can
analyze arbitrary boolean logic ([`?&` ("wutpam")](#wutpam),
[`?|` ("wutbar")](#wutbar), [`?!` ("wutzap")](#wutzap)) with full
short-circuiting.  Equality tests ([`.=` ("dottis")](@/docs/hoon/hoon-expressions/rune/dot.md#dottis)) are **not**
analyzed.

If the compiler detects that the branch is degenerate (only one
side is taken), it fails with an error.

## Runes

### ?> "wutgar"

`[%wtgr p=hoon q=hoon]`: positive assertion.

##### Expands to

```hoon
?.(p !! q)
```

##### Syntax

Regular: **2-fixed**.

##### Discussion

`?>` is used to force a crash when some condition `p` doesn't yield 'yes', `%.y`.

It can be used for type inference, with the `?=` rune, to specify the type of a value.

##### Examples

```
> ?>(=(3 3) %foo)
%foo

> ?>(=(3 4) %foo)
ford: build failed

> =a `*`123

> `@`a
nest-fail

> ?>(?=(@ a) `@`a)
123
```

### ?| "wutbar"

`[%wtbr p=(list hoon)]`: logical OR.

##### Expands to

**Pseudocode**: `a`, `b`, `c`, ... as elements of `p`:

```hoon
?:(a & ?:(b & ?:(c & ?:(... ?:(z & |)))))
```

##### Desugaring

```hoon
|-
?~  p
  |
?:  i.p
  &
$(p t.p)
```

##### Syntax

Regular: **running**.

Irregular: `|(foo bar baz)` is `?|(foo bar baz)`.

##### Examples

```
~zod:dojo> |(=(6 42) =(42 42))
%.y

~zod:dojo> |(=(6 42) =(42 43))
%.n
```

### ?: "wutcol" {#wutcol}

`[%wtcl p=hoon q=hoon r=hoon]`: branch on a boolean test.

##### Produces

If `p` produces yes, `%.y`, then `q`. If `p` produces no, `%.n`, then `r`.
If `p` is not a boolean, compiler yells at you.

##### Type inference

The subject types of `q` and `r` are constrained to match any pattern-matching algebra in `p`.  The analysis, which is conservative, understands any combination of [`?=`](#wuttis), [`?&`](#wutpam), [`?|`](#wutbar), and  [`?!`](#wutzap), and infers the type of the subject appropriately when compiling.

If test analysis reveals that either branch is never taken, or if `p` is not a boolean, compilation fails.  An untaken branch is indicated with `mint-lost`.

##### Syntax

Regular: **3-fixed**.

##### Discussion

Short-circuiting in boolean tests works as you'd expect
and includes the expected inference.  For instance,
if you write `?&(a b)`, `b` is only executed if `a` is
positive, and compiled with that assumption.

Note also that all other branching expressions reduce to `?:`.

##### Examples

```
~zod:dojo> ?:((gth 1 0) 3 4)
3

~zod:dojo> ?:  (gth 1 0)
             3
           4
3

~zod:dojo> ?:((gth 1 2) 3 4)
4

~zod:dojo> ?:  (gth 1 2)
             3
           4
4
```

### ?. "wutdot"

`[%wtdt p=hoon q=hoon r=hoon]`: branch on a boolean test, inverted.

##### Expands to

```hoon
?:(p r q)
```

##### Syntax

Regular: **3-fixed**.

##### Discussion

`?.` is just like `?:`, but with its last two subexpressions reversed.

As is usual with inverted forms, use `?.` when the yes-case expression is much taller and/or wider than the no-case expression.

##### Examples

```
~zod:dojo> ?.((gth 1 2) 3 4)
3

~zod:dojo> ?.(?=(%a 'a') %not-a %yup)
%yup

~zod:dojo> ?.  %.y
             'this false case is less heavy than the true case'
           ?:  =(2 3)
             'two not equal to 3'
           'but see how \'r is much heavier than \'q?'
'but see how \'r is much heavier than \'q?'
```

### ?- "wuthep"

`[%wthp p=wing q=(list (pair spec value))]`: switch against a union, with no default.

##### Expands to

**Pseudocode**: `a`, `b`, `c`, ... as elements of `q`:

```hoon
?:  ?=(p.a p)  q.a
?:  ?=(p.b p)  q.b
?:  ?=(p.c p)  q.c
...
~|(%mint-lost !!)
```

##### Desugaring

```hoon
|-
?.  q
  ~|(%mint-lost !!)
?:  ?=(p.i.q p)
  q.i.q
$(q t.q)
```

##### Syntax

Regular: **1-fixed**, then **jogging**.

##### Discussion

The `?-` rune is for a conditional expression in which the type of `p` determines which branch is taken.  Usually the type of `p` is a union of other types.  There is no default branch.

The compiler makes sure that your code neither misses a case of
the union, nor includes a double case that isn't there.  This is
not special handling for `?-`, just a consequence of the
semantics of `?:`, which `?-` reduces to.

A missing case will throw the `mint-lost` error.  An extra case
will throw `mint-vain`.

##### Examples

```
~zod:dojo> =cor  |=  vat=?(%a %b)
                 ?-  vat
                   %a  20
                   %b  42
                 ==

~zod:dojo> (cor %a)
20

~zod:dojo> (cor %b)
42

~zod:dojo> (cor %c)
! nest-fail
```

### ?^ "wutket"

`[%wtkt p=wing q=hoon r=hoon]`: branch on whether a wing
of the subject is a cell.

##### Expands to

```hoon
?:(?=(^ p) q r)
```

##### Syntax

Regular: **3-fixed**.

##### Discussion

The type of the wing, `p`, must not be known to be either an atom or a cell, or else you'll get a `mint-vain` error at compile time.  `mint-vain` means that one of the `?^` branches, `q` or `r`, is never taken.

##### Examples

```
~zod:dojo> ?^(0 1 2)
! mint-vain
! exit

~zod:dojo> ?^(`*`0 1 2)
2

~zod:dojo> ?^(`*`[1 2] 3 4)
3
```

### ?< "wutgal"

`[%wtgl p=hoon q=hoon]`: negative assertion.

##### Expands to

```hoon
?:(p !! q)
```

##### Syntax

Regular: **2-fixed**.

##### Discussion

`?<` is used to force a crash when some condition `p` doesn't yield 'no', `%.n`.

It can be used for type inference with the `?=` rune, much like the `?>` rune.

##### Examples

```
> ?<(=(3 4) %foo)
%foo

> ?<(=(3 3) %foo)
ford: build failed

> =a `*`[12 14]

> `^`a
nest-fail

> ?<(?=(@ a) `^`a)
[12 14]
```

### ?+ "wutlus"

`[%wtls p=wing q=hoon r=(list (pair spec hoon))]`: switch against
a union, with a default.

##### Expands to

**Pseudocode**: `a`, `b`, `c`, ... as elements of `r`:

```hoon
?:  ?=(p.a p)  q.a
?:  ?=(p.b p)  q.b
?:  ?=(p.c p)  q.c
...
q
```

##### Desugaring

```hoon
|-
?.  r
  q
?:  ?=(p.i.r p)
  q.i.r
$(r t.r)
```

##### Syntax

Regular: **2-fixed**, then **jogging**.

##### Discussion

The `?+` rune is for a conditional expression in which the type of `p` determines which branch is taken.  Usually the type of `p` is a union of other types.  If `p`'s type doesn't match the case for any given branch, the default expression, `q`, is evaluated.

If there is a case that is never taken you'll get a `mint-vain` error.

##### Examples

```
~zod:dojo> =cor  |=  vat=?(%a %b)
                 ?+  vat  240
                   %a  20
                   %b  42
                 ==

~zod:dojo> (cor %a)
20

~zod:dojo> (cor %b)
42

~zod:dojo> (cor %c)
240
```

### ?& "wutpam"

`[%wtpm p=(list hoon)]`: logical AND.

##### Expands to

**Pseudocode**: `a`, `b`, `c`, ... as elements of `p`:

```hoon
?.(a | ?.(b | ?.(c | ?.(... ?.(z | &)))))
```

##### Desugaring

```hoon
|-
?~  p
  &
?.  i.p
  |
$(p t.p)
```

##### Syntax

Regular: **running**.

Irregular: `&(foo bar baz)` is `?&(foo bar baz)`.

##### Examples

```
~zod:dojo> &(=(6 6) =(42 42))
%.y

~zod:dojo> &(=(6 7) =(42 43))
%.n
```

### ?~ "wutsig"

`[%wtsg p=wing q=hoon r=hoon]`: branch on whether a wing of the subject is null.

##### Expands to

```hoon
?:(?=($~ p) q r)
```

##### Syntax

Regular: **3-fixed**.

##### Discussion

It's bad style to use `?~` to test for any zero atom.  Use it only for a true null, `~`.

##### Examples

```
~zod:dojo> =foo ""

~zod:dojo> ?~(foo 1 2)
1
```

### ?= "wuttis"

`[%wtts p=spec q=wing]`: test pattern match.

##### Produces

`%.y` (yes) if the noun at `q` is in the type of `p`; `%.n` (no) otherwise.

##### Syntax

Regular: **2-fixed**.

##### Discussion

`?=` is not as powerful as it might seem.  For instance, it
can't generate a loop -- you cannot (and should not) use it to
test whether a `*` is a `(list @)`.  Nor can it validate atomic
auras.

Patterns should be as weak as possible.  Unpack one layer of
union at a time.  Don't confirm things the type system knows.

For example, when matching from a tagged union for the type `[%foo p=@
q=[@ @]]`, the appropriate pattern is `[%foo *]`.  You have one
question, which is whether the head of the noun is `%foo`.

A common error is `find.$`, meaning `p` is not a type.

##### Examples

```
~zod:dojo> =bar [%foo %bar %baz]
~zod:dojo> ?=([%foo *] bar)
%.y
```

### ?@ "wutvat"

`[%wtpt p=wing q=hoon r=hoon]`: branch on whether a wing of the subject is an atom.

##### Expands to

```hoon
?:(?=(@ p) q r)
```

##### Syntax

Regular: **3-fixed**.

##### Discussion

The type of the wing, `p`, must not be known to be either an atom or a cell, or else you'll get a `mint-vain` error at compile time.  `mint-vain` means that one of the `?@` branches, `q` or `r`, is never taken.

##### Examples

```
~zod:dojo> ?@(0 1 2)
! mint-vain
! exit

~zod:dojo> ?@(`*`0 1 2)
1

~zod:dojo> ?@(`*`[1 2] 3 4)
4
```

### ?! "wutzap"

`[%wtzp p=hoon]`: logical NOT.

##### Expands to

```hoon
.=(| p)
```

Produces the logical NOT of `p`.

##### Syntax

Regular: **1-fixed**.

Irregular: `!foo` is `?!(foo)`.

##### Examples

```
~zod:dojo> ?!(.=(1 2))
%.y

~zod:dojo> !&
%.n

~zod:dojo> !|
%.y

~zod:dojo> !(gth 5 6)
%.y
```
