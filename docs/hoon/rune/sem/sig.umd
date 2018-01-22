---
navhome: /docs/
next: true
sort: 2
title: ;~ "semsig"
---

# `;~ "semsig"`

`[%smsg p=hoon q=(list hoon)]`: glue a pipeline together with a 
product-sample adapter.

## Produces

The gates in `q` connected together using the gate `p`, which 
transforms a `q` product and a `q` gate into a `q` sample.

## Expands to

*Note: these are structurally correct, but elide some type-system complexity.*

`;~(a b)` reduces to `b`.

`;~(a b c)` expands to

```
|=  arg=*
(a (b arg) c(+6 arg))
```

`;~(a b c d)` expands to

```
|=  arg=*
%+  a (b arg)
=+  arg=arg
|.  (a (c arg) d(+6 arg))
```

### Compiler macro

```
?~  q  !!
|-
?~  t.q  i.q
=/  a  $(q t.q)
=/  b  i.q
=/  c  ,.+6.b
|.  (p (b c) a(,.+6 c))
```

## Discussion

Apparently `;~` ("semsig") is a "Kleisli arrow."  Whatevs.  It's also 
a close cousin of the infamous "monad."  Don't let that bother
you either.  Hoon doesn't know anything about category theory,
so you don't need to either.

`;~` is often used in parsers, but is not only for parsers.

This can be thought of as user-defined function composition; instead of simply
nesting the gates in `q`, each is passed individually to `p` with the product
of the previous gate, allowing arbitrary filtering, transformation, or
conditional application.

## Syntax

Regular: *1-fixed*, then *running*.

## Examples

A simple "parser."  `trip` converts a `cord` (atomic string) to
a `tape` (linked string).

```
~zod:dojo> =cmp |=([a=tape b=$-(char tape)] `tape`?~(a ~ (weld (b i.a) t.a)))
~zod:dojo> ;~(cmp trip)
<1.zje {a/@ <409.yxa 110.lxv 1.ztu $151>}>
~zod:dojo> (;~(cmp trip) 'a')
"a"
```

With just one gate in the pipeline `q`, the glue `p` is unused:

```
~zod:dojo> (;~(cmp trip |=(a=@ ~[a a])) 'a')
"aa"
~zod:dojo> (;~(cmp trip |=(a=@ ~[a a])) '')
""
```

But for multiple gates, we need it to connect the pipeline:

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
