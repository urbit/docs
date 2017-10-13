---
navhome: /docs/
sort: 9
---

# `:or  ?|  "wutbar"` 

`{$or p/(list seed)}`: logical or.

## Expands to

*Pseudocode*, `a`, `b`, `c`, ... as elements of `p`

```
:if(a & :if(b & :if(c & :if(... :if(z & |)))))
```

### Compiler macro

```
:loop
:ifno  p  
  |
:if  i.p
  &
:moar(p t.p)
```

```
|-
?~  p
  |
?:  i.p
  &
$(p t.p)
```

## Syntax

Regular: *running*.

Irregular: `|(foo bar baz)` is `?|(foo bar baz)`.

## Examples

```
~zod:dojo> :or(=(6 42) =(42 42))
%.y
```

```
~zod:dojo> |(=(6 42) =(42 42))
%.y
```
