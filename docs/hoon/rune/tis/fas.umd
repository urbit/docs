---
navhome: /docs/
next: true
sort: 6
title: =/ "tisfas"
---

# `=/ "tisfas"` 

`[%tsfs p=taco q=hoon r=hoon]`: combine a named and/or typed 
noun with the subject.

## Expands to

*if `p` is a symbol*:

```
=+(^=(p q) r)
```

*if `p` is a symbol with a mold*:

```
=+(^-(p q) r)
```

### Compiler macro

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
`=/` ("tisfas") "declares a type-inferred variable."  If it has a mold, `=/`
"declares a type-checked variable."

## Examples

```
~zod:dojo> =foo  |=  a=@
                 =/  b  1
                 =/  c=@  2
                 :(add a b c)
~zod:dojo> (foo 5)
8
```

