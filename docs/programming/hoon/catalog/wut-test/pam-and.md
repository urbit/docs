---
sort: 8
---

# `:and, ?&, "wutpam", {$and p/(list seed)}`

Logical and.

## Expands to

```
:ifno  p  
  &
:lest  i.p
  |
:moar(p t.p)
```

## Syntax

Regular: *running*.

Irregular: `&(foo bar baz)` is `?&(foo bar baz)`.

## Examples

```
~zod:dojo> &(=(6 6) =(42 42))
%.y
```
