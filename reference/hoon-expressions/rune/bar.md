+++
title = "Cores | ('bar')"
weight = 7
template = "doc.html"
+++
Core expressions produce cores. A core is a cell of `[battery payload]`.
The `battery` is code, a battery of Nock formulas.  The `payload` is the data
needed to run those formulas correctly.

Four core runes (`|=`, `|.`, `|-`, and `|*`) produce a
core with a single arm, named `$`. We can recompute this arm
with changes, which useful for recursion among other things:

## Runes

### |_ "barcab"

Produce a **door** (a core with a sample).

##### Syntax

Regular:

```
|_  a=spec
++  b=term  c=hoon
++  d=term  e=hoon
       ...
++  f=term  g=hoon
--
```

Note: The `++` rune may be replaced with any other rune in the `+` family.

AST:

```
[%brcb p=spec q=alas r=(map term tome)]
```

##### Semantics

The product of a `|_` expression is a **door**, a core with one or more arms whose payload includes a sample.  That is, a door is a cell of `[battery [sample context]]`, where the `battery` contains one or more arms.

`a` defines the door sample type and usually includes a name assignment (e.g., `n=@`).  `a` is followed by a series of arm definitions, each of which begins with a rune in the `+` family (most of `++`).  There must be at least one arm, but there may be arbitrarily many.  Each arm must include a name (`b`, `d`, and `f` above), which is followed by the expression (`c`, `e`, and `g` above) that defines the arm product.

The context of the door is the subject of the `|_` expression.

##### Expands to

```
=|  a=spec
|%
++  b=term  c=hoon
++  d=term  e=hoon
       ...
++  f=term  g=hoon
--
```

##### Discussion

A door is the general case of a gate (function).  A gate is a
door with only one arm, which has the name `$`.

Calling a door is like calling a gate except the caller also needs
to specify the arm to be computed.  So, for example, if you have some door `door` which contains some arm `arm`, and you want to pass some argument (i.e., input value `arg`), you would call it with `~(arm door arg)`.

