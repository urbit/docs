---
navhome: /docs/
sort: 6
---

# `:var  =/  "tisfas"` 

`{$var p/taco q/seed r/seed}`: combine a named and/or typed 
noun with the subject.

## Expands to

*if `p` is a symbol*:

```
:pin(:name(p q) r)
```

```
=+(^=(p q) r)
```

*if `p` is a symbol with a mold*:

```
:pin(:cast(p q) r)
```

```
=+(^-(p q) r)
```

### Compiler macro

```
:ifat  p
  :pin  :name(p q)
  r
:pin  :cast(:coat(p.p q.p) q)
r
```

```
?@  p
  =+  p=q
  r
=+  ^-($=(p.p q.p) q)
r
```

## Syntax

Regular: *3-fixed*.

## Discussion

`p` can be either a symbol or a symbol/mold.  If it's just a symbol,
`:var` "declares a type-inferred variable."  If it has a mold, `:var`
"declares a type-checked variable."

## Examples

```
~zod:dojo> =foo  :gate  a/@
                 :var  b  1
                 :var  c/@  2
                 :(add a b c)
~zod:dojo> (foo 5)
8
```

```
~zod:dojo> =foo  |=  a/@
                 =/  b  1
                 =/  c/@  2
                 :(add a b c)
~zod:dojo> (foo 5)
8
```

