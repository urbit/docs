+++
title = "Make ; ('mic')"
weight = 13
template = "doc.html"
aliases = ["docs/reference/hoon-expressions/rune/mic/"]
+++

Miscellaneous useful macros.

## Runes

### `;:` "miccol"

`[%mccl p=hoon q=(list hoon)]`: call a binary function as an n-ary function.

##### Expands to

**Pseudocode**: `a`, `b`, `c`, ... as elements of `q`:

Regular form:

```hoon
%-(p a %-(p b %-(p c ...)))
```

Irregular form:

```hoon
(p a (p b (p c ...)))
```

##### Desugaring

```hoon
|-
?~  q  !!
?~  t.q  !!
?~  t.t.q
  (p i.q i.t.q)
(p i.q $(q t.q))
```

##### Syntax

Regular: **1-fixed**, then **running**.

Irregular: `:(add a b c)` is `;:(add a b c)`.

##### Examples

```
~zod:dojo> (add 3 (add 4 5))
12

~zod:dojo> ;:(add 3 4 5)
12

~zod:dojo> :(add 3 4 5)
12
```


### `;;` "micmic"

`[%mcmc p=spec q=hoon]`: normalize with a mold, asserting fixpoint.

##### Expands to

```hoon
=+  a=(p q)
?>  =(`*`a `*`q)
a
```

> Note: the expansion implementation is hygienic -- it doesn't actually add the `a` face to the subject.

##### Syntax

Regular: **2-fixed**.

##### Examples

Fails because of auras:

```
~zod:dojo> ^-(tape ~[97 98 99])
mint-nice
nest-fail
ford: %slim failed: 
ford: %ride failed to compute type:
```

Succeeds because molds don't care about auras:

```
~zod:dojo> ;;(tape ~[97 98 99])
"abc"
```

Fails because not a fixpoint:

```
~zod:dojo> ;;(tape [50 51 52])
ford: %ride failed to execute:
```


### `;~` "micsig"

`[%mcsg p=hoon q=(list hoon)]`: glue a pipeline together with a
product-sample adapter.

##### Produces

The gates in `q` are composed together using the gate `p` as an intermediate function, which transforms a `q` product and a `q` gate into a `q` sample.

##### Expands to

**Note: these are structurally correct, but elide some type-system complexity.**

`;~(a b)` reduces to `b`.

`;~(a b c)` expands to

```hoon
|=  arg=*
(a (b arg) c(+6 arg))
```

`;~(a b c d)` expands to

```hoon
|=  arg=*
%+  a (b arg)
=+  arg=arg
|.  (a (c arg) d(+6 arg))
```

##### Desugaring

```hoon
?~  q  !!
|-
?~  t.q  i.q
=/  a  $(q t.q)
=/  b  i.q
=/  c  ,.+6.b
|.  (p (b c) a(,.+6 c))
```

##### Discussion

Apparently `;~` is a "Kleisli arrow."  It's also
a close cousin of the infamous "monad."  Don't let that bother
you.  Hoon doesn't know anything about category theory,
so you don't need to either.

`;~` is often used in parsers, but is not only for parsers.

This can be thought of as user-defined function composition; instead of simply
nesting the gates in `q`, each is passed individually to `p` with the product
of the previous gate, allowing arbitrary filtering, transformation, or
conditional application.

##### Syntax

Regular: **1-fixed**, then **running**.

##### Examples

A simple "parser."  `trip` converts a `cord` (atomic string) to
a `tape` (linked string).

```
~zod:dojo> =cmp |=([a=tape b=$-(char tape)] `tape`?~(a ~ (weld (b i.a) t.a)))
~zod:dojo> ;~(cmp trip)
<1.zje {a/@ <409.yxa 110.lxv 1.ztu $151>}>

```

With just one gate in the pipeline `q`, the glue `p` is unused:

```
~zod:dojo> (;~(cmp trip) 'a')
"a"
```

But for multiple gates, we need it to connect the pipeline:

```
~zod:dojo> (;~(cmp trip |=(a=@ ~[a a])) 'a')
"aa"
~zod:dojo> (;~(cmp trip |=(a=@ ~[a a])) '')
""
```

A more complicated example:

```
~zod:dojo> (;~(cmp trip ;~(cmp |=(a=@ ~[a a]) |=(a=@ <(dec a)>))) 'b')
"97b"
~zod:dojo> (;~(cmp trip |=(a=@ ~[a a]) |=(a=@ <(dec a)>)) 'b')
"97b"
~zod:dojo> (;~(cmp trip |=(a=@ ~[a a]) |=(a=@ <(dec a)>)) '')
""
~zod:dojo> (;~(cmp trip |=(a=@ ~[a a]) |=(a=@ <(dec a)>)) 'a')
"96a"
~zod:dojo> (;~(cmp trip |=(a=@ ~[a a]) |=(a=@ <(dec a)>)) 'acd')
"96acd"
```

