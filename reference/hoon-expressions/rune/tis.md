+++
title = "Change Subject = ('tis')"
weight = 5
template = "doc.html"
+++
These runes modify the subject.  (Or more precisely, they
evaluate at least one of their subexpressions with a modified subject.)

## Overview

Hoon doesn't have variables in the ordinary sense.  If you want to bind a name
to a value, e.g., `a` to `12`, you do so by pinning `12` to the subject and
associating the name with it.  This sort of operation is done with the `=`
family of runes.

Let's say you have some old subject `p`.  To 'pin' a value to the head means to
modify the subject by repacing it with a cell of `[new-value p]`.  The head of
the cell is the new value.  So to pin `12` with the face `a` the new subject
would be: `[a=12 p]`.

Of course there are many variations on ways to modify the subject, useful for
different situations.  Hence the whole family of `=` runes.

## Runes

### => "tisgar"

`[%tsgr p=hoon q=hoon]`: compose two expressions.

##### Produces

the product of `q`, with the product of `p` taken as the subject.

##### Syntax

Regular: **2-fixed**.

##### Examples

```
> =>([a=1 b=2 c=3] b)
2

> =>((add 2 4) [. .])
[6 6]
```

### =| "tisbar"


`[%tsbr p=spec q=hoon]`: combine a default type value with the subject.

##### Expands to

```
=+(*p q)
```

##### Syntax

Regular: **2-fixed**.

##### Discussion

The default (or 'bunt') value of `p` is pinned to the head of the subject.  Usually `p` includes a name for ease of reference.

Speaking more loosely, `=|` usually "declares a variable" which is "uninitialized," presumably because you'll set it in a loop or similar.

##### Examples

```
~zod:dojo> =foo  |=  a=@
                 =|  b=@
                 =-  :(add a b c)
                 c=2
~zod:dojo> (foo 5)
7
```

### =: "tiscol"

`[%tscl p=(list (pair wing hoon)) q=hoon]`: change multiple legs in the subject.

##### Expands to

```
=>(%_(. p) q)
```

##### Syntax

Regular: **jogging**, then **1-fixed**.

##### Discussion

This rune is like `=.`, but for modifying the values of multiple legs of the subject.

##### Examples

```
~zod:dojo> =+  a=[b=1 c=2]
           =:  c.a  4
               b.a  3
             ==
           a
[b=3 c=4]
```

### =, "tiscom"

`[%tscm p=hoon q=hoon]`: expose namespace

`p` evaluates to a noun with some namespace.  From within `q` you may access `p`'s names without a wing path (i.e., you can use face `b` rather than `b.p`).  This is especially useful for calling arms from an imported library core or for calling arms from a stdlib core repeatedly.

##### Syntax

Regular: **2-fixed**.

##### Examples

With an imported core:

```
> (sum -7 --7)
-find.sum
[crash message]

> (sum:si -7 --7)
--0

> =,  si  (sum -7 --7)
--0
```

With a dojo-defined face:

```
> =/  fan  [bab=2 baz=[3 qux=4]]
  =,  fan
  [bab qux.baz]
[2 4]
```

### =. "tisdot"

`[%tsdt p=wing q=hoon r=hoon]`: change one leg in the subject.

##### Expands to

```
=>(%_(. p q) r)
```

##### Syntax

Regular: **3-fixed**.

##### Discussion

