---
navhome: /docs/
next: true
sort: 12
title: ?- "wuthep"
---

# `?- "wuthep"` 

`[%wthp p=wing q=(list (pair model value))]`: switch against a 
union, with no default.

## Expands to

*Pseudocode*: `a`, `b`, `c`, ... as elements of `q`:

```
?:  ?=(p.a)  q.a
?:  ?=(p.b)  q.b
?:  ?=(p.c)  q.c
...
~|(%mint-lost !!)
```

### Compiler macro

```
|-
?.  q
  ~|(%mint-lost !!)
?:  ?=(p.i.q p)
  q.i.q
$(q t.q)
```

## Syntax

Regular: *1-fixed*, then *jogging*.

## Discussion

The compiler makes sure that your code neither misses a case of
the union, nor includes a double case that isn't there.  This is
not special handling for `?-` ("wuthep"), just a consequence of the
semantics of `?:` ("wutcol"), which `?-` reduces to.

A missing case will throw the `mint-lost` error.  An extra case
will throw `mint-vain`.  (Ecclesiastes did nothing wrong.)

## Examples

```
~zod:dojo> =cor  |=  vat=?($a $b)
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


