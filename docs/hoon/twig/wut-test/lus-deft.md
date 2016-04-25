---
sort: 13
---

# `:deft  ?-  "wutlus"`

`{$case p/wing q/seed r/(list (pair moss seed))}`: switch against 
a union, with a default.

## Expands to

```
:ifno  r
  q
:if  :fits(p.i.r p)
  q.i.r
:moar(r t.r)
```

## Syntax

Regular: *2-fixed*, then *jogging*.

## Discussion

An extra case will throw `mint-vain`.  A lost case defaults.

## Examples

```
~zod:dojo> =cor  |=  vat/?($a $b)
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