Technically the `=.` rune doesn't change the subject.  It creates
a new subject just like the old one except for a changed value at `p`.  Note that the mutation uses [`%_` ("cencab")](@/docs/reference/hoon-expressions/rune/cen.md#cencab), so the type at `p` doesn't change.  Trying to change the value type results in a `nest-fail`.

##### Examples

```
> =+  a=[b=1 c=2]
  =.  b.a  3
  a
[b=3 c=2]

> =+  a=[b=1 c=2]
  =.(b.a 3 a)
[b=3 c=2]

> =+  a=[b=1 c=2]
  =.(b.a "hello" a)
nest-fail
```

### =- "tishep"

`[%tshp p=hoon q=hoon]`: combine a new noun with the subject, inverted.

##### Expands to

```
=>([q .] p)
```

##### Syntax

Regular: **2-fixed**.

##### Discussion

`=-` is just like `=+` but its subexpressions are reversed.  `=-` looks better than `=+` when the expression you're pinning to the subject is much smaller than the expression that uses it.

##### Examples

```
~zod:dojo> =foo  |=  a=@
                 =+  b=1
                 =-  (add a b c)
                 c=2
~zod:dojo> (foo 5)
8
```

### =^ "tisket"

`[%tskt p=skin q=wing r=hoon s=hoon]`: pin the head of a pair; change
a leg with the tail.

##### Expands to

```
=/(p -.r =.(q +.r s))
```

##### Syntax

Regular: **4-fixed**.

##### Discussion

`p` is a new name (possibly with type annotation, e.g., `a=@`) of a value to be pinned to the subject.  The value of `p` is the head of the product of `r`.  `q` is given the value of the tail of `r`'s product.  Then `s` is evaluated against this new subject.

We generally use `=^` when we have a state machine with a function, `r`, that
produces a cell, whose head is a result and whose tail is a new
state.  The head value is given a new name `p`, and the
tail is stuffed back into wherever we stored the old state, `q`.

This may also remind you of Haskell's State monad.

##### Examples

The `og` core is a stateful pseudo-random number generator.
We have to change the core state every time we generate a
random number, so we use `=^`:

```
~zod:dojo> =+  rng=~(. og 420)
           =^  r1  rng  (rads:rng 100)
           =^  r2  rng  (rads:rng 100)
           [r1 r2]
[99 46]
```

### =< "tisgal"

`[%tsgl p=hoon q=hoon]`: compose two expressions, inverted.

##### Expands to

```
=>(q p)
```

##### Syntax

Regular: **2-fixed**.

Irregular: `foo:baz` is `=<(foo baz)`.

##### Discussion

`=<` is just `=>` backwards.

##### Examples

```
~zod:dojo> =<(b [a=1 b=2 c=3])
2

~zod:dojo> =<  b
           [a=1 b=2 c=3]
2

~zod:dojo> b:[a=1 b=2 c=3]
2

~zod:dojo> [. .]:(add 2 4)
[6 6]
```

### =+ "tislus"


`[%tsls p=hoon q=hoon]`: combine a new noun with the subject.

##### Expands to

```
=>([p .] q)
```

##### Syntax

Regular: **2-fixed**.

##### Discussion

The subject of the `=+` expression, call it `a`, becomes the cell `[p a]` for the evaluation of `q`.  That is, `=+` 'pins a value', `p`, to the head of the subject.

Loosely speaking, `=+` is the simplest way of "declaring a variable."

##### Examples

### =; "tismic"

`[%tsmc p=skin q=hoon r=hoon]`: combine a named noun with the subject, possibly with type annotation; inverted order.

##### Expands to

```
=/(p r q)
```

##### Syntax

Regular: **3-fixed**.

##### Discussion

`=;` is exactly like `=/` except that the order of its last two subexpressions is reversed.

##### Examples

```
~zod:dojo> =foo  |=  a=@
                 =/   b  1
                 =;   c=@  :(add a b c)
                 2
~zod:dojo> (foo 5)
8
```

### =/ "tisfas"

`[%tsfs p=skin q=hoon r=hoon]`: combine a named noun with the subject, possibly with type annotation.

##### Expands to

**if `p` is a name**, (e.g. `a`):

```
=+(^=(p q) r)
```

**if `p` is a name with a type** (e.g., `a=@`):

```
=+(^-(p q) r)
```

### Desugaring

```
?@  p
  =+  p=q
  r
=+  ^-($=(p.p q.p) q)
r
```

##### Syntax

Regular: **3-fixed**.

##### Discussion

`p` can be either a name or a name=type.  If it's just a name,
`=/` ("tisfas") "declares a type-inferred variable."  If it has a type, `=/`
"declares a type-checked variable."

##### Examples

```
~zod:dojo> =foo  |=  a=@
                 =/  b  1
                 =/  c=@  2
                 :(add a b c)
~zod:dojo> (foo 5)
8
```

### =~ "tissig"


`[%tssg p=(list hoon)]`: compose many expressions.

##### Produces

The product of the chain composition.

##### Syntax

Regular: **running**.

##### Examples

```
~zod:dojo> =~  [sub (mul 3 20) (add 10 20)]
      (sub +)
      +(.)
  ==
31

~zod:dojo> =foo =|  n=@
                =<  =~  increment
                        increment
                        increment
                        n
                    ==
                |%
                ++  increment
                  ..increment(n +(n))
                --
~zod:dojo> foo
3
```

### =* "tistar"

`[%tstr p=term q=hoon r=hoon]`: define an alias.

##### Produces

`r`, compiled with a subject in which `p` is aliased to `q`.

##### Syntax

Regular: **3-fixed**.

##### Discussion

The difference between aliasing and pinning is that pinning changes the subject, but for aliasing the subject noun stays the same.  The aliased expression, `q`, is recorded in the type information of `p`. `q` is calculated every time you use the `p` alias.

##### Examples

```
~zod:dojo>
    =+  a=1
    =*  b  a
    [a b]
[1 1]

~zod:dojo>
    =+  a=1
    =*  b  a
    =.  a  2
    [a b]
[2 2]
```

### =? "tiswut"

`[$tswt p=wing q=hoon r=hoon s=hoon]`: conditionally change one leg in the subject.

##### Expands to

```
=.  p  ?:(q r p)
s
```

##### Syntax

Regular: **4-fixed**.

##### Discussion

Use `=?` to replace the value of leg `p` with `r` on condition `q`. As
usual, we are not actually mutating the subject, just creating
a new subject with a changed value.  The change in value includes a
type check against the old subject; the type of `r` must nest under
the type of `p`.

##### Examples

```
> =a 12

> =?(a =(1 1) 22 a)
22

> =?(a =(1 2) 22 a)
12
```
