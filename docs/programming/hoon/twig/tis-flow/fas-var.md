---
sort: 6
---

# `:var, =/, "tisfas", {$var p/taco q/twig r/twig}`

Combine a named and/or typed noun with the subject.

## Expands to

```
?@(p :pin(:name(p q) r) :pin(:cast(:(coat p) q) r)
```

## Syntax

Regular: *3-fixed*.

## Discussion

`p` can be either a symbol or a symbol/mold.  If it's just a
symbol, `:var` "declares a type-inferred variable."  It has a
mold, `:var` "declares a type-checked variable."

## Examples

```
~zod:dojo> =foo  |=  a/@
                 =/  b  1
                 =/  c/@  2
                 :(add a b c)
~zod:dojo> (foo 5)
8
```

