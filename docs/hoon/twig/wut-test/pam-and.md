---
navhome: /docs/
sort: 8
---

# `:and  ?&  "wutpam"`

`{$and p/(list seed)}`: logical and.

## Expands to

*Pseudocode*, `a`, `b`, `c`, ... as elements of `p`

```
:lest(a | :lest(b | :lest(c | :lest(... :lest(z | &)))))
```

### Compiler macro

```
:loop
:ifno  p  
  &
:lest  i.p
  |
:moar(p t.p)
```

```
|-
?~  p
  &
?.  i.p
  |
$(p t.p)
```

## Syntax

Regular: *running*.

Irregular: `&(foo bar baz)` is `?&(foo bar baz)`.

## Examples

```
~zod:dojo> :and(=(6 6) =(42 42))
%.y
```

```
~zod:dojo> &(=(6 6) =(42 42))
%.y
```
