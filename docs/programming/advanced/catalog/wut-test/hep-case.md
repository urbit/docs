---
sort: 12
---

# `:case, ?-, "wuthep", {$case p/wing q/(list (pair moss seed))}`

Switch against a union, with no default.

## Expands to

```
:ifno  q
  :lost 
:if  :fits(p.i.q p)
  q.i.q
:moar(q t.q)
```

## Syntax

Regular: *1-fixed*, then *jogging*.

## Discussion

The compiler makes sure that your code neither misses a case of
the union, nor includes a double case that isn't there.  This is
not special handling for `:case`, just a consequence of the
semantics of `:if`, which `:case` reduces to.

A missing case will throw the `mint-lost` error.  An extra case
will throw `mint-vain`.  (Ecclesiastes did nothing wrong.)

## Examples

```
~zod:dojo> =cor  |=  vat/?($a $b)
                 ?-  vat
                   $a  20
                   $b  42
                 ==
~zod:dojo> (cor %a)
20
~zod:dojo> (cor %b)
42
~zod:dojo> (cor %c)
! nest-fail
```