Because gates are also doors, you can call them the same way.  To call the gate `foo` as a door, instead of `(foo baz)` we would write `~($ foo baz)`.  This
is an irregular form for `%~($ foo baz)`, [%~](/docs/reference/hoon-expressions/rune/cen#sig).

##### Examples

A trivial door:

```
/~zod:dojo> =mol  |_  a=@ud
                  ++  succ  +(a)
                  ++  prev  (dec a)
                  --
/~zod:dojo> ~(succ mol 1)
2
/~zod:dojo> ~(succ mol ~(succ mol ~(prev mol 5)))
6
```

A more interesting door, from the kernel library:

```
++  ne
  |_  tig=@
  ++  d  (add tig '0')
  ++  x  ?:((gte tig 10) (add tig 87) d)
  ++  v  ?:((gte tig 10) (add tig 87) d)
  ++  w  ?:(=(tig 63) '~' ?:(=(tig 62) '-' ?:((gte tig 36) (add tig 29) x)))
  --
```

The `ne` door prints a digit in base 10, 16, 32 or 64:

```
~zod:dojo> `@t`~(x ne 12)
'c'
```

### |% "barcen"

Produce a core, `[battery payload]`.

##### Syntax

Regular:

```
|%
++  a=term  b=hoon
++  c=term  d=hoon
       ...
++  e=term  f=hoon
--
```

Note: The `++` rune may be replaced with any other rune in the `+` family.

AST:

```
[%brcn p=(unit term) q=(map term tome)]
```

##### Semantics

The product of a `|%` expression is a dry core with one or more arms in the battery.

The `|%` rune is followed by a series of arm definitions, each of which begins with a rune in the `+` family (most of `++`).  There must be at least one arm, but there may be arbitrarily many.  Each arm must include a name (`a`, `c`, and `e` above), which is followed by the expression (`b`, `d`, and `f` above) that defines the arm product.

The core payload is the subject of the `|%` expression.

##### Discussion

A core is a cell of `[battery payload]`, where the `battery` is code and the `payload` is data.  The `battery` is one or more arms.  An arm is a computation that takes the core itself as its subject.

The `|%` rune is used to construct a core from a series of arm definitions.  Each arm definition in the expression begins with an arm rune (`++`, `+$`, or `+*`).  These arms make up the `battery`.  The subject of the `|%` expression is used to make the core's `payload`.

A core is like an "object" in a conventional language, but its
attributes (_arms_) are functions on the core, not the core and
an argument.  A "method" on a core is an arm that produces a gate.

##### Examples

A trivial core:

```
~zod:dojo> =foo  =+  x=58
                 |%
                 ++  n  (add 42 x)
                 ++  g  |=  b=@
                        (add b n)
                 --
~zod:dojo> n.foo
100
~zod:dojo> (g.foo 1)
101
```

### |: "barcol"

Produce a gate with a custom sample.

##### Syntax

Regular:

```
|:  a=hoon  b=hoon
```

AST:

```
[%brcl p=hoon q=hoon]
```

##### Semantics

`a` is a Hoon expression whose product type defines which values the gate accepts, and it usually includes a name (e.g., `n=1`).  The product of `a` also serves as the default value of the sample.  `b` is a Hoon expression that determines the product value of the gate.

##### Expands to

```
=>  ^~  a
  |.  b
```

##### Discussion

Pick your own default value for the sample.  Note that `a` is an ordinary expression, not a type; `|:` doesn't bunt a sample as
[`|=`](#bartis) does.

This is useful if you want a gate to have a sample of a particular type, but you don't want the default value of the gate to be the default value of that type.

##### Examples

```
> =add-ten |:(n=`@`2 (add n 10))

> (add-ten 10)
20

> (add-ten)
12
```

### |. "bardot"

Produce a trap (a core with one arm `$`).

##### Syntax

Regular:

```
|.  a=hoon
```

AST:

```
[%brdt p=hoon]
```

Semantics:

A `|.` expression produces a core with a single arm, `$`.  The core isn't explicitly given a sample.  `a` is a Hoon expression that defines the computation of the `$` arm.

The payload of the core is the subject of the `|.` expression.

##### Expands to

```
|%  ++  $  a=hoon
--
```

##### Discussion

A trap is generally used to defer a computation.

##### Examples

A trivial trap:

```
~zod:dojo> =foo |.(42)

~zod:dojo> $:foo
42

~zod:dojo> (foo)
42
```

A more interesting trap:

```
~zod:dojo> =foo  =/  reps  10
                 =/  step  0
                 =/  outp  0
                 |.
                 ?:  =(step reps)
                   outp
                 $(outp (add outp 2), step +(step))
~zod:dojo> (foo)
20
```

Note that we can use `$()` to recurse back into the
trap, since it's a core with an `$` arm.

> `$(...)` expands to `%=($ ...)` (["centis"](/docs/reference/hoon-expressions/rune/cen#centis)).

### |- "barhep"

Produce a trap (a core with one arm `$`) and evaluate it.

##### Syntax

Regular:

```
|-  a=hoon
```

AST:

```
[%brhp p=hoon]
```

##### Semantics

A `|-` expression produces a core with one arm named `$` and immediately evaluates `$`.  `a` is a Hoon expression that determines what `$` evaluates to.

##### Expands to

```
=<($ |.(a=hoon))
```

##### Discussion

The `|-` rune can be thought of as a 'recursion point' or a 'loop starting point'. Since `|-` makes a `|.` (["bardot"](#bardot), a core with one arm named `$`, we can recurse back into it with `$()`.

> `$(...)` expands to `%=($ ...)` (["centis"](/docs/reference/hoon-expressions/rune/cen#centis)).

##### Examples

A trivial computation doesn't recurse:

```
~zod:dojo> |-(42)
42
```

The classic loop is a decrement:

```
~zod:dojo> =foo  =/  a  42
                 =/  b  0
                 |-
                 ?:  =(a +(b))
                   b
                 $(b +(b))
~zod:dojo> foo
41
```

### |^ "barket"

Produce a core whose battery includes a `$` arm and compute the latter.

##### Syntax

Regular:

```
|^  a=hoon
++  b=term  c=hoon
++  d=term  e=hoon
       ...
++  f=term  g=hoon
--
```

Note: The `++` rune may be replaced with any other rune in the `+` family.

AST:

```
[%brkt p=hoon q=(map term tome)]
```

##### Semantics

A `|^` expression produces a multi-arm core whose battery includes a `$` arm, which is evaluated immediately.  `a` is a Hoon expression that defines the product of the `$` arm.  `a` is followed by a series of arm definitions for the rest of the core battery arms.  There must be at least one arm other than the `$` arm.

##### Expands to

```
=>  |%
    ++  $  a=hoon
    ++  b=term  c=hoon
    ++  d=term  e=hoon
           ...
    ++  f=term  g=hoon
    --
$
```

##### Discussion

The `|^` rune is useful when you define a multi-arm core in your code and a particular arm in it is to be evaluated immediately.

##### Examples

A trivial example:

```
~zod:dojo> |^
           (add n g)
           ++  n  42
           ++  g  58
           --
100
```

### |~ "barsig"

Produce an iron gate.

##### Syntax

Regular:

```
|~  a=spec  b=hoon
```

AST:

```
[%brsg p=spec q=hoon]
```

##### Semantics

A `|~` expression produces an iron gate.  `a` defines the sample, and `b` defines the output value of the gate.

##### Expands to

```
^|  |=(a b)
```

##### Discussion

See [this discussion of core variance models](@/docs/reference/hoon-expressions/advanced.md)

##### Examples

```
~zod:dojo> =>  ~  ^+(|~(a=@ *@) |=(a=* *@))
<1|usl {a/@ $~}>
```

### |* "bartar"

Produce a wet gate (one-armed core with sample).

##### Syntax

Regular:

```
|*  a=spec  b=hoon
```

AST:

```
[%brtr p=spec q=hoon]
```

##### Semantics

A `|*` expression produces a wet gate.  `a` defines the gate's sample, and `b` is a Hoon expression that determines the output value of the gate.

##### Expands to

```
=|  a
|@
++  $
  b
--
```

##### Discussion

In a normal (dry) gate, your argument is converted into the
sample type.  In a generic (wet) gate, your argument type
passes through the function, rather as if it were a macro (there
is still only one copy of the code, however).

Genericity is a powerful and dangerous tool.  Use wet gates only if
you know what you're doing.

Just as with a [gate](#bartis), we can recurse back into a wet gate
with `$()`.

> `$(...)` expands to `%=($ ...)` (["centis"](@/docs/reference/hoon-expressions/rune/cen.md#centis)).

##### Examples

Wet and dry gates in a nutshell:

```
~zod:dojo> =foo |=([a=* b=*] [b a])

~zod:dojo> =bar |*([a=* b=*] [b a])

~zod:dojo> (foo %cat %dog)
[6.778.724 7.627.107]

~zod:dojo> (bar %cat %dog)
[%dog %cat]
```

The dry gate does not preserve the type of `a` and `b`; the wet
gate does.

### |= "bartis"

Produce a gate (a one-armed core with a sample).

##### Syntax

Regular:

```
|=  a=spec  b=hoon
```

AST:

```
[%brts p=spec q=hoon]
```

##### Definition

The product of a `|=` expression is a dry **gate**, i.e., a Hoon function.

`p` defines the gate sample type -- i.e., the input value type -- and usually includes a sample name assignment (e.g., `a=@`).  `q` is an expression that determines the output value of the gate.

##### Expands to

```
=|  a=spec
|%  ++  $  b=hoon
--
```

##### Discussion

Dry gates are used for the vast majority of ordinary functions in Hoon.

A gate is a core with one arm named `$`, so we can recurse back into it with `$()`.

> `$(...)` expands to `%=($ ...)` (["centis"](@/docs/reference/hoon-expressions/rune/cen.md#centis)).

##### Examples

A trivial gate:

```
~zod:dojo> =foo |=(a=@ +(a))

~zod:dojo> (foo 20)
21
```

A slightly less trivial gate:

```
~zod:dojo> =foo  |=  [a=@ b=@]
                 (add a b)
~zod:dojo> (foo 30 400)
430
```

### |@ "barvat"

Produce a 'wet' core `[battery payload]`.

##### Syntax

Regular:

```
|@
++  a=term  b=hoon
++  c=term  d=hoon
       ...
++  e=term  f=hoon
--
```

Note: The `++` rune may be replaced with any other rune in the `+` family.

AST:

```
[%brvt p=(unit term) q=(map term tome)]
```

##### Semantics

A `|@` expression produces a 'wet' core whose payload is the expression's subject.  The various arms in the battery are each named (`a`, `c`, and `e` above) and defined explicitly with a Hoon expression (with `b`, `d`, and `f` above).

##### Discussion

The `|@` rune is just like the `|%` rune except that instead of producing a 'dry' core, it produces a 'wet' one.  This allows for type polymorphism of its arms, using 'genericity'.  See [Advanced types](@/docs/reference/hoon-expressions/advanced.md).

### |? "barwut"

Produce a lead trap.

##### Syntax

Regular:

```
|?  a=hoon
```

AST:

```
[%brwt p=hoon]
```

##### Semantics

A `|?` expression produces a lead trap (i.e., a lead core with one arm named `$`).  `a` is a Hoon expression that defines what the `$` arm does.

##### Expands to

```
^?  |.  a
```

##### Discussion

See this [discussion of the core variance model](@/docs/reference/hoon-expressions/advanced.md).

##### Examples

```
~zod:dojo> =>  ~  ^+  |?(%a)  |.(%a)
<1?pqz $~>

~zod:dojo> =>  ~  ^+  |?(%a)  |.(%b)
nest-fail
```
