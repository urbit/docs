---
navhome: /docs
sort: 2

---

# `:gate  |=  "bartis"` 

`{$gate p/moss q/seed}`: form a gate, a dry one-armed core with sample.

## Expands to

```
:new   p
:core
++  $
  q
--
```

## Syntax

Regular: *2-fixed*.

## Discussion

## Examples

A trivial gate:

```
~zod:dojo> =foo |=(a/@ +(a))
~zod:dojo> (foo 20)
21
```

A slightly less trivial gate:

```
~zod:dojo> =foo  :gate  {a/@ b/@}
                 (add a b)
~zod:dojo> (foo 20 400)
420
```
