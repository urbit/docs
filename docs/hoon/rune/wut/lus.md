---
navhome: /docs/
sort: 13
title: ?+ "wutlus"
---

# `?+ "wutlus"`

`[%wtls p=wing q=value r=(list (pair model value))]`: switch against 
a union, with a default.

## Expands to

*Pseudocode*: `a`, `b`, `c`, ... as elements of `r`:

```
?:  ?=(p.a)  q.a
?:  ?=(p.b)  q.b
?:  ?=(p.c)  q.c
...
q
```

### Compiler macro

```
|-
?.  r
  q
?:  ?=(p.i.r p)
  q.i.r
$(r t.r)
```

## Syntax

Regular: *2-fixed*, then *jogging*.

## Discussion

An extra case will throw `mint-vain`.  A lost case defaults.

## Examples

```
~zod:dojo> =cor  |=  vat=?($a $b)
                 ?+  vat  240
                   $a  20
                   $b  42
                 ==
~zod:dojo> (cor %a)
20
~zod:dojo> (cor %b)
42
~zod:dojo> (cor %c)
240
```
