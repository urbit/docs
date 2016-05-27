---
navhome: /docs
sort: 9
---

# `:or  ?|  "wutbar"` 

`{$or p/(list seed)}`: logical or.

## Expands to

```
:ifno  p  
  |
:if  i.p
  &
:moar(p t.p)
```

## Syntax

Regular: *running*.

Irregular: `|(foo bar baz)` is `?|(foo bar baz)`.

## Examples

```
~zod:dojo> |(=(6 42) =(42 42))
%.y
```
